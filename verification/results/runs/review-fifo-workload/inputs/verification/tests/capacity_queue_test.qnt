module capacity_queue_test {
 import capacity(BAD=0).* from "../models/capacity"
 // FIFO hostile entries consume real service; they cannot be costless rejections.
 run hostileServiceCostTest=init.then(hostile).then(hostile).then(admit(1)).then(service).expect(c.held.contains(1) and c.served==1 and not(c.done.contains(1))).then(service).expect(c.held.contains(1) and c.served==2).then(service).expect(c.done.contains(1) and c.served==3 and safe)
 run overloadRejectsTest=init.then(admit(1)).then(admit(2)).expect(safe).then(admit(3).fail())
 run recoveredFifoTest=init.then(admit(1)).then(outage).then(hostile).then(recover).then(service).expect(c.done.contains(1) and c.queue==List(0) and safe)
}
