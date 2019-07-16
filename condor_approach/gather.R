rm(list=ls())
library(BMhyb)
library(dplyr)

all.results <- data.frame()
model.averaged.results <- data.frame()
model.averaged.results.no.outliers <- data.frame()

delta.AICc.threshold <- 10

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
    local.results$source.file <- relevant.files[file.index]

    local.results$SE.fixed <- FALSE
    local.results$SE.fixed[which(is.na(local.results$SE))] <- TRUE
    local.results$SE[which(is.na(local.results$SE))] <- 0

    local.results$bt.fixed <- FALSE
    local.results$bt.fixed[which(is.na(local.results$bt))] <- TRUE
    local.results$bt[which(is.na(local.results$bt))] <- 1

    local.results$vh.fixed <- FALSE
    local.results$vh.fixed[which(is.na(local.results$vh))] <- TRUE
    local.results$vh[which(is.na(local.results$vh))] <- 0

    #local.results.numeric <- local.results[,which(!grepl("fixed", colnames(local.results)))]
    local.results.numeric <- local.results[,which(!grepl("file", colnames(local.results)))]


    avg.local.results <- apply(local.results.numeric, 2, stats::weighted.mean, w=local.results.numeric$AkaikeWeight)
    avg.local.results$source.file <- local.results$source.file[1]

    local.results.threshold <- local.results.numeric[which(local.results.numeric$deltaAICc<delta.AICc.threshold),]
    rel.lik <- exp(-0.5* local.results.threshold$deltaAICc)
    local.results.threshold$AkaikeWeight <- rel.lik / sum(rel.lik)

    avg.local.results.threshold <- apply(local.results.threshold, 2, stats::weighted.mean, w=local.results.threshold$AkaikeWeight)
    avg.local.results.threshold$source.file <- local.results$source.file[1]

    all.results <- plyr::rbind.fill(all.results, local.results)
    model.averaged.results <- plyr::rbind.fill(model.averaged.results, avg.local.results)
    model.averaged.results.no.outliers <- plyr::rbind.fill(model.averaged.results.no.outliers, avg.local.results.threshold)

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

save(all.results, model.averaged.results, model.averaged.results.no.outliers, file="Summary.rda")
