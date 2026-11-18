// Reporter sees authenticated manifests, not the source's live head.
module audit_scope {
 const OMIT:int
 type Header={genesis:int,checkpoint:int,highWater:int,program:int}
 type State={sourceHead:int,sourceHeaders:Set[Header],received:Set[Header],knownHead:int,verified:Set[int],
  seen:Set[int],reportHead:int,complete:bool,asOfLabeled:bool,currentClaim:bool}
 var h:State
 pure def header(n:int):Header={genesis:110,checkpoint:0,highWater:n,program:1}
 action init=h'={sourceHead:2,sourceHeaders:Set(),received:Set(),knownHead:0,verified:Set(),seen:Set(),
  reportHead:0,complete:false,asOfLabeled:true,currentClaim:false}
 action appendRecord=all {h.sourceHead==2,h'={...h,sourceHead:3}}
 action finalizeManifest=h'={...h,sourceHeaders:h.sourceHeaders.union(Set(header(h.sourceHead)))}
 action deliver(n:int):bool=all {h.sourceHeaders.contains(header(n)),h'={...h,received:h.received.union(Set(header(n)))}}
 action verify(n:int):bool=all {h.received.contains(header(n)),h'={...h,verified:h.verified.union(Set(n)),knownHead:n}}
 action fetchRecord(n:int):bool=all {n<=h.knownHead,n>0,h'={...h,seen:h.seen.union(Set(n))}}
 action reportAsOf(n:int):bool=all {h.verified.contains(n),h'={...h,reportHead:n,
   complete:if(OMIT==1) h.seen.size()>0 else 1.to(n).subseteq(h.seen),
   asOfLabeled:true,currentClaim:false}}
 action report=reportAsOf(h.knownHead)
 action step=any {appendRecord,finalizeManifest,nondet n=Set(2,3).oneOf();any {deliver(n),verify(n),reportAsOf(n)},
   nondet n=Set(1,2,3).oneOf();fetchRecord(n),report,h'=h}
 val scope=h.complete implies 1.to(h.reportHead).subseteq(h.seen)
 val freshness=not(h.currentClaim) and h.asOfLabeled
 val authenticated=h.reportHead==0 or h.sourceHeaders.contains(header(h.reportHead))
 val exactCursor = (if(h.verified==Set()) h.knownHead==0 else h.verified.contains(h.knownHead)) and
   h.verified.forall(n=>n<=h.knownHead)
 val safe=scope and freshness and authenticated and exactCursor
 val noComplete=not(h.complete)
}
module audit_safe {import audit_scope(OMIT=0).*}
module omitted_record {import audit_scope(OMIT=1).*}
