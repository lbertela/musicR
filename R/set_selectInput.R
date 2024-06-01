set_selectInput <- function(data, variable) {
     selectInput(inputId = paste0("filter_", variable), 
                 label = paste0("Sélectionner ", variable), 
                 choices = sort(unique(data[, variable])), 
                 multiple = TRUE
     )
}