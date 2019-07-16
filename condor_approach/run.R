args <- commandArgs(trailingOnly = TRUE)
print("args")
print(args)

setSessionTimeLimit(cpu=12*60*60) # stop a job after 12 hours: could be stalled


condition.matrix <- expand.grid(ntax=c(30,100), nhybridizations=c(1,2,5,10), tree.height=50, sigma.sq=0.01, mu=1, bt=c(1,2), vh=c(0,0.1*50*0.01,50*0.01), SE=c(0, 0.1*sqrt(0.01*50), 0.5*sqrt(0.01*50)), gamma=0.5, rep=sequence(100)) #for Vh, zero, as much variance as you get from 10% of evo history, or as much variance as you get from the whole tree. For SE, 10% and half of the variance from BM

base_number <- as.numeric(args[2]) + 1

conditions <- condition.matrix[base_number,]


DoRunTemplated <- function(ntax, nhybridizations, tree.height, sigma.sq, mu, bt, vh, SE, gamma) {
  library(BMhyb)
  #free.parameters <- strsplit("_", free.parameter.lumps)[[1]]
  free.parameters <- c("mu", "sigma.sq")
	hostname <- system("hostname -s", intern=TRUE)
	phy.graph<-BMhyb::SimulateNetwork(ntax=ntax, nhybridizations=nhybridizations, tree.height=tree.height)
  tips <- BMhyb::SimulateTips(phy.graph, sigma.sq=sigma.sq, mu=mu, bt=bt, vh=vh, SE=SE, gamma=gamma)
  result <- BMhyb::BMhyb(phy.graph=phy.graph, traits=tips, free.parameter.names=free.parameters, gamma=gamma, confidence.points=100, max.steps=2)
  result$hostname <- hostname
  return(result)
}

result <- DoRunTemplated(ntax=conditions$ntax, nhybridizations=conditions$nhybridizations, tree.height=conditions$tree.height, sigma.sq=conditions$sigma.sq, mu=conditions$mu, bt=conditions$bt, vh=conditions$vh, SE=conditions$SE, gamma=conditions$gamma)

save(result, conditions, file=paste0("Result_Arg1_", args[1], "_arg2_", args[2], "_ntax_", conditions$ntax, "_nhybridizations_",conditions$nhybridizations, "_treeheight_",conditions$tree.height, "_sigmasq_",conditions$sigma.sq, "_mu_",conditions$mu, "_bt_", conditions$bt, "_vh_", conditions$vh, "_SE_", round(conditions$SE,5), "_gamma_", conditions$gamma,"_rep_", conditions$rep, ".rda"))
