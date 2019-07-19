library(BMhyb)
data(nicotiana)
n.results <- BMhybExhaustive(phy.graph=nicotiana$phy.graph, traits=nicotiana$trait, confidence.points=5000)
save(n.results, file="NicotianaResults.rda")
