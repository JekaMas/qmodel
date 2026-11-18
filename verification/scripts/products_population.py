"""Pointwise induction for arbitrary finite populations and symbolic capacities."""
import json
import sys
from dataclasses import dataclass

from evidence import ROOT,execute
from products_hostile import RUNTIME
from repeated_checks import stage

RUNNER="verification/scripts/products_symbolic_runner.py"
FIELDS=("decision","holdA","holdB","paidA","paidB","refundA","refundB",
        "knownA","knownB","proofA","proofB","booking")


def app(op,*args):
    return "("+op+" "+" ".join(map(str,args))+")"


def both(*conditions):
    return app("and",*conditions) if len(conditions)>1 else conditions[0]


def typed_amount(hold,target,quantity):
    return app("ite",app("=",hold,target),quantity,0)


def field(name,target="before"):
    return app(name,target)


@dataclass(frozen=True)
class Transition:
    guard:str
    updates:dict
    move:tuple[int,int]=(0,0)
    spend:tuple[int,int]=(0,0)

    def row(self):
        return app("mkrow",*(self.updates.get(f,field(f)) for f in FIELDS))


def kernel():
    return {
        "hold-security":Transition(both("(= (holdA before) 0)","(>= (- ownA reservedA) amountA)",
                                       "(ite localA (= (decision before) 0) (= (knownA before) 0))"),
                                   {"holdA":1,"decision":"(ite localA 1 (decision before))"}),
        "hold-cash":Transition(both("(= (holdB before) 0)","(= (knownB before) 0)","(>= (- ownB reservedB) amountB)"),
                               {"holdB":1}),
        "register-remote":Transition(both("(not localA)","(= (decision before) 0)"),{"decision":1}),
        "authorize-prepared-security":Transition("(> (holdA before) 0)",{"proofA":1}),
        "authorize-prepared-cash":Transition("(> (holdB before) 0)",{"proofB":1}),
        "commit":Transition(both("(= (decision before) 1)",
                                 "(ite localA (= (holdA before) 1) (= (proofA before) 1))",
                                 "(ite localB (= (holdB before) 1) (= (proofB before) 1))"),
                            {"decision":2,"knownA":"(ite localA 2 (knownA before))",
                             "knownB":"(ite localB 2 (knownB before))",
                             "holdA":"(ite localA 2 (holdA before))","holdB":"(ite localB 2 (holdB before))",
                             "paidA":"(ite localA 1 (paidA before))","paidB":"(ite localB 1 (paidB before))"},
                            ("(ite localA amountA 0)","(ite localB amountB 0)")),
        "abort":Transition("(< (decision before) 2)",{"decision":3,
                  "knownA":"(ite localA 3 (knownA before))","knownB":"(ite localB 3 (knownB before))"}),
        "learn-a":Transition("(>= (decision before) 2)",{"knownA":field("decision")}),
        "learn-b":Transition("(>= (decision before) 2)",{"knownB":field("decision")}),
        "apply-a":Transition(both("(= (knownA before) 2)","(= (holdA before) 1)"),
                             {"holdA":2,"paidA":"(+ (paidA before) 1)"},("amountA",0)),
        "apply-b":Transition(both("(= (knownB before) 2)","(= (holdB before) 1)"),
                             {"holdB":2,"paidB":"(+ (paidB before) 1)"},(0,"amountB")),
        "release-a":Transition(both("(= (knownA before) 3)","(= (holdA before) 1)"),
                               {"holdA":3,"refundA":"(+ (refundA before) 1)"}),
        "release-b":Transition(both("(= (knownB before) 3)","(= (holdB before) 1)"),
                               {"holdB":3,"refundB":"(+ (refundB before) 1)"}),
        "ordinary-spend-a":Transition("(>= (- ownA reservedA) amountA)",{},spend=("amountA",0)),
        "ordinary-spend-b":Transition("(>= (- ownB reservedB) amountB)",{},spend=(0,"amountB")),
        "book-commit":Transition(both("(= (decision before) 2)","(= (holdA before) 2)","(= (holdB before) 2)"),
                                 {"booking":2}),
        "book-abort":Transition(both("(= (decision before) 3)","(= (knownA before) 3)","(= (knownB before) 3)",
                                     "(not (= (holdA before) 1))","(not (= (holdB before) 1))"),{"booking":3}),
    }


