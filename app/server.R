# Define server
server <- function(input, output, session) {
     
     options(reactable.language = reactableLang(
          pageInfo = "Album {rowStart} à {rowEnd} sur {rows}",
          pageSizeOptions = "Afficher {rows}",
          pagePrevious = "/u276e",
          pageNext = "/u276f",
          noData = "Aucun album trouvé")
     )
     
     observeEvent(input$resetAll, {
          reset("")
     })
     
     output$musictable <- renderReactable(
          
          reactable(data = prepare_data(data = data,
                                        filter_date = input$slider_date,
                                        filter_price = input$slider_price,
                                        filter_location = input$checkbox,
                                        filter_group = input_filter_group,
                                        filter_artist = input_filter_artis,
                                        filter_album = input_filter_album,
                                        filter_genre = input_filter_genre,
                                        filter_type = input_filter_type),
                         
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
