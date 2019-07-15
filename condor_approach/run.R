args <- commandArgs(trailingOnly = TRUE)
print("args")
print(args)

condition.matrix <- expand.grid(ntax=15:30, nhybridizations=1:2, tree.height=1, sigma.sq=0.01, mu=1, bt=1, vh=0, SE=0, gamma=0.5, rep=sequence(3))

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

save(result, conditions, file=paste0("Result_Arg1_", args[1], "_arg2_", args[2], "_ntax_", conditions$ntax, "_nhybridizations_",conditions$nhybridizations, "_treeheight_",conditions$tree.height, "_sigmasq_",conditions$sigma.sq, "_mu_",conditions$mu, "_bt_", conditions$bt, "_vh_", conditions$vh, "_SE_", conditions$SE, "_gamma_", conditions$gamma, ".rda"))
