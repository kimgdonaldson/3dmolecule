library(ChemmineR)
library(plotly)
library(httr)
library(rcdk)

# source("R/get_sdf.R")
# source("R/plot_3d_molecule.R")
# source("R/utils.R")

# Read the 3D SDF file
sdfset_3d <- read.SDFset("data/Bacoside A.sdf")




# Visualize the first molecule as an example
visualize_molecule(1)