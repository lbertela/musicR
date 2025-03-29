# Define UI
library(shiny)
library(reactable)
devtools::load_all()

ui <- navbarPage(
     strong("Music Center"),
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
                                  set_selectInput(inventory, var)
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
                             div(paste0("Groupes uniques : ", length(unique(inventory$group))), style = "color:white;font-size:20px"),
                             div(paste0("Albums uniques : ", length(unique(inventory$album))), style = "color:white;font-size:20px"),
                             div(paste0("Valeur totale : ", format(sum((inventory$price), na.rm = TRUE), big.mark = "'"), " CHF"), style = "color:white;font-size:20px"), br(),
                             
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
