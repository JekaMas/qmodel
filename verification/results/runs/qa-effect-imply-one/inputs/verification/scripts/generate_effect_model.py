"""Equivalent structural induction predicates with a checked row-domain bijection.

The point-set domain binds the whole imported State. The field predicate is the
same domain expressed without re-enumerating the record range at every query.
Two independent universal Quint lemmas prove its row constructor/decoder laws.
Neither the actual protocol State nor any transition/guard is changed.
"""
from pathlib import Path
import re,itertools,json
ROOT=Path(__file__).resolve().parents[2]
CORE=(ROOT/'verification/models/dvp.qnt').read_text()
TRADE_BODY=re.search(r'type Trade\s*=\s*\{(.*?)\}',CORE,re.S)[1]
TRADE_FIELDS=re.findall(r'(\w+)\s*:\s*(bool|int)(?=\s*[,}])',TRADE_BODY+'}')

def helper():
 rows=[]
 for booked,report,stale in [(0,0,False),(0,0,True),(1,0,True),(1,2,False),(1,3,False)]:
  for a,b in itertools.product([False,True],repeat=2):
   if report==2 and not(a and b):continue
   rows.append('{appliedEvidenceA:'+str(a).lower()+',appliedEvidenceB:'+str(b).lower()+',booked:'+str(booked)+',report:'+str(report)+',stale:'+str(stale).lower()+'}')
 return '''// Pure domain algebra, shared by the actual-State induction and its lemmas.
module effect_trade_domain {
 type TradeRow={'''+TRADE_BODY+'''}
 type TradeAux={appliedEvidenceA:bool,appliedEvidenceB:bool,booked:int,report:int,stale:bool}
 type TradeParams=(int,int,int,int,int,TradeAux,bool)
 pure val AuxSpace=Set('''+','.join(rows)+''')
 pure val RawTradeParams=tuples(0.to(3),0.to(3),0.to(3),Set(0,2,3),Set(0,2,3),AuxSpace,Bool)
 pure def tradeDomainRow(v:TradeParams):TradeRow={
  decision:v._1,oldTerminal:if(v._1>=2) v._1 else 0,holdA:v._2,holdB:v._3,
  effectsA:if(v._2==2) 1 else 0,effectsB:if(v._3==2) 1 else 0,
  refundsA:if(v._2==3) 1 else 0,refundsB:if(v._3==3) 1 else 0,
  knownA:v._4,knownB:v._5,preparedA:v._2!=0,preparedB:v._3!=0,
  appliedEvidenceA:v._6.appliedEvidenceA,appliedEvidenceB:v._6.appliedEvidenceB,
  booked:v._6.booked,report:v._6.report,stale:v._6.stale,intent:v._7}
 pure def tradeDomainIntent(z:TradeRow):bool=z.intent or (z.holdA==0 and z.holdB==0 and Set(0,3).contains(z.decision))
 pure def tradeDomainAux(z:TradeRow):TradeAux={appliedEvidenceA:z.appliedEvidenceA,appliedEvidenceB:z.appliedEvidenceB,booked:z.booked,report:z.report,stale:z.stale}
 pure def tradeDomainDecode(z:TradeRow):TradeParams=(z.decision,z.holdA,z.holdB,z.knownA,z.knownB,tradeDomainAux(z),z.intent)
 pure def tradeDomainContains(z:TradeRow):bool=and {
  0.to(3).contains(z.decision),0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  Set(0,2,3).contains(z.knownA),Set(0,2,3).contains(z.knownB),Bool.contains(z.intent),
  z.oldTerminal==(if(z.decision>=2) z.decision else 0),
  z.effectsA==(if(z.holdA==2) 1 else 0),z.effectsB==(if(z.holdB==2) 1 else 0),
  z.refundsA==(if(z.holdA==3) 1 else 0),z.refundsB==(if(z.holdB==3) 1 else 0),
  z.preparedA==(z.holdA!=0),z.preparedB==(z.holdB!=0),AuxSpace.contains(tradeDomainAux(z)),tradeDomainIntent(z)}
 pure val TradeSpace=RawTradeParams.map(v=>tradeDomainRow(v)).filter(z=>tradeDomainIntent(z))
}
'''

