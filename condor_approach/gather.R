library(BMhyb)
library(dplyr)
condition.matrix <- expand.grid(ntax=c(30,100), nhybridizations=c(1,5,10), tree.height=50, sigma.sq=0.01, mu=1, bt=c(1,2), vh=c(0,0.1*50*0.01), SE=c(0, 0.1*sqrt(0.01*50)), gamma=0.5, rep=sequence(50)) #for Vh, zero, as much variance as you get from 10% of evo history, or as much variance as you get from the whole tree. For SE, 10% and half of the variance from BM

all.results <- data.frame()

for (i in sequence(nrow(condition.matrix))) {
  results <- NULL
  conditions <- NULL
  relevant_file_string <- paste0("_ntax_", conditions$ntax, "_nhybridizations_",conditions$nhybridizations, "_treeheight_",conditions$tree.height, "_sigmasq_",conditions$sigma.sq, "_mu_",conditions$mu, "_bt_", conditions$bt, "_vh_", conditions$vh, "_SE_", round(conditions$SE,5), "_gamma_", conditions$gamma,"_rep_", conditions$rep, ".rda")
  relevant_files <- list.files(pattern=relevant_file_string)
  for (file_index in seq_along(relevant_files)) {
    try(load(relevant_files[file_index]))
    if(!is.null(results)) {
      local.results <- data.frame()
      for (result.index in seq_along(results)) {
        result <- results[[result.index]]
        result.params <- c(result$best, conditions)
        local.results <- plyr::rbind.fill(local.results, result.params)
      }
      local.results$deltaAICc <- local.results$AICc - min(local.results$AICc)
      rel.lik <- exp(-0.5* local.results$deltaAICc)
      local.results$AkaikeWeight <- rel.lik / sum(rel.lik)
      all.results <- plyr::rbind.fill(all.results, local.results)
    }
  }
}
save(all.results, file="Summary.rda")
