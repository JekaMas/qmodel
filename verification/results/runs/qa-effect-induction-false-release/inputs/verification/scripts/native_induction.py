"""Compile Quint and check equivalent native record-set induction obligations.

The correspondence certificate accepts exactly one algebraic domain-constructor
normalizations. All actual State/init/Next/monitor code remains byte-identical
in the compiled TLA output. Native proof obligations are initiation0,
preservation1 from the invariant, and implication0; no state/step filter.
"""
from pathlib import Path
import json,sys,subprocess,datetime,hashlib,re,shutil,os
from normalize_record_domains import normalize
if len(sys.argv)>1 and sys.argv[1]=='invoke':
 # Replay may execute this helper inside an immutable saved input closure.
 # Resolve source paths from the captured plan; use the current pinned cache.
 ROOT=Path(sys.argv[2]).resolve().parents[4]
 def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
else:
 from evidence import ROOT,QUINT,execute,digest,inputs
 from audit_evidence import load_latest,EvidenceError
BIN=Path(os.environ.get('QUINT_HOME',str(ROOT/'.quint')))/'apalache-dist-0.62.4/apalache/bin/apalache-mc'
PROFILE={'JAVA_TOOL_OPTIONS':'-Xmx24g -Xss8m','JVM_ARGS':'-Xmx24g -Xss8m'}
def checked(name,cmd,claim,expected='pass',backend='cli'):
 try:
  p,r=load_latest(name)
  if r['expectation_met'] and r['command']==cmd and r['claim']==claim and r['expected']==expected:
   retained=True
   if r['input_hashes']!=inputs(cmd):
    from qa_retention import relation
    try:relation(p,r)
    except (AssertionError,OSError):retained=False
   if retained:
    if digest(ROOT/r['raw_output'])!=r['raw_sha256']:raise ValueError('Changed raw output')
    print('REUSE',r['id'],flush=True);return r
 except EvidenceError:pass
 r=execute(name,cmd,claim=claim,backend=backend,expected=expected,seconds=14400,execution_env=PROFILE,resource_limit='24GiB heap; one sequential native checker;14400s cap')
 if not r['expectation_met']:raise RuntimeError('Unexpected native result '+r['id'])
 return r
def compile_profile(name,file,main,init='init',step='adversarialStep'):
 r=checked('qa-record-compile-'+name,[QUINT,'compile',file,'--main',main,'--init',init,'--step',step,'--invariant','effectI','--target','tlaplus','--verbosity','0'],['Compile actual full State/init/'+step+'; no verification claim'])
 raw=(ROOT/r['raw_output']).read_text();start=raw.index('---- MODULE');end=raw.rindex('====')
 original=raw[start:end+4]+'\n';normalized,changes=normalize(original)
 assert len(changes)==1 and len(changes[0]['fields'])==34
 selected=re.search(r'^q_step == (.+)$',original,re.M)[1]
 assert selected==step or selected.endswith('_'+step),selected
 directory=ROOT/'verification/generated/native-induction'/name;directory.mkdir(parents=True,exist_ok=True)
 module=re.search(r'MODULE\s+(\w+)',original)[1]
 original_path=directory/'original.tla';target=directory/(module+'.tla')
 original_path.write_text(original);target.write_text(normalized)
 closure=[file,'verification/scripts/normalize_record_domains.py','verification/scripts/native_induction.py',str(original_path.relative_to(ROOT)),str(target.relative_to(ROOT))]
 plan={'schema_version':1,'native_input_closure':closure,'compiler_receipt':r['id'],'quint_source':file,'main':main,'selected_init':init,'selected_step':step,'compiled_next':selected,'native_file':str(target.relative_to(ROOT)),'original_file':str(original_path.relative_to(ROOT)),'original_sha256':digest(original_path),'normalized_sha256':digest(target),'normalizations':changes,'proof':'Only exact product-record constructors normalized; all other compiled bytes unchanged. No projection/filter/guard/invariant change.'}
 plan_path=directory/'native-correspondence.json';plan_path.write_text(json.dumps(plan,indent=2)+'\n')
 return str(plan_path.relative_to(ROOT))
def invoke(plan_path,phase):
 p=json.loads((ROOT/plan_path).read_text());original=(ROOT/p['original_file']).read_text();normalized,changes=normalize(original)
 assert digest(ROOT/p['original_file'])==p['original_sha256'] and normalized==(ROOT/p['native_file']).read_text() and changes==p['normalizations']
 if phase=='init':init,inv,depth='q_init','effectI',0
 elif phase=='preserve':init,inv,depth='effectI','effectI',1
 elif phase=='imply':init,inv,depth='effectI','effectSoundness',0
 else:raise ValueError('Unknown obligation')
 cmd=[str(BIN),'check','--init='+init,'--next=q_step','--inv='+inv,'--length='+str(depth),p['native_file']]
 # Preservation is I /\ Next => I'. At state0, Init is already I itself.
 # Skip only that tautological query; check every VC at successor1. No state
 # or transition is excluded. Initiation0/implication0 remain separate gates.
 if phase=='preserve':cmd.insert(-1,'--tuning-options=search.invariantFilter=1->.*:search.invariant.mode=after')
 print('ACTUAL_NATIVE_COMMAND',json.dumps(cmd),flush=True)
 return subprocess.run(cmd,cwd=ROOT).returncode
def run_profiles(names):
 for name in names:
  fault=name=='false-release'
  file='verification/mutants/induction_soundness.qnt' if fault else 'verification/models/effect_consistency.qnt'
  main='induction_false_release' if fault else 'effects_'+name
  plan=compile_profile(name,file,main,'initControl' if fault else 'init','stepControl' if fault else 'adversarialStep')
  for phase in ['preserve'] if fault else ['init','preserve','imply']:
   checked('qa-effect-induction-false-release' if fault else 'qa-effect-'+phase+'-'+name,
    [sys.executable,'verification/scripts/native_induction.py','invoke',plan,phase],
    ['actual full-State induction obligation',phase,'source '+file,'selected step '+('stepControl' if fault else 'adversarialStep')],expected='counterexample' if fault else 'pass',backend='apalache-native')
def main():
 if len(sys.argv)>1 and sys.argv[1]=='invoke':raise SystemExit(invoke(sys.argv[2],sys.argv[3]))
 run_profiles(sys.argv[1:] or ['one','two','b','d','escrow','shared','private','open','false-release'])
if __name__=='__main__':main()
