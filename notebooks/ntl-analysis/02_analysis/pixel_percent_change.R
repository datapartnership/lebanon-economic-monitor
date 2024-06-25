# Pixel Maps Change

# Load data --------------------------------------------------------------------
roi_sf <- read_sf(file.path(admin_bnd_dir, "lbn_adm_cdr_20200810", "lbn_admbnda_adm0_cdr_20200810.shp"))

r12 <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", 
                        "VNP46A4_NearNadir_Composite_Snow_Free_qflag255_1_t2012.tif")) 
r22 <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", 
                        "VNP46A4_NearNadir_Composite_Snow_Free_qflag255_1_t2023.tif"))

r12 <- r12 %>% crop(roi_sf) %>% mask(roi_sf)
r22 <- r22 %>% crop(roi_sf) %>% mask(roi_sf)

r22_diff <- r22
r22_diff[] <- ((r22[] - r12[]) / r12[]) * 100

r22_diff[][r22_diff[] >  100] <- 100
r22_diff[][r22_diff[] < -100] <- -100

r_df <- rasterToPoints(r22_diff, spatial = TRUE) %>% as.data.frame()
names(r_df) <- c("value", "x", "y")

# Map --------------------------------------------------------------------------
## Plot
p <- ggplot() +
  geom_raster(data = r_df,
              aes(x = x, y = y,
                  fill = value),
              alpha = 0.8) +
  geom_sf(data = roi_sf,
          fill = NA,
          color = "black") +
  labs(fill = "% Change",
       title = "Percent Change\nfrom 2012 to 2023") +
  theme_void() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 10)) +
  scale_fill_gradient2(low = "firebrick3",
                       mid = "white",
                       high = "green3",
                       breaks = c(-100,-50,0,50,100),
                       labels = c("< -100", "-50", "0", "50", "> 100"))

ggsave(p,
       filename = file.path(figures_dir, "ntl_change_2012_2022_percent.png"),
       height = 2.25, width = 6)
