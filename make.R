source("R/packages.R")  # Load all the packages you need.
source("R/functions.R") # Load all the functions into your environment.
source("R/plan.R")      # Build your workflow plan data frame.

pkgconfig::set_config("drake::strings_in_dots" = "literals")
knitr::opts_knit$set(root.dir = "docs")
knitr::opts_knit$set(base.dir = "docs")

#make(cichlids)
#make(nicotiana)






#make(sims, parallelism = "mclapply", jobs = 24)
cl <- StartCluster()
future::plan("multisession", cl, workers=length(cl))
intended.results <- drake::drake_config(sims.separated)$all_targets
drake::vis_drake_graph(drake::drake_config(sims.separated))
make(sims.separated, parallelism = "future_lapply_staged")
for (i in sequence(length(intended.results))) {
  drake::loadd(intended.results[i])
}
parallel::stopCluster(cl)
