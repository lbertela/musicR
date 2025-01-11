#' Create simple selectInput based on a specific variable
#'
#' @param data input data
#' @param variable variable to be filtered on
#'
#' @returns a selectInput for the UI of a shiny App
#' @export
set_selectInput <- function(data, variable) {
     selectInput(inputId = paste0("filter_", variable), 
                 label = paste0("Sélectionner ", variable), 
                 choices = sort(unique(data[, variable])), 
                 multiple = TRUE
     )
}