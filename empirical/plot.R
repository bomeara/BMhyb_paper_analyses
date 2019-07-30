rm(list=ls())
library(BMhyb)
load("NicotianaResults.rda")
load("CichlidResultsYes.rda")
load("CichlidResultsNo.rda")
source("gather.R")

# DoPlot <- function(x) {
#   best.run <- which(x$summary.df$deltaAICc==0)
#   plot(x$results[[best.run]])
#   plot(x$results[[best.run]], style="contour")
#
# }
#
#
# DoPlot(n.results)
# DoPlot(c.results.no.empirical.se)
# DoPlot(c.results.yes.empirical.se)


load("NicotianaResults.rda")
class(n.results) <- "BMhybExhaustiveResult"
pdf(file="NicotianaResults.pdf", height=3, width=8)
print(plot(n.results, style="contour", nrow=2))
dev.off()

#ggplot2::ggsave("NicotianaResults_ggsave.pdf")
#summary(n.results)

pdf(file="CichlidUnivariateResults.pdf", height=5, width=10)
plot(c.results.raw[[c.results.no.empirical.se$summary.df$ModelNumber[which(c.results.no.empirical.se$summary.df$deltaAICc==0)]]])
dev.off()
