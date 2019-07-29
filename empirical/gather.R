rm(list=ls())
library(BMhyb)
data(cichlid)
load("CichlidResultsYes.rda")
c.results.yes.empirical.se$summary.df$EmpiricalSEKnown <- TRUE
load("CichlidResultsNo.rda")
c.results.no.empirical.se$summary.df$EmpiricalSEKnown <- FALSE


c.results.raw <- c(c.results.yes.empirical.se$results, c.results.no.empirical.se$results)
c.results.no.empirical.se$summary.df$ModelNumber <- c.results.no.empirical.se$summary.df$ModelNumber + 8
c.results <- rbind(c.results.yes.empirical.se$summary.df, c.results.no.empirical.se$summary.df)


c.results$BM_variance <- max(ape::branching.times(cichlid$phy.graph))*c.results$sigma.sq
c.results$deltaAICc <- c.results$AICc - min(c.results$AICc)
rel.lik <- exp(-0.5* c.results$deltaAICc)
c.results$AkaikeWeight <- rel.lik / sum(rel.lik)
c.results$SE[which(is.na(c.results$SE))] <- 0
c.results$bt[which(is.na(c.results$bt))] <- 1
c.results$vh[which(is.na(c.results$vh))] <- 0

c.results$nonhybrid_variance <- c.results$SE + c.results$BM_variance
c.results$hybrid_variance <- c.results$SE + c.results$BM_variance + c.results$vh
c.results$nonhybrid_proportional_BM_variance <- c.results$BM_variance / c.results$nonhybrid_variance
c.results$hybrid_proportional_BM_variance <- c.results$BM_variance / c.results$hybrid_variance
c.results$hybrid_proportional_vh_variance <- c.results$vh / c.results$hybrid_variance
c.results <- c.results[order(c.results$AkaikeWeight, decreasing=TRUE),]

all.sims <- data.frame()

for (i in seq_along(c.results.raw)) {
  all.sims <- plyr::rbind.fill(all.sims, c.results.raw[[i]]$good.region)
  all.sims <- plyr::rbind.fill(all.sims, c.results.raw[[i]]$bad.region)
}

all.sims <- all.sims[,-which(colnames(all.sims)=="SE")] # because SE has different meanings depending on whether we know empirical or not
params <- colnames(all.sims)[-1]
x <- list()
x$good.region <- all.sims[which(all.sims$negloglik<=(2+min(all.sims$negloglik))),]
x$bad.region <- all.sims[which(all.sims$negloglik>(2+min(all.sims$negloglik))),]
graphics::par(mfcol=c(1, length(params)))
for(parameter in sequence(length(params))) {
    graphics::plot(x=all.sims[,parameter+1], y=all.sims[,1], type="n", xlab=params[parameter], ylab="NegLnL", bty="n", ylim=c(min(all.sims[,1]), max(all.sims[,1])))
    graphics::points(x=x$good.region[,parameter+1], y=x$good.region[,1], pch=16, col="black")
    graphics::points(x=x$bad.region[,parameter+1], y=x$bad.region[,1], pch=16, col="gray")
    #graphics::points(x= x$best[parameter], y= x$best['NegLogLik'], pch=1, col=focal.color, cex=1.5)
}

load("NicotianaResults.rda")
merged <- MergeExhaustiveForPlotting(n.results)
plot(merged, style="contour")
