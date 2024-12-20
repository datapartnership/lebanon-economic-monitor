# Extract Nighttime Lights to Polygons

# Loop through different polygon types. For each polygon type
# 1. Make directories for where to save data
# 2. Aggregate annual data, both
# -- (a) VIIRS Black Marble [2012 - 2022]
# -- (b) DMSP [1992 - 2013]
# -- (c) Simulated DMSP (from VIIRS) [2014 - 2021]
# 3. Aggregate monthly data, VIIRS Black Marble only [2012 - present]

for(roi_name in rev(c("cadaster", "lbn_adm0", "lbn_adm1", "lbn_adm2", "lbn_adm3", "lbn_adm4"))){

  # Make Directories -------------------------------------------------------------
  dir.create(file.path(ntl_dir, "aggregated-to-polygons", roi_name))
  dir.create(file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-monthly"))
  dir.create(file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-annual"))

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
  roi_og_sf <- roi_sf

  # Aggregate annual -------------------------------------------------------------
  for(year in 1992:2023){

    ## Only process if file already hasn't been created
    OUT_FILE <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-annual", paste0("ntl_", year, ".Rds"))

    if(!file.exists(OUT_FILE)){

      if(year >= 2012){
        bm_r <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", paste0("VNP46A4_NearNadir_Composite_Snow_Free_qflag255_1_t",year,".tif")))

        if(year <= 2022){
          viirs_r_r <- raster(file.path(ntl_dir, "ntl-rasters", "viirs", "annual", paste0("LBN_viirs_mean_",year,".tif")))
        } else{
          viirs_r_r <- raster()
        }

      } else{
        bm_r     <- raster()
        viirs_r_r <- raster()
      }

      if(year %in% 2014:2022){
        viirs_c_r <- raster(file.path(ntl_dir, "ntl-rasters", "viirs", "annual", paste0("LBN_viirs_corrected_mean_",year,".tif")))
      } else{
        viirs_c_r <- raster()
      }

      if(year %in% 1992:2013){
        dmsp_r <- raster(file.path(ntl_dir, "ntl-rasters", "harmonized-dmsp-viirs", paste0("Harmonized_DN_NTL_",year,"_calDMSP.tif")))
      } else if(year %in% 2014:2021){
        dmsp_r <- raster(file.path(ntl_dir, "ntl-rasters", "harmonized-dmsp-viirs", paste0("Harmonized_DN_NTL_",year,"_simVIIRS.tif")))
      } else{
        dmsp_r <- raster()
      }

      roi_sf$ntl_bm_sum   <- exact_extract(bm_r, roi_sf, 'sum')
      roi_sf$ntl_bm_mean  <- exact_extract(bm_r, roi_sf, 'mean')
      roi_sf$ntl_bm_q5    <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.5))
      roi_sf$ntl_bm_q6    <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.6))
      roi_sf$ntl_bm_q7    <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.7))
      roi_sf$ntl_bm_q8    <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.8))
      roi_sf$ntl_bm_q9    <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.9))
      roi_sf$ntl_bm_q95   <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.95))
      roi_sf$ntl_bm_q99   <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.99))

      roi_sf$ntl_dmsp_sum  <- exact_extract(dmsp_r, roi_sf, 'sum')
      roi_sf$ntl_dmsp_mean  <- exact_extract(dmsp_r, roi_sf, 'mean')
      roi_sf$ntl_dmsp_q5    <- exact_extract(dmsp_r, roi_sf, 'quantile', quantiles = c(0.5))
      roi_sf$ntl_dmsp_q6    <- exact_extract(dmsp_r, roi_sf, 'quantile', quantiles = c(0.6))
      roi_sf$ntl_dmsp_q7    <- exact_extract(dmsp_r, roi_sf, 'quantile', quantiles = c(0.7))
      roi_sf$ntl_dmsp_q8    <- exact_extract(dmsp_r, roi_sf, 'quantile', quantiles = c(0.8))
      roi_sf$ntl_dmsp_q9    <- exact_extract(dmsp_r, roi_sf, 'quantile', quantiles = c(0.9))
      roi_sf$ntl_dmsp_q95   <- exact_extract(dmsp_r, roi_sf, 'quantile', quantiles = c(0.95))
      roi_sf$ntl_dmsp_q99   <- exact_extract(dmsp_r, roi_sf, 'quantile', quantiles = c(0.99))

      if(year >= 2022){
        roi_sf$ntl_dmsp_sum <- NA
        roi_sf$ntl_dmsp_mean <- NA
        roi_sf$ntl_dmsp_q5 <- NA
        roi_sf$ntl_dmsp_q6 <- NA
        roi_sf$ntl_dmsp_q7 <- NA
        roi_sf$ntl_dmsp_q8 <- NA
        roi_sf$ntl_dmsp_q9 <- NA
        roi_sf$ntl_dmsp_q95 <- NA
        roi_sf$ntl_dmsp_q99 <- NA
      }

      roi_sf$ntl_viirs_c_mean <- exact_extract(viirs_c_r, roi_sf, 'mean')
      roi_sf$ntl_viirs_r_mean <- exact_extract(viirs_r_r, roi_sf, 'mean')

      roi_sf$ntl_viirs_c_sum <- exact_extract(viirs_c_r, roi_sf, 'sum')
      roi_sf$ntl_viirs_r_sum <- exact_extract(viirs_r_r, roi_sf, 'sum')

      roi_sf$year <- year

      roi_df <- roi_sf
      roi_df$geometry <- NULL

      saveRDS(roi_df, OUT_FILE)
    }

  }

  #### Append all data
  ntl_annual_df <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-annual") %>%
    list.files(pattern = "*.Rds",
               full.names = T) %>%
    map_df(readRDS)

  #### Combine DMSP and VIIRS
  ntl_annual_df <- map_df(unique(ntl_annual_df$adm_id), function(id){

    ntl_annual_df[ntl_annual_df$adm_id %in% id,] %>%
      mutate(dmsp_scale_factor_add_2012base = ntl_bm_mean[year == 2012] - ntl_dmsp_mean[year == 2012],
             dmsp_scale_factor_add_2013base = ntl_bm_mean[year == 2013] - ntl_dmsp_mean[year == 2013],
             dmsp_scale_factor_div_2012base = ntl_bm_mean[year == 2012] / ntl_dmsp_mean[year == 2012],
             dmsp_scale_factor_div_2013base = ntl_bm_mean[year == 2013] / ntl_dmsp_mean[year == 2013]) %>%
      mutate(ntl_dmsp_mean_scale_add_2012base = ntl_dmsp_mean + dmsp_scale_factor_add_2012base,
             ntl_dmsp_mean_scale_add_2013base = ntl_dmsp_mean + dmsp_scale_factor_add_2013base,

             ntl_dmsp_mean_scale_div_2012base = ntl_dmsp_mean * dmsp_scale_factor_div_2012base,
             ntl_dmsp_mean_scale_div_2013base = ntl_dmsp_mean * dmsp_scale_factor_div_2013base) %>%

      mutate(ntl_mean_add_2012base = case_when(
        year < 2012 ~ ntl_dmsp_mean_scale_add_2012base,
        year >= 2012 ~ ntl_bm_mean
      )) %>%
      mutate(ntl_mean_add_2013base = case_when(
        year < 2013 ~ ntl_dmsp_mean_scale_add_2013base,
        year >= 2013 ~ ntl_bm_mean
      )) %>%
      mutate(ntl_mean_div_2012base = case_when(
        year < 2012 ~ ntl_dmsp_mean_scale_div_2012base,
        year >= 2012 ~ ntl_bm_mean
      )) %>%
      mutate(ntl_mean_div_2013base = case_when(
        year < 2013 ~ ntl_dmsp_mean_scale_div_2013base,
        year >= 2013 ~ ntl_bm_mean
      )) %>%

      dplyr::select(-c(dmsp_scale_factor_add_2012base,
                       dmsp_scale_factor_add_2013base,
                       dmsp_scale_factor_div_2012base,
                       dmsp_scale_factor_div_2013base,

                       ntl_dmsp_mean_scale_add_2012base,
                       ntl_dmsp_mean_scale_add_2013base,
                       ntl_dmsp_mean_scale_div_2012base,
                       ntl_dmsp_mean_scale_div_2013base))

  })

  ntl_annual_df$ntl_bm_mean[ntl_annual_df$ntl_bm_mean < 0] <- 0

  saveRDS(ntl_annual_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_annual_ntl.Rds")))
  write_csv(ntl_annual_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_annual_ntl.csv")))
  write_dta(ntl_annual_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_annual_ntl.dta")))

  # Aggregate monthly ------------------------------------------------------------
  roi_sf <- roi_og_sf

  monthly_rasters <- file.path(ntl_dir, "ntl-rasters", "blackmarble", "monthly") %>%
    list.files(pattern = "*.tif") %>%
    rev()

  for(r_month_i in monthly_rasters){

    ## Only process if file already hasn't been created
    month_i <- r_month_i %>%
      str_replace_all(".*_t", "") %>%
      str_replace_all(".tif", "")


    OUT_FILE <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-monthly", paste0("ntl_", month_i, ".Rds"))

    if(!file.exists(OUT_FILE)){

      bm_r <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "monthly", r_month_i))

      #roi_sf$ntl_bm_mean   <- exact_extract(bm_r, roi_sf, 'mean')

      roi_sf$ntl_bm_sum   <- exact_extract(bm_r, roi_sf, 'sum')
      roi_sf$ntl_bm_mean  <- exact_extract(bm_r, roi_sf, 'mean')
      roi_sf$ntl_bm_q5    <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.5))
      roi_sf$ntl_bm_q6    <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.6))
      roi_sf$ntl_bm_q7    <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.7))
      roi_sf$ntl_bm_q8    <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.8))
      roi_sf$ntl_bm_q9    <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.9))
      roi_sf$ntl_bm_q95   <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.95))
      roi_sf$ntl_bm_q99   <- exact_extract(bm_r, roi_sf, 'quantile', quantiles = c(0.99))

      roi_sf$date <- month_i %>%
        str_replace_all("_", "-") %>%
        paste0("-01") %>%
        ymd()

      roi_df <- roi_sf
      roi_df$geometry <- NULL

      saveRDS(roi_df, OUT_FILE)
    }
  }

  ntl_monthly_df <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-monthly") %>%
    list.files(pattern = "*.Rds",
               full.names = T) %>%
    map_df(readRDS)

  saveRDS(ntl_monthly_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_monthly_ntl.Rds")))
  write_csv(ntl_monthly_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_monthly_ntl.csv")))
  write_dta(ntl_monthly_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_monthly_ntl.dta")))

}
