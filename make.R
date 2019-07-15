source("R/packages.R")  # Load all the packages you need.
source("R/functions.R") # Load all the functions into your environment.
source("R/plan.R")      # Build your workflow plan data frame.

pkgconfig::set_config("drake::strings_in_dots" = "literals")
knitr::opts_knit$set(root.dir = "docs")
knitr::opts_knit$set(base.dir = "docs")

#make(cichlids)
#make(nicotiana)


#make(sims)




#make(sims, parallelism = "mclapply", jobs = 24)
# print("Starting cluster")
# cl <- StartCluster()
# print(paste0("cluster started with ", length(cl), " nodes"))
#library(future)
#future::plan(cluster, workers=cl)

#future::plan("cluster", cl, workers=length(cl))
# intended.results <- drake::drake_config(sims.separated)$all_targets
# drake::vis_drake_graph(drake::drake_config(sims.separated))
# make(sims.separated, parallelism = "future_lapply_staged")
# for (i in sequence(length(intended.results))) {
#   drake::loadd(intended.results[i])
# }

# GetHost <- function() {
#   Sys.sleep(2)
#   return(system("hostname", intern=TRUE))
# }
#
# GetHostAndTree <- function(ntax, number) {
#   phy <- ape::rcoal(ntax)
#   Sys.sleep(2)
#   return(list(tree=phy, host=system("hostname", intern=TRUE), number=number))
# }

#doParallel::registerDoParallel(cl)
#results <- foreach( number=6:10, ntax=3:5) %dopar% GetHostAndTree(ntax, number)

#drake::clean(destroy=TRUE)

 #drake::load_mtcars_example()
#drake::make(my_plan, parallelism = "future")
 #my_plan_2 <- my_plan
 #my_plan_2 <- rbind(my_plan_2, data.frame(target=paste0("hosts", sequence(30)), command="GetHost()", stringsAsFactors=FALSE), stringsAsFactors=FALSE)
# drake::clean(destroy=TRUE)
 #my_plan_2 <- my_plan_2[16:30,]
 #drake::make(my_plan_2, parallelism = "future")

#parallel::stopCluster(cl)
#for (i in sequence(30)) {
#  drake::loadd(paste0("hosts", i))
#  print(eval(parse(paste0("hosts", i))))
#}

# library(future)
# future::plan(cluster, workers=cl)
# cl <- StartCluster()
# print("starting results")
# results <- data.frame(target=paste0("name", sequence(10)), host="unknown", stringsAsFactors=FALSE)
#
# for (i in nrow(results)) {
#   a %<-% {
#     GetHost()
#   }
#   results[i,2] <- a
# }
# a %<-% {
#      pid <- Sys.getpid()
#      cat("Future 'a' ...\n")
#      3.14
#      system("hostname", intern=TRUE)
#
#  }
#  b %<-% {
#      rm(pid)
#      cat("Future 'b' ...\n")
#      Sys.getpid()
#      system("hostname", intern=TRUE)
#
#  }
#  c %<-% {
#      cat("Future 'c' ...\n")
#      #2 * a
#      Sys.getpid()
#      system("hostname", intern=TRUE)
#
#
#  }
#
# a
# b
# c

cl <- StartCluster()
doParallel::registerDoParallel(cl)
sim.results = foreach(ntax=3:4, nhybridizations=1:2, tree.height=1, sigma.sq=0.01, mu=1, bt=1, vh=0, SE=0, gamma=0.5) %dopar% DoRunTemplated(ntax, nhybridizations, tree.height, sigma.sq, mu, bt, vh, SE, gamma)
#sim.results = foreach(ntax=3:100, .combine=list) %dopar% GetPackages()
write(sim.results, file="simresults.rda")
