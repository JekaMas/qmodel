"""Audit actual executed formal evidence; these are not model-to-production tests."""
import copy,json,unittest,hashlib,tempfile,shutil,sys
from pathlib import Path
from unittest.mock import patch
import verification.scripts.audit_evidence as audit
sys.path.insert(0,str(audit.ROOT/"verification/scripts"))
import evidence as runner
import replay
from verification.scripts.audit_evidence import ROOT,EvidenceError,load_latest,validate,audit_required
class EvidenceAudit(unittest.TestCase):
 def test_required_backend_observations(self):
  self.assertGreater(audit_required(),50)
 def test_negative_suite_has_real_counterexamples(self):
  names=['expiry','binding','replay','reopen','non_atomic','relayer_assertion','stale_refund','pruned_tombstone']
  for name in names:
   p,r=load_latest('mutant-'+name);self.assertEqual(r['expected'],'counterexample');self.assertEqual(r['outcome'],'expected_counterexample_found');validate(r,p)
 def test_tool_error_cannot_kill_mutant(self):
  p,r=load_latest('mutant-expiry');bad=copy.deepcopy(r);bad['exit_code']=0
  with self.assertRaises(EvidenceError):validate(bad,p)
 def test_changed_source_identity_is_rejected(self):
  p,r=load_latest('final-record-safety');bad=copy.deepcopy(r);k=next(iter(bad['input_hashes']));bad['input_hashes'][k]='0'*64
  with self.assertRaises(EvidenceError):validate(bad,p)
 def test_external_and_timeout_scope_is_visible(self):
  m=json.loads((ROOT/'verification/results/manifest.json').read_text())
  self.assertFalse(m.get('unqualified_deployed_verification',False));self.assertGreater(len(m['external_obligations']),4)
  self.assertTrue(m['historical_broader_timeouts'])
  self.assertTrue(all(any(r['id']==i and r['outcome']=='timeout' for r in m['executions']) for i in m['historical_broader_timeouts']))
 def test_omitted_negative_observation_is_not_completion(self):
  with self.assertRaises(EvidenceError):load_latest('nonexistent-required-counterexample')
 def test_changed_claim_and_target_are_rejected(self):
  p,r=load_latest('mutant-expiry');bad=copy.deepcopy(r);bad['claim']='THIS_PROPERTY_WAS_NEVER_EXECUTED';bad['command'][bad['command'].index('--invariant')+1]=bad['claim']
  with self.assertRaises(EvidenceError):validate(bad,p)
 def test_changed_native_log_is_rejected(self):
  p,r=load_latest('mutant-expiry')
  with tempfile.TemporaryDirectory(dir=ROOT/'verification/results/runtime') as td:
   base=Path(td);raw=base/r['raw_output'];raw.parent.mkdir(parents=True);raw.write_text('Invariant violated: an unrelated observation')
   contracts=base/'verification/configs/proof-contracts.json';contracts.parent.mkdir(parents=True);shutil.copyfile(ROOT/'verification/configs/proof-contracts.json',contracts)
   with patch.object(audit,'ROOT',base):
    with self.assertRaisesRegex(EvidenceError,'Native output identity changed'):validate(r,p)
 def test_forced_replays_execute_two_processes(self):
  with tempfile.TemporaryDirectory(dir=ROOT/'verification/results/runtime') as td:
   base=Path(td);count=base/'calls.txt'
   code='from pathlib import Path; p=Path('+repr(str(count))+'); p.write_text(str(int(p.read_text())+1 if p.exists() else 1)); print(p.read_text())'
   cmd=[sys.executable,'-c',code]
   with patch.object(runner,'RESULTS',base):
    a=runner.execute('forced-probe',cmd,claim='actual process execution discriminator',force=True)
    b=runner.execute('forced-probe',cmd,claim='actual process execution discriminator',force=True)
   self.assertEqual(count.read_text(),'2');self.assertNotEqual(a['id'],b['id']);self.assertTrue(a['expectation_met'] and b['expectation_met'])
 def test_exact_failed_receipt_is_not_replaced_by_success(self):
  p,r=replay.select_receipt('apalache-core-20',include_failed=True)
  self.assertEqual(r['id'],'apalache-core-20');self.assertEqual(r['outcome'],'timeout')
  with self.assertRaises(ValueError):replay.select_receipt('apalache-core-20')
 def test_absolute_recorded_input_relocates_to_saved_closure(self):
  p,r=replay.select_receipt('mutant-expiry-attempt2');moved=copy.deepcopy(r)
  moved['environment']['QUINT_HOME']='/archive/old-qmodel/.quint'
  saved=replay.captured_argument(p,moved,'/archive/old-qmodel/verification/mutants/guided.qnt')
  self.assertEqual(saved,p.parent/'inputs/verification/mutants/guided.qnt')
  with self.assertRaises(ValueError):replay.captured_argument(p,moved,'/unrelated/live/model.qnt')
 def test_mutable_shared_trace_is_not_a_comparison_baseline(self):
  p,r=replay.select_receipt('mutant-expiry-attempt1')
  contracts=json.loads((ROOT/'verification/configs/proof-contracts.json').read_text())['observations']
  self.assertIsNone(replay.comparison_trace(r,contracts[r['id']]))
  p,r=replay.select_receipt('mutant-expiry-attempt2')
  baseline=replay.comparison_trace(r,contracts[r['id']])
  self.assertIsNotNone(baseline);self.assertNotEqual(baseline,ROOT/r['command'][r['command'].index('--out-itf')+1])
 def test_zero_selected_quint_scenarios_are_not_success(self):
  p,r=load_latest('review-zero-selection')
  self.assertFalse(r['expectation_met']);self.assertEqual(r['outcome'],'tool_error')
  self.assertEqual(r['exit_code'],0);self.assertNotRegex((ROOT/r['raw_output']).read_text(),r'[1-9][0-9]* passing')
  with self.assertRaises(EvidenceError):validate(r,p)
 def test_new_invocation_records_observed_runtime(self):
  p,r=load_latest('review-fifo-workload')
  self.assertEqual(r['tool_versions']['quint'],json.loads((ROOT/'package.json').read_text())['devDependencies']['@informalsystems/quint'])
  self.assertIn('execution_plan_sha256',r);self.assertIn('raw_sha256',r);self.assertTrue(r['tooling_hashes'])
  validate(r,p)
if __name__=='__main__':unittest.main()
