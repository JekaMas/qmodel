"""Sequential native QA repair proofs; immutable attempts and explicit subjects.

No polling/state-count loop: the child checker finishes or reaches its recorded
cap before the next heavyweight invocation starts. Existing successful exact
subjects are reused; native graph passes are not refreshed for documentation.
"""
from evidence import *
from audit_evidence import load_latest,EvidenceError
import argparse
PROFILE={'JAVA_TOOL_OPTIONS':'-Xmx8g -Xss8m','JVM_ARGS':'-Xmx8g -Xss8m'}
INDUCTION_PROFILE={'JAVA_TOOL_OPTIONS':'-Xmx24g -Xss8m','JVM_ARGS':'-Xmx24g -Xss8m'}

def checked(id,cmd,claim,backend='tlc',expected='pass',seconds=14400,config=None,profile=None):
 try:
  p,old=load_latest(id)
  if old['expectation_met'] and old['command']==cmd and old['input_hashes']==inputs(cmd) and old['claim']==claim and old['expected']==expected:
   # Reuse this exact observed attempt (not the family's first old base).
   if digest(ROOT/old['raw_output'])!=old['raw_sha256']:raise EvidenceError('Native output changed')
   print('REUSE exact observed repair',old['id'],flush=True)
   return old
 except EvidenceError:pass
 r=execute(id,cmd,claim=claim,backend=backend,expected=expected,seconds=seconds,
  config=config or {'purpose':'QA-01..04 repaired actual model'},execution_env=profile or PROFILE,
  resource_limit=('24 GiB heap' if profile==INDUCTION_PROFILE else '8 GiB heap')+';4/8 TLC workers as configured;one heavy checker;'+str(seconds)+'s cap')
 if not r['expectation_met']:raise RuntimeError('Unexpected native result: '+r['id'])
 return r

def tlc(id,file,main,inv=None,temporal=None,init='init',step='step',workers8=False):
 cmd=[QUINT,'verify','verification/models/'+file+'.qnt','--main',main,'--backend','tlc','--init',init,'--step',step,'--tlc-config','verification/configs/'+('extended-tlc8.json' if workers8 else 'extended-tlc.json'),'--verbosity','3']
 if inv:cmd+=['--invariants']+inv
 if temporal:cmd+=['--temporal',temporal]
 return checked(id,cmd,[inv,temporal])

def run_suite(suite):
 if suite=='reference':tlc('qa-core-finite','dvp','baseline',['safe','CDecision'])
 if suite=='full':
  tlc('qa-full-two','liveness_variants','live_two',['safe','CDecision'],'progress',workers8=True)
  tlc('qa-full-recovery','recovery','recovery',['safe','CDecision'],'recoveryProgress',step='recoveryStep',workers8=True)
 if suite=='variants':
  for m in ['live_open','live_b','live_d','live_escrow']:
   tlc('qa-variant-'+m,'liveness_variants',m,['safe','CDecision'],'progress',workers8=True)
  for m in ['private_asset','shared_execution']:tlc('qa-variant-'+m,'variants',m,['safe','CDecision'],workers8=True)
  tlc('qa-multilateral','multilateral','multilateral',['safe'],'progress',workers8=True)
 if suite=='privacy':
  # One safe access graph checks the complete strengthened conjunction, not four
  # reruns of the identical graph with one conjunct each.
  tlc('qa-pipeline-access','privacy_pipeline','pipeline_safe',['safe'],step='accessStep',workers8=True)
  for m,inv,step in [('pipeline_log','PNI','pairedStep'),('pipeline_timing','PTiming','pairedStep'),('pipeline_unsalted','PNI','pairedStep'),('pipeline_scope','PAccess','accessStep'),('pipeline_substitution','PBinding','accessStep'),('pipeline_note','PAvailability','pairedStep'),('pipeline_compromise','PAccess','accessStep')]:
   cmd=[QUINT,'verify','verification/models/privacy_pipeline.qnt','--main',m,'--backend','tlc','--invariant',inv,'--step',step,'--tlc-config','verification/configs/extended-tlc.json','--verbosity','3']
   checked('qa-'+m,cmd,inv,expected='counterexample')
  for m,inv,expect in [('integrated','safe','pass'),('integrated','noUsability','counterexample'),('integrated_leak','safe','counterexample')]:
   cmd=[QUINT,'verify','verification/models/integrated.qnt','--main',m,'--backend','tlc','--invariant',inv,'--tlc-config','verification/configs/extended-tlc.json','--verbosity','3']
   checked('qa-privacy-time-'+m+'-'+inv,cmd,inv,expected=expect)
  for temp,expect in [('availability','pass'),('unconditionalAvailability','counterexample')]:
   cmd=[QUINT,'verify','verification/models/privacy_pipeline.qnt','--main','pipeline_safe','--backend','tlc','--step','dataStep','--temporal',temp,'--tlc-config','verification/configs/extended-tlc.json','--verbosity','3']
   checked('qa-private-'+temp,cmd,temp,expected=expect)
 if suite=='core':
  tlc('qa-full-one','liveness','liveness',['safe','CDecision'],'progress')
  tlc('qa-compact-two','compact_two','compact_two',['safe','CDecision'],'progress',step='relevantStep',workers8=True)
  tlc('qa-compact-recovery','compact_recovery','compact_recovery',['safe','CDecision'],'recoveryProgress',step='recoveryStep',workers8=True)
  tlc('qa-admission-contexts','admission_focus','admission_focus',['safe','CDecision'],step='focusStep',workers8=True)
 if suite=='mapping':tlc('qa-economic-mapping','mapping','mapping',['simulation','economicOutputs'],init='initMapped',step='stepMapped')
 if suite=='consistency':
  from native_induction import run_profiles
  run_profiles(['false-release','one','two','b','d','escrow','shared','private','open'])
  run_suite('observer')
 if suite=='observer':tlc('qa-trusted-observer','observer_view','observer_view',['safe','TrustedNI','TrustedAccess'],step='accessStep',workers8=True)
 if suite=='architecture':
  cmd=[QUINT,'verify','verification/models/dvp.qnt','--main','baseline','--backend','tlc','--invariant','noLag','--tlc-config','verification/configs/extended-tlc.json','--verbosity','3']
  checked('qa-immediate',cmd,'noLag',expected='counterexample')
  cmd=[QUINT,'verify','verification/models/failure_controls.qnt','--main','permanent_halt','--backend','tlc','--init','initControl','--step','stepControl','--temporal','unconditional','--tlc-config','verification/configs/extended-tlc.json','--verbosity','3']
  checked('qa-permanent-halt',cmd,'unconditional',expected='counterexample')
 if suite=='apalache':
  cmd=[QUINT,'verify','verification/models/dvp.qnt','--main','baseline','--backend','apalache','--max-steps','12','--invariants','safe','CDecision','--apalache-config','verification/configs/extended-apalache.json','--verbosity','3']
  checked('qa-apalache12',cmd,['safe','CDecision','all prefixes through12'],backend='apalache')
def main():
 parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('suite',choices=['reference','full','variants','privacy','core','mapping','apalache','consistency','observer','architecture','remaining','final']);a=parser.parse_args()
 suites=['reference','full','core','variants','privacy','mapping','apalache'] if a.suite=='final' else ['core','variants','privacy','mapping','apalache'] if a.suite=='remaining' else [a.suite]
 for suite in suites:run_suite(suite)
if __name__=='__main__':main()
