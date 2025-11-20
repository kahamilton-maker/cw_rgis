if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               ggeffects,
               sf,
               terra,
               tidyterra,
               exactextractr,
               mapview,
               here)

(df_finsync <- read_csv(here("data/data_finsync_nc.csv")))

df_msa <- df_finsync %>% 
  mutate(presence = 1) %>% 
  pivot_wider(id_cols = c(site_id, lon, lat),
              names_from = latin,
              values_from = presence,
              values_fill = 0) %>% 
  select(site_id,
         lon,
         lat,
         "Micropterus salmoides") %>% 
  rename(y = "Micropterus salmoides" )

sf_msa <- df_msa %>% 
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)

spr_tmp_nc <- rast(here("data/spr_tmp_nc.tif"))

sf_msa_tmp <- extract(x = spr_tmp_nc,
                       y = sf_msa,
                       bind = TRUE) %>% 
  st_as_sf()

ggplot() +
  geom_spatraster(data = spr_tmp_nc) +
  geom_sf(data = sf_msa_tmp,) +
  scale_fill_viridis_c()

df_msa_tmp <- as_tibble(sf_msa_tmp)

df_msa_tmp %>% 
  ggplot(aes(x = temperature,
             y = y)) +
  geom_point() +
  theme_bw()

b <- glm(y ~ temperature,
         data = df_msa_tmp,
         family = "binomial")
summary(b)

msa_pred <- ggpredict(b,
          terms = "temperature [all]")

ggplot() +
  geom_point(data = df_msa_tmp,
             aes(x = temperature,
                 y = y)) +
  geom_line(data = msa_pred,
            aes(x = x,
                y = predicted)) +
  geom_ribbon(data = msa_pred,
              aes(x = x,
                  ymin = conf.low,
                  ymax = conf.high),
              fill = "blue",
              alpha = 0.2) +
labs(x = "Air Temperature",
     y = "Probability of occurrence") +
  theme_bw()
