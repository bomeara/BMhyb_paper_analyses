cichlid <- drake_plan(

)

nicotiana <- drake_plan(

)

# see https://ropenscilabs.github.io/drake-manual/plans.html
sims <- drake_plan(
  #my.cluster <- StartCluster(),
  sim.results = DoRunTemplated(ntax__, nhybridizations__, tree.height__, sigma.sq__, mu__, bt__, vh__, SE__, gamma__)
  #,
  #save(sim.results, file_out("TestSims.rda"))
)

sims.separated <- evaluate_plan(
  sims,
  rules=list(
    ntax__ = c(3,4),
    nhybridizations__ = c(1,2),
    tree.height__ = c(1),
    sigma.sq__ = c(0.01),
    mu__ = c(1),
    bt__ = c(1),
    vh__ = c(0),
    SE__ = c(0),
    gamma__ = c(0.5)
  )
)

# ntax.vector <- c(30, 100)
# nhybridizations.vector <- c(1, 5, 10)
# gamma.vector <-c(.5)
# sigmasq.vector <- c(0.01)
# tree.height.vector <- c(50)
# mu.vector <- c(1)
# bt.vector <- c(1, 2)
# vh.vector <- c(0, .1*max(sigmasq.vector)*max(tree.height.vector), max(sigmasq.vector)*max(tree.height.vector)) #zero, as much variance as you get from 10% of evo history, or as much variance as you get from the whole tree
# #SE.vector <- c(0, 0.5*sqrt(max(sigmasq.vector)*max(tree.height.vector)))
# SE.vector <- c(0)
# free.parameter.vector <- c("sigma.sq_mu", "sigma.sq_mu_vh", "sigma.sq_mu_bt", "sigma.sq_mu_bt_vh") # we will later split these to get the actual free parameteres

test <- drake_plan(
  cl = StartCluster(),
  result = TestCluster(cl)
)
