# Nighttime Lights Analysis: Main Script

# Filepaths ---------------------------------------------------------------------
if(Sys.info()[["user"]] == "robmarty"){
  git_dir  <- "~/Documents/Github/lebanon-economic-monitor"
  proj_dir <- "~/Dropbox/World Bank/Side Work/Lebanon Economic Monitor"
} 

data_dir      <- file.path(proj_dir, "Data")
ntl_dir       <- file.path(data_dir, "night-time-lights")
gas_flare_dir <- file.path(data_dir, "gas-flaring")
admin_bnd_dir <- file.path(data_dir, "shapefiles")

figures_dir   <- file.path(git_dir, "notebooks", "ntl-analysis", "figures")

# Packages ---------------------------------------------------------------------
# devtools::install_github("ramarty/blackmarbler")

library(tidyverse)
library(janitor)
library(readxl)
library(lubridate)
library(ggpubr)
library(sf)
library(raster)
library(exactextractr)
library(blackmarbler)