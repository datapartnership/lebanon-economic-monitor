# VIIRS and DMSP

ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "lbn_adm0", 
                            paste0("lbn_adm0", "_annual_ntl.Rds")))

ntl_long_df <- ntl_df %>%
  dplyr::select(year, ntl_mean_add_2012base, ntl_dmsp_mean, ntl_bm_mean) %>%
  pivot_longer(cols = -year) %>%
  filter(year >= 1992) %>%
  mutate(name_clean = case_when(
    name == "ntl_mean_add_2012base" ~ "NTL: Harmonized",
    name == "ntl_dmsp_mean" ~ "NTL: DMSP",
    name == "ntl_bm_mean" ~ "NTL: VIIRS"
  ))
ntl_long_df$value[(ntl_long_df$name == "ntl_dmsp_mean") & (ntl_long_df$year >= 2014)] <- NA

ntl_long_df %>%
  ggplot() +
  geom_line(aes(x = year, 
               y = value,
               color = name_clean,
               size = name_clean)) +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Annual Nighttime Lights: Country Level",
       color = NULL,
       size = NULL) +
  scale_x_continuous(breaks = seq(1992, 2022, 4)) +
  scale_y_continuous(limits = c(0, 25)) +
  scale_size_manual(values = c(2, 2, 0.5)) +
  scale_color_manual(values = c("dodgerblue", "orange", "black")) +
  theme_classic2() 

ggsave(filename = file.path(figures_dir, "viirs_dmsp_adm0.png"),
       height = 2.25, width = 6)
