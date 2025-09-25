# script to install all required packages for package version of ODC Utilities

to_install <- c(
    # "tidyverse",
    # "shiny",
    "shinyjs",
    "DT",
    "waiter",
    # "reticulate"
)

install.packages(to_install)

rm(to_install)
gc()
