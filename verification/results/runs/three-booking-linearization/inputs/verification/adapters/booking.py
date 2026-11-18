"""A-chain PoC COMMIT booking at the SQLite boundary.

Callers supply the agreed descriptor and authenticated application evidence.
The adapter checks settlement binding and persistence. It has no chain verifier
or submission authority and creates no financial effects on either ledger.
"""
from contextlib import closing
from dataclasses import dataclass
import json
import sqlite3

DESCRIPTOR_FIELDS = frozenset("""
    trade nonce chainA genesisA chainB genesisB decisionDomain assetA assetB
    holdA holdB decisionContract security cash sellerA buyerA buyerB sellerB
    deadline protocol epoch commitment
""".split())


@dataclass(frozen=True)
class ApplicationEvidence:
    descriptor: dict[str, int]
    leg: int
    outcome: int
    phase: int
    chain: int
    genesis: int
    asset: int
    recipient: int
    quantity: int
    event_id: str


def canonical(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def commit_row(descriptor, evidence):
    descriptor = dict(descriptor)
    if descriptor.keys() != DESCRIPTOR_FIELDS or any(type(v) is not int for v in descriptor.values()):
        raise ValueError("expected the complete integer descriptor")
    if descriptor["decisionDomain"] != 0:
        raise ValueError("adapter requires the A-hosted decision profile")
    if descriptor["security"] <= 0 or descriptor["cash"] <= 0:
        raise ValueError("the delivery quantities must be positive")
    expected = {
        0: (5, descriptor["chainA"], descriptor["genesisA"], descriptor["assetA"], descriptor["buyerA"], descriptor["security"]),
        1: (6, descriptor["chainB"], descriptor["genesisB"], descriptor["assetB"], descriptor["sellerB"], descriptor["cash"]),
    }
    events = {}
    for item in evidence:
        observed = (item.phase, item.chain, item.genesis, item.asset, item.recipient, item.quantity)
        values = (item.leg, item.outcome, *observed)
        if (
            any(type(v) is not int for v in values)
            or any(type(v) is not int for v in item.descriptor.values())
            or item.descriptor != descriptor
            or item.outcome != 2
            or item.leg not in expected
            or expected[item.leg] != observed
            or not isinstance(item.event_id, str)
            or not item.event_id
        ):
            raise ValueError("application evidence conflicts with agreed COMMIT terms")
        if item.leg in events and events[item.leg] != item.event_id:
            raise ValueError("conflicting application events for the same leg")
        events[item.leg] = item.event_id
    if events.keys() != expected.keys():
        raise ValueError("matching application evidence from both legs is required")

    # The authoritative decision chain and contract own this trade slot. The
    # full descriptor (including nonce and epoch) is bound to the stored row.
    key = canonical([descriptor[field] for field in ("chainA", "genesisA", "decisionContract", "trade")])
    payload = canonical({"descriptor": descriptor, "outcome": 2, "events": [events[0], events[1]]})
    return key, payload


def record_commit(path, descriptor, evidence):
    """Persist one matching row. An exact replay returns that same row."""
    key, payload = commit_row(descriptor, evidence)
    with closing(sqlite3.connect(path, timeout=10)) as database, database:
        database.execute("""
            CREATE TABLE IF NOT EXISTS commit_booking (
                operation_id TEXT PRIMARY KEY,
                payload TEXT NOT NULL
            )
        """)
        database.execute("""
            INSERT INTO commit_booking VALUES (?, ?)
            ON CONFLICT(operation_id) DO NOTHING
        """, (key, payload))
        stored, = database.execute(
            "SELECT payload FROM commit_booking WHERE operation_id = ?", (key,),
        ).fetchone()
        if stored != payload:
            raise ValueError("conflicting durable booking for this decision slot")
    return json.loads(stored)
