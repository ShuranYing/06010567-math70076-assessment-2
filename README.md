# Global Female Education and Fertility Analysis

## Overview
This project investigates the relationship between female education levels and fertility rates globally from 2000 to 2023, using data from the World Bank and UNDP HDR. The project includes:
-  Data acquisition and cleaning
-  Exploratory data analysis
-  Modelling analysis
-  Interactive Shiny app for dynamic exploration

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

### GitHub Commit
Tagged release for final submission: [🔗 Click here](https://github.com/YOUR-USERNAME/YOUR-REPO/tree/v1.0)

## ✍️ Author
Imperial CID: `YOURCID`  
MSc Statistics (Data Science), Imperial College London
