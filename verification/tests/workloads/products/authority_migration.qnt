// Reach an actual old certificate, then explore every modeled handoff order.
module authority_migration {
  import authority_core(MODE=0) as core from "./authority"
  var prefix:int
  action start = all {core::init,prefix'=0}
  action certifyOld = any {
    all {prefix==0,core::executed(0),prefix'=1},
    all {prefix==1,core::finalVote(0,0),prefix'=2},
    all {prefix==2,core::finalVote(1,0),prefix'=3},
    all {prefix==3,core::finalVote(2,0),prefix'=4},
    all {prefix==4,core::accept(0,0,0,2),prefix'=5}
  }
  action migrate = all {
    prefix==5,prefix'=prefix,
    any {
      core::a'=core::a,
      nondet root=core::Roots.oneOf()
      any {
        core::install(root), core::restore(root), core::verifyHistorical(root),
        nondet v=core::Old.oneOf()
        core::approve(v,root),
        all {core::a.epoch==1,
          any {
            core::executed(root),
            nondet v=core::New.oneOf()
            core::finalVote(v,root),
            nondet body=Set(2,3).oneOf()
            any {core::accept(0,0,root,body),core::accept(1,0,root,body)}
          }
        }
      }
    }
  }
  action step = any {certifyOld,migrate}
  val safe = core::authoritySafe and core::a.historical.subseteq(Set(0))
}
