library(BMhyb)

data(cichlid)

c.results.no.empirical.se <- BMhybExhaustive(phy.graph=cichlid$phy.graph, traits=cichlid$trait, confidence.points=5000)
save(c.results.no.empirical.se, file="CichlidResultsNo.rda")
