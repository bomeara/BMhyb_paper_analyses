GeneratePossibleSets <- function() {
  ntax.vector <- c(30, 100)
  nhybridizations.vector <- c(1, 5, 10)
  gamma.vector <-c(.5)
  sigmasq.vector <- c(0.01)
  tree.height.vector <- c(50)
  mu.vector <- c(1)
  bt.vector <- c(1, 2)
  vh.vector <- c(0, .1*max(sigmasq.vector)*max(tree.height.vector), max(sigmasq.vector)*max(tree.height.vector)) #zero, as much variance as you get from 10% of evo history, or as much variance as you get from the whole tree
  #SE.vector <- c(0, 0.5*sqrt(max(sigmasq.vector)*max(tree.height.vector)))
  SE.vector <- c(0)
  free.parameter.vector <- c("sigma.sq_mu", "sigma.sq_mu_vh", "sigma.sq_mu_bt", "sigma.sq_mu_bt_vh") # we will later split these to get the actual free parameteres
  nreps <- 25
  possible.sets <- expand.grid(ntax=ntax.vector, nhybridizations=nhybridizations.vector, gamma=gamma.vector, sigma.sq=sigmasq.vector, mu=mu.vector, bt=bt.vector, vh=vh.vector, SE=SE.vector, tree.height=tree.height.vector, free.parameter.lumps = free.parameter.vector)
  return(possible.sets)
}

DoRun <- function(id, identifier, sets) {
	session.info.variable <- sessionInfo()
	x <- sets[id,]
  free.parameters <- strsplit("_", x$free.parameter.lumps)[[1]]
	hostname <- system("hostname -s", intern=TRUE)
	phy.graph<-BMhyb::SimulateNetwork(ntax=x['ntax'], nhybridizations=x['nhybridizations'], tree.height=x['tree.height'])
  tips <- BMhyb::SimulateTips(phy.graph, sigma.sq=x['sigma.sq'], mu=x['mu'], bt=x['bt'], vh=x['vh'], SE=x['SE'], gamma=x['gamma'])
  result <- BMhyb::BMhyb(phy.graph=phy.graph, traits=tips, free.parameter.names=free.parameters, gamma=x['gamma'], confidence.points=1000)
  return(result)
}


DoRunTemplated <- function(ntax, nhybridizations, tree.height, sigma.sq, mu, bt, vh, SE, gamma) {
  #free.parameters <- strsplit("_", free.parameter.lumps)[[1]]
  free.parameters <- c("mu", "sigma.sq")
	hostname <- system("hostname -s", intern=TRUE)
	phy.graph<-BMhyb::SimulateNetwork(ntax=ntax, nhybridizations=nhybridizations, tree.height=tree.height)
  tips <- BMyhyb::SimulateTips(phy.graph, sigma.sq=sigma.sq, mu=mu, bt=bt, vh=vh, SE=SE, gamma=gamma)
  result <- BMhyb::BMhyb(phy.graph=phy.graph, traits=tips, free.parameter.names=free.parameters, gamma=gamma, confidence.points=100, max.steps=2)
  result$hostname <- hostname
  return(result)
}


StartCluster <- function() {
  # http://www.win-vector.com/blog/2016/01/running-r-jobs-quickly-on-many-machines/
  # have to deal with hardcoded 125 limit: https://github.com/HenrikBengtsson/Wishlist-for-R/issues/28
  machine.names <- c("omearalab13.bio.utk.edu",
  "omearaclustera.nomad.utk.edu",
  "omearaclusterb.nomad.utk.edu",
  "omearaclusterc.nomad.utk.edu",
  "omearaclusterd.nomad.utk.edu",
  "omearaclustere.nomad.utk.edu",
  "omearaclusterh.nomad.utk.edu",
  "omearaclusteri.nomad.utk.edu",
  "omearaclusterl.nomad.utk.edu")

  cluster.df <- data.frame(machine.name=machine.names, ncore=1, mhz=0, stringsAsFactors=FALSE)
  tmp <- parallel::makePSOCKcluster(cluster.df$machine.name,
  rscript="/usr/bin/Rscript")
  get_max_cpu <- function() {
    mhz <- 0
    result <- NULL
    try(result <- as.numeric(gsub("CPU max MHz:[[:space:]]+", "", system("lscpu | grep MHz | grep max", intern=TRUE))))
    if(!is.null(result)) {
      mhz <- result
    }
    return(mhz)
  }
  cluster.df$ncore <- unlist(parallel::clusterCall(tmp, parallel::detectCores))
  cluster.df$mhz <- unlist(parallel::clusterCall(tmp, get_max_cpu))
  parallel::stopCluster(tmp)
  cluster.df <- cluster.df[order(cluster.df$mhz, decreasing=TRUE),] #sort to make it as fast as possible before hitting connection limit



  all.machines.spec <- c()
  for (i in sequence(nrow(cluster.df))) {
    for (j in sequence(cluster.df$ncore[i])) {
      if(length(all.machines.spec)<110) { # https://github.com/HenrikBengtsson/Wishlist-for-R/issues/28 Hardcoded limit in R on number of connections
        all.machines.spec <- append(all.machines.spec, list(name=cluster.df$machine.name[i]))
      }
    }
  }
  cl <- parallel::makeCluster(type="PSOCK", spec=all.machines.spec, rscript="/usr/bin/Rscript")
  return(cl)
}

GenerateSimResults <- function() {
  cl <- StartCluster()
  doParallel::registerDoParallel(cl)
  sim.results = foreach(ntax=3:4, nhybridizations=1:2, tree.height=1, sigma.sq=0.01, mu=1, bt=1, vh=0, SE=0, gamma=0.5) %dopar% DoRunTemplated(ntax, nhybridizations, tree.height, sigma.sq, mu, bt, vh, SE, gamma)
  parallel::stopCluster(cl)
  return(sim.results)
}

TestCluster <- function(cl) {
  library(drake)
  drake_examples("Docker-psock")
  future::plan("cluster", workers = cl)
  load_mtcars_example()
  make(my_plan, parallelism = "future")
}

GetHost <- function() {
  Sys.sleep(30)
  return(system("hostname", intern=TRUE))
}
