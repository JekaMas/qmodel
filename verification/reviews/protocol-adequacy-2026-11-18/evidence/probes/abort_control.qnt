module abort_control {
 import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=0).* from "../../../../models/dvp"
 run prematureSourceRecordRejectedTest=init.then(sign(1,0)).then(sign(1,1)).then(captureAbortRecord(1,1).fail())
}
