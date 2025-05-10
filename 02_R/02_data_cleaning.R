library(tidyverse)
library(zoo)
library(janitor)
library(here)

# Read dataset
df <- read_csv(here::here("01_data", "raw", "merged_data.csv")) %>% 
  clean_names()

# Remove unnecessary variables
df <- df %>%
  select(-status, -capital, -lending, -lastupdated)

# Re-order
df <- df %>%
  select(country, iso2c, iso3c, year, region, income,
         longitude, latitude,
         fertility, edu_upper, edu_lower, edu_tertiary,
         gdp, urban, female_labor, contraceptive,
         eys_f, gii, mmr, pr_f)

# Generate variables
df <- df %>%
  mutate(log_gdp = if_else(gdp > 0, log(gdp), NA_real_))

# Imputation
df <- df %>%
  arrange(iso3c, year) %>%
  group_by(iso3c) %>%
  mutate(across(
    c(fertility, edu_upper, edu_lower, edu_tertiary,
      gdp, log_gdp, urban, female_labor, contraceptive,
      eys_f, gii, mmr, pr_f),
    ~ na.approx(., rule = 2, na.rm = FALSE)
  )) %>%
  ungroup()

df <- df %>%
  mutate(
    income = factor(income, levels = c("Low income", "Lower middle income", "Upper middle income", "High income"))
  )

write_csv(df, here::here("01_data", "clean", "merged_clean.csv"))