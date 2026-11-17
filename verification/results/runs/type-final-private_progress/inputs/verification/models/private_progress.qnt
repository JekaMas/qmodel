module private_progress {
 import privacy(LEAK=0).* from "./privacy"
 action dataStep=any {publicSchedule,noteDelivery,losePayload,crash,recover,
   all {p.delivered,loseKey},p'=p}
 temporal dataRecovery=eventually(always(p.key and p.up))
 temporal availability=(dataRecovery and noteDelivery.weakFair(Set(p))).implies(p.delivered.leadsTo(p.claimedUsable))
 temporal permanentLoss=noteDelivery.weakFair(Set(p)).implies(p.delivered.leadsTo(p.claimedUsable))
}
