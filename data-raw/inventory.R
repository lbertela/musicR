## code to prepare `inventory` dataset goes here
rm(list=ls())
Sys.setenv(LANG = "en")

# Set Paths and files
path_onedrive <- "C:/Users/ludov/OneDrive/Inventaire Vinyle et CD/"
path_www <- "inst/app/www"

files <- list.files(path = path_onedrive)

# Identify .jpg and .xlsx files
jpg_files <- files[grepl(".jpg", files)]
xlsx_file <- files[grepl(".xlsx", files)]

# Save each .jpg file into "www"
for(file in jpg_files) {
     file.copy(from = file.path(path_onedrive, file),
               to = path_www,
               overwrite = TRUE)
}

# Load inventory
inventory <- openxlsx::read.xlsx(file.path(path_onedrive, xlsx_file), 
                                 startRow = 2, rowNames = FALSE)

names(inventory) <- c("group", "album", "artist", "year", "genre", 
                      "price", "type", "cover", "location", "link")

# Prepare inventory
inventory <- inventory %>% 
     mutate(price = case_when(is.na(price) ~ 0,
                              price == "-" ~ 0,
                              TRUE ~ as.numeric(price))) %>% 
     mutate(cover = gsub(".jpg", "", cover)) %>% 
     relocate(group, cover)

# Save the inventory
usethis::use_data(inventory, overwrite = TRUE)
