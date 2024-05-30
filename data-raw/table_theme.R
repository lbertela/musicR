## code to prepare `table_theme` dataset goes here

table_theme <- reactablefmtr::slate(font_color = "#FFFFFF",
                                    header_font_color = "#FFFFFF",
                                    header_font_size = 20,
                                    centered = TRUE)

table_theme[["inputStyle"]]$color <- "#000000"
table_theme[["highlightColor"]] <- "#808080"

usethis::use_data(table_theme, overwrite = TRUE)
