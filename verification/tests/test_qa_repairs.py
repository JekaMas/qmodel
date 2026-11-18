"""Audit real native repair observations and independently inspect fault effects.

These tests assert model/test adequacy, not deployed implementation conformance.
The native checker runs happen before this integrity/semantic audit.
"""
import json,re,sys,unittest,hashlib
from pathlib import Path
from verification.scripts.audit_evidence import ROOT,load_latest,validate
sys.path.insert(0,str(ROOT/'verification/scripts'))
import evidence

def decode(x):
 if isinstance(x,list):return [decode(v) for v in x]
 if isinstance(x,dict):
  if '#bigint' in x:return int(x['#bigint'])
  if '#set' in x:return [decode(v) for v in x['#set']]
  if '#tup' in x:return tuple(decode(v) for v in x['#tup'])
  if '#map' in x:return {decode(a):decode(b) for a,b in x['#map']}
  return {k:decode(v) for k,v in x.items() if k!='#meta'}
 return x

class RepairAudit(unittest.TestCase):
 def complete_constructor(self,text,n,domains,trade_types,pc=False):
  # Independent completeness audit: each field is an independent choice from
  # exactly its invariant domain. No coupling or extra admission filter can
  # turn preservation into a proof over a convenient subset of I states.
  body=text.split('action arbitraryInductive={',1)[1].split('\n }',1)[0]
  declarations=re.findall(r'\s*nondet (\w+)=(.*?)\.oneOf\(\)\n',body)
  self.assertEqual(len(declarations),len(dict(declarations)))
  actual=dict(declarations);expected={};values={}
  for t in range(1,n+1):
   for f,typ in trade_types:expected['t'+str(t)+'_'+f]='Bool' if typ=='bool' else 'Int'
  values['trades']='Map('+','.join(str(t)+' -> {'+','.join(f+':t'+str(t)+'_'+f for f,_ in trade_types)+'}' for t in range(1,n+1))+')'
  for d in domains:
   f=d['field']
   if f=='trades':continue
   if f in ['receivedA','receivedB']:
    for t in range(1,n+1):expected[f+str(t)]='Int'
    values[f]='Map('+','.join(str(t)+' -> '+f+str(t) for t in range(1,n+1))+')'
   else:expected['v_'+f]=d['domain'];values[f]='v_'+f
  if pc:expected['programCounter']='Int'
  self.assertEqual(actual,expected)
  candidate='  val candidate={'+','.join(d['field']+':'+values[d['field']] for d in domains)+'}\n'
  self.assertIn(candidate,body)
  guard="  all {Trades.forall(t=>tradeDomainContains(candidate.trades.get(t))),physicalInvariant(candidate),s'=candidate"+(",pc'=programCounter" if pc else '')+'}'
  self.assertIn(guard,body)
  rest=re.sub(r'\s*nondet \w+=.*?\.oneOf\(\)\n','',body).replace(candidate,'').replace(guard,'')
  self.assertEqual(rest.strip(),'')
 def observation(self,name,owner):
  p,r=load_latest(name);validate(r,p)
  self.assertEqual(r['input_hashes'][owner],hashlib.sha256((ROOT/owner).read_bytes()).hexdigest())
  return p,r
 def counter(self,name,prop,owner='verification/models/dvp.qnt'):
  p,r=self.observation(name,owner)
  self.assertEqual(r['expected'],'counterexample');self.assertEqual(r['claim'],prop)
  self.assertEqual(r['outcome'],'expected_counterexample_found')
  states=json.loads((ROOT/r['native_trace']).read_text())['states']
  return decode(states[-1])
 def counts(self,name,owner,n):
  p,r=self.observation(name,owner)
  self.assertEqual(r['expected'],'pass')
  self.assertIn(str(n)+' passing',(ROOT/r['raw_output']).read_text())
 def world(self,state):return next(v for k,v in state.items() if k.split('::')[-1]=='s')
 def conservation(self,s):
  self.assertEqual(s['ownerA']+s['vaultA']+s['spentA']+sum(s['receivedA'].values()),2)
  self.assertEqual(s['ownerB']+s['vaultB']+s['spentB']+sum(s['receivedB'].values()),3)
 def test_all_payload_values_and_error_states(self):
  self.counts('qa-payload-exact-values','verification/models/privacy_pipeline.qnt',20)
 def test_every_payload_corruption_is_detected(self):
  replay=json.loads((ROOT/'verification/reports/qa-replay-validation.json').read_text())
  self.assertEqual(replay['count'],47);self.assertEqual(replay['negative_native_states_match'],46)
  for x in replay['observations']:
   p,r=load_latest(x['replay_receipt']);validate(r,p)
   self.assertTrue(x['forced_new_process'] and x['outcome_reproduced'])
  for suffix in ['field'+str(f) for f in range(16)]+['root','program']:
   self.counter('qa-payload_'+suffix,'PBinding','verification/models/privacy_pipeline.qnt')
  for name in ['qa-note_amount','qa-note_recipient']:
   self.counter(name,'PBinding','verification/models/privacy_pipeline.qnt')
 def test_consumer_contexts_reach_real_acceptance_gate(self):
  self.counts('qa-proof-consumer-contexts','verification/models/dvp.qnt',31)
  self.observation('qa-admission-contexts','verification/models/dvp.qnt')
  for row in json.loads((ROOT/'verification/mutants/admission-placements.json').read_text()):
   self.counts(row['positive'],'verification/models/dvp.qnt',2)
 def test_missing_program_admission_is_killed(self):
  s=self.world(self.counter('qa-program_admission','S10'))
  self.assertEqual(s['trades'][1]['decision'],2)
  self.assertTrue(any(f['program']==0 and f['d']['trade']==1 and f['phase']==2 for f in s['proofs']))
  self.assertNotIn(0,s['historical']);self.assertEqual(s['trades'][1]['holdB'],1)
  for row in json.loads((ROOT/'verification/mutants/admission-placements.json').read_text()):
   s=self.world(self.counter(row['negative'],'S10'))
   self.assertEqual(s['trades'][1]['decision'],2)
   self.assertNotIn(0,s['historical'])
   self.assertTrue(any(f['phase']==row['source_phase'] and f['program']==0 for f in s['proofs']))

 def test_actual_and_absent_abort_legs_are_distinct(self):
  self.counts('qa-abort-semantic-records','verification/models/dvp.qnt',8)
 def test_premature_absence_cannot_certify_reconciliation(self):
  s=self.world(self.counter('qa-premature_absence','S15'));z=s['trades'][1]
  self.assertEqual((z['decision'],z['booked'],z['holdA'],z['holdB']),(3,1,1,1))
  self.assertEqual(z['refundsA']+z['refundsB'],0)
  self.assertTrue(all(r['disposition']==0 for r in s['abortRecords']))
 def test_every_economic_placement_has_exact_outputs(self):
  for m in ['native','escrow','b','d','shared','booking']:
   self.counts('qa-economic-'+m,'verification/models/dvp.qnt',2)
  self.counts('qa-economic-multilateral','verification/models/multilateral.qnt',2)
 def test_wrong_valid_account_or_asset_preserves_supply_but_fails(self):
  for name,leg,kind,wrong_asset in [('security_recipient',0,0,False),('cash_recipient',1,0,False),('security_refund_recipient',0,1,False),('cash_refund_recipient',1,1,False),('security_asset',0,0,True),('cash_asset',1,0,True)]:
   s=self.world(self.counter('qa-'+name,'S05'));self.conservation(s)
   r=next(r for r in s['economicReceipts'] if r['trade']==1 and r['leg']==leg and r['kind']==kind)
   self.assertEqual(r['quantity'],2 if leg==0 else 3)
   if wrong_asset:self.assertNotEqual(r['asset'],30 if leg==0 else 40)
   else:
    self.assertIn(r['account'],[0,1]);self.assertNotEqual(r['account'],1 if kind==0 else 0)
 def test_booking_recipient_and_quantity_substitution_is_detected(self):
  for name,field,expected in [('booking_recipient','sellerB',1),('booking_quantity','cash',3)]:
   s=self.world(self.counter('qa-'+name,'S05'));self.conservation(s)
   self.assertEqual(s['trades'][1]['booked'],1)
   self.assertEqual(len(s['financialRecords']),1)
   self.assertNotEqual(s['financialRecords'][0]['d'][field],expected)
 def test_actual_effect_soundness_is_inductive_over_the_full_machine(self):
  for direction in ['forward','reverse']:
   p,r=self.observation('qa-trade-domain-'+direction,'verification/models/effect_trade_domain.qnt')
   self.assertEqual(r['command'][r['command'].index('--max-steps')+1],'0')
   self.assertEqual(r['command'][r['command'].index('--invariant')+1],'verified')
   self.assertEqual(r['outcome'],'bounded_no_counterexample')
  correspondence=json.loads((ROOT/'verification/generated/effect-domain-correspondence.json').read_text())
  self.assertEqual(len(correspondence['state_fields']),34);self.assertEqual(len(correspondence['row_fields']),18)
  core=(ROOT/'verification/models/dvp.qnt').read_text()
  fields=lambda name:re.findall(r'(\w+)\s*:',re.search(r'type '+name+r'\s*=\s*\{(.*?)\}',core,re.S)[1])
  self.assertEqual([x['field'] for x in correspondence['state_fields']],fields('State'))
  self.assertEqual(correspondence['row_fields'],fields('Trade'))
  model=(ROOT/'verification/models/effect_consistency.qnt').read_text()
  self.assertIn('domainByFields(x:State):bool=and {'+','.join(x['field_constraint'] for x in correspondence['state_fields'])+'}',model)
  for name in ['one','two','b','d','escrow','shared','private','open']:
   from qa_retention import module
   selected=module(model,'effects_'+name)
   n=int(re.search(r'import dvp\(N=(\d+)',selected)[1])
   self.assertEqual(n,2 if name=='two' else 1)
   trade_types=re.findall(r'(\w+)\s*:\s*(bool|int)(?=\s*[,}])',re.search(r'type Trade\s*=\s*\{(.*?)\}',core,re.S)[1]+'}')
   self.complete_constructor(selected,n,correspondence['state_fields'],trade_types)
   for phase,inv,depth in [('init','effectIExpanded',0),('preserve','effectIExpanded',1),('imply','effectSoundness',0)]:
    p,r=self.observation('qa-effect-'+phase+'-'+name,'verification/models/dvp.qnt')
    self.assertEqual(r['backend'],'apalache-native');self.assertEqual(r['command'][-1],phase)
    plan_path=next(x for x in r['command'] if x.endswith('native-correspondence.json'))
    plan=json.loads((ROOT/plan_path).read_text())
    self.assertEqual(plan['selected_step'],'adversarialStep')
    self.assertEqual(plan['main'],'effects_'+name)
    self.assertEqual(plan['quint_source'],'verification/models/effect_consistency.qnt')
    cp,compiler=load_latest(plan['compiler_receipt']);validate(compiler,cp)
    original=(ROOT/plan['original_file']).read_text();raw=(ROOT/compiler['raw_output']).read_text()
    self.assertEqual(original,raw[raw.index('---- MODULE'):raw.rindex('====')+4]+'\n')
    from normalize_record_domains import normalize
    normalized,changes=normalize(original)
    self.assertEqual(normalized,(ROOT/plan['native_file']).read_text())
    self.assertEqual(changes,plan['normalizations']);self.assertEqual(len(changes),1)
    self.assertEqual(changes[0]['fields'],fields('State'))
    native=(ROOT/r['raw_output']).read_text()
    self.assertIn('--length='+str(depth),native);self.assertIn('--inv='+inv,native)
    self.assertIn('--init=q_init',native)
    self.assertEqual(plan['selected_init'],'init' if phase=='init' else 'arbitraryInductive')
    self.assertIn('--next=q_step',native)
    self.assertIn('action arbitraryInductive={',model)
    self.assertIn('EXITCODE: OK',native)
    if phase=='preserve':
     self.assertIn('search.invariantFilter=1->.*',native)
     self.assertIn('State 1: Checking',native)
   # Reject a domain constructor that silently drops/duplicates tuple fields.
   from normalize_record_domains import normalize
   broken='StateSpace ==\n  {([a |-> v[1], b |-> v[1]]): v \\in Int \\X Int}\n\n'
   with self.assertRaises(ValueError):normalize(broken)

 def test_plausible_release_record_cannot_replace_actual_release(self):
  self.observation('qa-false-release-weak-safe','verification/models/dvp.qnt')
  s=self.world(self.counter('qa-false-release','effectSoundness'))
  self.assertEqual((s['trades'][1]['holdB'],s['trades'][1]['refundsB']),(1,1))
  self.assertTrue(any(r['leg']==1 and r['kind']==1 and r['account']==0 and r['quantity']==3 for r in s['economicReceipts']))
  self.observation('qa-effect-false-imply','verification/models/dvp.qnt')
  _,r=self.observation('qa-effect-induction-false-release','verification/models/dvp.qnt')
  self.assertEqual(r['expected'],'counterexample');self.assertEqual(r['outcome'],'expected_counterexample_found')
  plan=json.loads((ROOT/next(x for x in r['command'] if x.endswith('native-correspondence.json'))).read_text())
  self.assertEqual(plan['selected_step'],'stepControl');self.assertEqual(r['command'][-1],'preserve')
  self.assertEqual(plan['selected_init'],'arbitraryInductive')
  correspondence=json.loads((ROOT/'verification/generated/effect-domain-correspondence.json').read_text())
  core=(ROOT/'verification/models/dvp.qnt').read_text()
  trade_types=re.findall(r'(\w+)\s*:\s*(bool|int)(?=\s*[,}])',re.search(r'type Trade\s*=\s*\{(.*?)\}',core,re.S)[1]+'}')
  self.complete_constructor((ROOT/'verification/mutants/induction_soundness.qnt').read_text(),1,correspondence['state_fields'],trade_types,pc=True)
  self.assertIn('--inv=effectSoundness',(ROOT/r['raw_output']).read_text())
  association=json.loads((ROOT/'verification/reports/qa-native-false-release.json').read_text())
  self.assertEqual(association['receipt'],r['id'])
  self.assertEqual(association['receipt_sha256'],hashlib.sha256(load_latest(r['id'])[0].read_bytes()).hexdigest())
  self.assertEqual(association['raw_sha256'],r['raw_sha256'])
  self.assertIn(association['exported_path'],(ROOT/r['raw_output']).read_text())
  trace=ROOT/association['preserved_trace']
  self.assertEqual(hashlib.sha256(trace.read_bytes()).hexdigest(),association['trace_sha256'])
  states=decode(json.loads(trace.read_text())['states'])
  self.assertEqual([x['pc'] for x in states],[12,13])
  before,after=[next(v for k,v in x.items() if k.endswith('_dvp_s')) for x in states]
  self.assertEqual((before['trades'][1]['holdB'],before['trades'][1]['refundsB']),(1,0))
  self.assertEqual((after['trades'][1]['holdB'],after['trades'][1]['refundsB']),(1,1))
  raw=(ROOT/r['raw_output']).read_text()
  self.assertTrue(evidence.native_counterexample(raw));self.assertFalse(evidence.native_tool_error(raw))
  self.assertTrue(evidence.native_tool_error('EXITCODE: ERROR (12)'))
 def test_colocated_commit_cannot_skip_local_transfers(self):
  self.observation('qa-non-atomic-cash-weak-safe','verification/models/dvp.qnt')
  self.observation('qa-partial-shared-weak-safe','verification/models/dvp.qnt')
  b=self.world(self.counter('qa-non-atomic-cash','localCommitAtomicity'))['trades'][1]
  shared=self.world(self.counter('qa-partial-shared','localCommitAtomicity'))['trades'][1]
  self.assertEqual((b['decision'],b['holdB'],b['effectsB']),(2,1,0))
  self.assertEqual((shared['decision'],shared['effectsA'],shared['effectsB']),(2,0,1))
 def test_native_payload_error_fields_are_not_tool_errors(self):
  p,r=load_latest('qa-payload_field0');raw=(ROOT/r['raw_output']).read_text()
  self.assertIn('error: 0',raw);self.assertIn('error: Invariant violated',raw)
  self.assertFalse(evidence.native_tool_error(raw))
 def test_actual_qnt_error_remains_a_non_success(self):
  raw=(ROOT/'verification/reviews/protocol-adequacy-2026-11-18/evidence/observations/runs/program_strict_foreign/raw.log').read_text()
  self.assertIn('Error [QNT502]',raw);self.assertTrue(evidence.native_tool_error(raw))
  native=json.loads((ROOT/'verification/results/runs/qa-effect-init-one-attempt1/receipt.json').read_text())
  raw=(ROOT/native['raw_output']).read_text()
  self.assertIn('EXITCODE: ERROR',raw);self.assertTrue(evidence.native_tool_error(raw))
  self.assertFalse(native['expectation_met']);self.assertEqual(native['outcome'],'tool_error')
 def test_authenticated_observer_uses_query_context(self):
  meta=json.loads((ROOT/'verification/mutants/observer-control.json').read_text())
  canonical=(ROOT/meta['canonical_source']).read_text();mutant=(ROOT/meta['mutant']).read_text()
  for key,text in [('canonical',canonical),('mutant',mutant)]:
   self.assertEqual(hashlib.sha256(text.encode()).hexdigest(),meta[key+'_sha256'])
  # Only release differs; the oracle, captured authenticated query and event
  # collector remain byte-identical. The fault cannot redefine its checker.
  strip=lambda text:re.sub(r'  pure def release\(.*?(?=  pure def issued)', '',text,flags=re.S)
  self.assertEqual(strip(canonical),strip(mutant))
  monitor=lambda text:text[text.index(' // Authenticated query'):text.index('\n action stepControl') if '\n action stepControl' in text else text.rindex('\n}')]
  self.assertEqual(monitor((ROOT/'verification/models/observer_view.qnt').read_text()),monitor((ROOT/'verification/mutants/observer_soundness.qnt').read_text()))
  self.assertEqual(hashlib.sha256(monitor((ROOT/'verification/models/observer_view.qnt').read_text()).encode()).hexdigest(),meta['monitor_sha256'])
  self.observation('qa-trusted-observer','verification/models/privacy_pipeline.qnt')
  owner='verification/mutants/generated/role_confusion.qnt'
  self.observation('qa-role-confusion-weak-observer',owner)
  self.observation('qa-role-confusion-weak-access',owner)
  state=self.counter('qa-role-confusion','TrustedNI',owner)
  self.counter('qa-role-confusion-access','TrustedAccess',owner)
  p=next(v for k,v in state.items() if k.split('::')[-1]=='p')
  left=p['issuesL'][0];right=p['issuesR'][0]
  self.assertEqual((left['query']['role'],left['response']['role'],left['response']['field']),(3,4,6))
  self.assertEqual((left['response']['value'],right['response']['value']),(4,7))
if __name__=='__main__':unittest.main()
