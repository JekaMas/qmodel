"""Directly affected checks from the independent review; stop on an unexpected result."""
from evidence import *
import argparse
p=argparse.ArgumentParser();p.add_argument('suite',choices=['privacy']);a=p.parse_args()
def check(*args,**kw):
 r=execute(*args,**kw)
 if not r['expectation_met']:sys.exit(1)
 return r
for path in ['verification/models/privacy_pipeline.qnt','verification/models/integrated.qnt','verification/tests/privacy_pipeline_test.qnt']:
 check('review-type-'+Path(path).stem,[QUINT,'typecheck',path],claim='new/repaired privacy data pipeline parse/type/effect correctness')
for inv,step in [('safe','pairedStep'),('PAccess','accessStep'),('PBinding','accessStep'),('PNI','accessStep')]:
 check('review-pipeline-'+inv,[QUINT,'verify','verification/models/privacy_pipeline.qnt','--main','pipeline_safe','--backend','tlc','--invariant',inv,'--step',step,'--tlc-config','verification/configs/tlc.json','--verbosity','3'],claim=inv,backend='tlc',seconds=150,config={'scope':'actual independently evaluated worlds,12 public operations; concrete API/log/explorer/job/backup/report values; one arbitrary release plus real regulator release'})
for main,inv,step in [('pipeline_log','PNI','pairedStep'),('pipeline_timing','PTiming','pairedStep'),('pipeline_unsalted','PNI','pairedStep'),('pipeline_scope','PAccess','accessStep'),('pipeline_substitution','PBinding','accessStep'),('pipeline_note','PAvailability','pairedStep'),('pipeline_compromise','PAccess','accessStep')]:
 cmd=[QUINT,'verify','verification/models/privacy_pipeline.qnt','--main',main,'--backend','tlc','--invariant',inv,'--step',step,'--tlc-config','verification/configs/tlc.json','--verbosity','3']
 check('review-'+main,cmd,claim=inv,backend='tlc',expected='counterexample',seconds=90)
check('review-pipeline-witnesses',[QUINT,'test','verification/tests/privacy_pipeline_test.qnt','--main','privacy_pipeline_test','--match','.*Test','--backend','typescript','--seed','17'],claim='eight exact state/payload/retry/recovery/audit/key-loss witnesses')
for main,inv,expect in [('integrated','safe','pass'),('integrated','noUsability','counterexample'),('integrated_leak','safe','counterexample')]:
 check('review-privacy-time-'+main+'-'+inv,[QUINT,'verify','verification/models/integrated.qnt','--main',main,'--backend','tlc','--invariant',inv,'--tlc-config','verification/configs/tlc.json','--verbosity','3'],claim=inv,backend='tlc',expected=expect,seconds=120)
print('Independent-review privacy repair suite: all intended observations obtained')
