"""Generate explicit 0/1/0 induction obligations over the actual full State.

The ordinary Quint induction CLI cannot negate this large record's map-valued
TypeOK without unsupported function-set expansion in Apalache0.62.4. Explicit
arbitrary-state initialization uses independent nondeterministic fields instead.
Domain closure is part of the invariant proved after the actual step, not a
restriction on the step. No protocol state/transition is projected or filtered.
"""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[2]
CORE=(ROOT/'verification/models/dvp.qnt').read_text()
TRADE_FIELDS=re.findall(r'(\w+)\s*:\s*(bool|int)(?=\s*[,}])',re.search(r'type Trade\s*=\s*\{(.*?)\}',CORE,re.S)[1]+'}')

def body(n,local,control=False):
 bad=CORE[CORE.index('    val f=fact(t,p)',CORE.index('action inject')):CORE.index("    s'={...s,received",CORE.index('action inject'))].rstrip()+'\n    bad\n'
 text=''' // BEGIN generated full-state induction obligations
 // All integer amounts/auxiliary counters are unbounded Int. Only the finite
 // population and actual generated auxiliary fact/output universes are fixed.
 pure def domainFact(t:int,p:int,binding:int):Fact = {
'''+bad+''' }
 pure val AuthenticFacts=tuples(Trades,0.to(6)).map(v=>fact(v._1,v._2))
 pure val CandidateFacts=tuples(Trades,0.to(6),0.to(10)).map(v=>domainFact(v._1,v._2,v._3))
 pure val FactSpace=AuthenticFacts.union(CandidateFacts).union(AuthenticFacts.map(f=>{...f,program:0}))
 pure val AbortSpace=tuples(Trades,Set(0,1),0.to(3)).map(v=>{
  val d=desc(v._1)
  {d:d,leg:v._2,genesis:if(v._2==0) d.genesisA else d.genesisB,checkpoint:0,program:1,disposition:v._3}})
 pure val OutputSpace=tuples(Trades,Set(0,1),Set(0,1)).map(v=>economicOutput(v._1,v._2,v._3))
 pure val BookingSpace=tuples(Trades,Set(2,3)).map(v=>bookingOutput(v._1,v._2))
'''
 domains={'signed':'tuples(Trades.map(t=>desc(t)),Set(0,1))','economicReceipts':'OutputSpace','financialRecords':'BookingSpace',**{f:'FactSpace' for f in ['included','finalized','captured','proofs','network','received','pruned']},'abortRecords':'AbortSpace','up':'0.to(4)','historical':'Set(1,2)','eligible':'tuples(Trades,Set(0,1))','frozen':'Set(0,1)','note':'Trades','rejects':'0.to(10)'}
 text+=' pure def domainClosed(x:State):bool=and {x.trades.keys()==Trades,x.receivedA.keys()==Trades,x.receivedB.keys()==Trades,'+','.join('x.'+k+'.subseteq('+d+')' for k,d in domains.items())+'}\n'
 text+=' pure def localAtomic(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies '+local+'})\n'
 text+=''' pure def effectInvariant(x:State):bool=domainClosed(x) and localAtomic(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
 val effectI=effectInvariant(s)
 val localCommitAtomicity=localAtomic(s)
 val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
 action arbitraryInvariant={
'''
 values={}
 for t in range(1,n+1):
  for field,typ in TRADE_FIELDS:text+='  nondet t'+str(t)+'_'+field+'='+('Bool' if typ=='bool' else 'Int')+'.oneOf()\n'
  values.setdefault('trades',[]).append(str(t)+' -> {'+','.join(f+':t'+str(t)+'_'+f for f,_ in TRADE_FIELDS)+'}')
 for f in ['receivedA','receivedB']:
  for t in range(1,n+1):text+='  nondet '+f+str(t)+'=Int.oneOf()\n'
  values[f]='Map('+','.join(str(t)+' -> '+f+str(t) for t in range(1,n+1))+')'
 values['trades']='Map('+','.join(values['trades'])+')'
 for k,d in domains.items():
  text+='  nondet v_'+k+'='+d+'.powerset().oneOf()\n';values[k]='v_'+k
 for k in ['height','ownerA','ownerB','vaultA','vaultB','spentA','spentB','epoch']:
  text+='  nondet v_'+k+'=Int.oneOf()\n';values[k]='v_'+k
 for k in ['admitted','transportCompromised','custody','upgrade','validator','decrypt']:
  text+='  nondet v_'+k+'=Bool.oneOf()\n';values[k]='v_'+k
 if control:text+='  nondet programCounter=Int.oneOf()\n'
 text+='  val candidate={'+','.join(k+':'+v for k,v in values.items())+'}\n'
 text+="  all {effectInvariant(candidate),s'=candidate"+(",pc'=programCounter" if control else '')+'}\n }\n // END generated full-state induction obligations\n'
 return text

def main():
 profiles=[('one',1,0,False,False,False),('two',2,0,False,False,False),('b',1,1,False,False,False),('d',1,2,False,False,False),('escrow',1,0,False,True,False),('shared',1,3,False,False,False),('private',1,0,False,False,True),('open',1,0,True,False,False)]
 out='// Genuine full-State initiation, preservation and implication in explicit0/1/0 calls.\n// Same actual init/adversarialStep; auxiliary domain closure is proved, not assumed on Next.\n'
 for name,n,host,op,es,pr in profiles:
  local={0:'z.effectsA==1',1:'z.effectsB==1',2:'true',3:'z.effectsA==1 and z.effectsB==1'}[host]
  out+='module effects_'+name+' {\n import dvp(N='+str(n)+',HOST='+str(host)+',OPEN_REQUIRED='+str(op).lower()+',ESCROW='+str(es).lower()+',PRIVATE='+str(pr).lower()+',MUTANT=0).* from "./dvp"\n'+body(n,local)+'}\n'
 (ROOT/'verification/models/effect_consistency.qnt').write_text(out)
 old=(ROOT/'verification/mutants/effect_soundness.qnt').read_text()
 prefix=old[:old.index(' // Independent source-state monitor:')].replace('module false_release {','module induction_false_release {')
 # Keep the actual faulty handler and the exact original custom control steps.
 tail=old[old.index(' var pc:int'):]
 (ROOT/'verification/mutants/induction_soundness.qnt').write_text(prefix+' var pc:int\n'+body(1,'z.effectsA==1',True)+tail.replace(' var pc:int\n','',1))
if __name__=='__main__':main()
