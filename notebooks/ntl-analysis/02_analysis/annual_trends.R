# Annual Trends in Nighttime Lights

# WDI GDP Data -----------------------------------------------------------------
gdp_df <- WDI(country = "LBN",
          indicator = c("NY.GDP.MKTP.KD", "NY.GDP.PCAP.KD"),
          start = 1992,
          end = 2022,
          extra = TRUE)

gdp_long_df <- gdp_df %>%
  dplyr::select(year, NY.GDP.MKTP.KD, NY.GDP.PCAP.KD) %>%
  dplyr::rename("GDP" = "NY.GDP.MKTP.KD",
                "GDP, Per Capita" = "NY.GDP.PCAP.KD") %>%
  pivot_longer(cols = -year)

# ADM 0 ------------------------------------------------------------------------
ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "lbn_adm0", 
                            paste0("lbn_adm0", "_annual_ntl.Rds")))

ntl_df <- ntl_df %>%
  dplyr::mutate(value = ntl_mean_add_2012base,
                name = "Nighttime Lights") %>%
  dplyr::select(year, name, value)

ntl_gdp_df <- bind_rows(ntl_df, gdp_long_df)

ntl_gdp_df %>%
  filter(year >= 1995) %>%
  ggplot(aes(x = year, 
             y = value)) +
  geom_line(color = "black",
            size = 1) +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Annual Nighttime Lights and GDP") +
  scale_x_continuous(breaks = seq(1995, 2022, 4)) +
  theme_classic2() +
  facet_wrap(~name, scales = "free_y", ncol = 1) +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold"))

ggsave(filename = file.path(figures_dir, "annual_trends_adm0.png"),
       height = 6, width = 4.5)

# ADM 1 ------------------------------------------------------------------------
ntl_df <- readRDS(file.path(ntl_dir, "aggregated-to-polygons", "lbn_adm1", 
                            paste0("lbn_adm1", "_annual_ntl.Rds")))

ntl_df %>%
  filter(year >= 1995) %>%
  ggplot() +
  geom_col(aes(x = year, 
               y = ntl_mean_add_2012base),
           fill = "gray30") +
  labs(x = NULL,
       y = "Nighttime Lights",
       title = "Annual Nighttime Lights: Governorate Level") +
  scale_x_continuous(breaks = seq(1995, 2022, 8)) +
  theme_classic2() +
  theme(strip.background = element_blank(),
        strip.text = element_text(face = "bold")) +
  facet_wrap(~admin1Name,
             scales = "free_y")

ggsave(filename = file.path(figures_dir, "annual_trends_adm1.png"),
       height = 4, width = 6)
