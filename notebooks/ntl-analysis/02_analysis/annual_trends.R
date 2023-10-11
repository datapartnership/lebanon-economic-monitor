# Annual Trends in Nighttime Lights

# ADM 0 ------------------------------------------------------------------------
ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "lbn_adm0", 
                            paste0("lbn_adm0", "_annual_ntl.Rds")))

# ntl_df %>%
#   ggplot(aes(x = year,
#              y = ntl_dmsp_mean)) + 
#   geom_col() +
#   scale_x_continuous(breaks = seq(1992, 2022, 4)) 

ntl_df %>%
  filter(year >= 1992) %>%
  ggplot() +
  geom_col(aes(x = year, 
               y = ntl_mean_add_2012base),
           fill = "gray30") +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Annual Nighttime Lights: Country Level") +
  scale_x_continuous(breaks = seq(1992, 2022, 4)) +
  theme_classic2()

ggsave(filename = file.path(figures_dir, "annual_trends_adm0.png"),
       height = 2, width = 4.5)

# ADM 1 ------------------------------------------------------------------------
ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "lbn_adm1", 
                            paste0("lbn_adm1", "_annual_ntl.Rds")))

ntl_df %>%
  filter(year >= 1992) %>%
  ggplot() +
  geom_col(aes(x = year, 
               y = ntl_mean_add_2012base),
           fill = "gray30") +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Annual Nighttime Lights: Governorate Level") +
  scale_x_continuous(breaks = seq(1992, 2022, 4)) +
  theme_classic2() +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold")) +
  facet_wrap(~admin1Name,
             scales = "free_y")

ggsave(filename = file.path(figures_dir, "annual_trends_adm1.png"),
       height = 4, width = 6)
