# Percent Change Maps

for(roi_name in c("lbn_adm1", "lbn_adm2", "lbn_adm3", "lbn_adm4")){
  
  # Load data --------------------------------------------------------------------
  ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", roi_name, 
                              paste0(roi_name, "_annual_ntl.Rds")))
  
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
  
  # Prep data -------------------------------------------------------------------
  ntl_pc_df <- ntl_df %>%
    dplyr::filter(year %in% c(2019, 2022)) %>%
    dplyr::select(year, adm_id, ntl_bm_mean) %>%
    mutate(year = paste0("yr", year)) %>%
    pivot_wider(id_cols = adm_id, names_from = year, values_from = "ntl_bm_mean") %>%
    mutate(pc = (yr2022 - yr2019) / yr2019 * 100)
  
  roi_sf <- roi_sf %>%
    left_join(ntl_pc_df, by = "adm_id")
  
  roi_sf$pc[roi_sf$pc > 0] <- NA
  #roi_sf$pc[is.na(roi_sf$pc)] <- 0
  
  # Map --------------------------------------------------------------------------
  city_df <- data.frame(lat = 33.898316, lon = 35.505696, name = "Beirut")
  
  p <- ggplot() +
    geom_sf(data = roi_sf, 
            aes(fill = pc,
                color = pc)) +
    labs(fill = "% Change\nin NTL",
         color = "% Change\nin NTL") +
    coord_sf() +
    theme_void() +
    scale_fill_distiller(palette = "YlOrRd", direction = -1) +
    scale_color_distiller(palette = "YlOrRd", direction = -1)
  
  if(roi_name != "lbn_adm4"){
    p <- p +
      geom_point(data = city_df,
                 aes(x = lon, y = lat)) +
      geom_text_repel(data = city_df,
                      aes(x = lon, y = lat, label = name),
                      seed = 42) 
  }
  
  ggsave(p,
         filename = file.path(figures_dir, paste0("pc_map_",roi_name,".png")),
         height = 4, width = 3.5)
  
  # Table ----------------------------------------------------------------------
  if(roi_name == "lbn_adm1") roi_sf <- roi_sf %>% dplyr::mutate(name = admin1Name)
  if(roi_name == "lbn_adm2") roi_sf <- roi_sf %>% dplyr::mutate(name = admin2Name)
  if(roi_name == "lbn_adm3") roi_sf <- roi_sf %>% dplyr::mutate(name = admin3Name)
  if(roi_name == "lbn_adm4") roi_sf <- roi_sf %>% dplyr::mutate(name = Sector)
  
  roi_sf %>%
    st_drop_geometry() %>%
    dplyr::select(name, yr2019, yr2022, pc) %>%
    dplyr::filter(pc < 0) %>%
    arrange(-yr2019) %>%
    head(30) %>%
    dplyr::mutate(yr2019 = round(yr2019, 2),
                  yr2022 = round(yr2022, 2),
                  pc = round(pc,1)) %>%
    dplyr::rename("Name" = name,
                  "NTL: 2019" = yr2019,
                  "NTL: 2022" = yr2022,
                  "Percent Change" = pc) %>%
    gt() %>%
    #gt_hulk_col_numeric(`NTL: 2019`, trim = TRUE) %>%
    #gt_hulk_col_numeric(`NTL: 2022`, trim = TRUE)  %>%
    gt_color_rows(`Percent Change`, 
                  palette = "Reds",
                  reverse = T) %>%
    gtsave(filename = file.path(figures_dir, paste0("pc_table_",roi_name,".png")))
  
}
