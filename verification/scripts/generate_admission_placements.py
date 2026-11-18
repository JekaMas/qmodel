"""Actual source-derived program0 cases at every remote preparation consumer.

B consumes security evidence; D separately consumes security and cash evidence.
Shared execution has no remote-proof admission gate. No certificate fixtures.
"""
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[2]
def module(name,host,phase,bug,tests):
 head='module '+name+' {\n import dvp(N=1,HOST='+str(host)+',OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT='+str(bug)+').* from "../models/dvp"\n'
 actions=['sign(1,0)','sign(1,1)','openA(1)','prepareB(1)','registerDecision(1)','finalize(1,1)','capture(1,1)',('proveUnadmitted(1,1)' if phase==1 else 'prove(1,1)'),('deliverUnadmitted(1,1)' if phase==1 else 'deliver(1,1)'),'finalize(1,2)','capture(1,2)',('proveUnadmitted(1,2)' if phase==2 else 'prove(1,2)'),('deliverUnadmitted(1,2)' if phase==2 else 'deliver(1,2)')]
 if tests:
  prefix='init'+''.join('.then('+a+')' for a in actions)
  canonical='init'+''.join('.then('+a.replace('proveUnadmitted','prove').replace('deliverUnadmitted','deliver')+')' for a in actions)
  return head+' run actualUnadmittedRejectTest='+prefix+'.expect(s.proofs.contains({...fact(1,'+str(phase)+'),program:0}) and s.received.contains({...fact(1,'+str(phase)+'),program:0}) and not(s.historical.contains(0)) and not(canCommit(s,1)) and safe).then(commit(1).fail())\n run canonicalAcceptTest='+canonical+'.then(commit(1)).expect(safe and S10 and s.trades.get(1).decision==2)\n}\n'
 actions+=['commit(1)']
 return head+" var pc:int\n action initControl=all {init,pc'=0}\n action stepControl=any {\n"+',\n'.join('  all {pc=='+str(i)+','+a+",pc'=pc+1}" for i,a in enumerate(actions))+'\n }\n}\n'
def main():
 positive='// Actual captured/finalized facts; crypto-validity is distinct from admission.\n'
 negative='// Only the real consumer program-admission gate is removed (MUTANT10).\n// Canonical S10 and actual source/proof production remain unchanged.\n'
 catalog=[]
 for name,host,phase in [('b',1,1),('d_security',2,1),('d_cash',2,2)]:
  positive+=module('admission_'+name+'_test',host,phase,0,True)
  negative+=module('admission_'+name+'_fault',host,phase,10,False)
  catalog.append({'name':name,'host':host,'source_phase':phase,'positive':'qa-admission-'+name,'negative':'qa-program-admission-'+name,'finding':'QA-02','property':'S10','steps':15,'scope':'Actual source-derived external program0 at the selected remote consumer; no provenance fixture.'})
 (ROOT/'verification/tests/admission_placements_test.qnt').write_text(positive)
 (ROOT/'verification/mutants/admission_placements.qnt').write_text(negative)
 (ROOT/'verification/mutants/admission-placements.json').write_text(json.dumps(catalog,indent=2)+'\n')
if __name__=='__main__':main()
