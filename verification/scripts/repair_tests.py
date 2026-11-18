"""Changed-boundary scenarios, isolated controls and seeded operational samples."""
from evidence import *
from audit_evidence import load_latest,EvidenceError
import argparse

def run(id,cmd,claim,expected='pass',backend='cli',config=None,seconds=120):
 try:
  p,r=load_latest(id)
  if r['expectation_met'] and r['command']==cmd and r['input_hashes']==inputs(cmd) and r['expected']==expected and r['backend']==backend and digest(ROOT/r['raw_output'])==r['raw_sha256']:
   print('REUSE exact observed repair',r['id'],flush=True);return r
 except EvidenceError:pass
 r=execute(id,cmd,claim=claim,expected=expected,backend=backend,config=config,seconds=seconds)
 if not r['expectation_met']:raise RuntimeError('Unexpected native observation: '+r['id'])
 return r

def tests(id,file,main):
 return run(id,[QUINT,'test','verification/tests/'+file+'.qnt','--main',main,'--match','.*Test','--backend','typescript','--seed','17'],'Actual changed-boundary scenario coverage: '+main)

def admission(positive=True,negative=True):
 for row in json.loads((V/'mutants/admission-placements.json').read_text()):
  if positive:tests(row['positive'],'admission_placements_test','admission_'+row['name']+'_test')
  if negative:
   cmd=[QUINT,'run','verification/mutants/admission_placements.qnt','--main','admission_'+row['name']+'_fault','--init','initControl','--step','stepControl','--invariant','S10','--backend','typescript','--max-samples','1','--max-steps',str(row['steps']),'--seed','17','--verbosity','2','--out-itf','verification/results/traces/'+row['negative']+'.itf.json']
   run(row['negative'],cmd,'S10',expected='counterexample',backend='simulation',config=row)

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('suite',choices=['positive','negative','operational','admission']);a=p.parse_args()
 if a.suite=='admission':admission()
 if a.suite=='positive':
  admission(negative=False)
  tests('qa-payload-exact-values','payload_values_test','payload_values_test')
  tests('qa-proof-consumer-contexts','proof_consumer_test','proof_consumer_test')
  tests('qa-abort-semantic-records','abort_records_test','abort_records_test')
  for m in ['native','escrow','b','d','shared','multilateral','booking']:tests('qa-economic-'+m,'economic_outputs_test','economic_'+m+'_test')
  for f in ['dvp_test','bindings_test','recovery_test','network_test','d_outage_test','phase_failure_test','report_view_test','privacy_pipeline_test']:
   tests('qa-scenarios-'+f,f,f)
  for m in ['open_test','contention_test','b_path_test','d_path_test','policy_test','shared_policy_test','shared_path_test','escrow_path_test','multilateral_test']:
   tests('qa-scenarios-'+m,'variants_test',m)
 if a.suite=='negative':
  admission(positive=False)
  for row in json.loads((V/'mutants/qa-controls.json').read_text()):
   cmd=[QUINT,'run','verification/mutants/qa_controls.qnt','--main',row['module'],'--init',row['init'],'--step',row['step'],'--invariant',row['property'],'--backend','typescript','--max-samples','1','--max-steps',str(row['steps']),'--seed','17','--verbosity','2','--out-itf','verification/results/traces/'+row['id']+'.itf.json']
   run(row['id'],cmd,row['property'],expected='counterexample',backend='simulation',config=row,seconds=60)
  for row in json.loads((V/'mutants/manifest.json').read_text()):
   id='qa-legacy-'+row['id'];cmd=[QUINT,'run','verification/mutants/guided.qnt','--main',row['id'],'--init','initGuided','--step','stepGuided','--backend','typescript','--invariant',row['property'],'--max-samples','1','--max-steps',str(len(row['schedule'])+1),'--seed','17','--verbosity','2','--out-itf','verification/results/traces/'+id+'.itf.json']
   run(id,cmd,row['property'],expected='counterexample',backend='simulation',config=row)
 if a.suite=='operational':
  for seed in [17,29,43]:
   id='qa-combined-faults-'+str(seed);cmd=[QUINT,'run','verification/models/operational_faults.qnt','--main','operational_faults','--backend','rust','--invariant','safe','--max-samples','10000','--max-steps','100','--seed',str(seed),'--verbosity','1','--step','faults']
   run(id,cmd,'safe',backend='simulation',config={'main':'operational_faults','step':'faults','samples':10000,'steps':100,'seed':seed},seconds=600)
if __name__=='__main__':main()
