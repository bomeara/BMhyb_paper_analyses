using Pkg
ENV["R_HOME"]="*"
Pkg.add("RCall")
ENV["CMAKE_JL_BUILD_FROM_SOURCE"] = 1
Pkg.add("CMake")
Pkg.build("CMake")
Pkg.add("NLopt")
Pkg.build("NLopt")
Pkg.add("DataFrames")
Pkg.add("StatsModels")
Pkg.add("PhyloNetworks")
Pkg.add("PhyloPlots")
Pkg.update()
using PhyloNetworks
truenet = readTopology("((((D:0.4,C:0.4):4.8,((A:0.8,B:0.8):2.2)#H1:2.2::0.5):4.0,(#H1:0::0.5,E:3.0):6.2):2.0,O:11.2);")
vcv(truenet)
using DataFrames

dat = DataFrame(trait0 = [1, 2, 3, 4, 5, 6], tipNames=tipLabels(truenet))
using StatsModels
fitTrait1 = phyloNetworklm(@formula(trait0 ~ 1), dat, truenet)

fitTrait1
