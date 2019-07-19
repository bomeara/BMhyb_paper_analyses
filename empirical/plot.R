rm(list=ls())
library(BMhyb)
load("NicotianaResults.rda")
load("CichlidResultsYes.rda")
load("CichlidResultsNo.rda")


DoPlot <- function(x) {
  best.run <- which(x$summary.df$deltaAICc==0)
  plot(x$results[[best.run]])
  plot(x$results[[best.run]], style="contour")

}


DoPlot(n.results)
DoPlot(c.results.no.empirical.se)
DoPlot(c.results.yes.empirical.se)
