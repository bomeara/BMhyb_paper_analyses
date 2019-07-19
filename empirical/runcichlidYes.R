library(BMhyb)

data(cichlid)
c.results.yes.empirical.se <- BMhybExhaustive(phy.graph=cichlid$phy.graph, traits=cichlid$trait, measurement.error=cichlid$final.se, confidence.points=5000)
save(c.results.yes.empirical.se, file="CichlidResultsYes.rda")
