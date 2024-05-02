rm(list=ls())
Sys.setenv(LANG = "en")

path_onedrive <- "C:/Users/ludov/OneDrive/Inventaire Vinyle et CD/"
path_jpg <- "C:/Users/ludov/Saved Games/Documents/music_center/www"
path_xlsx <- "C:/Users/ludov/Saved Games/Documents/music_center"

files <- list.files(path = "C:/Users/ludov/OneDrive/Inventaire Vinyle et CD/")

jpg_files <- files[grepl(".jpg", files)]
xlsx_file <- files[grepl(".xlsx", files)]

for(file in jpg_files) {
     file.copy(from = file.path(path_onedrive, file),
               to = path_jpg,
               overwrite = TRUE)
}

file.copy(from = file.path(path_onedrive, xlsx_file),
          to = path_xlsx,
          overwrite = TRUE)

