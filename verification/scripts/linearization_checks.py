"""Capture exact-source execution of the SQLite booking history tests."""
import sys

from evidence import execute

TEST = "verification/tests/test_booking_linearization.py"
ADAPTER = "verification/adapters/booking.py"
FIXTURES = "verification/tests/test_assurance_booking.py"


def check():
    launch = (
        "import runpy,sys;from pathlib import Path;"
        "sys.path[0]=str(Path(sys.argv[2]).resolve().parents[2]);"
        "sys.argv=sys.argv[1:2];runpy.run_path(sys.argv[0],run_name='__main__')"
    )
    return execute(
        "three-booking-linearization",[sys.executable,"-B","-c",launch,TEST,ADAPTER,FIXTURES],
        claim="Real SQLite histories are linearizable against an independent booking object",
        config={"object":"one A-hosted COMMIT booking slot","fixture_boundary":"upstream authenticated facts"},
    )


if __name__ == "__main__":
    raise SystemExit(not check()["expectation_met"])
