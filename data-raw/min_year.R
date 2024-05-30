## code to prepare `min_year` dataset goes here

min_year <- min(inventory$year, na.rm = TRUE)

usethis::use_data(min_year, overwrite = TRUE)
