// Explore public schedule choices after both real pipelines have a proof.
module privacy_exact {
  import privacy_products(MODE=0) as pair from "./privacy"
  var elapsed:int
  action start = all {pair::init,elapsed'=0}
  action step = any {
    all {elapsed<5,pair::batch,elapsed'=elapsed+1},
    all {elapsed>=5,elapsed<9,pair::step,elapsed'=elapsed+1},
    all {elapsed==9,elapsed'=elapsed,pair::x'=pair::x}
  }
  val safe = pair::safe
}