def state_domains():
 fields=[('trades','Trades.setOfMaps(TradeSpace)'),('signed','tuples(Trades.map(t=>desc(t)),Set(0,1)).powerset()'),('height','Int')]
 fields += [(x,'Int') for x in ['ownerA','ownerB','vaultA','vaultB','spentA','spentB']]
 fields += [('receivedA','Trades.setOfMaps(Int)'),('receivedB','Trades.setOfMaps(Int)'),('economicReceipts','OutputSpace.powerset()'),('financialRecords','BookingSpace.powerset()')]
 fields += [(x,'FactSpace.powerset()') for x in ['included','finalized','captured','proofs','network','received']]
 fields += [('abortRecords','AbortSpace.powerset()'),('pruned','FactSpace.powerset()'),('up','0.to(4).powerset()'),('epoch','Int'),('admitted','Bool'),('historical','Set(1,2).powerset()'),('eligible','tuples(Trades,Set(0,1)).powerset()'),('frozen','Set(0,1).powerset()'),('note','Trades.powerset()'),('rejects','0.to(10).powerset()')]
 fields += [(x,'Bool') for x in ['transportCompromised','custody','upgrade','validator','decrypt']]
 return fields

def expanded(k,d):
 if k=='trades':return 'x.trades.keys()==Trades and Trades.forall(t=>tradeDomainContains(x.trades.get(t)))'
 if k in ['receivedA','receivedB']:return 'x.'+k+'.keys()==Trades and Trades.forall(t=>Int.contains(x.'+k+'.get(t)))'
 if d.endswith('.powerset()'):return 'x.'+k+'.subseteq('+d[:-len('.powerset()')]+')'
 return d+'.contains(x.'+k+')'

def domain():
 bad=CORE[CORE.index('    val f=fact(t,p)',CORE.index('action inject')):CORE.index("    s'={...s,received",CORE.index('action inject'))].rstrip()+'\n    bad\n'
 out=''' // Complete actual-State domain. Its closure is part of the induction.
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
 fields=state_domains()
 out+=' pure val StateSpace=tuples('+','.join(d for _,d in fields)+').map(v=>{'+','.join(k+':v._'+str(i+1) for i,(k,_) in enumerate(fields))+'})\n'
 out+=' val FullTypeOK=s.in(StateSpace)\n'
 out+=' // Record membership is field membership; map membership fixes keys and\n // range; powerset membership is subset. Row equivalence has native lemmas.\n'
 out+=' pure def domainByFields(x:State):bool=and {'+','.join(expanded(k,d) for k,d in fields)+'}\n'
 return out

def monitors(local,pc=False):
 out=' pure def localAtomicAt(x:State):bool=Trades.forall(t=> {val z=x.trades.get(t);z.decision==2 implies '+local+'})\n val localCommitAtomicity=localAtomicAt(s)\n'
 out+=''' pure def physicalInvariant(x:State):bool=localAtomicAt(x) and Trades.forall(t=> {val z=x.trades.get(t);and {
  0.to(3).contains(z.holdA),0.to(3).contains(z.holdB),
  0.to(1).contains(z.effectsA),0.to(1).contains(z.effectsB),
  0.to(1).contains(z.refundsA),0.to(1).contains(z.refundsB),
  (z.holdA==2) iff z.effectsA==1,(z.holdB==2) iff z.effectsB==1,
  (z.holdA==3) iff z.refundsA==1,(z.holdB==3) iff z.refundsB==1}})
'''
 out+=' val ICore=physicalInvariant(s)\n'
 suffix=' and pc.in(Int)' if pc else ''
 out+=' val effectI=FullTypeOK and ICore'+suffix+'\n val effectIExpanded=domainByFields(s) and ICore'+suffix+'\n'
 out+=' // Equivalent initializers, not a state/transition filter. The domain\n // encoder/decoder lemmas establish that every field-form state is included.\n val inductionInit=effectI and effectIExpanded\n'
 out+=''' val effectSoundness=localCommitAtomicity and Trades.forall(t=> {val z=s.trades.get(t);and {
  z.effectsA>0 implies z.holdA==2,z.effectsB>0 implies z.holdB==2,
  z.refundsA>0 implies z.holdA==3,z.refundsB>0 implies z.holdB==3,
  z.holdA==1 implies z.effectsA==0 and z.refundsA==0,
  z.holdB==1 implies z.effectsB==0 and z.refundsB==0}})
'''
 return out

def arbitrary(n,pc=False):
 # Every scalar is independent; finite map keys are exactly the configured
 # Trades. The guard is precisely the remaining row/physical invariant. Type
 # domains of all other fields follow from their nondeterministic choices.
 out=' // Complete arbitrary invariant-state initializer; not protocol Next.\n action arbitraryInductive={\n';values={}
 for t in range(1,n+1):
  for field,typ in TRADE_FIELDS:out+='  nondet t'+str(t)+'_'+field+'='+('Bool' if typ=='bool' else 'Int')+'.oneOf()\n'
  values.setdefault('trades',[]).append(str(t)+' -> {'+','.join(f+':t'+str(t)+'_'+f for f,_ in TRADE_FIELDS)+'}')
 values['trades']='Map('+','.join(values['trades'])+')'
 for k,d in state_domains():
  if k=='trades':continue
  if k in ['receivedA','receivedB']:
   for t in range(1,n+1):out+='  nondet '+k+str(t)+'=Int.oneOf()\n'
   values[k]='Map('+','.join(str(t)+' -> '+k+str(t) for t in range(1,n+1))+')'
  else:out+='  nondet v_'+k+'='+d+'.oneOf()\n';values[k]='v_'+k
 if pc:out+='  nondet programCounter=Int.oneOf()\n'
 out+='  val candidate={'+','.join(k+':'+values[k] for k,_ in state_domains())+'}\n'
 out+="  all {Trades.forall(t=>tradeDomainContains(candidate.trades.get(t))),physicalInvariant(candidate),s'=candidate"+(",pc'=programCounter" if pc else '')+'}\n }\n'
 return out

def lemmas():
 out='''// Universal symbolic domain-bijection obligations, not sampled tests.