def environment():
    row_fields=" ".join(f"({f} Int)" for f in FIELDS)
    return f"""(set-logic ALL)
(declare-datatypes ((R 0)) (((mkrow {row_fields}))))
(declare-const population Int)
(declare-const trade Int)
(declare-const observer Int)
(declare-const place Int)
(declare-const rows (Array Int R))
(declare-const amountA Int)
(declare-const amountB Int)
(declare-const ownA Int)
(declare-const ownB Int)
(declare-const reservedA Int)
(declare-const reservedB Int)
(declare-const deliveredA Int)
(declare-const deliveredB Int)
(declare-const spentA Int)
(declare-const spentB Int)
(define-fun localA () Bool (or (= place 0) (= place 3)))
(define-fun localB () Bool (or (= place 1) (= place 3)))
(define-fun between ((x Int)(lo Int)(hi Int)) Bool (and (<= lo x) (<= x hi)))
(assert (and (> population 0) (between trade 1 population) (between observer 1 population)
             (between place 0 3) (> amountA 0) (> amountB 0)))
(define-fun valid ((z R)) Bool
 (and
  (between (decision z) 0 3) (between (holdA z) 0 3) (between (holdB z) 0 3)
  (or (= (knownA z) 0) (and (>= (decision z) 2) (= (knownA z) (decision z))))
  (or (= (knownB z) 0) (and (>= (decision z) 2) (= (knownB z) (decision z))))
  (=> (and localA (>= (decision z) 2)) (= (knownA z) (decision z)))
  (=> (and localB (>= (decision z) 2)) (= (knownB z) (decision z)))
  (= (paidA z) (ite (= (holdA z) 2) 1 0))
  (= (paidB z) (ite (= (holdB z) 2) 1 0))
  (= (refundA z) (ite (= (holdA z) 3) 1 0))
  (= (refundB z) (ite (= (holdB z) 3) 1 0))
  (=> (= (holdA z) 2) (= (knownA z) 2)) (=> (= (holdB z) 2) (= (knownB z) 2))
  (=> (= (holdA z) 3) (= (knownA z) 3)) (=> (= (holdB z) 3) (= (knownB z) 3))
  (between (proofA z) 0 1) (between (proofB z) 0 1)
  (=> (= (proofA z) 1) (> (holdA z) 0)) (=> (= (proofB z) 1) (> (holdB z) 0))
  (=> (= (decision z) 2)
      (and (ite localA (= (holdA z) 2) (and (= (proofA z) 1) (> (holdA z) 0)))
           (ite localB (= (holdB z) 2) (and (= (proofB z) 1) (> (holdB z) 0)))))
  (or (= (booking z) 0)
      (and (= (booking z) (decision z))
           (or (and (= (booking z) 2) (= (holdA z) 2) (= (holdB z) 2))
               (and (= (booking z) 3) (= (knownA z) 3) (= (knownB z) 3)
                    (not (= (holdA z) 1)) (not (= (holdB z) 1))))))))
(define-fun before () R (select rows trade))
"""


