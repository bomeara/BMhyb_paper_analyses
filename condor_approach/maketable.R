library(openxlsx)
source("gather.R")

condition.matrix.variable.only <- expand.grid(ntax=c(30,100), nhybridizations=c(1,5,10), bt=c(1,2), vh=c(0, 0.1*50*0.01, 0.5*50*0.01), SE=c(0, 0.1*sqrt(0.01*50))) #for Vh, zero, as much variance as you get from 10% of evo history, or as much variance as you get from 50% of the whole tree. For SE, 10% and half of the variance from BM


condition.matrix.variable.only <- condition.matrix.variable.only[order(condition.matrix.variable.only$ntax, condition.matrix.variable.only$nhybridizations, condition.matrix.variable.only$bt, condition.matrix.variable.only$vh, condition.matrix.variable.only$SE),]

condition.matrix.variable.only$sigma.sq.est.mean <- NA
condition.matrix.variable.only$sigma.sq.est.sd <- NA

condition.matrix.variable.only$mu.est.mean <- NA
condition.matrix.variable.only$mu.est.sd <- NA

condition.matrix.variable.only$bt.est.mean <- NA
condition.matrix.variable.only$bt.est.sd <- NA

condition.matrix.variable.only$vh.est.mean <- NA
condition.matrix.variable.only$vh.est.sd <- NA

condition.matrix.variable.only$SE.est.mean <- NA
condition.matrix.variable.only$SE.est.sd <- NA

condition.matrix.variable.only$count <- 0

params <- c("sigma.sq", "mu", "bt", "vh", "SE")

for (condition_index in sequence(nrow(condition.matrix.variable.only))) {
  local <- subset(model.averaged.results, model.averaged.results$ntax.true==condition.matrix.variable.only$ntax[condition_index] & model.averaged.results$vh.true==condition.matrix.variable.only$vh[condition_index] & model.averaged.results$bt.true==condition.matrix.variable.only$bt[condition_index] & model.averaged.results$SE.true==condition.matrix.variable.only$SE[condition_index] & model.averaged.results$nhybridizations.true==condition.matrix.variable.only$nhybridizations[condition_index])
  if(nrow(local)>0) {
    for (param_index in seq_along(params)) {
      condition.matrix.variable.only[condition_index, paste0(params[param_index], '.est.mean')] <- mean(local[,params[param_index]], na.rm=TRUE)
      condition.matrix.variable.only[condition_index, paste0(params[param_index], '.est.sd')] <- sd(local[,params[param_index]], na.rm=TRUE)
    }
    condition.matrix.variable.only[condition_index, "count"] <- nrow(local)
  }
}

result_matrix <- data.frame(
  ntax=condition.matrix.variable.only$ntax,
  nhybridizations=condition.matrix.variable.only$nhybridizations,
  sigma.sq_true=0.01,
  sigma.sq_est=paste0(round(condition.matrix.variable.only$sigma.sq.est.mean,3), " (", round(condition.matrix.variable.only$sigma.sq.est.sd,3), ")"),
  mu_true = 1,
  mu_est = paste0(round(condition.matrix.variable.only$mu.est.mean,3), " (", round(condition.matrix.variable.only$mu.est.sd,3), ")"),
  bt_true=condition.matrix.variable.only$bt,
  bt_est=paste0(round(condition.matrix.variable.only$bt.est.mean,3), " (", round(condition.matrix.variable.only$bt.est.sd,3), ")"),
  vh_true=condition.matrix.variable.only$vh,
  vh_est=paste0(round(condition.matrix.variable.only$vh.est.mean,3), " (", round(condition.matrix.variable.only$vh.est.sd,3), ")"),
  SE_true=round(condition.matrix.variable.only$SE, 3),
  SE_est=paste0(round(condition.matrix.variable.only$SE.est.mean,3), " (", round(condition.matrix.variable.only$SE.est.sd,3), ")"),
  stringsAsFactors=FALSE
)

wb <- openxlsx::createWorkbook()
openxlsx::addWorksheet(wb, "Summary")
openxlsx::writeDataTable(wb, sheet=1, result_matrix)
for (column_index in sequence(ncol(result_matrix))) {
  if(!grepl("_est", colnames(result_matrix)[column_index])) {
    start_merge <- 2
    for (row_index in 2:nrow(result_matrix)) {
      if(result_matrix[row_index, column_index] != result_matrix[row_index-1, column_index]) {
        openxlsx::mergeCells(wb, sheet=1, cols=rep(column_index,2), rows=c(start_merge, row_index))
        start_merge <- row_index + 1
      }
    }
    openxlsx::mergeCells(wb, sheet=1, cols=rep(column_index,2), rows=c(start_merge, row_index+1))
  }
}

openxlsx::saveWorkbook(wb, "Summary.xlsx", overwrite = TRUE)
system("open Summary.xlsx")
