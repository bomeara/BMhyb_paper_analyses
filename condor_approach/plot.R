#save(all.results, model.averaged.results, model.averaged.results.no.outliers, file="Summary.rda")
rm(list=ls())
source("gather.R")
library(ggplot2)
library(Metrics)


plotresults <- function(results) {
    
    results$Number_of_taxa <- as.factor(results$ntax.true)
    results$N_Hybrid <- as.factor(results$nhybridizations.true)
    results$True_beta <- as.factor(results$bt.true) 
    results$True_vh <- as.factor(results$vh.true)
    results$True_SE <- as.factor(results$SE.true)
    results$Weight_for_free_beta <- 1-results$bt.fixed
    results$Weight_for_free_SE <- 1-results$SE.fixed
    results$Weight_for_free_vh <- 1-results$vh.fixed
    
    
    
    sigma.sq.plot <- ggplot(results, aes(x=Number_of_taxa, y=sigma.sq, fill=N_Hybrid)) +
        geom_boxplot(notch=TRUE) + geom_hline(yintercept=unique(results$sigma.sq.true)) + scale_fill_viridis_d() 
    print(sigma.sq.plot)
    
    mu.plot <- ggplot(results, aes(x=Number_of_taxa, y=mu, fill=N_Hybrid)) +
        geom_boxplot(notch=TRUE) + geom_hline(yintercept=unique(results$mu.true)) + scale_fill_viridis_d()
    print(mu.plot)
    
    vh.plot <- ggplot(results, aes(x=Number_of_taxa, y=vh, fill=N_Hybrid)) +
        geom_boxplot(notch=TRUE) + geom_hline(data = results, aes(yintercept = vh.true)) +  facet_wrap(~ N_Hybrid + True_vh, nrow=1, labeller = label_both) + scale_fill_viridis_d()
    print(vh.plot)
  
    
    SE.plot <- ggplot(results, aes(x=Number_of_taxa, y=SE, fill=N_Hybrid)) +
        geom_boxplot(notch=TRUE) + geom_hline(data = results, aes(yintercept = SE.true)) +  facet_wrap(~ N_Hybrid + True_SE, nrow=1, labeller = label_both) + scale_fill_viridis_d()
    print(SE.plot)
    
    
    bt.plot <- ggplot(results, aes(x=Number_of_taxa, y=bt, fill=True_beta)) +
        geom_boxplot(notch=TRUE) + facet_wrap(~ N_Hybrid + True_beta, nrow=1, labeller = label_both) + geom_hline(data = results, aes(yintercept = bt.true)) + scale_fill_viridis_d()
    print(bt.plot)
    
    bt.plot2 <- ggplot(results, aes(x=Number_of_taxa, y=Weight_for_free_beta, fill=True_beta)) +
        geom_boxplot(notch=TRUE) + facet_wrap(~ N_Hybrid + True_beta, nrow=1, labeller = label_both) + scale_fill_viridis_d()
    print(bt.plot2)
    
    vh.plot2 <- ggplot(results, aes(x=Number_of_taxa, y=Weight_for_free_vh, fill=True_vh)) +
        geom_boxplot(notch=TRUE) + facet_wrap(~ N_Hybrid + True_vh, nrow=1, labeller = label_both) + scale_fill_viridis_d()
    print(vh.plot2)
    
    
    SE.plot2 <- ggplot(results, aes(x=Number_of_taxa, y=Weight_for_free_SE, fill=True_SE)) +
        geom_boxplot(notch=TRUE) + facet_wrap(~ N_Hybrid + True_SE, nrow=1, labeller = label_both) + scale_fill_viridis_d()
    print(SE.plot2)
    
    vh.plot3 <- ggplot(results, aes(x=Number_of_taxa, y=vh, fill=N_Hybrid)) +
        geom_boxplot(notch=TRUE) + geom_hline(data = results, aes(yintercept = vh.true)) +  facet_wrap(~ N_Hybrid + True_vh + True_SE + True_beta, nrow=4, labeller = label_both) + scale_fill_viridis_d()
    print(vh.plot3)
    
    if(any(grepl("ModelType", colnames(results)))) {
        vh.exhaustive.plot <- ggplot(results, aes(x=Number_of_taxa, y=vh, fill=True_vh)) +
            geom_boxplot() + facet_wrap(~ N_Hybrid +ModelType,  nrow=3, labeller = label_both) + scale_fill_viridis_d() + ylim(low=0, high=0.5)
        print(vh.exhaustive.plot)
    }
    
}

###### 

load("Summary.rda")



#plotresults(all.results)

plotresults(model.averaged.results)

#plotresults(all.results)

best.results <- all.results[which(all.results$deltaAICc==0),]

vh.best <- best.results[which(best.results$vh>0),]