def solver_case(transition):
    terms=environment()
    terms+="""(assert (and (valid before) (valid (select rows observer))
                    (>= ownA reservedA) (>= ownB reservedB)
                    (>= deliveredA 0) (>= deliveredB 0) (>= spentA 0) (>= spentB 0)
                    (>= reservedA (ite (= (holdA before) 1) amountA 0))
                    (>= reservedB (ite (= (holdB before) 1) amountB 0))))
"""
    terms+=f"(assert {transition.guard})\n(define-fun after () R {transition.row()})\n"
    parts=["(valid (select (store rows trade after) observer))",
           "(=> (>= (decision before) 2) (= (decision after) (decision before)))"]
    for which,move,spend in zip(("A","B"),transition.move,transition.spend):
        old_active=typed_amount(field("hold"+which),1,"amount"+which)
        new_active=typed_amount(field("hold"+which,"after"),1,"amount"+which)
        terms+=f"(define-fun newOwn{which} () Int (- own{which} {move} {spend}))\n"
        terms+=f"(define-fun newReserved{which} () Int (+ (- reserved{which} {old_active}) {new_active}))\n"
        terms+=f"(define-fun newDelivered{which} () Int (+ delivered{which} {move}))\n"
        terms+=f"(define-fun newSpent{which} () Int (+ spent{which} {spend}))\n"
        parts.extend([
            f"(>= newReserved{which} 0)",f"(>= newOwn{which} newReserved{which})",
            f"(= (+ newOwn{which} newDelivered{which} newSpent{which}) (+ own{which} delivered{which} spent{which}))",
            f"(=> (>= (hold{which} before) 2) (= (hold{which} after) (hold{which} before)))",
            f"(= {move} (* amount{which} (- (paid{which} after) (paid{which} before))))",
        ])
    return terms+"(assert (not "+both(*parts)+"))\n(check-sat)\n"


def identity(legacy=False):
    encode="(+ (* 10 phase) t)" if legacy else "(+ (* 7 t) phase)"
    return f"""(set-logic QF_LIA)
(declare-const n Int)
(declare-const t Int)
(declare-const u Int)
(declare-const p Int)
(declare-const r Int)
(define-fun code ((t Int)(phase Int)) Int {encode})
(assert (and (> n 0) (<= 1 t n) (<= 1 u n) (<= 0 p 6) (<= 0 r 6)
             (= (code t p) (code u r)) (or (not (= t u)) (not (= p r)))))
(check-sat)
"""


def obligation(name,script,expected="unsat"):
    return {"name":name,"script":script,"expected":expected}


def input_closure(mode):
    actions=kernel()
    if mode=="proof":
        empty=app("mkrow",*([0]*len(FIELDS)))
        init=environment()+f"(assert (= rows ((as const (Array Int R)) {empty})))\n"
        init+="""(assert (and (>= ownA 0) (>= ownB 0) (= reservedA 0) (= reservedB 0)
                         (= deliveredA 0) (= deliveredB 0) (= spentA 0) (= spentB 0)))
(assert (not (and (valid (select rows observer)) (>= ownA reservedA) (>= ownB reservedB))))
(check-sat)
"""
        instances=[obligation("arbitrary-initialization",init)]
        instances += [obligation(name,solver_case(row)) for name,row in actions.items()]
        instances += [obligation("arbitrary-trade-phase-injectivity",identity())]
    else:
        broken_capacity=Transition(both("(= (holdA before) 0)","localA","(= (decision before) 0)"),
                                   actions["hold-security"].updates)
        duplicate=Transition("(= (knownB before) 2)",actions["apply-b"].updates,(0,"amountB"))
        unauthenticated=Transition(both("(= (decision before) 1)","(= place 0)","(= (holdA before) 1)"),
                                   actions["commit"].updates,actions["commit"].move)
        instances=[
            obligation("missing-available-capacity",solver_case(broken_capacity),"sat"),
            obligation("duplicate-consumption",solver_case(duplicate),"sat"),
            obligation("missing-remote-preparation-authority",solver_case(unauthenticated),"sat"),
            obligation("legacy-symbolic-root-alias",identity(legacy=True),"sat"),
        ]
    return {"obligations.json":(json.dumps({"obligations":instances},indent=2)+"\n").encode()}


def check(mode):
    run=f"products-population-{mode}"
    folder=RUNTIME/run
    stage(folder,input_closure(mode))
    return execute(run,[sys.executable,"-B",RUNNER,str((folder/"obligations.json").relative_to(ROOT))],
                   claim="Symbolic induction on arbitrary population, affected and observer trades",
                   seconds=140,config={"mode":mode,"population":"arbitrary positive integer"})


if __name__=="__main__":
    results=[check(mode) for mode in ("proof","controls")]
    raise SystemExit(not all(r["expectation_met"] for r in results))
