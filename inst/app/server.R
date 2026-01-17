# Define server
inventory <- readRDS(system.file("app/data/inventory.rds", package = "musicr"))

table_theme <- reactablefmtr::slate(font_color = "#FFFFFF",
                                    header_font_color = "#FFFFFF",
                                    header_font_size = 20,
                                    centered = TRUE)
table_theme[["inputStyle"]]$color <- "#000000"
table_theme[["highlightColor"]] <- "#808080"
table_theme[["headerStyle"]]$backgroundColor <- "#34495e"

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
     
     filtered_inventory <- reactive({
          musicr::prepare_data(
               data = inventory,
               filter_date     = input$slider_date,
               filter_price    = input$slider_price,
               filter_location = input$checkbox,
               filter_group    = input$filter_group,
               filter_artist   = input$filter_artist,
               filter_album    = input$filter_album,
               filter_genre    = input$filter_genre,
               filter_type     = input$filter_type,
               global_search   = input$global_search
          )
     })
     
     row_details <- function(index) {
          
          cover <- paste0(filtered_inventory()[index, ]$cover, ".jpg")
          link <- filtered_inventory()[index, ]$link
          album <- filtered_inventory()[index, ]$album
          artist <- filtered_inventory()[index, ]$artist
          year <- filtered_inventory()[index, ]$year
          
          img_tag <- tags$img(src = cover, height = "200px", style = "border-radius:5px;")
          
          spotify_logo_img <- tags$img(
               src = "https://upload.wikimedia.org/wikipedia/commons/1/19/Spotify_logo_without_text.svg",
               height = "30px",
               style = "margin-top: -10px; margin-left: 15px;"
          )
          
          if (!is.na(link)) {
               spotify_logo <- tags$a(href = link, target = "_blank", spotify_logo_img)
          } else {
               spotify_logo <- ""
          }
          
          text_div <- div(
               style = "margin-left: 20px",
               div(album, style = "font-size:50px; color:white; font-weight:bold; margin-bottom:5px;", spotify_logo),
               div(paste(artist, "\u2022", year), style = "font-size:18px; color: #cccccc")
          )
          
          div(style = "padding: 10px; background-color: #2f3542; display:flex; justify-content:left;",
              img_tag,
              text_div)
     }

     output$musictable <- renderReactable(
          
          reactable(data = filtered_inventory(),
                    
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
                         location = colDef(show = FALSE),
                         cover = colDef(show = FALSE),
                         link = colDef(show = FALSE)
                         
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
                    highlight = TRUE,
                    onClick = "expand",
                    rowStyle = list(cursor = "pointer"),
                    details = row_details
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
