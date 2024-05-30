library(rsconnect)
library(shiny)
library(ggplot2)
library(dplyr)
library(reactable)
library(htmltools)
library(shinyWidgets)
library(shinyjs)
devtools::load_all()

#setwd("app")
file <- "data/01_inventaire.xlsx"

# Get the data
data <- openxlsx::read.xlsx(file, startRow = 2, rowNames = FALSE)
names(data) <- c("group", "album", "artist", "year", "genre", 
                 "price", "type", "cover", "location", "link")

# Prepare data
data <- data %>% 
     mutate(price = case_when(is.na(price) ~ 0,
                              price == "-" ~ 0,
                              TRUE ~ as.numeric(price))) %>% 
     mutate(cover = gsub(".jpg", "", cover)) %>% 
     relocate(group, cover) 

# Compute useful inputs
min_year <- min(data$year, na.rm = TRUE)
max_year <- max(data$year, na.rm = TRUE)
max_price <- max(na.omit(data$price))

# Table theme
table_theme <- reactablefmtr::slate(font_color = "#FFFFFF",
                                    header_font_color = "#FFFFFF",
                                    header_font_size = 20,
                                    centered = TRUE)

table_theme[["inputStyle"]]$color <- "#000000"
table_theme[["highlightColor"]] <- "#808080"

# Run App
runApp()
