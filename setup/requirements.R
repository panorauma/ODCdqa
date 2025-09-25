# script to install all required packages for package version of ODC Utilities

install.packages(
    c("shinyjs", "DT", "waiter"),
    repos = "https://cloud.r-project.org"
)
gc()
