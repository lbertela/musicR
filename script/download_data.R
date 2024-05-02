rm(list=ls())
Sys.setenv(LANG = "en")

# Set Paths and files
path_onedrive <- "C:/Users/ludov/OneDrive/Inventaire Vinyle et CD/"
path_jpg <- "C:/Users/ludov/Saved Games/Documents/GitHub/music_center/app/www"
path_xlsx <- "C:/Users/ludov/Saved Games/Documents/GitHub/music_center/app"

files <- list.files(path = path_onedrive)

# Identify .jpg and .xlsx files
jpg_files <- files[grepl(".jpg", files)]
xlsx_file <- files[grepl(".xlsx", files)]

# Save each .jpg file
for(file in jpg_files) {
     file.copy(from = file.path(path_onedrive, file),
               to = path_jpg,
               overwrite = TRUE)
}

# Save the .xlsx database
file.copy(from = file.path(path_onedrive, xlsx_file),
          to = path_xlsx,
          overwrite = TRUE)

