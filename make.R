# This script runs all the project
library(rmarkdown)
source("02_R/01_data_download.R")
source("02_R/02_data_cleaning.R")
# Render EDA Report
render(  
  input = "02_R/03_eda.Rmd",  
  output_format = "bookdown::pdf_document2",  
  output_dir = "03_outputs/report",  
  clean = TRUE
)
# Render Modelling Report
render(
  input = "02_R/04_modelling.Rmd",
  output_format = "bookdown::pdf_document2",
  output_dir = "03_outputs/report",
  clean = TRUE
)
shiny::runApp("02_R/05_app.R")
