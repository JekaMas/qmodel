"""Finite invocation/response histories at the real SQLite booking boundary."""
from concurrent.futures import ThreadPoolExecutor
from contextlib import closing
from dataclasses import asdict, dataclass, replace
from itertools import combinations, permutations
import json
from pathlib import Path
import sqlite3
import tempfile
from threading import Barrier, Lock
import unittest

from verification.adapters.booking import record_commit
from verification.tests.test_assurance_booking import A, B, D, EXPECTED

CONFLICT = "conflict"
ALTERNATE = {**D, "nonce": 2}
ALTERNATE_ROW = {"descriptor": ALTERNATE, "outcome": 2, "events": [A.event_id, B.event_id]}


@dataclass
class Call:
    invocation: int
    request: dict | None  # None means a read of the same authoritative decision slot.
    response: int | None = None
    value: dict | str | None = None


def linearizable(calls):
    """Find a legal sequential explanation, extending any necessary pending call."""
    complete = [call for call in calls if call.response is not None]
    pending = [call for call in calls if call.response is None]
    for count in range(len(pending) + 1):
        for included in combinations(pending, count):
            for order in permutations([*complete, *included]):
                if any(
                    later.response is not None and later.response < earlier.invocation
                    for i, earlier in enumerate(order) for later in order[i+1:]
                ):
                    continue
                stored = None
                for call in order:
                    if call.request is None:
                        observed = stored
                    elif stored is None:
                        observed = stored = call.request
                    else:
                        observed = stored if call.request == stored else CONFLICT
                    if call.response is not None and call.value != observed:
                        break
                else:
                    return True
    return False


class ObservedHistory:
    def __init__(self):
        self.lock = Lock()
        self.event = 0
        self.calls = []

    def invoke(self, request):
        with self.lock:
            self.event += 1
            call = Call(self.event, request)
            self.calls.append(call)
        return call

    def respond(self, call, value):
        with self.lock:
            self.event += 1
            call.response = self.event
            call.value = value

    def dump(self, name):
        print("HISTORY", name, json.dumps([asdict(call) for call in self.calls], sort_keys=True))


class BookingLinearization(unittest.TestCase):
    def setUp(self):
        workspace = tempfile.TemporaryDirectory()
        self.addCleanup(workspace.cleanup)
        self.path = Path(workspace.name) / "books.db"
        self.history = ObservedHistory()
        # Create the actual operation table in an empty DB before invocation.
        with closing(sqlite3.connect(self.path)) as database, database:
            database.execute("CREATE TABLE commit_booking (operation_id TEXT PRIMARY KEY, payload TEXT NOT NULL)")

    def read(self):
        call = self.history.invoke(None)
        with closing(sqlite3.connect(self.path)) as database:
            rows = database.execute("SELECT payload FROM commit_booking").fetchall()
        self.assertLessEqual(len(rows), 1)
        self.history.respond(call, json.loads(rows[0][0]) if rows else None)

    def write(self, proposal, start=None, lose_ack=False):
        terms = proposal["descriptor"]
        call = self.history.invoke(proposal)
        if start is not None:
            start.wait(timeout=15)
        try:
            observed = record_commit(self.path, terms, [replace(A, descriptor=terms), replace(B, descriptor=terms)])
        except ValueError as error:
            self.assertIn("conflicting durable booking", str(error))
            observed = CONFLICT
        if not lose_ack:
            self.history.respond(call, observed)

    def test_three_concurrent_invocations_linearize_with_live_reads(self):
        start = Barrier(3)
        self.read()
        with ThreadPoolExecutor(max_workers=3) as workers:
            jobs = [workers.submit(self.write, row, start) for row in (EXPECTED, ALTERNATE_ROW, EXPECTED)]
            for job in jobs:
                job.result()
        self.read()
        self.history.dump("three_calls")
        calls = self.history.calls
        self.assertTrue(linearizable(calls))
        writes = [call for call in calls if call.request is not None]
        self.assertLess(max(call.invocation for call in writes), min(call.response for call in writes))
        self.assertIn(CONFLICT, [call.value for call in writes])

    def test_lost_response_does_not_duplicate_durable_effect(self):
        self.write(EXPECTED, lose_ack=True)
        self.read()
        self.write(EXPECTED)
        self.write(ALTERNATE_ROW)
        self.read()
        self.history.dump("lost_response")
        self.assertIsNone(self.history.calls[0].response)
        self.assertEqual(self.history.calls[1].value, EXPECTED)
        self.assertTrue(linearizable(self.history.calls))
        self.assertFalse(linearizable(self.history.calls[1:]))  # Read requires the unknown completed write.

    def test_early_ack_and_conflicting_success_fail_history_check(self):
        early = [Call(1, EXPECTED, 2, EXPECTED), Call(3, None, 4, None)]
        conflicting = [Call(1, EXPECTED, 4, EXPECTED), Call(2, ALTERNATE_ROW, 3, ALTERNATE_ROW)]
        self.assertFalse(linearizable(early))
        self.assertFalse(linearizable(conflicting))
        self.assertTrue(linearizable([Call(1, EXPECTED, 4, EXPECTED), Call(2, None, 3, None)]))


if __name__ == "__main__":
    print("SQLite", sqlite3.sqlite_version, flush=True)
    unittest.main(verbosity=2)
