"""Real SQLite conformance checks with pre-authenticated evidence fixtures."""
from concurrent.futures import ThreadPoolExecutor
from contextlib import closing
from dataclasses import replace
import json
from pathlib import Path
import shutil
import sqlite3
import tempfile
import unittest

from verification.adapters.booking import ApplicationEvidence, record_commit


D = {
    "trade": 1, "nonce": 1, "chainA": 10, "genesisA": 110, "chainB": 20, "genesisB": 120,
    "decisionDomain": 0, "assetA": 30, "assetB": 40, "holdA": 50, "holdB": 60, "decisionContract": 70,
    "security": 2, "cash": 3, "sellerA": 0, "buyerA": 1, "buyerB": 0, "sellerB": 1,
    "deadline": 2, "protocol": 1, "epoch": 0, "commitment": 1001,
}
A = ApplicationEvidence(D, 0, 2, 5, 10, 110, 30, 1, 2, "A:delivery:1")
B = ApplicationEvidence(D, 1, 2, 6, 20, 120, 40, 1, 3, "B:delivery:1")
EXPECTED = {"descriptor": D, "outcome": 2, "events": ["A:delivery:1", "B:delivery:1"]}


class BookingConformance(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.path = Path(temporary.name) / "booking.db"

    def rows(self):
        with closing(sqlite3.connect(self.path)) as db:
            return [json.loads(row[0]) for row in db.execute("SELECT payload FROM commit_booking")]

    def test_restore_stale_snapshot_and_replay(self):
        backup = self.path.with_name("stale.db")
        with closing(sqlite3.connect(self.path)) as db, closing(sqlite3.connect(backup)) as stale:
            db.execute("CREATE TABLE commit_booking (operation_id TEXT PRIMARY KEY, payload TEXT NOT NULL)")
            db.commit()
            db.backup(stale)
        self.assertEqual(record_commit(self.path, D, [A, B]), EXPECTED)
        self.assertEqual(self.rows(), [EXPECTED])
        # The database is genuinely older than the booking. Evidence is retained
        # outside the projection, so a restarted adapter can rebuild it.
        shutil.copyfile(backup, self.path)
        self.assertEqual(self.rows(), [])
        self.assertEqual(record_commit(self.path, D, [B, A, B]), EXPECTED)
        self.assertEqual(record_commit(self.path, D, [A, B]), EXPECTED)
        self.assertEqual(self.rows(), [EXPECTED])

    def test_reject_partial_wrong_phase_and_wrong_economic_effect(self):
        for evidence in (
            [A], [A, replace(B, phase=4)], [A, replace(B, quantity=4)],
            [A, replace(B, recipient=0)], [A, replace(B, chain=10)],
            [A, replace(B, genesis=110)], [A, replace(B, asset=30)],
            [A, replace(B, descriptor={**D, "nonce": 2})],
            [A, replace(B, descriptor={**D, "nonce": True})],
            [A, replace(B, descriptor={**D, "nonce": 1.0})],
            [A, B, replace(B, event_id="B:other")],
        ):
            with self.subTest(evidence=evidence), self.assertRaises(ValueError):
                record_commit(self.path, D, evidence)
        self.assertFalse(self.path.exists(), "invalid evidence must not write the projection")

    def test_competing_replay_and_conflicting_descriptor(self):
        with ThreadPoolExecutor(max_workers=2) as pool:
            values = list(pool.map(lambda _: record_commit(self.path, D, [B, A]), range(2)))
        self.assertEqual(values, [EXPECTED, EXPECTED])
        conflict = {**D, "nonce": 2}
        with self.assertRaisesRegex(ValueError, "conflicting durable booking"):
            record_commit(self.path, conflict, [replace(A, descriptor=conflict), replace(B, descriptor=conflict)])
        self.assertEqual(self.rows(), [EXPECTED])


if __name__ == "__main__":
    print("SQLite", sqlite3.sqlite_version, flush=True)
    unittest.main(verbosity=2)
