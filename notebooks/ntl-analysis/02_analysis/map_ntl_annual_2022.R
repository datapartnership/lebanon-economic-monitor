# Nighttime Lights Map: 2022

# Load data --------------------------------------------------------------------
r_mean  <- raster(file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual", "VNP46A4_t2022.tif"))
roi_sp <- read_sf(file.path(admin_bnd_dir, "lbn_adm_cdr_20200810", "lbn_admbnda_adm0_cdr_20200810.shp")) %>%
  as("Spatial")

# Prep data --------------------------------------------------------------------
r_mean <- r_mean %>% crop(roi_sp) %>% mask(roi_sp) 

r_mean_df <- rasterToPoints(r_mean, spatial = TRUE) %>% as.data.frame()
names(r_mean_df) <- c("value", "x", "y")

## Transform NTL
r_mean_df$value_adj <- log(r_mean_df$value+1)

r_mean_df$value_adj[r_mean_df$value_adj <= 0.5] <- 0

# Map --------------------------------------------------------------------------
p <- ggplot() +
  geom_raster(data = r_mean_df, 
              aes(x = x, y = y, 
                  fill = value_adj)) +
  scale_fill_gradient2(low = "black",
                       mid = "yellow",
                       high = "red",
                       midpoint = 5) +
  labs(title = "NTL: 2022") +
  coord_quickmap() + 
  theme_void() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5),
        legend.position = "none")

ggsave(p,
       filename = file.path(figures_dir, "ntl_2022.png"),
       height = 5, width = 3.5,
       dpi = 1000)
