module interventions {
  const POLICY:int // 0 durable holds, 1 authorized precommit coordinated cancel, 2 postcommit freeze, 3 arbitrary seizure
  type State={prepared:bool,eligible:bool,decision:int,hold:int,delivered:bool,
    funding:bool,cancelAuthorized:bool,frozen:bool,revoked:bool,version:int,exit:bool}
  var i:State
  action init=i'={prepared:false,eligible:true,decision:0,hold:0,delivered:false,
    funding:true,cancelAuthorized:false,frozen:false,revoked:false,version:0,exit:false}
  action prepare=all {i.eligible,i.funding,not(i.frozen),not(i.exit),i.decision==0,not(i.prepared),i'={...i,prepared:true,hold:1}}
  action revoke=i'={...i,eligible:false,revoked:true}
  action authorizeCancel=all {POLICY==1,i.decision==0,i'={...i,cancelAuthorized:true}}
  action cancel=all {POLICY==1,i.cancelAuthorized,i.decision==0,i'={...i,decision:3}}
  action commit=all {i.prepared,i.hold==1,i.decision==0,not(i.frozen),i'={...i,decision:2}}
  action apply=all {i.decision==2,i.hold==1,not(i.frozen),i'={...i,hold:2,delivered:true}}
  action refund=all {i.decision==3,i.hold==1,not(i.frozen),i'={...i,hold:3}}
  action freeze=all {POLICY==2,i'={...i,frozen:true}}
  action unfreeze=i'={...i,frozen:false}
  action seize=all {POLICY==3,i'={...i,hold:0,funding:false,delivered:false}}
  action upgrade=all {i.version==0,i'={...i,version:1}}
  action exitMember=i'={...i,exit:true}
  action step=any {prepare,revoke,authorizeCancel,cancel,commit,apply,refund,freeze,unfreeze,seize,upgrade,exitMember,i'=i}
  val backing=i.decision==2 implies i.hold==1 or i.delivered
  val admission=i.prepared implies not(i.revoked) or i.hold>=1
  val noMixed=not(i.delivered and i.hold==3)
  val safe=backing and admission and noMixed
  temporal progress=apply.weakFair(Set(i)).implies((i.decision==2).leadsTo(i.delivered))
}
module durable {import interventions(POLICY=0).*}
module coordinated {import interventions(POLICY=1).*}
module mandatory_freeze {import interventions(POLICY=2).*}
module arbitrary_seizure {import interventions(POLICY=3).*}
