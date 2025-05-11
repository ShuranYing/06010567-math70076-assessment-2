# Global Female Education and Fertility Analysis

## Overview
This project investigates the relationship between female education levels and fertility rates globally from 2000 to 2023, using data from the World Bank and UNDP HDR. The project includes:
-  Data acquisition and cleaning
-  Exploratory data analysis
-  Modelling analysis
-  Interactive Shiny app for dynamic exploration

## Data Sources and Variables

The dataset used in this project combines indicators from:

- **World Bank (WDI)**: accessed via the `WDI` R package.
  - **Fertility rate (SP.DYN.TFRT.IN)** – Births per woman.
  - **Female educational attainment**:
    - Upper secondary (SE.SEC.CUAT.UP.FE.ZS)
    - Lower secondary (SE.SEC.CUAT.LO.FE.ZS)
    - Tertiary (SE.TER.CUAT.BA.FE.ZS)
  - **GDP per capita (NY.GDP.PCAP.CD)**
  - **Urban population (% of total population) (SP.URB.TOTL.IN.ZS)**
  - **Female labour force participation (SL.TLF.CACT.FE.ZS)**
  - **Contraceptive prevalence (SP.DYN.CONU.ZS)**

- **UNDP Human Development Report (HDR)**: accessed via `readxl` from `hdr-data.xlsx`.
  - **GII (Gender Inequality Index)** – Ranges from 0 (equality) to 1 (inequality).
  - **EYS_F (Expected years of schooling – female)**
  - **MMR (Maternal Mortality Ratio)**
  - **PR_F (Proportion of seats held by women in parliament)**

### Data Structure

- Panel data from **2000 to 2023**, covering all countries with available records.
- Missing values were imputed using linear interpolation (`zoo::na.approx()`), where possible.
- The final dataset includes country-level observations for each year.

## Project Structure
```text
.
├── 01_data/
│   ├── raw/
│   └── clean/
├── 02_R/
│   ├── 01_data_download.R     # Download and merge WDI & HDR data
│   ├── 02_data_cleaning.R     # Clean, select, and impute data
│   ├── 03_eda.Rmd             # Exploratory data analysis
│   ├── 04_modelling.Rmd       # Panel regression & prediction
│   ├── 05_app.R               # Shiny app for interactive visualisation
├── 03_outputs/
│   ├── report/
├── make.R                 # File for runing the project
├── README.md              # Project documentation
└── 06010567-math70076-assessment-2-summary.pdf
```
## Instructions

### Setup
Install required packages using:

```r
install.packages(c("rmarkdown", "knitr", "kableExtra", "WDI", "tidyverse", "readxl", "here", "zoo", "janitor", "ggthemes", "ggrepel", "viridis", "corrplot", "sf", "rnaturalearth", "rnaturalearthdata", "gridExtra", "ggfortify", "car", "sandwich", "lmtest", "tibble", "ggeffects", "plm", "shiny", "plotly", "readr", "ggplot2", "fmsb"))
```

### Run the Project
```r
source("make.R")
```