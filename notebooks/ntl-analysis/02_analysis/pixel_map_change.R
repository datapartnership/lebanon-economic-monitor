# Pixel Maps Change

# Load data --------------------------------------------------------------------
roi_sf <- read_sf(file.path(admin_bnd_dir, "lbn_adm_cdr_20200810", "lbn_admbnda_adm0_cdr_20200810.shp"))

r12 <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", "VNP46A4_t2012.tif")) 
r22 <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", "VNP46A4_t2022.tif"))

r12 <- r12 %>% crop(roi_sf) %>% mask(roi_sf)
r22 <- r22 %>% crop(roi_sf) %>% mask(roi_sf)

r22_diff <- r22
r22_diff[] <- r22[] - r12[]

THRESH <- 3

r22_bin <- r22
r22_bin[] <- NA
r22_bin[r12[] > THRESH] <- 0
r22_bin[r22_diff[] > THRESH]  <- 1
r22_bin[r22_diff[] < -THRESH] <- -1

r_df <- rasterToPoints(r22_bin, spatial = TRUE) %>% as.data.frame()
names(r_df) <- c("value", "x", "y")


# Map --------------------------------------------------------------------------
## Plot
p <- ggplot() +
  geom_raster(data = r_df[r_df$value == 0,], 
              aes(x = x, y = y,
                  fill = "No Change"),
              alpha = 0.8) +
  geom_raster(data = r_df[r_df$value == 1,], 
              aes(x = x, y = y,
                  fill = "New Lights"),
              alpha = 0.8) +
  geom_raster(data = r_df[r_df$value == -1,], 
              aes(x = x, y = y,
                  fill = "Lights Lost"),
              alpha = 0.8) +
  geom_sf(data = roi_sf,
          fill = NA,
          color = "black") +
  labs(fill = NULL,
       title = "2012 to 2022") +
  theme_void() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 10)) +
  scale_fill_manual(values = c("firebrick3", "green3", "dodgerblue")) 

ggsave(p,
       filename = file.path(figures_dir, "ntl_change_2012_2022_bin.png"),
       height = 2.25, width = 6)
