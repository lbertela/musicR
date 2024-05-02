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

# Define server
server <- function(input, output, session) {
     
     options(reactable.language = reactableLang(
          pageInfo = "Album {rowStart} à {rowEnd} sur {rows}",
          pageSizeOptions = "Afficher {rows}",
          pagePrevious = "\u276e",
          pageNext = "\u276f",
          noData = "Aucun album trouvé")
     )
     
     observeEvent(input$resetAll, {
          reset("")
     })
     
     output$musictable <- renderReactable(
          
          reactable(data = data %>% 
                         filter(year >= input$date[1], 
                                year <= input$date[2],
                                price >= input$price[1],
                                price <= input$price[2],
                                
                                if(length(input$checkbox) == 2){
                                     location %in% data$location
                                } else if(length(input$checkbox) == 0){
                                     location %in% data$location
                                } else if (length(input$checkbox) == 1 & input$checkbox == 2){
                                     location == "RBR"
                                } else if(length(input$checkbox) == 1 & input$checkbox == 1){
                                     location == "AB"
                                },
                                
                                if(is.null(input$filter_group)){
                                     group %in% data$group
                                } else {
                                     group %in% input$filter_group},
                                
                                if(is.null(input$filter_artist)){
                                     artist %in% data$artist
                                } else {
                                     artist %in% input$filter_artist},
                                
                                if(is.null(input$filter_album)){
                                     album %in% data$album
                                } else {
                                     album %in% input$filter_album},
                                
                                if(is.null(input$filter_genre)){
                                     genre %in% data$genre
                                } else {
                                     genre %in% input$filter_genre},
                                
                                if(is.null(input$filter_type)){
                                     type %in% data$type
                                } else {
                                     type %in% input$filter_type}
                         ),
                    
                    defaultColDef = colDef(
                         vAlign = "center",
                         align = "left",
                         sortNALast = TRUE,
                         footerStyle = list(fontWeight = "bold",
                                            fontSize = 18,
                                            backgroundColor = "white",
                                            color = "black")
                    ),
                    
                    columns = list(
                         group = colDef(name = "Groupe", width = 170, footer = "TOTAL"),
                         album = colDef(name = "Album", minWidth = 80),
                         artist = colDef(name = "Artiste(s)", width = 170),
                         year = colDef(name = "Année", width = 100), 
                         genre = colDef(name = "Genre", width = 100), 
                         price = colDef(name = "Prix", width = 100,
                                        footer = function(values) sprintf("%.0f CHF", sum(values, na.rm = TRUE)),
                                        cell = function(value) {if (value == 0) "-" else paste0(value, " CHF")}),
                         type = colDef(name = "Support", width = 100), 
                         cover = colDef(name = "Couverture", align = "center",
                                        width = 120,
                                        cell = function(value) {
                                             image <- img(src = sprintf("%s.jpg", value), 
                                                          style = "height: 50px;", 
                                                          alt = value)
                                        }
                         ),
                         location = colDef(show = FALSE)
                    ),
                    
                    defaultSorted = c("group", "album"),
                    striped = TRUE,
                    compact = TRUE,
                    wrap = FALSE,
                    rownames = FALSE,
                    filterable = TRUE,
                    searchable = FALSE,
                    defaultPageSize = 10,
                    showSortIcon = TRUE,
                    pageSizeOptions = c(5, 10, 15, 20),
                    showPageSizeOptions = TRUE,
                    theme = slate(font_color = "#FFFFFF",
                                  header_font_color = "#FFFFFF",
                                  header_font_size = 20,
                                  centered = TRUE),
                    height = 780,
                    resizable = TRUE
          )
     )
}


