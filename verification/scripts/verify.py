"""Audit/reuse observed greens, or explicitly rerun exact versioned input closures.

The baseline and negative suites are deliberately separate. A negative suite
requires a native property violation, never merely a nonzero process exit.
"""
from pathlib import Path
import argparse,json,subprocess,sys,hashlib
sys.path.insert(0,str(Path(__file__).resolve().parent))
from audit_evidence import ROOT,EvidenceError,load_latest,validate
from guarantee_audit import audit_guarantees
from repeated_audit import coverage as audit_repeated

def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('suite',choices=['baseline','negative','audit'])
 p.add_argument('--fresh',action='store_true',help='explicitly rerun exact recorded source snapshots, bounded per receipt; may take tens of minutes')
 p.add_argument('--focused',action='store_true',help='audit the explicitly selected focused scope while retaining deferred full checks')
 a=p.parse_args()
 manifest=json.loads((ROOT/'verification/results/manifest.json').read_text())
 for rel,h in manifest['final_model_hashes'].items():
  if hashlib.sha256((ROOT/rel).read_bytes()).hexdigest()!=h:
   raise EvidenceError('Final model inventory changed: '+rel+'; reconcile affected checks before accepting this report')
 acceptance=json.loads((ROOT/'verification/configs/acceptance.json').read_text())
 ids=acceptance['required_focused'] if a.focused else acceptance['required']
 selected=[]
 for base in ids:
  rp,r=load_latest(base)
  if a.suite=='baseline' and r['expected']!='pass':continue
  # A weak-oracle discriminator intentionally accepts a faulty model to expose
  # its blind spot. Audit it, but never count it as safe-baseline verification.
  if a.suite=='baseline' and base in acceptance.get('oracle_discriminators',[]):continue
  if a.suite=='negative' and r['expected']!='counterexample':continue
  validate(r,rp);selected.append(r["id"])
 if not selected:raise EvidenceError('Empty selected suite')
 if not a.focused:
  assurance=audit_guarantees()
  if a.suite in ['baseline','audit']:
   selected.extend(v['receipt'] for v in assurance['graphs'].values())
   selected.extend(assurance['directed'].values())
   selected.extend([assurance['sampled'],assurance['history']['baseline']])
  if a.suite in ['negative','audit']:
   selected.extend(v for k,v in assurance['history'].items() if k!='baseline')
  if a.suite=='audit':
   selected.extend(assurance['controls'].values())
  if a.suite in ['baseline','audit']:
   repeated=audit_repeated()
   selected.extend(repeated['directed_receipts'] + repeated['sample_receipts'])
   if a.suite=='audit':
    selected.append(repeated['legacy_discriminator'])
 if a.fresh:
  for base in selected:
   done=subprocess.run([sys.executable,str(ROOT/'verification/scripts/replay.py'),base],cwd=ROOT)
   if done.returncode:return done.returncode
 print(json.dumps({'suite':a.suite,'focused':a.focused,'deferred_full_checks':acceptance.get('deferred',{}),'checks':len(selected),'status':'passed','mode':'exact-recorded-input rerun' if a.fresh else 'audited original backend results; valid greens reused','scope':'named finite/bounded/sampled configurations only','broader_timeouts':manifest['historical_broader_timeouts'],'unmet_scoped_checks':manifest['unmet_scoped_checks']},indent=2))
 return 1 if manifest['unmet_scoped_checks'] and not a.focused else 0

if __name__=='__main__':
 try:sys.exit(main())
 except (EvidenceError,OSError,KeyError,ValueError) as e:
  print('Evidence audit failed: '+str(e),file=sys.stderr);sys.exit(1)
