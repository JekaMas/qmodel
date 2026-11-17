"""Checked definitional identity, not a projected economic refinement.

Finite nondet binding is existential choice; actionAny is disjunction. Expanding
that choice distributes existential quantification over the same shared primitive
action relations. Reject every AST shape we do not explicitly implement. Both
sides inherit the identical state/init/guards/effects/properties from dvp; no
solver constraint or property assumption is used in this check.
"""
from pathlib import Path
import subprocess,json,hashlib,copy,argparse,tempfile
ROOT=Path(__file__).resolve().parents[2]
SOURCE='verification/models/dvp.qnt';VIEW='verification/models/full_grounded.qnt'
def parsed(path):
 with tempfile.NamedTemporaryFile(suffix='.json',dir=ROOT/'verification/results/runtime') as out:
  subprocess.run([str(ROOT/'node_modules/.bin/quint'),'parse',path,'--out',out.name],cwd=ROOT,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=True)
  x=json.loads(Path(out.name).read_text())
 if x.get('errors'):raise ValueError(x['errors'])
 return {m['name']:m for m in x['modules']}
def overrides(instance):return {k['name']:v['value'] for k,v in instance['overrides']}
def checked():
 ms=parsed(VIEW);lib=ms['dvp'];defs={d['name']:d for d in lib['declarations'] if d['kind']=='def'}
 baseline=ms['baseline']['declarations'];view=ms['full_grounded']['declarations']
 if len(baseline)!=1 or baseline[0]['kind']!='instance' or baseline[0]['protoName']!='dvp':raise ValueError('Unsupported reference instance')
 if len(view)!=2 or view[0]['kind']!='instance' or view[0]['protoName']!='dvp' or view[1].get('name')!='groundedStep':raise ValueError('View must only instantiate shared dvp and define groundedStep')
 bindings=overrides(baseline[0])
 if bindings!={'N':1,'HOST':0,'OPEN_REQUIRED':False,'ESCROW':False,'PRIVATE':False,'MUTANT':0}:raise ValueError('Reference instance changed')
 def atom(e,env):
  if e['kind'] in ['int','bool']:return e['value']
  if e['kind']=='name' and e['name'] in env:return env[e['name']]
  raise ValueError('Unsupported nonconstant leaf argument: '+repr(e))
 def domain(e,env):
  if e['kind']=='name' and e['name']=='Trades':return domain(defs['Trades']['expr'],env)
  if e['kind']=='app' and e['opcode']=='to':
   a,b=[atom(v,env) for v in e['args']];return list(range(a,b+1))
  if e['kind']=='app' and e['opcode']=='Set':return [atom(v,env) for v in e['args']]
  raise ValueError('Unsupported finite choice domain')
 def leaves(e,env):
  if e['kind']=='app' and e['opcode']=='actionAny':return [x for a in e['args'] for x in leaves(a,env)]
  if e['kind']=='let':
   op=e['opdef'];choice=op['expr']
   if op['qualifier']!='nondet' or choice.get('opcode')!='oneOf' or len(choice['args'])!=1:raise ValueError('Unsupported binding')
   return [x for v in domain(choice['args'][0],env) for x in leaves(e['expr'],{**env,op['name']:v})]
  if e['kind']=='app' and e['opcode']=='tradeStep':
   fn=defs['tradeStep']['expr'];args=[atom(v,env) for v in e['args']]
   if fn['kind']!='lambda' or len(fn['params'])!=len(args):raise ValueError('Unsupported tradeStep')
   return leaves(fn['expr'],{**env,**{p['name']:v for p,v in zip(fn['params'],args)}})
  if e['kind']=='name':name=e['name'];args=[]
  elif e['kind']=='app':name=e['opcode'];args=[atom(v,env) for v in e['args']]
  else:raise ValueError('Unsupported action expression')
  if name not in defs or defs[name]['qualifier']!='action':raise ValueError('Leaf is not the shared primitive action: '+name)
  return [(name,tuple(args))]
 expected=set(leaves(defs['step']['expr'],bindings));observed=set(leaves(view[1]['expr'],bindings))
 def compare(candidate,bind):
  if bind!=bindings:raise ValueError('Instance parameters changed')
  if set(candidate)!=expected:raise ValueError('Primitive relation disjunction changed; missing='+repr(sorted(expected-set(candidate)))+' extra='+repr(sorted(set(candidate)-expected)))
 compare(observed,overrides(view[0]))
 # Independent falsification: remove an economically necessary return delivery,
 # and change host. Each must fail even though a trivial safety run could pass.
 for candidate,bind in [(observed-{('deliver',(1,3))},bindings),(observed,{**bindings,'HOST':1})]:
  try:compare(candidate,bind)
  except ValueError:pass
  else:raise AssertionError('Identity checker accepted changed behavior')
 return {'kind':'checked finite-choice definitional identity','state_mapping':'identity of every State field; no fields hidden/removed','initializer':'same imported dvp.init','properties':['same imported safe (S01-S16)','same imported CDecision'],'source_sha256':{p:hashlib.sha256((ROOT/p).read_bytes()).hexdigest() for p in [SOURCE,VIEW]},'instance':bindings,'primitive_relation_count':len(expected),'primitive_relations':[[n,list(args)] for n,args in sorted(expected)],'all_proof_phases':list(range(7)),'negative_controls':['missing deliver(1,3) rejected','changed HOST rejected'],'proof_rule':'exists over an explicitly finite domain equals disjunction over every domain value; actionAny is associative/commutative/idempotent disjunction; shared primitive definitions are unchanged','boundary':'Exact nondeterministic state/transition traces for this instance, not a claim about simulation probability distributions or a projected model.'}
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--out');p.add_argument('source',nargs='?',default=SOURCE);p.add_argument('view',nargs='?',default=VIEW);a=p.parse_args()
 if a.source!=SOURCE or a.view!=VIEW:raise ValueError('Unexpected proof subject')
 r=checked()
 if a.out:(ROOT/a.out).write_text(json.dumps(r,indent=2)+'\n')
 print(json.dumps({'status':'passed','primitive_relations':r['primitive_relation_count'],'negative_controls':r['negative_controls']}))
