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

r_diff_10[] <- (r12[] - r10[]) / r10[] * 100
r_diff_11[] <- (r12[] - r11[]) / r11[] * 100

r_diff_10[][r_diff_10[] >  100] <- 100
r_diff_10[][r_diff_10[] < -100] <- -100

r_diff_11[][r_diff_11[] >  100] <- 100
r_diff_11[][r_diff_11[] < -100] <- -100

r10_df <- rasterToPoints(r_diff_10, spatial = TRUE) %>% as.data.frame()
names(r10_df) <- c("value", "x", "y")

r11_df <- rasterToPoints(r_diff_11, spatial = TRUE) %>% as.data.frame()
names(r11_df) <- c("value", "x", "y")

# Map --------------------------------------------------------------------------
## Plot
p <- ggplot() +
  geom_raster(data = r10_df,
              aes(x = x, y = y,
                  fill = value),
              alpha = 0.8) +
  geom_sf(data = roi_sf,
          fill = NA,
          color = "black") +
  labs(fill = "% Change",
       title = "Percent Change\nfrom 2010 to 2012") +
  theme_void() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 10)) +
  scale_fill_gradient2(low = "firebrick3",
                       mid = "white",
                       high = "green3",
                       breaks = c(-100,-50,0,50,100),
                       labels = c("< -100", "-50", "0", "50", "> 100"))

ggsave(p,
       filename = file.path(figures_dir, "ntl_change_2010_2012_pc.png"),
       height = 2.25, width = 6)

# Map --------------------------------------------------------------------------
## Plot
p <- ggplot() +
  geom_raster(data = r11_df,
              aes(x = x, y = y,
                  fill = value),
              alpha = 0.8) +
  geom_sf(data = roi_sf,
          fill = NA,
          color = "black") +
  labs(fill = "% Change",
       title = "Percent Change\nfrom 2011 to 2012") +
  theme_void() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 10)) +
  scale_fill_gradient2(low = "firebrick3",
                       mid = "white",
                       high = "green3",
                       breaks = c(-100,-50,0,50,100),
                       labels = c("< -100", "-50", "0", "50", "> 100"))

ggsave(p,
       filename = file.path(figures_dir, "ntl_change_2011_2012_pc.png"),
       height = 2.25, width = 6)
