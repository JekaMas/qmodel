// Universal symbolic domain-bijection obligations, not sampled tests.
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
  nondet v_decision=Int.oneOf()
  nondet v_oldTerminal=Int.oneOf()
  nondet v_holdA=Int.oneOf()
  nondet v_holdB=Int.oneOf()
  nondet v_effectsA=Int.oneOf()
  nondet v_effectsB=Int.oneOf()
  nondet v_refundsA=Int.oneOf()
  nondet v_refundsB=Int.oneOf()
  nondet v_knownA=Int.oneOf()
  nondet v_knownB=Int.oneOf()
  nondet v_preparedA=Bool.oneOf()
  nondet v_preparedB=Bool.oneOf()
  nondet v_appliedEvidenceA=Bool.oneOf()
  nondet v_appliedEvidenceB=Bool.oneOf()
  nondet v_booked=Int.oneOf()
  nondet v_report=Int.oneOf()
  nondet v_stale=Bool.oneOf()
  nondet v_intent=Bool.oneOf()
  val candidate={decision:v_decision,oldTerminal:v_oldTerminal,holdA:v_holdA,holdB:v_holdB,effectsA:v_effectsA,effectsB:v_effectsB,refundsA:v_refundsA,refundsB:v_refundsB,knownA:v_knownA,knownB:v_knownB,preparedA:v_preparedA,preparedB:v_preparedB,appliedEvidenceA:v_appliedEvidenceA,appliedEvidenceB:v_appliedEvidenceB,booked:v_booked,report:v_report,stale:v_stale,intent:v_intent}
  all {tradeDomainContains(candidate),z'=candidate}
 }
 action step=z'=z
 val verified=RawTradeParams.contains(tradeDomainDecode(z)) and tradeDomainIntent(tradeDomainRow(tradeDomainDecode(z))) and tradeDomainRow(tradeDomainDecode(z))==z
}
