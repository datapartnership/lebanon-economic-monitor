# Maps: Percent Change
# * 2010 to 2012
# * 2011 to 2012

# Load data --------------------------------------------------------------------
roi_sf <- read_sf(file.path(admin_bnd_dir, "lbn_adm_cdr_20200810", "lbn_admbnda_adm0_cdr_20200810.shp"))

r10 <- raster(file.path(ntl_dir, "ntl-rasters", "harmonized-dmsp-viirs", "Harmonized_DN_NTL_2010_calDMSP.tif"))
r11 <- raster(file.path(ntl_dir, "ntl-rasters", "harmonized-dmsp-viirs", "Harmonized_DN_NTL_2011_calDMSP.tif"))
r12 <- raster(file.path(ntl_dir, "ntl-rasters", "harmonized-dmsp-viirs", "Harmonized_DN_NTL_2012_calDMSP.tif"))

r10 <- r10 %>% crop(roi_sf) %>% mask(roi_sf)
r11 <- r11 %>% crop(roi_sf) %>% mask(roi_sf)
r12 <- r12 %>% crop(roi_sf) %>% mask(roi_sf)

r12 <- resample(r12, r11)

r_diff_10  <- r10
r_diff_11  <- r11

r_diff_10[] <- r12[] - r10[]
r_diff_11[] <- r12[] - r11[]

THRESH <- 3

r10_bin <- r10
r10_bin[] <- NA
r10_bin[r10[] > THRESH] <- 0
r10_bin[r_diff_10[] > THRESH]  <- 1
r10_bin[r_diff_10[] < -THRESH] <- -1

r11_bin <- r11
r11_bin[] <- NA
r11_bin[r11[] > THRESH] <- 0
r11_bin[r_diff_10[] > THRESH]  <- 1
r11_bin[r_diff_10[] < -THRESH] <- -1

r10_df <- rasterToPoints(r10_bin, spatial = TRUE) %>% as.data.frame()
names(r10_df) <- c("value", "x", "y")

r11_df <- rasterToPoints(r11_bin, spatial = TRUE) %>% as.data.frame()
names(r11_df) <- c("value", "x", "y")

# Map --------------------------------------------------------------------------
## Plot
p <- ggplot() +
  geom_raster(data = r10_df[r10_df$value == 0,],
              aes(x = x, y = y,
                  fill = "No Change"),
              alpha = 0.8) +
  geom_raster(data = r10_df[r10_df$value == 1,],
              aes(x = x, y = y,
                  fill = "New Lights"),
              alpha = 0.8) +
  geom_raster(data = r10_df[r10_df$value == -1,],
              aes(x = x, y = y,
                  fill = "Lights Lost"),
              alpha = 0.8) +
  geom_sf(data = roi_sf,
          fill = NA,
          color = "black") +
  labs(fill = NULL,
       title = "2010 to 2012") +
  theme_void() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 10)) +
  scale_fill_manual(values = c("firebrick3", "green3", "dodgerblue"))

ggsave(p,
       filename = file.path(figures_dir, "ntl_change_2010_2012_bin.png"),
       height = 2.25, width = 6)

# Map --------------------------------------------------------------------------
## Plot
p <- ggplot() +
  geom_raster(data = r11_df[r11_df$value == 0,],
              aes(x = x, y = y,
                  fill = "No Change"),
              alpha = 0.8) +
  geom_raster(data = r11_df[r11_df$value == 1,],
              aes(x = x, y = y,
                  fill = "New Lights"),
              alpha = 0.8) +
  geom_raster(data = r11_df[r11_df$value == -1,],
              aes(x = x, y = y,
                  fill = "Lights Lost"),
              alpha = 0.8) +
  geom_sf(data = roi_sf,
          fill = NA,
          color = "black") +
  labs(fill = NULL,
       title = "2011 to 2012") +
  theme_void() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 10)) +
  scale_fill_manual(values = c("firebrick3", "green3", "dodgerblue"))

ggsave(p,
       filename = file.path(figures_dir, "ntl_change_2011_2012_bin.png"),
       height = 2.25, width = 6)
