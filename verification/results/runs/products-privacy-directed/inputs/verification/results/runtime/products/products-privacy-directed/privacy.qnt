// Pairs of actual evaluated source worlds. The scheduler is public and never
// branches on protected positions, roots, notes, or entitlement values.
module privacy_products {
  import privacy_pipeline(LEAK=0) as pp from "./privacy_pipeline"
  const MODE:int
  pure val Batch=Set(1,2)
  type View={route:int,packet:pp::Event,backupBytes:int,epoch:int,fresh:bool,canUse:bool}
  type Paired={left:int->pp::World,right:int->pp::World,phase:int->int,
    time:int,down:bool,backup:bool,cacheGrant:bool,currentGrant:bool,epoch:int,fresh:bool,
    historyL:List[View],historyR:List[View],unauthorized:bool,probes:int}
  var x:Paired

  action init=x'={left:Batch.mapBy(t=>pp::initial(10+t,4+t)),right:Batch.mapBy(t=>pp::initial(20+t,7+t)),
    phase:Batch.mapBy(_=>0),time:0,down:false,backup:false,cacheGrant:false,currentGrant:false,
    epoch:0,fresh:true,historyL:List(),historyR:List(),unauthorized:false,probes:0}

  pure def message(w:pp::World,t:int,kind:int,now:int,epoch:int,fresh:bool,role:int):View = {
    val wire=pp::observation(w,kind,now,0)
    val entitlement=if(kind==102) pp::release(w,role,3,5,1,now) else pp::emptyPayload
    val privateOnWire=kind==102 and MODE==4 and role==7
    val result={...wire,payload:if(privateOnWire) entitlement else pp::emptyPayload,
      time:if(MODE==3 and kind==100 and w.position>6) now+1 else now,
      error:if(kind==102) entitlement.error else wire.error}
    {route:if(MODE==2 and kind==100) w.position else t,packet:pp::normalize(result,w),
      backupBytes:if(kind==101) (if(MODE==1) 64+w.position else 64) else 0,
      epoch:epoch,fresh:fresh,canUse:if(MODE==5) w.paid==3 else w.usable}
  }

  pure def append(x:Paired,t:int,kind:int,role:int):Paired =
    {...x,historyL:x.historyL.append(message(x.left.get(t),t,kind,x.time,x.epoch,x.fresh,role)),
      historyR:x.historyR.append(message(x.right.get(t),t,kind,x.time,x.epoch,x.fresh,role))}

  pure def advanceLocal(y:Paired,t:int):Paired = {
    val p=y.phase.get(t)
    val w={...y,left:y.left.set(t,pp::evolve(y.left.get(t),p)),
      right:y.right.set(t,pp::evolve(y.right.get(t),p)),phase:y.phase.set(t,p+1)}
    append(w,t,p,0)
  }
  action batch = all {
    not(x.down),Batch.forall(t=>x.phase.get(t)<12),
    x'=advanceLocal(advanceLocal({...x,time:x.time+1},1),2)
  }
  action single(t:int):bool = all {
    Batch.contains(t),not(x.down),x.phase.get(t)<12,
    x'=advanceLocal({...x,time:x.time+1},t)
  }
  action poll(t:int):bool = all {
    Batch.contains(t),x.probes<6,
    x'=append({...x,probes:x.probes+1,time:x.time+1},t,100,3)
  }
  action backup = all {not(x.backup),x'=append({...x,backup:true,cacheGrant:x.currentGrant},1,101,3)}
  action stop = all {not(x.down),x.probes<6,x'=append({...x,down:true,probes:x.probes+1,fresh:false},1,103,3)}
  action restore = all {x.down,x.backup,x'=append({...x,down:false,fresh:false},1,104,3)}
  action recognizeCurrent = all {not(x.fresh),not(x.down),x'=append({...x,fresh:true},1,105,3)}
  action grant = all {not(x.currentGrant),x.epoch==0,x'={...x,currentGrant:true}}
  action revoke = all {x.currentGrant,x'={...x,currentGrant:false,epoch:1}}
  action query(t:int):bool = {
    val role=if(x.currentGrant and t==1) 7 else if(MODE==4 and x.cacheGrant and t==1) 7 else 3
    all {x.probes<6,Batch.contains(t),
      x'=append({...x,unauthorized:x.unauthorized or (role==7 and not(x.currentGrant)),probes:x.probes+1},t,102,role)}
  }
  action loseKey(t:int):bool = {
    val l=x.left.get(t)
    val r=x.right.get(t)
    all {l.key,x'=append({...x,left:x.left.set(t,{...l,key:false,usable:false}),
      right:x.right.set(t,{...r,key:false,usable:false})},t,106,3)}
  }
  action step = any {
    batch,backup,stop,restore,recognizeCurrent,grant,revoke,x'=x,
    nondet t=Batch.oneOf();any {single(t),poll(t),query(t),loseKey(t)}
  }
  val observerEqual = x.historyL==x.historyR and not(x.unauthorized)
  val keySafe = Batch.forall(t=>pp::usable(x.left.get(t)) and pp::usable(x.right.get(t))) and
    x.historyL.foldl(true,(ok,e)=>ok and (e.packet.op!=106 or not(e.canUse))) and
    x.historyR.foldl(true,(ok,e)=>ok and (e.packet.op!=106 or not(e.canUse)))
  val safe = observerEqual and keySafe and Batch.forall(t=>pp::ledgerSafe(x.left.get(t)) and pp::ledgerSafe(x.right.get(t)))
}
module products_privacy {import privacy_products(MODE=0).*}
module products_privacy_test {
  import privacy_products(MODE=0).*
  run cacheAtProof=init.then(5.reps(_=>batch)).then(grant).then(backup)
  run restorable=cacheAtProof.then(query(1)).then(revoke).then(stop).then(poll(1)).then(poll(2))
    .expect(safe and x.down and not(x.fresh)).then(restore).then(query(1)).then(recognizeCurrent)
  run BatchOutageBackupAndRoleChangeTest=restorable.then(7.reps(_=>batch))
    .expect(safe and Batch.forall(t=>x.left.get(t).usable and x.right.get(t).usable))
    .then(loseKey(2)).expect(safe and x.left.get(2).paid==3 and not(x.left.get(2).usable))
  run NonEntitledBatchScopeTest=cacheAtProof.then(query(2))
    .expect(safe and x.historyL.nth(x.historyL.length()-1).packet.error==403)
}
module products_privacy_mutant_test {
  import privacy_products(MODE=1) as backupFault
  import privacy_products(MODE=2) as routeFault
  import privacy_products(MODE=3) as timeFault
  import privacy_products(MODE=4) as staleRole
  import privacy_products(MODE=5) as keyFault
  run BackupSizeLeakTest=backupFault::init.then(backupFault::backup).expect(not(backupFault::observerEqual))
  run RoutingLeakTest=routeFault::init.then(routeFault::poll(1)).expect(not(routeFault::observerEqual))
  run TimingLeakTest=timeFault::init.then(timeFault::poll(1)).expect(not(timeFault::observerEqual))
  run CachedRevokedScopeLeakTest=staleRole::init.then(staleRole::grant).then(staleRole::backup)
    .then(staleRole::revoke).then(staleRole::stop).then(staleRole::restore).then(staleRole::query(1))
    .expect(staleRole::x.unauthorized and not(staleRole::observerEqual))
  run LostKeyFalseUsabilityTest=keyFault::init.then(12.reps(_=>keyFault::batch))
    .then(keyFault::loseKey(2)).expect(not(keyFault::keySafe))
}
