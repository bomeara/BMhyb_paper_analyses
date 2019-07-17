library(BMhyb)
load("NicotianaResults.rda")
load("CichlidResults.rda")
BMhyb::plot(n.results)
BMhyb::plot(n.results, style="contour")

BMhyb::plot(c.results.no.empirical.se)
BMhyb::plot(c.results.no.empirical.se, style="contour")

BMhyb::plot(c.results.yes.empirical.se)
BMhyb::plot(c.results.yes.empirical.se, style="contour")
