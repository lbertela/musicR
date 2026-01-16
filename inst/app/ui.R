# Define UI
library(shiny)
library(reactable)
library(dplyr)

inventory <- readRDS(system.file("app/data/inventory.rds", package = "musicr"))
max_price <- max(na.omit(inventory$price))
min_year <- min(inventory$year, na.rm = TRUE)
max_year <- max(inventory$year, na.rm = TRUE)

ui <- navbarPage(
     title = strong("Music Center"),
     # Barre de recherche
     header = tags$div(
          style = "position: absolute; right: 30px; top: 6px; width: 250px; z-index: 1000;",
          textInput(
               inputId = "global_search",
               label = NULL,
               placeholder = "\U0001F50D Rechercher...",
               width = "100%"
          )
     ),
     # Onglet Tableau
     tabPanel("Tableau",
              fluidPage(
                   shinyjs::useShinyjs(),
                   theme = shinythemes::shinytheme("slate"),
                   
                   fluidRow(column(
                        width = 1, 
                        offset = 11,
                        img(src = "02_logo.png", 
                            height = 130, 
                            width = 195, 
                            style = "left: -70px; top: 13px; position: absolute;")
                   )),
                   
                   titlePanel(
                        title = div(h1(strong("Inventaire")), style = "color:white"),
                        windowTitle = "Music Center"
                   ),
                   
                   sidebarLayout(
                        # Inputs: Select variables
                        sidebarPanel(
                             h3(strong("Filtres")),
                             
                             lapply(c("group", "album", "artist", "genre", "type"), function(var) {
                                  musicr::set_selectInput(inventory, var)
                             }),
                             
                             br(),
                             
                             sliderInput(
                                  inputId = "slider_date",
                                  label = "S\u00e9lectionner ann\u00e9es:", 
                                  min = min_year, 
                                  max = max_year,
                                  value = c(min_year, max_year),
                                  step = 1,
                                  sep = ''
                             ),
                             sliderInput(
                                  inputId = "slider_price",
                                  label = "S\u00e9lectionner prix:", 
                                  min = 0, 
                                  max = max_price,
                                  value = c(0, max_price),
                                  step = 1
                             ), br(), 
                             
                             checkboxGroupInput("checkbox", "Propri\u00e9t\u00e9",
                                                choices = list("Aliano" = 1,
                                                               "Rita" = 2),
                                                selected = c(1, 2),
                                                inline = TRUE),
                             
                             br(), br(),
                             
                             actionButton("resetAll", "R\u00e9initialiser Filtres"),
                             
                        ),
                        # Output
                        mainPanel(
                             div(
                                  style = "display:flex; gap: 30px; margin-bottom: 10px;",
                                  
                                  # Card 1
                                  div(
                                       style = "width:200px; background-color:#34495e; padding:13px; border-radius:10px; text-align:center; color:white; height:100px;",
                                       icon("users", style = "font-size:20px; margin-bottom:10px;"),
                                       div(paste0(length(unique(inventory$group))), style = "font-size:20px; font-weight:bold;"),
                                       div("Groupes uniques", style = "font-size:17px;")
                                  ),
                                  
                                  # Card 2
                                  div(
                                       style = "width:200px; background-color:#5D6DFF; padding:13px; border-radius:10px; text-align:center; color:white; height:100px;",
                                       icon("compact-disc", style = "font-size:20px; margin-bottom:10px;"),
                                       div(paste0(length(unique(inventory$album))), style = "font-size:20px; font-weight:bold;"),
                                       div("Albums uniques", style = "font-size:17px;")
                                  ),
                                  
                                  # Card 3
                                  div(
                                       style = "width:200px; background-color:#1ABC9C; padding:13px; border-radius:10px; text-align:center; color:white; height:100px;",
                                       icon("hand-holding-dollar", style = "font-size:20px; margin-bottom:10px;"),
                                       div(paste0(format(sum(inventory$price, na.rm = TRUE), big.mark = "'"), " CHF"), style = "font-size:20px; font-weight:bold;"),
                                       div("Valeur totale", style = "font-size:17px;")
                                  )
                             ),
                             
                             br(),
                             reactableOutput(outputId = "musictable")
                        )
                   )
              )
     ),
     # Onglet Graphiques
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
