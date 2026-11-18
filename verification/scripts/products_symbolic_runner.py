"""Execute and classify captured standalone SMT-LIB obligations."""
import json
from pathlib import Path
import subprocess
import sys


def main(file):
    print(subprocess.check_output(["z3","--version"],text=True).strip(),flush=True)
    manifest=json.loads(Path(file).read_text())
    ok=True
    for query in manifest["obligations"]:
        native=subprocess.run(["z3","-in","-smt2"],input=query["script"],text=True,
                              stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=45)
        answer=native.stdout.splitlines()[0] if native.stdout else ""
        print(f"{query['name']}: {answer}",flush=True)
        if answer!=query["expected"] or native.returncode!=0:
            ok=False
            print(native.stdout)
        elif answer=="sat":
            witness=subprocess.run(["z3","-in","-smt2"],input=query["script"]+"\n(get-model)\n",
                                  text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=45)
            if witness.returncode!=0:
                ok=False
            print(witness.stdout)
    return int(not ok)


if __name__=="__main__":
    raise SystemExit(main(sys.argv[1]))
