library(BMhyb)
library(dplyr)

all.results <- data.frame()

relevant.files <- list.files(pattern="Result.*rda")
for (file.index in seq_along(relevant.files)) {
  results <- NULL
  conditions <- NULL
  try(load(relevant.files[file.index]))
  if(!is.null(results)) {
    names(conditions) <- paste0(names(conditions), ".true")
    local.results <- data.frame()
    for(i in sequence(length(results))) {
      local.row <- cbind(results[[i]]$best, conditions)
      local.results <- plyr::rbind.fill(local.results, local.row)
    }
    local.results$deltaAICc <- local.results$AICc - min(local.results$AICc)
    rel.lik <- exp(-0.5* local.results$deltaAICc)
    local.results$AkaikeWeight <- rel.lik / sum(rel.lik)
    all.results <- plyr::rbind.fill(all.results, local.results)
  }
}
all.results$SE.fixed <- FALSE
all.results$SE.fixed[which(is.na(all.results$SE))] <- TRUE
all.results$SE[which(is.na(all.results$SE))] <- 0

all.results$bt.fixed <- FALSE
all.results$bt.fixed[which(is.na(all.results$bt))] <- TRUE
all.results$bt[which(is.na(all.results$bt))] <- 1

all.results$vh.fixed <- FALSE
all.results$vh.fixed[which(is.na(all.results$vh))] <- TRUE
all.results$vh[which(is.na(all.results$vh))] <- 0

save(all.results, file="Summary.rda")
