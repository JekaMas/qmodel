"""Deterministic QA-01..04 discriminators; properties stay in the real models.

Each negative drives the changed protocol/payload constructor through actions.
It never mutates oracle state or treats tool errors as expected violations.
"""
from pathlib import Path
import json
R=Path(__file__).resolve().parents[2]
controls=[];modules=[]
for field in range(16):
 name=f'payload_field{field}'
 role=7 if field<6 else 4 if field==6 else 0 if field==7 else 3
 end=11 if field==7 else 5
 modules.append(f'''module {name} {{
 import privacy_pipeline(LEAK={8+field}).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<{end}) advance else request({role},{field},0,1)
}}
''')
 controls.append(dict(id='qa-'+name,module=name,property='PBinding',init='init',step='stepControl',steps=end+2,finding='QA-01',changed_input=f'corrupt returned field{field} only; oracle source/query unchanged'))
for mode,name,field,end,role in [(24,'payload_root',0,5,7),(25,'payload_program',0,5,7),
 (26,'note_amount',7,11,0),(27,'note_recipient',7,11,0)]:
 modules.append(f'''module {name} {{
 import privacy_pipeline(LEAK={mode}).* from "../models/privacy_pipeline"
 action stepControl=if(p.pc<{end}) advance else request({role},{field},0,1)
}}
''')
 controls.append(dict(id='qa-'+name,module=name,property='PBinding',init='init',step='stepControl',steps=end+2,finding='QA-01',changed_input='corrupt proof header or recipient-note source field only'))
signed=['sign(1,0)','sign(1,1)'];held=signed+['openA(1)','prepareB(1)']
proof=held+['finalize(1,2)','capture(1,2)','prove(1,2)','deliver(1,2)'];committed=proof+['commit(1)']
settled=committed+['finalize(1,3)','capture(1,3)','prove(1,3)','deliver(1,3)','learn(1,2,1)','applyB(1)']
booked=settled+sum(([f'finalize(1,{p})',f'capture(1,{p})',f'prove(1,{p})',f'deliver(1,{p})',f'observe(1,{p-5})'] for p in [5,6]),[])+['reconcile(1)']
aborted=held+['tick','tick','abort(1)'];abort_known=aborted+['finalize(1,4)','capture(1,4)','prove(1,4)','deliver(1,4)','learn(1,3,1)']
rows=[('program_admission',10,'S10',held+['finalize(1,2)','capture(1,2)','proveUnadmitted(1,2)','deliverUnadmitted(1,2)','commit(1)'],'QA-02'),
 ('premature_absence',13,'S15',signed+['captureAbortRecord(1,0)','captureAbortRecord(1,1)','openA(1)','prepareB(1)','tick','tick','abort(1)','finalize(1,4)','capture(1,4)','prove(1,4)','deliver(1,4)','recordAbort(1)'],'QA-03'),
 ('security_recipient',11,'S05',committed,'QA-04'),('security_asset',12,'S05',committed,'QA-04'),
 ('cash_recipient',15,'S05',settled,'QA-04'),('cash_asset',16,'S05',settled,'QA-04'),
 ('security_refund_recipient',14,'S05',aborted+['refund(1,0)'],'QA-04'),
 ('cash_refund_recipient',17,'S05',abort_known+['refund(1,1)'],'QA-04'),
 ('booking_recipient',18,'S05',booked,'QA-04'),('booking_quantity',19,'S05',booked,'QA-04')]
for name,mode,prop,actions,finding in rows:
 modules.append('module '+name+' {\n import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT='+str(mode)+').* from "../models/dvp"\n var pc:int\n action initControl=all {init,pc\'=0}\n action stepControl=any {\n'+',\n'.join('  all {pc=='+str(i)+','+action+",pc'=pc+1}" for i,action in enumerate(actions))+'\n }\n}\n')
 controls.append(dict(id='qa-'+name,module=name,property=prop,init='initControl',step='stepControl',steps=len(actions)+1,finding=finding,mutation=mode,schedule=actions,changed_input='one isolated producer/consumer fault; strict property unchanged'))
(R/'verification/mutants/qa_controls.qnt').write_text('\n'.join(modules))
(R/'verification/mutants/qa-controls.json').write_text(json.dumps(controls,indent=2)+'\n')
# Independent literal expectations for successful fields at the directed public
# prefix. This does not call release/fieldValue/disclosureBound to build expected.
expected=[1,0,3,4,1,3,4,3,1,1043,1,0,120,2,5,1]
lines=['// Exact returned values and full binding, independent of producer helpers.','module payload_values_test {',' import privacy_pipeline(LEAK=0).* from "../models/privacy_pipeline"']
for field,value in enumerate(expected):
 role=7 if field<6 else 4 if field==6 else 0 if field==7 else 3
 end=11 if field==7 else 5
 lines.append(f' run field{field}ExactTest=init.then({end}.reps(_=>advance)).then(request({role},{field},0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field=={field} and d.error==0 and d.value=={value} and d.root==1043 and d.program==1))')
lines += [' run deniedIdentityTest=init.then(5.reps(_=>advance)).then(request(3,0,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==0 and d.error==403 and d.value== -1))',
 ' run unavailableNoteTest=init.then(5.reps(_=>advance)).then(request(0,7,0,1)).expect(PBinding and PAccess and p.releasesL.exists(d=>d.field==7 and d.error==404 and d.value== -1 and d.note==emptyPayload.note))',
 ' run downTimeExactTest=init.then(7.reps(_=>advance)).then(request(3,14,0,1)).expect(PBinding and p.releasesL.exists(d=>d.field==14 and d.error==0 and d.value==503))',
 ' run recoveredTimeExactTest=init.then(8.reps(_=>advance)).then(request(3,14,0,1)).expect(PBinding and p.releasesL.exists(d=>d.field==14 and d.error==0 and d.value==8))','}']
(R/'verification/tests/payload_values_test.qnt').write_text('\n'.join(lines)+'\n')
print('Generated',len(controls),'isolated native controls and20exact payload cases')
