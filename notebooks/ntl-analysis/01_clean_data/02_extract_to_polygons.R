# Extract Nighttime Lights to Polygons

for(roi_name in c("lbn_adm0", "lbn_adm1", "lbn_adm2", "lbn_adm3", "lbn_adm4")){
  
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
  
  roi_sf$adm_id <- 1:nrow(roi_sf)
  
  # Aggregate annual -------------------------------------------------------------
  for(year in 1992:2022){
    
    ## Only process if file already hasn't been created
    OUT_FILE <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-annual", paste0("ntl_", year, ".Rds"))
    
    if(!file.exists(OUT_FILE)){
      
      if(year >= 2012){
        bm_r <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", paste0("VNP46A4_t",year,".tif")))
      } else{
        bm_r <- raster()
      }
      
      if(year %in% 1992:2013){
        dmsp_r <- raster(file.path(ntl_dir, "ntl-rasters", "harmonized-dmsp-viirs", paste0("Harmonized_DN_NTL_",year,"_calDMSP.tif")))
      } else if(year %in% 2014:2021){
        dmsp_r <- raster(file.path(ntl_dir, "ntl-rasters", "harmonized-dmsp-viirs", paste0("Harmonized_DN_NTL_",year,"_simVIIRS.tif")))
      } else{
        dmsp_r <- raster()
      }
      
      roi_sf$ntl_bm_mean   <- exact_extract(bm_r, roi_sf, 'mean')
      roi_sf$ntl_dmsp_mean <- exact_extract(dmsp_r, roi_sf, 'mean')
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
      mutate(dmsp_scale_factor = ntl_bm_mean[year == 2012] - ntl_dmsp_mean[year == 2012]) %>%
      mutate(ntl_dmsp_mean_scale = ntl_dmsp_mean + dmsp_scale_factor) %>%
      mutate(ntl_mean = case_when(
        year < 2012 ~ ntl_dmsp_mean_scale,
        year >= 2012 ~ ntl_bm_mean
      ))
    
  })
  
  ntl_annual_df$ntl_bm_mean[ntl_annual_df$ntl_bm_mean < 0] <- 0
  
  saveRDS(ntl_annual_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_annual_ntl.Rds")))
  write_csv(ntl_annual_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_annual_ntl.csv")))
  
  # Aggregate monthly ------------------------------------------------------------
  monthly_rasters <- file.path(ntl_dir, "ntl-rasters", "blackmarble", "monthly") %>%
    list.files(pattern = "*.tif")
  
  for(r_month_i in monthly_rasters){
    
    ## Only process if file already hasn't been created
    month_i <- r_month_i %>%
      str_replace_all(".*_t", "") %>%
      str_replace_all(".tif", "")
    
    OUT_FILE <- file.path(ntl_dir, "aggregated-to-polygons", roi_name, "individual-monthly", paste0("ntl_", month_i, ".Rds"))
    
    if(!file.exists(OUT_FILE)){
      
      bm_r <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "monthly", r_month_i))
      
      roi_sf$ntl_bm_mean   <- exact_extract(bm_r, roi_sf, 'mean')
      
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
  
  saveRDS(ntl_monthly_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "monthly_ntl.Rds")))
  write_csv(ntl_monthly_df, file.path(ntl_dir, "aggregated-to-polygons", roi_name, paste0(roi_name, "_monthly_ntl.csv")))
  
}
