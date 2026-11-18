"""Audit this review archive, or deliberately rerun one exact successful probe.

Probes test assertion/input adequacy using copied models. They are separate from
the published protocol acceptance suite. The first two harness failures stay in
the archive but are not accepted as property counterexamples or replay targets.
"""
from pathlib import Path
import hashlib
import json
import re
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical(value):
    if isinstance(value, list):
        return [canonical(v) for v in value]
    if isinstance(value, dict):
        for tag in ['#set', '#map']:
            if tag in value:
                return {tag: sorted([canonical(v) for v in value[tag]],
                                    key=lambda v: json.dumps(v, sort_keys=True))}
        return {k: canonical(v) for k, v in value.items() if k != '#meta'}
    return value


def audit():
    index = json.loads((HERE / 'integrity.json').read_text())
    for rel, expected in index['sha256'].items():
        path = HERE / rel
        if not path.is_file() or sha(path) != expected:
            raise ValueError('Changed/missing review evidence: ' + rel)
    observations = {}
    failed = []
    for p in sorted((HERE / 'evidence/observations/runs').glob('*/receipt.json')):
        r = json.loads(p.read_text())
        raw = (p.parent / 'raw.log').read_text()
        if sha(p.parent / 'raw.log') != r['raw_sha256']:
            raise ValueError('Changed native output: ' + r['id'])
        if sha(p.parent / 'execution-plan.json') != r['execution_plan_sha256']:
            raise ValueError('Changed execution plan: ' + r['id'])
        plan = json.loads((p.parent / 'execution-plan.json').read_text())
        for key in ['command', 'claim', 'expected', 'backend', 'configuration',
                    'input_hashes', 'tooling_hashes', 'timeout_seconds',
                    'environment', 'resource_limit']:
            if plan[key] != r[key]:
                raise ValueError('Plan/observation mismatch: ' + key)
        for key, value in plan['tool_versions'].items():
            if r['tool_versions'].get(key) != value:
                raise ValueError('Tool identity mismatch: ' + r['id'])
        for group, prefix in [('input_hashes', 'inputs'), ('tooling_hashes', 'tooling')]:
            for rel, expected in r[group].items():
                if sha(p.parent / prefix / rel) != expected:
                    raise ValueError('Changed captured source/tooling: ' + rel)
        if r.get('native_trace_sha256'):
            if sha(p.parent / 'native.itf.json') != r['native_trace_sha256']:
                raise ValueError('Changed native trace: ' + r['id'])
        if not r['expectation_met']:
            failed.append(r['id'])
            if r['outcome'] != 'tool_error':
                raise ValueError('Unexpected original non-success: ' + r['id'])
        elif r['expected'] == 'counterexample':
            if r['exit_code'] == 0 or 'Invariant violated' not in raw:
                raise ValueError('Missing actual invariant violation: ' + r['id'])
        else:
            if r['exit_code'] != 0:
                raise ValueError('Native positive did not succeed: ' + r['id'])
            if 'test' == r['command'][1] and not re.search(r'[1-9][0-9]* passing', raw):
                raise ValueError('Empty scenario selection: ' + r['id'])
            if 'run' == r['command'][1] and '[ok] No violation found' not in raw:
                raise ValueError('Missing positive simulation result: ' + r['id'])
        observations[r['id']] = (p, r)
    if sorted(failed) != sorted(index['preserved_setup_failures']):
        raise ValueError('Original setup failure inventory differs')
    if set(index['selected_observations']) != set(observations) - set(failed):
        raise ValueError('Successful discriminator inventory differs')
    return index, observations


def main():
    if len(sys.argv) != 2:
        raise ValueError('Use: replay_probe.py audit|<exact-successful-receipt-id>')
    index, observations = audit()
    name = sys.argv[1]
    if name == 'audit':
        print(json.dumps({'status': 'passed', 'archived_files': len(index['sha256']),
                          'successful_discriminators': len(index['selected_observations']),
                          'preserved_setup_failures': index['preserved_setup_failures'],
                          'native_processes_started': 0}, indent=2))
        return 0
    if name not in index['selected_observations']:
        raise ValueError('Not an exact successful review probe: ' + name)
    p, r = observations[name]
    sys.path.insert(0, str(ROOT / 'verification/scripts'))
    import evidence as runner
    runner.RESULTS = ROOT / 'verification/results/runtime/comparative-review-replays'
    cmd = list(r['command'])
    cmd[0] = runner.QUINT
    for i, arg in enumerate(cmd):
        if i and cmd[i - 1] in ['--out-itf', '--out', '--output']:
            continue
        if arg.endswith(('.qnt', '.json')):
            if arg not in r['input_hashes']:
                raise ValueError('Uncaptured input argument: ' + arg)
            cmd[i] = str(p.parent / 'inputs' / arg)
    if '--out-itf' in cmd:
        destination = runner.RESULTS / 'exports' / (name + '.itf.json')
        destination.parent.mkdir(parents=True, exist_ok=True)
        cmd[cmd.index('--out-itf') + 1] = str(destination)
    observed = runner.execute(
        name, cmd, claim=r['claim'], expected=r['expected'], backend=r['backend'],
        seconds=r['timeout_seconds'], force=True,
        config={'review_probe': name, 'exact_archived_input_closure': True},
        execution_env={k: r['environment'][k] for k in ['JAVA_TOOL_OPTIONS', 'JVM_ARGS']},
        resource_limit=r['resource_limit'])
    matched = None
    if r.get('native_trace_sha256') and observed.get('native_trace'):
        before = json.loads((p.parent / 'native.itf.json').read_text())['states']
        after = json.loads((ROOT / observed['native_trace']).read_text())['states']
        matched = canonical(before) == canonical(after)
    ok = observed['expectation_met'] and observed['outcome'] == r['outcome'] and matched is not False
    result = {'status': 'passed' if ok else 'failed', 'original_probe': name,
              'new_receipt': observed['id'], 'outcome': observed['outcome'],
              'native_states_match': matched, 'minimized': False,
              'scope': 'copied-model review discriminator; not unchanged-protocol evidence'}
    (runner.RESULTS / 'runs' / observed['id'] / 'review-replay.json').write_text(
        json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))
    return 0 if ok else 1


if __name__ == '__main__':
    try:
        sys.exit(main())
    except (ValueError, OSError, KeyError) as error:
        print('Review probe error: ' + str(error), file=sys.stderr)
        sys.exit(1)
