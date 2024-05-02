library(rsconnect)
library(shiny)
library(ggplot2)
library(openxlsx)
library(dplyr)
library(shinythemes)
library(data.table)
library(reactable)
library(htmltools)
library(shinyWidgets)
library(reactablefmtr)
library(shinyjs)

file <- "Inventaire Vinyle et CD_Ali.xlsx"

# Get the data
data <- read.xlsx(file, startRow = 2, rowNames = FALSE)
setDT(data)

# Change names
names_orig <- names(data)
setnames(data, names_orig, c("group", "album", "artist", "year", "genre", "price", "type", "cover", "location"))

# Replace empty price by 0
data <- data[is.na(price), price := 0]
data <- data[price == "-", price := 0]
data <- data[, price := as.numeric(price)]

# Compute useful data
min_year <- min(data$year)
max_year <- max(data$year)
max_price <- max(na.omit(data$price))

# Define UI 
ui <- fluidPage(useShinyjs(),
                theme = shinytheme("slate"),
                titlePanel(div(h1(strong("Music Center")), style = "color:white")),
                sidebarLayout(
                     # Inputs: Select variables
                     sidebarPanel(h3(strong("Filtres")),
                                  selectInput(inputId = "filter_group", 
                                              label = "Sélectionner groupes", 
                                              choices = sort(data$group), 
                                              selected = NULL,
                                              selectize = TRUE,
                                              multiple = TRUE
                                  ),
                                  selectInput(inputId = "filter_album", 
                                              label = "Sélectionner albums", 
                                              choices = sort(data$album), 
                                              selected = NULL,
                                              selectize = TRUE,
                                              multiple = TRUE
                                  ),
                                  selectInput(inputId = "filter_artist", 
                                              label = "Sélectionner artistes", 
                                              choices = sort(data$artist), 
                                              selected = NULL,
                                              selectize = TRUE,
                                              multiple = TRUE
                                  ),
                                  selectInput(inputId = "filter_genre", 
                                              label = "Sélectionner genres", 
                                              choices = sort(data$genre), 
                                              selected = NULL,
                                              selectize = TRUE,
                                              multiple = TRUE
                                  ),
                                  selectInput(inputId = "filter_type", 
                                              label = "Sélectionner supports", 
                                              choices = sort(data$type), 
                                              selected = NULL,
                                              selectize = TRUE,
                                              multiple = TRUE
                                  ),
                                  
                                  br(),
                                  
                                  sliderInput(
                                       inputId = "date",
                                       label = "Sélectionner années:", 
                                       min = min_year, 
                                       max = max_year,
                                       value = c(min_year, max_year),
                                       step = 1,
                                       sep = ''
                                  ),
                                  sliderInput(
                                       inputId = "price",
                                       label = "Sélectionner prix:", 
                                       min = 0, 
                                       max = max_price,
                                       value = c(0, max_price),
                                       step = 1
                                  ), br(), 
                                  
                                  checkboxGroupInput("checkbox", "Propriété",
                                                     choices = list("Aliano" = 1,
                                                                    "Rita" = 2),
                                                     selected = c(1, 2),
                                                     inline = TRUE),
                                  
                                  br(), br(),
                                  
                                  actionButton("resetAll", "Réinitialiser Filtres"),
                                  
                     ),
                     # Output
                     mainPanel(
                          div(paste0("Groupes uniques : ", length(unique(data$group))), style = "color:white;font-size:20px"),
                          div(paste0("Albums uniques : ", length(unique(data$album))), style = "color:white;font-size:20px"),
                          div(paste0("Valeur totale : ", sum((data$price), na.rm = TRUE), " CHF"), style = "color:white;font-size:20px"), br(),
                          
                          div(h3(strong("Tableau")), style = "color:white"), br(),
                          reactableOutput(outputId = "musictable")
                     )
                )
)

