# Define UI
ui <- navbarPage(
     strong("Music Center"),
     tabPanel("Tableau",
              fluidPage(
                   useShinyjs(),
                   theme = shinythemes::shinytheme("slate"),
                   
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