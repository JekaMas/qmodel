  // Work membership is durable while a proof, retry, or report is incomplete.
  type Queue={jobs:Set[int], offered:Set[int], junk:Set[int], ticks:int, lost:bool}
  var q:Queue
  action jobInit = all {start,pc'=0,q'={jobs:Set(),offered:Set(),junk:Set(),ticks:0,lost:false}}
  action admitJobs = all {pc==loadedPC,pc'=workingPC,q'={...q,jobs:Trades},clock'=clock,s'=s}

  action junkArrival(id:int):bool = all {
    pc==workingPC,pc'=pc,s'=s,clock'=clock,
    q'={...q,offered:q.offered.union(Set(id)),junk:if(q.offered.contains(id)) q.junk else q.junk.union(Set(id))}
  }

  action interrupted = all {
    pc==workingPC,clock.failures==4,pc'=pc,stop(3,2),
    q'=if(mode==3) {...q,jobs:Set(),ticks:0} else {...q,ticks:0}
  }
  action elapsed = all {pc==workingPC,pc'=pc,advance,q'=q}
  action restored = all {pc==workingPC,pc'=pc,restart(3),q'=q}
  action drop = {
    nondet t=Trades.oneOf()
    nondet p=Set(2,3,4).oneOf()
    all {pc==workingPC,pc'=pc,not(q.lost),not(s.received.contains(fact(t,p))),lose(t,p),
         clock'=clock,q'={...q,lost:true}}
  }

  def done(t:int):bool = evidenceBackedBooking(s,desc(t))
  val allDone = Trades.forall(t=>done(t))
  def ready(t:int):bool = q.jobs.contains(t) and not(done(t)) and
    Trades.filter(x=>x<t).forall(x=>not(q.jobs.contains(x)) or done(x))
  action firstStep(t:int):bool = if(t==2) abort(t) else
    any {advanceProof(t,2),commit(t)}

  action nextTradeJob(t:int):bool = {
    val disposition=s.trades.get(t).decision
    if(disposition==2) commitWork(t)
    else if(disposition==3) abortWork(t)
    else firstStep(t)
  }

  action service = all {
    pc==workingPC,pc'=pc,s.up==actors,clock'=clock,not(allDone),q.ticks<56,
    if(mode==1 and q.junk.size()>0) {
      nondet id=q.junk.oneOf()
      all {s'=s,q'={...q,junk:q.junk.exclude(Set(id)),ticks:q.ticks+1}}
    } else if(mode==2) all {s'=s,q'={...q,ticks:q.ticks+1}}
    else {
      nondet t=Trades.oneOf()
      all {ready(t),nextTradeJob(t),q'={...q,ticks:q.ticks+1}}
    }
  }
  action jobStep = any {
    bootstrap,admitJobs,interrupted,restored,elapsed,drop,service,
    nondet id=Set(1,2,3).oneOf();junkArrival(id),
    all {s'=s,clock'=clock,pc'=pc,q'=q}
  }
  val readySurvives = pc<workingPC or q.jobs==Trades
  val serviceBound = q.ticks<56 or allDone
  val jobSafety = sequenceSafe and readySurvives and serviceBound
  val completionWitness = not(allDone and q.junk.size()==3 and q.lost and clock.failures==3)
  temporal jobProgress = (eventually(always(s.up==actors)) and service.weakFair(Set(s)))
                            .implies((pc==workingPC).leadsTo(allDone))
