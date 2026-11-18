// Two independently evaluated worlds, coupled only by the public operation schedule.
// This is a focused ideal-crypto interface model, not a proof of ZK or a refinement
// theorem for dvp.qnt. Private witnesses are never fields of observer-visible events.
module privacy_pipeline {
  const LEAK:int // 0 safe; 1 witness log; 2 timing; 3 unsalted guess; 4 wrong scope;
                 // 5 substituted disclosure; 6 wrong recipient note; 7 key compromise;
                 // 8..23 wrong scalar field0..15; 24 wrong root; 25 wrong program;
                 // 26 wrong source-note amount; 27 wrong source-note recipient.
  type Witness={trade:int,asset:int,amount:int,sender:int,recipient:int,
    genesis:int,position:int,owner:int,held:int,epoch:int}
  type Proof={trade:int,asset:int,amount:int,program:int,root:int,witness:Witness}
  type Note={trade:int,asset:int,amount:int,recipient:int}
  type World={id:int,position:int,signed:bool,owner:int,held:int,paid:int,
    snapshot:Witness,finalized:bool,captured:Witness,hasCapture:bool,
    proof:Proof,hasProof:bool,decision:int,epoch:int,up:bool,note:Note,
    hasNote:bool,key:bool,usable:bool,reportComplete:bool}
  // The private source commitment binds actual snapshot contents. Integers are
  // opaque atoms to this observer; arithmetic decoding is not in its capabilities.
  // Only equality, replay links and the explicit content-aware correspondence below
  // are admitted. This idealization does not establish computational hiding.
  pure def name(w:World,cap:Witness):int = w.id*1000+cap.position*10+cap.held
  pure def witness(w:World):Witness={trade:1,asset:40,amount:3,sender:0,recipient:1,
    genesis:120,position:w.position,owner:w.owner,held:w.held,epoch:w.epoch}
  pure def initial(world:int,pos:int):World={
    val empty={trade:1,asset:40,amount:3,sender:0,recipient:1,genesis:120,
      position:pos,owner:3,held:0,epoch:0}
    {id:world,position:pos,signed:false,owner:3,held:0,paid:0,
      snapshot:empty,finalized:false,captured:empty,hasCapture:false,
      proof:{trade:0,asset:0,amount:0,program:0,root:0,witness:empty},hasProof:false,
      decision:0,epoch:0,up:true,note:{trade:0,asset:0,amount:0,recipient:0},
      hasNote:false,key:true,usable:false,reportComplete:false}
  }
  // A fixed, observer-independent schedule drives each world's actual transitions:
  // consent, reserve, finalize, capture, prove, retry, crash, recover/rotate,
  // verify decision, cash application, note delivery, scoped audit/report.
  pure def evolve(w:World,op:int):World =
    if(op==0) {...w,signed:true}
    else if(op==1 and w.signed and w.owner-w.held>=3) {...w,held:3}
    else if(op==2 and w.held==3) {...w,snapshot:witness(w),finalized:true}
    else if(op==3 and w.finalized) {...w,captured:w.snapshot,hasCapture:true}
    else if(op==4 and w.hasCapture) {...w,hasProof:true,proof:{trade:w.captured.trade,
      asset:w.captured.asset,amount:w.captured.amount,program:1,
      root:name(w,w.captured),witness:w.captured}}
    else if(op==6) {...w,up:false}
    else if(op==7) {...w,up:true,epoch:1}
    else if(op==8 and w.up and w.hasProof and w.proof.witness==w.snapshot and
      w.proof.trade==1 and w.proof.asset==40 and w.proof.amount==3 and w.proof.program==1)
      {...w,decision:2}
    else if(op==9 and w.up and w.decision==2 and w.held==3)
      {...w,owner:w.owner-3,held:0,paid:3}
    else if(op==10 and w.paid==3) {...w,hasNote:true,
      note:{trade:w.captured.trade,asset:if(LEAK==6) 41 else w.captured.asset,
        amount:if(LEAK==26) 4 else w.captured.amount,
        recipient:if(LEAK==27) 0 else w.captured.recipient},usable:w.key}
    else if(op==11 and w.hasProof and w.paid==3) {...w,reportComplete:true}
    else w
  // This is the complete returned wire/API body. Internal source witnesses are
  // deliberately absent; an opaque root does not make a nested witness private.
  type Payload={role:int,field:int,surface:int,scope:int,value:int,error:int,
    trade:int,asset:int,root:int,program:int,note:Note}
  pure val emptyPayload:Payload={role:0,field:0,surface:0,scope:0,value:0,error:0,
    trade:0,asset:0,root:0,program:0,note:{trade:0,asset:0,amount:0,recipient:0}}
  type Event={op:int,trade:int,root:int,program:int,outcome:int,payload:Payload,
    routing:int,scope:int,queue:int,size:int,error:int,time:int,value:int}
  pure def observation(w:World,op:int,elapsed:int,externalQueue:int):Event={op:op,trade:w.proof.trade,
    root:w.proof.root,program:w.proof.program,
    outcome:w.decision,payload:emptyPayload,routing:20,scope:if(op==11) 1 else 0,queue:externalQueue+(if(w.hasCapture and not(w.hasProof)) 1 else 0)+(if(w.up) 0 else 1),
    size:if(w.hasProof) 2 else 1,error:if(w.up) 0 else 503,
    time:elapsed+(if(LEAK==2 and op==5 and w.captured.position>5) 1 else 0),
    value:if(LEAK==1 and op==4) w.captured.position
      else if(LEAK==3 and op==4) w.captured.position%2
      else if(LEAK==7 and op==11) w.snapshot.position else 0}
  // A fresh name is tied to a concrete private Witness, not an arbitrary identical
  // commitment constant. Retries reuse the same proof/root. The partial bijection
  // maps only the two authentic corresponding snapshot roots, and fixes public 0.
  pure def normalize(e:Event,w:World):Event = {...e,root:
    if(e.root==0) 0 else if(e.root==name(w,w.snapshot)) 1 else e.root,
    payload:{...e.payload,root:if(e.payload.root==0) 0 else if(e.payload.root==name(w,w.snapshot)) 1 else e.payload.root,
      value:if(e.payload.field==9 and e.payload.error==0 and e.payload.value==name(w,w.snapshot)) 1 else e.payload.value}}
  // Ghost issuance provenance is internal verifier/oracle data, never a response.
  // The query and contemporaneous source/proof context are captured separately
  // from the returned body. Neither release nor fieldValue is an oracle helper.
  type Query={role:int,field:int,surface:int,scope:int,at:int}
  type Issue={response:Payload,query:Query,source:Witness,note:Note,hasNote:bool,
    proofRoot:int,proofProgram:int,hasProof:bool,decision:int,up:bool}
  // Authenticated principal IDs, not caller-asserted role strings. Field indices
  // and six surfaces match privacy-policy.md. Scope 1 is the admitted local trade;
  // scope 2 is unrelated and cannot use the same authorization.
  pure def entitled(role:int,f:int,scope:int):bool = f>=8 or (scope==1 and
    (if(role==0) Set(0,1,2,4,7).contains(f)
     else if(role==2) Set(0,1,2,3,4,5).contains(f)
     else if(role==4) Set(2,4,5,6).contains(f)
     else if(role==5) Set(0,1,2,7).contains(f)
     else if(role==7) Set(0,1,2,3,4,5).contains(f) else false))
  pure def fieldValue(w:World,f:int,at:int):int =
    if(f==0) w.snapshot.recipient else if(f==1) w.snapshot.sender
    else if(f==2) w.snapshot.amount else if(f==3) w.snapshot.position
    else if(f==4) 1 else if(f==5) w.snapshot.held
    else if(f==6) w.captured.position else if(f==7) w.note.amount
    else if(f==8) w.proof.program else if(f==9) w.proof.root
    else if(f==10) w.snapshot.trade else if(f==11) w.decision
    else if(f==12) w.snapshot.genesis else if(f==13) (if(w.hasProof) 2 else 1)
    else if(f==14) (if(w.up) at else 503) else 1
  pure def release(w:World,role:int,f:int,surface:int,scope:int,at:int):Payload={
    val effectiveRole=4 // deliberate authenticated-principal confusion
    val permitted=entitled(effectiveRole,f,scope) or (LEAK==4 and role==7 and scope==2) or
      (LEAK==7 and role==3 and f==3)
    val available=f!=7 or w.hasNote
    {role:effectiveRole,field:f,surface:surface,scope:scope,
      value:if(not(permitted) or not(available)) -1
        else if(LEAK==8+f) (if(f==0) 0 else if(f==1) 1 else 99)
        else if(LEAK==5 and f==2) 4 else fieldValue(w,f,at),
      error:if(not(permitted)) 403 else if(not(available)) 404 else 0,trade:w.snapshot.trade,
      asset:if(permitted and available and Set(2,6,7).contains(f)) w.snapshot.asset else 0,
      root:if(LEAK==24) 999 else w.proof.root,program:if(LEAK==25) 99 else w.proof.program,
      note:if(permitted and available and f==7) w.note else emptyPayload.note}}
  pure def issued(w:World,role:int,f:int,surface:int,scope:int,at:int):Issue={
    response:release(w,role,f,surface,scope,at),query:{role:role,field:f,surface:surface,scope:scope,at:at},
    source:w.snapshot,note:w.note,hasNote:w.hasNote,proofRoot:w.proof.root,
    proofProgram:w.proof.program,hasProof:w.hasProof,decision:w.decision,up:w.up}
  // Relayer+unrelated-institution observers see their own complete response body.
  // Other authenticated principals use private channels: observer sees permitted
  // routing/status/size metadata, not regulator/prover/custody plaintext. The fixed
  // schedule never chooses a request by consulting either protected world.
  pure def responseEvent(w:World,d:Payload,at:int):Event={...observation(w,100+d.field,at,0),
    payload:if(d.role==1 or d.role==3) d else emptyPayload,
    scope:d.scope,error:d.error,size:if(d.error==0) 2 else 1,value:0}
  type State={pc:int,left:World,right:World,obsL:List[Event],obsR:List[Event],
    releasesL:Set[Payload],releasesR:Set[Payload],issuesL:Set[Issue],issuesR:Set[Issue],requested:bool}
  var p:State
  action init=p'={pc:0,left:initial(1,4),right:initial(2,7),obsL:List(),obsR:List(),
    releasesL:Set(),releasesR:Set(),issuesL:Set(),issuesR:Set(),requested:false}
  // Timestamp is supplied by the public schedule/environment, never a hidden input.
  action advanceWith(elapsed:int,externalQueue:int):bool={
    val l=evolve(p.left,p.pc)
    val r=evolve(p.right,p.pc)
    all {p.pc<12,p'={...p,pc:p.pc+1,left:l,right:r,
      obsL:p.obsL.append(observation(l,p.pc,elapsed,externalQueue)),obsR:p.obsR.append(observation(r,p.pc,elapsed,externalQueue)),
      releasesL:if(p.pc==11) p.releasesL.union(Set(release(l,7,3,5,1,p.pc))) else p.releasesL,
      releasesR:if(p.pc==11) p.releasesR.union(Set(release(r,7,3,5,1,p.pc))) else p.releasesR,
      issuesL:if(p.pc==11) p.issuesL.union(Set(issued(l,7,3,5,1,p.pc))) else p.issuesL,
      issuesR:if(p.pc==11) p.issuesR.union(Set(issued(r,7,3,5,1,p.pc))) else p.issuesR}}
  }
  action advanceAt(elapsed:int):bool=advanceWith(elapsed,0)
  action advance=advanceAt(p.pc)
  action request(role:int,f:int,surface:int,scope:int):bool=all {p.pc>=5,not(p.requested),
    p'={...p,requested:true,releasesL:p.releasesL.union(Set(release(p.left,role,f,surface,scope,p.pc))),
      releasesR:p.releasesR.union(Set(release(p.right,role,f,surface,scope,p.pc))),
      issuesL:p.issuesL.union(Set(issued(p.left,role,f,surface,scope,p.pc))),
      issuesR:p.issuesR.union(Set(issued(p.right,role,f,surface,scope,p.pc))),
      obsL:p.obsL.append(responseEvent(p.left,release(p.left,role,f,surface,scope,p.pc),p.pc)),
      obsR:p.obsR.append(responseEvent(p.right,release(p.right,role,f,surface,scope,p.pc),p.pc))}}
  action loseKey=p'={...p,left:{...p.left,key:false,usable:false},right:{...p.right,key:false,usable:false}}
  action pairedStep=any {advance,p'=p}
  // Stateless payload construction needs at most one arbitrary API request; the
  // main paired trace separately retains its actual authorized regulator release.
  action accessStep=any {advance,nondet role=0.to(7).oneOf();nondet f=0.to(15).oneOf();
    nondet surface=0.to(5).oneOf();nondet scope=Set(1,2).oneOf();request(role,f,surface,scope),p'=p}
  pure def ledgerSafe(w:World):bool = w.owner+w.paid==3 and w.owner>=w.held and
    (w.hasProof implies w.finalized and w.hasCapture and w.proof.witness==w.snapshot and
      w.proof.root==name(w,w.snapshot) and w.proof.amount==w.snapshot.held) and
    (w.decision==2 implies w.hasProof and (w.held==3 or w.paid==3))
  pure def disclosureSafe(d:Payload):bool = and {
    d.error==0 implies entitled(d.role,d.field,d.scope),d.error!=0 implies d.value== -1,
    (d.field!=7 or d.error!=0) implies d.note==emptyPayload.note,
    (not(Set(2,6,7).contains(d.field)) or d.error!=0) implies d.asset==0}
  pure def disclosureBound(i:Issue):bool = {
    val d=i.response
    val q=i.query
    val expectedError=if(not(entitled(q.role,q.field,q.scope))) 403 else if(q.field==7 and not(i.hasNote)) 404 else 0
    // Independent specification of each value, evaluated from immutable issuance
    // provenance. Keep this separate from the mutable producer's fieldValue.
    val expectedValue=if(q.field==0) i.source.recipient else if(q.field==1) i.source.sender
      else if(q.field==2) i.source.amount else if(q.field==3 or q.field==6) i.source.position
      else if(q.field==4) 1 else if(q.field==5) i.source.held else if(q.field==7) i.note.amount
      else if(q.field==8) i.proofProgram else if(q.field==9) i.proofRoot
      else if(q.field==10) i.source.trade else if(q.field==11) i.decision
      else if(q.field==12) i.source.genesis else if(q.field==13) (if(i.hasProof) 2 else 1)
      else if(q.field==14) (if(i.up) q.at else 503) else 1
    and {d.role==q.role,d.field==q.field,d.surface==q.surface,d.scope==q.scope,
      d.error==expectedError,d.trade==i.source.trade,d.root==i.proofRoot,d.program==i.proofProgram,
      d.value==(if(expectedError==0) expectedValue else -1),
      d.asset==(if(expectedError==0 and Set(2,6,7).contains(q.field)) i.source.asset else 0),
      if(q.field==7 and expectedError==0) d.note==i.note and d.note.trade==i.source.trade and
        d.note.asset==i.source.asset and d.note.amount==i.source.amount and
        d.note.recipient==i.source.recipient else d.note==emptyPayload.note}
  }
  pure def usable(w:World):bool = w.usable implies w.paid==3 and w.hasNote and w.key and
    w.note.trade==w.captured.trade and w.note.asset==w.captured.asset and
    w.note.amount==w.captured.amount and w.note.recipient==w.captured.recipient
  val PAccess=p.releasesL.forall(d=>disclosureSafe(d)) and p.releasesR.forall(d=>disclosureSafe(d))
  val PBinding=p.issuesL.forall(d=>disclosureBound(d)) and p.issuesR.forall(d=>disclosureBound(d))
  val PAvailability=usable(p.left) and usable(p.right)
  val PNI=p.obsL.foldl(List(),(a,e)=>a.append(normalize(e,p.left)))==p.obsR.foldl(List(),(a,e)=>a.append(normalize(e,p.right)))
  val PTiming=p.obsL.foldl(List(),(a,e)=>a.append(e.time))==p.obsR.foldl(List(),(a,e)=>a.append(e.time))
  val sourceRelation=p.left.position!=p.right.position and p.left.owner==p.right.owner and p.left.held==p.right.held and
    p.left.paid==p.right.paid and p.left.snapshot.position!=p.right.snapshot.position
  val safe=ledgerSafe(p.left) and ledgerSafe(p.right) and sourceRelation and PAccess and PBinding and PAvailability and PNI and PTiming
  // Actual typed note/key usability progress under this finite public schedule.
  // Permanent key loss remains in the transition system; it violates the stronger
  // unconditional claim rather than being hidden by a state constraint.
  action dataStep=any {advance,loseKey,p'=p}
  val completed=p.pc==12 and p.left.usable and p.right.usable and p.left.reportComplete and p.right.reportComplete
  temporal availability=(always(p.left.key and p.right.key) and advance.weakFair(Set(p))).implies(eventually(completed))
  temporal unconditionalAvailability=advance.weakFair(Set(p)).implies(eventually(completed))
  val noCompletion=not(completed)
}
module pipeline_safe {import privacy_pipeline(LEAK=0).*}
module pipeline_log {import privacy_pipeline(LEAK=1).*}
module pipeline_timing {import privacy_pipeline(LEAK=2).*}
module pipeline_unsalted {import privacy_pipeline(LEAK=3).*}
module pipeline_scope {import privacy_pipeline(LEAK=4).*}
module pipeline_substitution {import privacy_pipeline(LEAK=5).*}
module pipeline_note {import privacy_pipeline(LEAK=6).*}
module pipeline_compromise {import privacy_pipeline(LEAK=7).*}
