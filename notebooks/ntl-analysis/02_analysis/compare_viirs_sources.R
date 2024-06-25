# Compare VIIRS Sources

ntl0_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "lbn_adm0",
                             paste0("lbn_adm0", "_annual_ntl.Rds")))

ntl0_df %>%
  dplyr::mutate(ntl_bm_mean = ntl_bm_mean / 10) %>%
  dplyr::select(admin0RefN, year, ntl_viirs_c_mean, ntl_viirs_r_mean, ntl_bm_mean) %>%
  pivot_longer(-c(admin0RefN, year)) %>%
  dplyr::filter(year >= 2012) %>%
  dplyr::mutate(name = case_when(
    name == "ntl_viirs_c_mean" ~ "VIIRS: Corrected",
    name == "ntl_viirs_r_mean" ~ "VIIRS: Raw",
    name == "ntl_bm_mean" ~ "VIIRS: BlackMarble"
  )) %>%
  ggplot() +
  geom_line(aes(x = year, y = value, color = name),
            linewidth = 1) +
  scale_x_continuous(breaks = seq(2012,2023,2),
                     labels = seq(2012,2023,2)) +
  labs(title = "VIIRS Nighttime Lights: Different Sources",
       color = "",
       x = "Year",
       y = NULL) +
  theme_classic2()

ggsave(filename = file.path(figures_dir, "viirs_diff_sources.png"),
       height = 3, width = 6)
