from pathlib import Path
import re,hashlib
R=Path(__file__).resolve().parents[2];p=R/'verification/models/induction.qnt';source=p.read_text()
fields=re.findall(r'var v_(\w+): (\w+)',source)
def expr(s):
 return re.sub(r'v_(\w+)',r'o.\1',s)
actions={name:body.strip() for name,body in re.findall(r'  action (\w+)=(.*?)(?=\n  (?:action|val)|\n\})',source,re.S)}
def assignments(body):
 return {k:v.strip() for k,v in re.findall(r"v_(\w+)'=([^,}]+)",body)}
init=assignments(actions['init'])
lines=['// Generated from induction.qnt guard/update relations; source SHA256 '+hashlib.sha256(source.encode()).hexdigest(),
 '// Safety projection only. No liveness preservation or arbitrary-trade refinement claim.',
 'module mapped {',' const BAD:int',' import dvp(N=1,HOST=0,OPEN_REQUIRED=false,ESCROW=false,PRIVATE=false,MUTANT=BAD).* from "./dvp"',
 ' type Abs={'+','.join(k+':'+t for k,t in fields)+'}',
 ' pure val initialAbs:Abs={'+','.join(k+':'+init[k] for k,_ in fields)+'}']
names=['prepareA','prepareB','certify','commit','abort','deliver','pay','refundA','refundB','tick']
for name in names:
 body=actions[name];i=body.rfind('all {');guards=body[len('all {'):i].strip().strip(',');updates=assignments(body)
 lines.append(' pure def abs_'+name+'(o:Abs,n:Abs):bool=and {'+expr(guards)+',n=={'+','.join(k+':'+expr(updates[k]) for k,_ in fields)+'}}')
lines += [' pure def abstractNext(o:Abs,n:Abs):bool = or {o==n,'+','.join('abs_'+name+'(o,n)' for name in names)+'}',
' pure def alpha(x:State):Abs={ownerA:x.ownerA,ownerB:x.ownerB,holdA:x.trades.get(1).holdA,holdB:x.trades.get(1).holdB,paidA:x.trades.get(1).effectsA,paidB:x.trades.get(1).effectsB,receivedA:x.receivedA.get(1),receivedB:x.receivedB.get(1),decision:x.trades.get(1).decision,terminal:x.trades.get(1).oldTerminal,height:x.height,certificateB:has(x,1,2),knownB:x.trades.get(1).knownB,refundA:x.trades.get(1).refundsA,refundB:x.trades.get(1).refundsB}']
desired=re.search(r'val desired=(.*?)(?=\n  val Strengthening)',source,re.S)[1].strip();lines.append(' pure def abstractDesired(o:Abs):bool='+expr(desired))
lines+=[' var previous:Abs'," action initMapped=all {init,previous'=initialAbs}"," action stepMapped=all {step,previous'=alpha(s)}",' val simulation=abstractNext(previous,alpha(s)) and abstractDesired(alpha(s))','}',
'module mapping {import mapped(BAD=0).*}','module mapping_mutant {import mapped(BAD=1).*}']
(R/'verification/models/mapping.qnt').write_text('\n'.join(lines)+'\n')
print('Generated pure relations for',len(names),'abstract actions and',len(fields),'mapped fields')
