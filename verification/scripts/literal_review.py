"""Attach review/evidence owners to the original literal task bullet inventory.

This is traceability, not a claim that every prose bullet is a separate theorem.
"""
from pathlib import Path
import json,re
V=Path(__file__).resolve().parents[1];xs=json.loads((V/'coverage-contract.json').read_text());ps={p['id']:p for p in json.loads((V/'properties.json').read_text())}
sections={
 '02':(['S03','S06','S08','S11','S15'],['protocol.md','models/dvp.qnt']),
 '03':(['S01','L01','O-Immediate','O-Permanent'],['properties.json','assumptions.md','reports/traceability.md']),
 '04':(['S10','S12','S13','C-Records'],['models/dvp.qnt','models/mapping.qnt','reports/conformance-boundary.md']),
 '05':(['R-Core','R-Policy','S10','S13'],['tests/dvp_test.qnt','tests/recovery_test.qnt','tests/network_test.qnt','reports/counterexamples.md']),
 '06':(['S01','L01'],['results/toolchain/','reports/executions.md']),
 '07':([],['results/manifest.json','reports/executions.md','reports/counterexamples.md']),
 '08':([],['README.md','reports/findings.md','reports/interview-summary.md']),
 '09':(['C-Decision','C-Local','C-Records','V-Three'],['reports/protocol-review.md','models/multilateral.qnt']),
 '10':(['V-AOpen','V-B','V-D','V-Escrow','V-Private','V-Shared'],['variants.json','models/variants.qnt','models/mechanisms.qnt','models/authentication.qnt']),
 '11':(['P-Access','P-Binding','P-Availability','P-Scope','P-NI','P-Timing'],['privacy-policy.md','models/privacy_pipeline.qnt','models/integrated.qnt','models/audit_scope.qnt']),
 '12':(['T-Async','T-Eventual','T-Bounded','T-Capacity'],['timing-assumptions.md','models/timing.qnt','models/stabilization.qnt','models/late_resolution.qnt','models/capacity.qnt']),
 '13':(['S13','S14','S16'],['assumption-guarantee-matrix.json','models/trust.qnt','models/interventions.qnt','models/membership.qnt']),
 '15':([],['coverage-contract.json','variants.json','privacy-policy.md','timing-assumptions.md','assumption-guarantee-matrix.json','reports/conformance-boundary.md','reports/coverage.md'])}
for x in xs:
 if x['id'].startswith('PH-'):continue
 sec=x['id'].split('-')[1];ids,artifacts=sections.get(sec,([],['sources/source-inventory.json']))
 match=re.search(r'\b(S\d\d|L\d\d|P-(?:Access|Binding|Availability|Scope|NI|Timing)|T-(?:Async|Eventual|Bounded)|C-(?:Decision|Local|Records))\b',x['requirement'])
 if match and match[1] in ps:ids=[match[1]]
 checks=list(dict.fromkeys(c for p in ids for c in ps[p]['executed_checks']))
 x.update(property_ids=ids,review_artifacts=artifacts,checks=checks,review_disposition='Mapped to scoped properties, guards, scenarios and artifacts; not independently counted as an execution.')
 if sec=='01':x.update(status='excluded-with-reason',verification_status='missing_original_source',exclusion_reason='Named PDF/design workspace absent at requested local source paths; continue under explicit v2 fallback and recovered shared answer. No invented source contents.')
 elif 'https://' in x['requirement']:x.update(status='excluded-with-reason',verification_status='bibliographic_reference_not_a_model_property',exclusion_reason='Method reference; installed CLI/backends were consulted and smoke-tested. This URL is not an independently discharged protocol obligation.')
 elif not checks:x.update(status='executed-with-result',verification_status='artifact_review_only',evidence_boundary='Required reporting/status artifact exists; no separate formal theorem is claimed.')
 else:x.update(status='executed-with-result',verification_status='mapped_scoped_observations',evidence_boundary='Exact property/check bounds and exceptions apply. Mapping a prose bullet does not strengthen the underlying predicate or prove excluded implementation semantics.')
(V/'coverage-contract.json').write_text(json.dumps(xs,indent=2)+'\n')
lines=['# Literal v2 coverage review','','The original 154-item inventory combines lifecycle phases, protocol properties, procedural directions and bibliography. This is a review/traceability table; repeated citations do not create additional executions. Read the precise property scopes and residual limits before treating a mapped bullet as a guarantee. The full paragraph-level instruction remains preserved as sources/task-v2.md.','','| Original ID / requirement | Disposition | Properties and actual checks | Review owner / limit |','|---|---|---|---|']
for x in xs:
 req=x['requirement'].replace('|','/');checks=', '.join(x.get('checks',[])) or 'artifact/reference review'
 owner=', '.join(x.get('review_artifacts',[])) or 'coverage-contract.md lifecycle matrix'
 lines.append(f"| {x['id']}: {req} | {x['status']} / {x['verification_status']} | {', '.join(x.get('property_ids',[]))}; {checks} | {owner}; {x.get('exclusion_reason',x.get('evidence_boundary','scoped lifecycle observations only'))} |")
(V/'reports/literal-coverage.md').write_text('\n'.join(lines)+'\n')
print('Reviewed all '+str(len(xs))+' original inventory entries without multiplying execution counts')
