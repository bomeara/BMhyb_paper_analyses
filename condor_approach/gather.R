
library(BMhyb)
condition.matrix <- expand.grid(ntax=c(30,100), nhybridizations=c(1,5,10), tree.height=50, sigma.sq=0.01, mu=1, bt=c(1,2), vh=c(0,0.1*50*0.01), SE=c(0, 0.1*sqrt(0.01*50)), gamma=0.5, rep=sequence(50)) #for Vh, zero, as much variance as you get from 10% of evo history, or as much variance as you get from the whole tree. For SE, 10% and half of the variance from BM

for (i in sequence(nrow(condition.matrix))) {
  result <- NULL
  conditions <- NULL
  try(load(file=paste0("Result_arg1_", args[1], "_arg2_", args[2], "_ntax_", conditions$ntax, "_nhybridizations_",conditions$nhybridizations, "_treeheight_",conditions$tree.height, "_sigmasq_",conditions$sigma.sq, "_mu_",conditions$mu, "_bt_", conditions$bt, "_vh_", conditions$vh, "_SE_", round(conditions$SE,5), "_gamma_", conditions$gamma,"_rep_", conditions$rep, ".rda"))
  if(!is.null(result))
}
