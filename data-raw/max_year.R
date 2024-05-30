## code to prepare `max_year` dataset goes here

max_year <- max(inventory$year, na.rm = TRUE)

usethis::use_data(max_year, overwrite = TRUE)
