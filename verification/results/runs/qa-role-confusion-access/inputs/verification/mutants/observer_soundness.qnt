module role_confusion {
 import privacy_pipeline(LEAK=0).* from "./generated/role_confusion"

 // Authenticated query principal decides who received a body. A producer's
 // returned role tag cannot turn a public caller into a private prover channel.
 // There is at most one arbitrary API request; the extra regulator issue is
 // private. A set therefore preserves the entire public response history here.
 // PNI separately retains ordering/timing/size/error of all12public operations.
 type TrustedView={query:Query,body:Payload}
 pure def trustedView(i:Issue,w:World):TrustedView={
  val d=i.response
  {query:i.query,body:{...d,
   root:if(d.root==0) 0 else if(d.root==name(w,w.snapshot)) 1 else d.root,
   value:if(i.query.field==9 and d.error==0 and d.value==name(w,w.snapshot)) 1 else d.value}}
 }

 pure def trustedAccess(i:Issue):bool = i.response.error!=0 or
  entitled(i.query.role,i.response.field,i.query.scope)
 val TrustedAccess=PAccess and p.issuesL.forall(i=>trustedAccess(i)) and p.issuesR.forall(i=>trustedAccess(i))
 val TrustedNI=PNI and
  p.issuesL.filter(i=>Set(1,3).contains(i.query.role)).map(i=>trustedView(i,p.left))==
  p.issuesR.filter(i=>Set(1,3).contains(i.query.role)).map(i=>trustedView(i,p.right))
 action stepControl=if(p.pc<5) advance else request(3,6,0,1)
}
