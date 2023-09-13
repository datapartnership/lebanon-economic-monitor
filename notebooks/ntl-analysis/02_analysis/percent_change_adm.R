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
    dplyr::filter(year %in% c(2019, 2020, 2021, 2022)) %>%
    dplyr::select(year, adm_id, ntl_bm_mean) %>%
    mutate(year = paste0("yr", year)) %>%
    pivot_wider(id_cols = adm_id, names_from = year, values_from = "ntl_bm_mean") %>%
    mutate(pc19 = (yr2022 - yr2019) / yr2019 * 100,
           pc20 = (yr2022 - yr2020) / yr2020 * 100,
           pc21 = (yr2022 - yr2021) / yr2021 * 100)
  
  roi_sf <- roi_sf %>%
    left_join(ntl_pc_df, by = "adm_id")
  
  roi_sf$pc19[roi_sf$pc19 > 0] <- NA
  roi_sf$pc19[is.na(roi_sf$pc19)] <- 0
  
  roi_sf$pc20[roi_sf$pc20 > 0] <- NA
  roi_sf$pc20[is.na(roi_sf$pc20)] <- 0
  
  roi_sf$pc21[roi_sf$pc21 > 0] <- NA
  roi_sf$pc21[is.na(roi_sf$pc21)] <- 0
  
  # Map --------------------------------------------------------------------------
  city_df <- data.frame(lat = 33.898316, lon = 35.505696, name = "Beirut")
  
  roi_long_sf <- roi_sf %>%
    dplyr::select(adm_id, pc19, pc20, pc21) %>%
    pivot_longer(cols = -c(adm_id, geometry)) %>%
    dplyr::mutate(name_clean = case_when(
      name == "pc19" ~ "2019 to 2022",
      name == "pc20" ~ "2020 to 2022",
      name == "pc21" ~ "2021 to 2022"
    )) 
  
  p <- ggplot() +
    geom_sf(data = roi_long_sf,
            aes(fill = value,
                color = value)) +
    labs(fill = "% Change\nin NTL",
         color = "% Change\nin NTL") +
    coord_sf() +
    theme_void() +
    scale_fill_distiller(palette = "YlOrRd", direction = -1) +
    scale_color_distiller(palette = "YlOrRd", direction = -1) +
    facet_wrap(~name_clean)
  
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
         height = 4, width = 5)
  
  # Table ----------------------------------------------------------------------
  if(roi_name == "lbn_adm1") roi_sf <- roi_sf %>% dplyr::mutate(name = admin1Name)
  if(roi_name == "lbn_adm2") roi_sf <- roi_sf %>% dplyr::mutate(name = admin2Name)
  if(roi_name == "lbn_adm3") roi_sf <- roi_sf %>% dplyr::mutate(name = admin3Name)
  if(roi_name == "lbn_adm4") roi_sf <- roi_sf %>% dplyr::mutate(name = Sector)
  
  roi_sf$name[roi_sf$name == "Trablous El-Haddadine, El-Hadid, El-Mharta"] <- "Trablous El-Haddadine"
  
  
  roi_sf %>%
    st_drop_geometry() %>%
    dplyr::select(name, yr2019, yr2020, yr2021, yr2022, pc19, pc20, pc21) %>%
    #dplyr::filter(pc < 0) %>%
    arrange(-yr2019) %>%
    head(30) %>%
    dplyr::mutate(yr2019 = round(yr2019, 2),
                  yr2020 = round(yr2020, 2),
                  yr2021 = round(yr2021, 2),
                  yr2022 = round(yr2022, 2),
                  pc19 = round(pc19,1),
                  pc20 = round(pc20,1),
                  pc21 = round(pc21,1)) %>%
    dplyr::rename("Name" = name,
                  "NTL: 2019" = yr2019,
                  "NTL: 2020" = yr2020,
                  "NTL: 2021" = yr2021,
                  "NTL: 2022" = yr2022,
                  "PC: 19 to 22" = pc19,
                  "PC: 20 to 22" = pc20,
                  "PC: 21 to 22" = pc21) %>%
    gt() %>%
    #gt_hulk_col_numeric(`NTL: 2019`, trim = TRUE) %>%
    #gt_hulk_col_numeric(`NTL: 2022`, trim = TRUE)  %>%
    gt_color_rows(c(`PC: 19 to 22`,
                    `PC: 20 to 22`,
                    `PC: 21 to 22`), 
                  palette = "Reds",
                  reverse = T) %>%
    gtsave(filename = file.path(figures_dir, paste0("pc_table_",roi_name,".png")))
  
}
