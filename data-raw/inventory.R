## code to prepare `inventory` dataset goes here
rm(list=ls())
Sys.setenv(LANG = "en")

# Set Paths and files
path_onedrive <- "C:/Users/ludov/OneDrive/Inventaire Vinyle et CD/"
path_www <- "app/www"

files <- list.files(path = path_onedrive)

# Identify .jpg and .xlsx files
jpg_files <- files[grepl(".jpg", files)]
xlsx_file <- files[grepl(".xlsx", files)]

# Save each .jpg file
for(file in jpg_files) {
     file.copy(from = file.path(path_onedrive, file),
               to = path_www,
               overwrite = TRUE)
}

# Save the .xlsx database
inventory <- openxlsx::read.xlsx(file.path(path_onedrive, xlsx_file))

usethis::use_data(inventory, overwrite = TRUE)
