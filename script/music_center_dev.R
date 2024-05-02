rm(list=ls())
Sys.setenv(LANG = "en")

library(rsconnect)
library(shiny)
library(ggplot2)
library(openxlsx)
library(dplyr)
library(shinythemes)
library(reactable)
library(htmltools)
library(reactablefmtr)
library(shinyjs)

# Path and files to data
path <- "C:/Users/ludov/Saved Games/Documents/GitHub/music_center/app"
file <- "01_inventaire.xlsx"

# Load the data
data <- read.xlsx(file.path(path, file), startRow = 2, rowNames = FALSE)

# Change column names
names(data) <- c("group", "album", "artist", "year", "genre", "price",
                 "type", "cover", "location", "link")

# Prepare data
data <- data %>% 
     mutate(price = case_when(is.na(price) ~ 0,
                              price == "-" ~ 0,
                              TRUE ~ as.numeric(price))) %>% 
     mutate(cover = gsub(".jpg", "", cover)) %>% 
     relocate(group, cover) 

# Save useful information
min_year <- min(data$year, na.rm = TRUE)
max_year <- max(data$year, na.rm = TRUE)
max_price <- max(na.omit(data$price))

# Modify themes
table_theme <- slate(font_color = "#FFFFFF",
      header_font_color = "#FFFFFF",
      header_font_size = 20,
      centered = TRUE)

table_theme[["inputStyle"]]$color <- "#000000"
table_theme[["highlightColor"]] <- "#808080"

