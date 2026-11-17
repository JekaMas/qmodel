module privacy {
  const LEAK: int // 0 safe, 1 witness log, 2 control-flow/timing, 3 unsalted guess, 4 wrong scope
  type Event = {phase:int, opaque:int, value:int, delay:int, size:int, err:int}
  type State = {pc:int,left:List[Event],right:List[Event],released:Set[(int,int,int,int)],
    badBinding:bool,delivered:bool,note:bool,key:bool,claimedUsable:bool,
    highWater:int,seen:Set[int],complete:bool,up:bool,epoch:int,published:int,noteTrade:int}
  var p:State
  pure def allowed(role:int,f:int,scope:int):bool =
    if(f>=8) true
    else if(role==0) scope==1 and Set(0,1,2,4,7).contains(f)
    else if(role==2) f!=6 and f!=7 and scope==1
    else if(role==4) scope==1 and Set(2,4,5,6).contains(f)
    else if(role==5) scope==1 and Set(0,1,2,7).contains(f)
    else if(role==7) scope==1 and f!=6 and f!=7
    else false
  // Different fresh opaque names in each world. compareObs is the explicit static renaming.
  pure def opaque(world:int,subject:int):int = world*100+subject
  pure def normalize(e:Event):Event = {...e,opaque:e.opaque%100}
  pure def event(world:int,phase:int):Event = {
    val hidden=if(world==1) 4 else 7
    {phase:phase,opaque:opaque(world,phase+1),
      value:if(LEAK==1 and phase==2) hidden else if(LEAK==3 and phase==1) hidden%2 else 0,
      delay:if(LEAK==2 and phase==3 and hidden>5) 2 else 1,
      size:if(phase==2) 2 else 1,err:0}
  }
  action init = p'={pc:0,left:List(),right:List(),released:Set(),badBinding:false,
    delivered:false,note:false,key:true,claimedUsable:false,highWater:2,
    seen:Set(),complete:false,up:true,epoch:0,published:0,noteTrade:0}
  action publicSchedule = all {p.pc<6,p.up,p'={...p,pc:p.pc+1,
    left:p.left.append(event(1,p.pc)),right:p.right.append(event(2,p.pc)),
    epoch:if(p.pc==4) 1 else p.epoch,delivered:p.delivered or p.pc==5}}
  action disclose(role:int,f:int,surface:int,scope:int):bool = all {
    allowed(role,f,scope) or (LEAK==1 and role==3 and f==6) or (LEAK==4 and role==7 and scope==2),
    p'={...p,released:p.released.union(Set((role,f,surface,scope)))}}
  action audit(t:int):bool = all {t<=p.highWater,p'={...p,seen:p.seen.union(Set(t)),
    complete:p.seen.union(Set(t))==Set(1,2)}}
  action bindDisclosure(opening:int):bool = all {opening==1 or LEAK==5,p'={...p,published:opening,badBinding:opening!=1}}
  action noteDelivery = all {p.delivered,p'={...p,note:true,noteTrade:if(LEAK==6) 2 else 1,claimedUsable:p.key}}
  action loseKey = p'={...p,key:false,claimedUsable:false}
  action compromiseDisclosure = all {LEAK==7,p'={...p,released:p.released.union(Set((3,2,4,1)))}}
  action losePayload = p'={...p,note:false,claimedUsable:false}
  action crash = p'={...p,up:false}
  action recover = p'={...p,up:true}
  action step = any {publicSchedule,noteDelivery,losePayload,loseKey,compromiseDisclosure,crash,recover,
    nondet r=0.to(7).oneOf();nondet f=0.to(15).oneOf();nondet surf=0.to(5).oneOf();nondet scope=Set(1,2).oneOf();disclose(r,f,surf,scope),
    nondet t=Set(1,2).oneOf();audit(t),bindDisclosure(1),p'=p}
  action accessStep = any {p'=p,all {p.released==Set(),
    nondet r=0.to(7).oneOf();nondet f=0.to(15).oneOf();nondet surf=0.to(5).oneOf();nondet scope=Set(1,2).oneOf();disclose(r,f,surf,scope)}}
  action bindingStep = any {bindDisclosure(1),bindDisclosure(2),p'=p}
  action scopeStep = any {audit(1),audit(2),p'=p}
  // Focused relational step excludes independent disclosure-set enumeration.
  action pairedStep = any {publicSchedule,p'=p}
  val PAccess = p.released.forall(x=>allowed(x._1,x._2,x._4))
  val PBinding = not(p.badBinding) and (p.published==0 or p.published==1)
  val PAvailability = p.claimedUsable implies p.delivered and p.note and p.key and p.noteTrade==1
  val PScope = p.complete implies p.seen==Set(1,2) and p.highWater==2
  val PNI = p.left.foldl(List(),(a,e)=>a.append(normalize(e)))==p.right.foldl(List(),(a,e)=>a.append(normalize(e)))
  val PTiming = p.left.foldl(List(),(a,e)=>a.append(e.delay))==p.right.foldl(List(),(a,e)=>a.append(e.delay))
  val safe = PAccess and PBinding and PAvailability and PScope and PNI and PTiming
  val noAudit = not(p.complete)
  val deliveryMeansUsability = p.delivered implies p.claimedUsable
}
module privacy_safe {import privacy(LEAK=0).*}
module witness_log {import privacy(LEAK=1).*}
module timing_leak {import privacy(LEAK=2).*}
module unsalted {import privacy(LEAK=3).*}
module wrong_scope {import privacy(LEAK=4).*}

module disclosure_substitution {import privacy(LEAK=5).*}
module wrong_note {import privacy(LEAK=6).*}

module disclosure_key_compromise {import privacy(LEAK=7).*}
