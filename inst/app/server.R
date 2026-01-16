# Define server
inventory <- readRDS(system.file("app/data/inventory.rds", package = "musicr"))

table_theme <- reactablefmtr::slate(font_color = "#FFFFFF",
                                    header_font_color = "#FFFFFF",
                                    header_font_size = 20,
                                    centered = TRUE)
table_theme[["inputStyle"]]$color <- "#000000"
table_theme[["highlightColor"]] <- "#808080"

server <- function(input, output, session) {
     
     options(reactable.language = reactableLang(
          pageInfo = "Album {rowStart} à {rowEnd} sur {rows}",
          pageSizeOptions = "Afficher {rows}",
          pagePrevious = "\u276e",
          pageNext = "\u276f",
          noData = "Aucun album trouvé")
     )
     
     observeEvent(input$resetAll, {
          shinyjs::reset("")
     })
     
     output$musictable <- renderReactable(
          
          reactable(data = musicr::prepare_data(data = inventory,
                                                filter_date = input$slider_date,
                                                filter_price = input$slider_price,
                                                filter_location = input$checkbox,
                                                filter_group = input$filter_group,
                                                filter_artist = input$filter_artist,
                                                filter_album = input$filter_album,
                                                filter_genre = input$filter_genre,
                                                filter_type = input$filter_type),
                    
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
                         cover_html = colDef(name = "Cover", align = "center",
                                             width = 80,
                                             html = TRUE,
                                             cell = JS("function(cellInfo) { return cellInfo.value; }")),
                         location = colDef(show = FALSE)
                    ),
                    
                    striped = TRUE,
                    compact = TRUE,
                    wrap = TRUE,
                    rownames = FALSE,
                    filterable = TRUE,
                    searchable = FALSE,
                    defaultPageSize = 10,
                    showSortIcon = TRUE,
                    pageSizeOptions = c(5, 10, 15, 20, nrow(inventory)),
                    showPageSizeOptions = TRUE,
                    theme = table_theme,
                    height = 735,
                    resizable = TRUE,
                    highlight = TRUE
          )
     )
     
     output$histo1 <- renderPlot({
          musicr::plot_freq_bar(data = inventory, variable = "type")
     }, width = 1000, height = 480, res = 150, bg="transparent")
     
     output$histo2 <- renderPlot({
          musicr::plot_freq_hist(data = inventory, variable = "price")
     }, width = 500, height = 480, res = 150, bg="transparent")
     
     output$histo3 <- renderPlot({
          musicr::plot_freq_bar(data = inventory, variable = "genre")
     }, width = 1000, height = 480, res = 150, bg="transparent")
     
     output$histo4 <- renderPlot({
          musicr::plot_freq_hist(data = inventory, variable = "year")
     }, width = 500, height = 480, res = 150, bg="transparent")
     
}
