// Pure domain algebra, shared by the actual-State induction and its lemmas.
module effect_trade_domain {
 type TradeRow={ decision:int, oldTerminal:int, holdA:int, holdB:int,
    effectsA:int, effectsB:int, refundsA:int, refundsB:int,
    knownA:int, knownB:int, preparedA:bool, preparedB:bool, appliedEvidenceA:bool,
    appliedEvidenceB:bool, booked:int, report:int, stale:bool, intent:bool }
 type TradeAux={appliedEvidenceA:bool,appliedEvidenceB:bool,booked:int,report:int,stale:bool}
 type TradeParams=(int,int,int,int,int,TradeAux,bool)
 pure val AuxSpace=Set({appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:0,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:0,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:0,stale:true},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:2,stale:false},{appliedEvidenceA:false,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:false,appliedEvidenceB:true,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:false,booked:1,report:3,stale:false},{appliedEvidenceA:true,appliedEvidenceB:true,booked:1,report:3,stale:false})
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
