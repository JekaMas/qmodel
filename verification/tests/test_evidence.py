"""Audit actual executed formal evidence; these are not model-to-production tests."""
import copy,json,unittest
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
if __name__=='__main__':unittest.main()
