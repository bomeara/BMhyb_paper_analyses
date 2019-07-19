library(BMhyb)

data(cichlid)

c.results.no.empirical.se <- BMhybExhaustive(phy.graph=cichlid$phy.graph, traits=cichlid$trait, confidence.points=5000, ncores=8)
save(c.results.no.empirical.se, file="CichlidResultsNo.rda")
c.results.yes.empirical.se <- BMhybExhaustive(phy.graph=cichlid$phy.graph, traits=cichlid$trait, measurement.error=cichlid$final.se, confidence.points=5000, ncores=8)
save(c.results.yes.empirical.se, file="CichlidResultsYes.rda")
data(nicotiana)
n.results <- BMhybExhaustive(phy.graph=nicotiana$phy.graph, traits=nicotiana$trait, confidence.points=5000, ncores=8)
save(n.results, file="NicotianaResults.rda")
