library(ape)
library(BMhyb)
phy.graph <- ape::read.evonet(text="((((D:0.4,C:0.4):4.8,((A:0.8,B:0.8):2.2)#H1:2.2::0.5):4.0,(#H1:0::0.5,E:3.0):6.2):2.0,O:11.2);")
traits <- sequence(6)
names(traits) <- phy.graph$tip.label
print(BMhyb:::PruneDonorsRecipientsFromVCV(ComputeVCV(phy.graph)))
 # plot(phy.graph, arrows=2)
 # nodelabels()
 #  axisPhylo(backward=FALSE)

BMhyb:::BMhyb(phy.graph, traits, free.parameter.names=c("sigma.sq", "mu"))
# phy.graph2 <- phy.graph
# phy.graph2$reticulation <- matrix(c(11,13), nrow=1, byrow=TRUE)
# print(BMhyb:::PruneDonorsRecipientsFromVCV(ComputeVCV(phy.graph2)))
