# Extract Nighttime Lights to Polygons

# Loop through different polygon types. For each polygon type
# 1. Make directories for where to save data
# 2. Aggregate annual data, both
# -- (a) VIIRS Black Marble [2012 - 2022]
# -- (b) DMSP [1992 - 2013]
# -- (c) Simulated DMSP (from VIIRS) [2014 - 2021]
# 3. Aggregate monthly data, VIIRS Black Marble only [2012 - present]

for(roi_name in c("cadaster", "lbn_adm0", "lbn_adm1", "lbn_adm2", "lbn_adm3", "lbn_adm4")){

  # Make Directories -------------------------------------------------------------
  dir.create(file.path(ntl_dir, "aggregated-individual-files", "annual", roi_name))
  dir.create(file.path(ntl_dir, "aggregated-individual-files", "monthly", roi_name))

  #dir.create(file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-monthly"))
  #dir.create(file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-annual"))

  # Load ROI ---------------------------------------------------------------------
  if(roi_name == "lbn_adm0"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "lbn_adm_cdr_20200810", "lbn_admbnda_adm0_cdr_20200810.shp"))
  }

  if(roi_name == "lbn_adm1"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "lbn_adm_cdr_20200810", "lbn_admbnda_adm1_cdr_20200810.shp"))
  }

  if(roi_name == "lbn_adm2"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "lbn_adm_cdr_20200810", "lbn_admbnda_adm2_cdr_20200810.shp"))
  }

  if(roi_name == "lbn_adm3"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "lbn_adm_cdr_20200810", "lbn_admbnda_adm3_cdr_20200810.shp"))
  }

  if(roi_name == "lbn_adm4"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "lbn_beirut_adm4_mapaction_pcoded", "lbn_beirut_adm4_MapAction_Pcoded.shp"))
  }

  if(roi_name == "cadaster"){
    roi_sf <- read_sf(file.path(admin_bnd_dir, "cad_shp", "cadaster.shp"))
  }

  roi_sf$adm_id <- 1:nrow(roi_sf)
  roi_sf$date <- NULL
  roi_sf$validOn <- NULL
  roi_sf$validTo <- NULL

  roi_og_sf <- roi_sf

  # Aggregate annual -------------------------------------------------------------
  years_vec <- file.path(ntl_dir, "ntl-rasters", "annual") %>%
    list.files(pattern = ".tif") %>%
    str_replace_all(".tif", "") %>%
    str_replace_all("VNP46A4_NearNadir_Composite_Snow_Free_qflag255_1_t", "")

  for(year in years_vec){

    ## Only process if file already hasn't been created
    OUT_FILE <- file.path(ntl_dir, "aggregated-individual-files", "annual", roi_name, paste0("ntl_", year, ".Rds"))

    if(!file.exists(OUT_FILE)){

      bm_r <- raster(file.path(ntl_dir, "ntl-rasters", "annual", paste0("VNP46A4_NearNadir_Composite_Snow_Free_qflag255_1_t",year,".tif")))

      roi_sf$ntl_bm_sum   <- exact_extract(bm_r, roi_sf, 'sum')
      roi_sf$ntl_bm_mean  <- exact_extract(bm_r, roi_sf, 'mean')

      roi_sf$year <- year

      roi_df <- roi_sf
      roi_df$geometry <- NULL

      saveRDS(roi_df, OUT_FILE)
    }

  }

  #### Append all data
  ntl_annual_df <- file.path(ntl_dir, "aggregated-individual-files", "annual", roi_name) %>%
    list.files(pattern = "*.Rds",
               full.names = T) %>%
    map_df(readRDS)

  ntl_annual_df$ntl_bm_sum[is.na(ntl_annual_df$ntl_bm_sum)] <- 0
  ntl_annual_df$ntl_bm_mean[is.na(ntl_annual_df$ntl_bm_mean)] <- 0

  #### Combine DMSP and VIIRS
  write_csv(ntl_annual_df, file.path(ntl_dir, "aggregated", "annual", paste0(roi_name, "_annual_ntl.csv")))
  write_dta(ntl_annual_df, file.path(ntl_dir, "aggregated", "annual", paste0(roi_name, "_annual_ntl.dta")))

  # Aggregate monthly ------------------------------------------------------------
  roi_sf <- roi_og_sf

  monthly_rasters <- file.path(ntl_dir, "ntl-rasters", "monthly") %>%
    list.files(pattern = "*.tif") %>%
    rev()

  for(r_month_i in monthly_rasters){

    ## Only process if file already hasn't been created
    month_i <- r_month_i %>%
      str_replace_all(".*_t", "") %>%
      str_replace_all(".tif", "")


    OUT_FILE <- file.path(ntl_dir, "aggregated-individual-files", "monthly", roi_name, paste0("ntl_", month_i, ".Rds"))

    if(!file.exists(OUT_FILE)){

      bm_r <- raster(file.path(ntl_dir, "ntl-rasters", "monthly", r_month_i))

      roi_sf$ntl_bm_sum   <- exact_extract(bm_r, roi_sf, 'sum')
      roi_sf$ntl_bm_mean  <- exact_extract(bm_r, roi_sf, 'mean')

      roi_sf$date <- month_i %>%
        str_replace_all("_", "-") %>%
        paste0("-01") %>%
        ymd()

      roi_df <- roi_sf
      roi_df$geometry <- NULL

      saveRDS(roi_df, OUT_FILE)
    }
  }

  ntl_monthly_df <- file.path(ntl_dir, "aggregated-individual-files", "monthly", roi_name) %>%
    list.files(pattern = "*.Rds",
               full.names = T) %>%
    map_df(readRDS)

  ntl_monthly_df$ntl_bm_sum[is.na(ntl_monthly_df$ntl_bm_sum)] <- 0
  ntl_monthly_df$ntl_bm_mean[is.na(ntl_monthly_df$ntl_bm_mean)] <- 0

  write_csv(ntl_monthly_df, file.path(ntl_dir, "aggregated", "monthly", paste0(roi_name, "_monthly_ntl.csv")))
  write_dta(ntl_monthly_df, file.path(ntl_dir, "aggregated", "monthly", paste0(roi_name, "_monthly_ntl.dta")))

}
