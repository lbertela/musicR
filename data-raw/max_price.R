## code to prepare `max_price` dataset goes here

max_price <- max(na.omit(inventory$price))

usethis::use_data(max_price, overwrite = TRUE)
