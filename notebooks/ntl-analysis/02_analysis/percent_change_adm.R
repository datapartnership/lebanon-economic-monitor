# Percent Change Maps

roi_name <- "lbn_adm2"

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

ggsave(p,
       filename = file.path(figures_dir, paste0("pc_map_",roi_name,".png")),
       height = 5, width = 3.5)