# Define UI
ui <- navbarPage(
     strong("Music Center"),
     tabPanel("Tableau",
              fluidPage(
                   useShinyjs(),
                   theme = shinytheme("slate"),
                   
                   fluidRow(column(width = 1, offset = 11,
                                   img(src = "02_logo.png", 
                                       height = 130, 
                                       width = 195, 
                                       style = "left: -70px; top: 13px; position: absolute;"))),
                   
                   titlePanel(title = div(h1(strong("Inventaire")), style = "color:white"),
                              windowTitle = "Music Center"),
                   
                   sidebarLayout(
                        # Inputs: Select variables
                        sidebarPanel(
                             h3(strong("Filtres")),
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
                                          inputId = "slider_date",
                                          label = "Sélectionner années:", 
                                          min = min_year, 
                                          max = max_year,
                                          value = c(min_year, max_year),
                                          step = 1,
                                          sep = ''
                                     ),
                                     sliderInput(
                                          inputId = "slider_price",
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
                             div(paste0("Valeur totale : ", format(sum((data$price), na.rm = TRUE), big.mark = "'"), " CHF"), style = "color:white;font-size:20px"), br(),
                             
                             reactableOutput(outputId = "musictable")
                        )
                   )
              )
     ),
     tabPanel("Graphiques",
              fluidPage(
                   fluidRow(
                        column(width = 7, align = "center", plotOutput(outputId = "histo1")),
                        column(width = 5, align = "center", plotOutput(outputId = "histo2"))),
                        
                   br(), br(), br(), br(),
                   
                   fluidRow(
                        column(width = 7, align = "center", plotOutput(outputId = "histo3")),
                        column(width = 5, align = "center", plotOutput(outputId = "histo4")))),
     )
)


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
                         filter(year >= input$slider_date[1], 
                                year <= input$slider_date[2],
                                price >= input$slider_price[1],
                                price <= input$slider_price[2],
                                
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
                         group = colDef(name = "Groupe", minWidth = 40, footer = "TOTAL"),
                         album = colDef(name = "Album", minWidth = 80), 
                         artist = colDef(name = "Artiste(s)", minWidth = 40),
                         year = colDef(name = "Année", width = 100), 
                         genre = colDef(name = "Genre", width = 100), 
                         price = colDef(name = "Prix", width = 100,
                                        footer = function(values) paste0(format(sum(values, na.rm = TRUE), big.mark = "'"), " CHF"),
                                        cell = function(value) {if (value == 0) "-" else paste0(value, " CHF")}),
                         type = colDef(name = "Support", width = 100), 
                         cover = colDef(name = "Cover", align = "center",
                                        width = 80,
                                        cell = function(value,index){
                                             htmltools::a(
                                                  href=data$link[index],
                                                  target="_blank",
                                                  htmltools::img(src=sprintf("%s.jpg", value),
                                                                 style = "height: 50px;",
                                                                 alt = value))}),
                         location = colDef(show = FALSE),
                         link = colDef(show = FALSE)
                    ),
                    
                    defaultSorted = c("group", "album"),
                    striped = TRUE,
                    compact = TRUE,
                    wrap = TRUE,
                    rownames = FALSE,
                    filterable = TRUE,
                    searchable = FALSE,
                    defaultPageSize = 10,
                    showSortIcon = TRUE,
                    pageSizeOptions = c(5, 10, 15, 20, nrow(data)),
                    showPageSizeOptions = TRUE,
                    theme = table_theme,
                    height = 735,
                    resizable = TRUE,
                    highlight = TRUE
          )
     )
     
     output$histo1 <- renderPlot({
          
          dt_plot <- as.data.frame(table(data$type)) %>% 
               dplyr::rename(group = Var1) %>% 
               dplyr::rename(value = Freq) %>%
               mutate(group = forcats::fct_reorder(group, value))
          
          p <- ggplot(dt_plot, aes(x=group, y=value)) +
               geom_bar(stat="identity", fill="#f68060", alpha=.7, width=.3) +
               theme_minimal() +
               coord_flip() +
               xlab("") +
               ylab("") + 
               theme(axis.text=element_text(color="white"),
                     axis.ticks.x=element_blank(),
                     axis.ticks.y=element_blank(),
                     panel.grid = element_line(color = "darkgrey",
                                               linewidth = 0.1),
                     panel.border = element_rect(fill = "transparent",
                                                 color = "darkgrey")
                     )

          p
          
     }, width = 1000, height = 480, res = 150, bg="transparent")
     
     output$histo2 <- renderPlot({
          
          dt_plot <- data.frame(price = data$price)
          
          p <- ggplot(dt_plot, aes(x=price)) +
               geom_histogram(binwidth=5, colour="black", fill="#f68060", 
                              alpha=0.7, linewidth=0.25) +
               theme_minimal() +
               xlab("Prix") +
               ylab("Albums") + 
               theme(axis.text=element_text(color="white"),
                     axis.title.x = element_text(colour = "white"),
                     axis.title.y = element_text(colour = "white", vjust = 3),
                     axis.ticks.x=element_blank(),
                     axis.ticks.y=element_blank(),
                     panel.grid = element_line(color = "darkgrey",
                                               linewidth = 0.1),
                     panel.border = element_rect(fill = "transparent",
                                                 color = "darkgrey")
               )
          
          p
          
     }, width = 500, height = 480, res = 150, bg="transparent")
     
     output$histo3 <- renderPlot({
          
          dt_plot <- as.data.frame(table(data$genre)) %>% 
               dplyr::rename(group = Var1) %>% 
               dplyr::rename(value = Freq) %>%
               mutate(group = forcats::fct_reorder(group, value))
          
          
          p <- ggplot(dt_plot, aes(x=group, y=value)) +
               geom_bar(stat="identity", fill="#f68060", alpha=.7, width=.3) +
               theme_minimal() +
               coord_flip() +
               xlab("") +
               ylab("") + 
               theme(axis.text=element_text(color="white"),
                     axis.ticks.x=element_blank(),
                     axis.ticks.y=element_blank(),
                     panel.grid = element_line(color = "darkgrey",
                                               linewidth = 0.1),
                     panel.border = element_rect(fill = "transparent",
                                                 color = "darkgrey")
               )
          
          p
          
     }, width = 1000, height = 480, res = 150, bg="transparent")
     
     output$histo4 <- renderPlot({
          
          dt_plot <- data.frame(year = data$year)
          
          p <- ggplot(dt_plot, aes(x=year)) +
               geom_histogram(binwidth=3, colour="black", fill="#f68060", 
                              alpha=0.7, linewidth=0.25) +
               theme_minimal() +
               xlab("Année") +
               ylab("Albums") + 
               theme(axis.text=element_text(color="white"),
                     axis.title.x = element_text(colour = "white"),
                     axis.title.y = element_text(colour = "white", vjust = 3),
                     axis.ticks.x=element_blank(),
                     axis.ticks.y=element_blank(),
                     panel.grid = element_line(color = "darkgrey",
                                               linewidth = 0.1),
                     panel.border = element_rect(fill = "transparent",
                                                 color = "darkgrey")
               )
          
          p
          
     }, width = 500, height = 480, res = 150, bg="transparent")
}

# Create a Shiny app object 
shinyApp(ui = ui, server = server)
