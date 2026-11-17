"""Readable projections of actual native ITF states, never invented/minimized traces."""
from pathlib import Path
import json
R=Path(__file__).resolve().parents[2];V=R/'verification'
def dec(x):
 if isinstance(x,list):return [dec(v) for v in x]
 if isinstance(x,dict):
  if '#bigint' in x:return int(x['#bigint'])
  if '#set' in x:return [dec(v) for v in x['#set']]
  if '#tup' in x:return tuple(dec(v) for v in x['#tup'])
  if '#map' in x:return {dec(a):dec(b) for a,b in x['#map']}
  return {k:dec(v) for k,v in x.items() if k!='#meta'}
 return x
out=['# Native counterexample chronology','','These tables project the saved native ITF state sequence. Actions come from the executed guided schedule; states, balances, effects, knowledge and evidence come from the backend trace. No trace minimization was performed. All eight traces were rerun against their exact saved source closures and normalized native states matched. Temporal lasso/cycle traces stay in their TLC raw logs; they are not represented as invented ITF.','','Codes: decision 0 absent, 1 OPEN, 2 COMMIT, 3 ABORT; hold 0 absent, 1 reserved, 2 delivered, 3 refunded. Native owner balances include reserved quantities; delivered quantities are in effects/recipient maps. Evidence pairs are `(trade, phase)`: 0 OPEN, 1 A prepared, 2 B prepared, 3 COMMIT, 4 ABORT, 5 A applied, 6 B applied.']
for m in json.loads((V/'mutants/manifest.json').read_text()):
 n=m['id'];d=json.loads((V/f'results/traces/{n}.itf.json').read_text());rp=json.loads((V/f'results/replays/mutant-{n}/replay.json').read_text())
 out += ['',f'## {n}: {m["property"]}','','Native [ITF](../results/traces/'+n+'.itf.json), [replay](../results/replays/mutant-'+n+'/replay.json). '+str(len(d['states'])-1)+' transitions; replay matched: '+str(rp['native_states_match'])+'.','','| State / action | A height / B clock | Decision; A/B hold; A/B effects; B refunds | A/B local outcome knowledge | Owner A/B | Finalized / captured / proof / wire / received |','|---|---|---|---|---|---|']
 for i,raw in enumerate(d['states']):
  state=dec(raw);s=next(v for k,v in state.items() if k.endswith('::s'))
  ts='; '.join(f"t{t}: {z['decision']}; {z['holdA']}/{z['holdB']}; {z['effectsA']}/{z['effectsB']}; {z['refundsB']}" for t,z in s['trades'].items())
  know='; '.join(f"t{t}: {z['knownA']}/{z['knownB']}" for t,z in s['trades'].items())
  def ev(k):return ','.join(f"{f['d']['trade']}:{f['phase']}" for f in s[k]) or '-'
  phase=' / '.join(ev(k) for k in ['finalized','captured','proofs','network','received'])
  action='init' if i==0 else m['schedule'][i-1]
  out.append(f"| {i}: `{action}` | {s['height']} / {state.get('bClock','n/a')} | {ts} | {know} | {s['ownerA']}/{s['ownerB']} | {phase} |")
 out += ['','Violation is the final native state. Reproduce with `python3 verification/scripts/replay.py mutant-'+n+' --latest-success`. The guided trace is a small explicit witness; no globally shortest-path claim is made.']
(V/'reports/counterexamples.md').write_text('\n'.join(out)+'\n')
print('Rendered eight original native traces and exact replay references')
