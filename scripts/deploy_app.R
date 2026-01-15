if (print(requireNamespace("musicr", quietly = TRUE))) {
     remove.packages("musicr")
}
remotes::install_github("https://github.com/lbertela/musicR.git")
musicr::myApp()

# With the Rstudio Viewer, publish the app under the name you want, like "music_center_ali"
