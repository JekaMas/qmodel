// Observe the last pre-rotation finalized source state, independently of the
// consumer's proof test. Snapshot previous effects before every economic step.
module admission_history {
  import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "./dvp"
  type Effects={a:int,b:int,finalHolds:Set[int],receivedPreps:Set[int],committed:bool}
  var cut:Set[int]
  var previous:Effects
  pure def effects(x:State):Effects={
    a:x.trades.get(1).holdA,b:x.trades.get(1).holdB,
    finalHolds:Set(1,2).filter(p=>x.finalized.contains(fact(1,p))),
    receivedPreps:Set(1,2).filter(p=>x.received.exists(f=>
      f==fact(1,p) and x.finalized.contains(f) and x.proofs.contains(f) and x.historical.contains(f.program))),
    committed:x.trades.get(1).decision==2
  }
  action initial=all {init,cut'=Set(),previous'={a:0,b:0,finalHolds:Set(),receivedPreps:Set(),committed:false}}
  action protocolWork=any {sign(1,0),sign(1,1),openA(1),prepareB(1),commit(1),abort(1),tick,idle,
    nondet p=Set(1,2).oneOf(); any {finalize(1,p),capture(1,p),prove(1,p),deliver(1,p)}}
  action historyStep=all {previous'=effects(s),any {
    all {protocolWork,cut'=cut},all {rotate,cut'=effects(s).finalHolds}
  }}
  val newFinalsAuthenticated = s.epoch!=1 or
    effects(s).finalHolds.exclude(previous.finalHolds).forall(p=>previous.receivedPreps.contains(3-p))
  val priorFinality = {
    val now=effects(s)
    newFinalsAuthenticated and ((s.epoch==1 and cut==Set()) implies and {
      now.a==1 implies previous.a==1,now.b==1 implies previous.b==1,
      now.finalHolds==Set(),now.committed implies previous.committed
    })
  }
}
