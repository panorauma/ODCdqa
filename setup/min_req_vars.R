library(tidyverse)

url <- "https://raw.githubusercontent.com/panorauma/ODC_min_vars/refs/heads/main/odc_min_vars.csv"
min_vars <- read_csv(url)

# copy and paste this into functions.R
cat(paste0('"', min_vars$Variable, '"', collapse = ", "))