module trade_domain_forward {
 import effect_trade_domain.* from "./effect_trade_domain"
 var v:TradeParams
 action init={nondet p=RawTradeParams.oneOf();v'=p}
 action step=v'=v
 val verified=(not(tradeDomainIntent(tradeDomainRow(v))) or tradeDomainContains(tradeDomainRow(v))) and tradeDomainDecode(tradeDomainRow(v))==v
}
module trade_domain_reverse {
 import effect_trade_domain.* from "./effect_trade_domain"
 var z:TradeRow
 action init={
'''
 for field,typ in TRADE_FIELDS:out+='  nondet v_'+field+'='+('Bool' if typ=='bool' else 'Int')+'.oneOf()\n'
 out+='  val candidate={'+','.join(f+':v_'+f for f,_ in TRADE_FIELDS)+"}\n  all {tradeDomainContains(candidate),z'=candidate}\n }\n action step=z'=z\n"
 out+=' val verified=RawTradeParams.contains(tradeDomainDecode(z)) and tradeDomainIntent(tradeDomainRow(tradeDomainDecode(z))) and tradeDomainRow(tradeDomainDecode(z))==z\n}\n'
 return out

def main():
 (ROOT/'verification/models/effect_trade_domain.qnt').write_text(helper())
 (ROOT/'verification/models/trade_domain_lemmas.qnt').write_text(lemmas())
 profiles=[('one',1,0,False,False,False),('two',2,0,False,False,False),('b',1,1,False,False,False),('d',1,2,False,False,False),('escrow',1,0,False,True,False),('shared',1,3,False,False,False),('private',1,0,False,False,True),('open',1,0,True,False,False)]
 out='// Actual full State/init/adversarialStep. Equivalent field-form induction\n// avoids expensive range re-enumeration; native row-bijection lemmas are required.\n'
 for name,n,host,op,es,pr in profiles:
  local={0:'z.effectsA==1',1:'z.effectsB==1',2:'true',3:'z.effectsA==1 and z.effectsB==1'}[host]
  out+='module effects_'+name+' {\n import dvp(N='+str(n)+',HOST='+str(host)+',OPEN_REQUIRED='+str(op).lower()+',ESCROW='+str(es).lower()+',PRIVATE='+str(pr).lower()+',MUTANT=0).* from "./dvp"\n import effect_trade_domain.* from "./effect_trade_domain"\n'+domain()+monitors(local)+arbitrary(n)+'}\n'
 (ROOT/'verification/models/effect_consistency.qnt').write_text(out)
 old=(ROOT/'verification/mutants/effect_soundness.qnt').read_text()
 prefix=old[:old.index(' // Independent source-state monitor:')].replace('module false_release {','module induction_false_release {')
 prefix=prefix.replace(' action falseRelease',' import effect_trade_domain.* from "../models/effect_trade_domain"\n action falseRelease')
 tail=old[old.index(' var pc:int'):].replace(' var pc:int\n','',1)
 (ROOT/'verification/mutants/induction_soundness.qnt').write_text(prefix+' var pc:int\n'+domain()+monitors('z.effectsA==1',True)+arbitrary(1,True)+tail)
 directory=ROOT/'verification/generated';directory.mkdir(exist_ok=True)
 (directory/'effect-domain-correspondence.json').write_text(json.dumps({'state_fields':[{'field':k,'domain':d,'field_constraint':expanded(k,d)} for k,d in state_domains()],'row_fields':[k for k,_ in TRADE_FIELDS],'row_bijection_obligations':['qa-trade-domain-forward','qa-trade-domain-reverse'],'identities':['record-set membership iff every named field belongs to its domain','function-set membership iff exact domain and pointwise range membership','powerset membership iff subset','TradeSpace membership iff tradeDomainContains by the two universal native lemmas'],'scope':'Exact typed record/map/set-domain equivalence; no protocol state or Next relation changes.'},indent=2)+'\n')
if __name__=='__main__':main()
