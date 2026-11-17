module smoke {
  var x: int
  action init = x' = 0
  action advance = all { x == 0, x' = 1 }
  action idle = x' = x
  action step = any { advance, idle }
  val TypeOK = Set(0, 1).contains(x)
  val falseInvariant = x == 0
  temporal progress = eventually(x == 1)
  temporal fairProgress = advance.weakFair(Set(x)).implies(eventually(x == 1))
}
