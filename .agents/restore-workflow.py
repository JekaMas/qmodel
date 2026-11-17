"""Restore the exact workflow pin from the bundled source if remote fetch cannot supply it."""
from pathlib import Path
import subprocess
ROOT=Path(__file__).resolve().parents[1]
PIN='be0666c4f8456480a21d7e67b7b5b96d55ededb3'
BUNDLE=ROOT/'.agents/bundles/agent-workflow-be0666c.bundle'
DEST=ROOT/'.agents/workflow'
def git(*args,cwd=ROOT):return subprocess.run(['git',*map(str,args)],cwd=cwd,check=True,text=True,capture_output=True).stdout.strip()
if (DEST/'.git').exists():
 current=git('rev-parse','HEAD',cwd=DEST)
 if current!=PIN:raise SystemExit('Existing workflow has another revision; inspect it rather than overwrite it.')
 print('Exact workflow already present:',PIN)
else:
 if DEST.exists() and any(DEST.iterdir()):raise SystemExit('Workflow destination is nonempty; preserve it and inspect before restoration.')
 git('clone',BUNDLE,DEST)
 git('checkout','--detach',PIN,cwd=DEST)
 git('remote','set-url','origin','https://github.com/JekaMas/agent-workflow.git',cwd=DEST)
 git('submodule','init','.agents/workflow')
 git('submodule','absorbgitdirs','.agents/workflow')
 assert git('rev-parse','HEAD',cwd=DEST)==PIN
 print('Restored exact bundled workflow:',PIN)
