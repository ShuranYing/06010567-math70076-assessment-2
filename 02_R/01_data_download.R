library(WDI)
library(tidyverse)
library(readxl)
library(here)

indicators <- c(
  fertility = "SP.DYN.TFRT.IN",
  edu_upper = "SE.SEC.CUAT.UP.FE.ZS",
  edu_lower = "SE.SEC.CUAT.LO.FE.ZS",
  edu_tertiary = "SE.TER.CUAT.BA.FE.ZS",
  gdp = "NY.GDP.PCAP.CD",
  urban = "SP.URB.TOTL.IN.ZS",
  female_labor = "SL.TLF.CACT.FE.ZS",
  contraceptive = "SP.DYN.CONU.ZS"
)

wdi_raw <- WDI(
  country = "all",
  indicator = indicators,
  start = 2000,
  end = 2023,
  extra = TRUE,
  cache = NULL
) %>%
  filter(region != "Aggregates")

write_csv(wdi_raw, here::here("01_data", "raw", "wdi_raw.csv"))

hdr_long <- read_excel(here::here("01_data", "raw", "hdr-data.xlsx"), sheet = "Data") %>%
  select(iso3c = countryIsoCode, year, indicator = indicatorCode, value) %>%
  mutate(year = as.integer(year)) %>%
  filter(indicator %in% c("eys_f", "gii", "mmr", "pr_f"))

hdr_wide <- hdr_long %>%
  pivot_wider(names_from = indicator, values_from = value)

merged_data <- wdi_raw %>%
  left_join(hdr_wide, by = c("iso3c", "year"))

write_csv(merged_data, here::here("01_data", "raw", "merged_data.csv"))
