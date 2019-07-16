#save(all.results, model.averaged.results, model.averaged.results.no.outliers, file="Summary.rda")

library(ggplot2)
library(Metrics)

load("Summary.rda")

all.results$Number_of_taxa <- as.factor(all.results$ntax.true)
all.results$Number_of_hybridizations <- as.factor(all.results$nhybridizations.true)
all.results$True_beta <- as.factor(all.results$bt.true)

sigma.sq.plot <- ggplot(all.results, aes(x=Number_of_taxa, y=sigma.sq, fill=Number_of_hybridizations)) +
  geom_violin() + geom_hline(yintercept=unique(all.results$sigma.sq.true))
sigma.sq.plot

mu.plot <- ggplot(all.results, aes(x=Number_of_taxa, y=mu, fill=Number_of_hybridizations)) +
  geom_violin() + geom_hline(yintercept=unique(all.results$mu.true))
mu.plot

vh.plot <- ggplot(all.results, aes(x=Number_of_taxa, y=vh, fill=Number_of_hybridizations)) +
  geom_violin()
vh.plot

bt.plot <- ggplot(all.results, aes(x=Number_of_taxa, y=bt, fill=True_beta)) +
  geom_violin() + facet_wrap(~ Number_of_hybridizations + True_beta, nrow=1) + geom_hline(data = all.results, aes(yintercept = bt.true))
bt.plot
