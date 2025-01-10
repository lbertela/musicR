#' Launch the Music Center App
#'
#' @description This function launches the Shiny app included in the `musicr`.
#' @export
# myApp <- function() {
#      # Locate the app directory
#      app_dir <- file.path(here::here(), "inst/app")
#      
#      # Source the ui and server scripts
#      source(file.path(app_dir, "ui.R"), local = TRUE)
#      source(file.path(app_dir, "server.R"), local = TRUE)
#      
#      # Run the Shiny app
#      shinyApp(ui = ui, server = server)
# }

myApp <- function() {
     # Locate the app directory relative to the package
     app_dir <- system.file("app", package = "musicr")
     
     if (app_dir == "") {
          stop("Could not find the app directory. Please check the package structure.")
     }
     
     # Run the Shiny app
     shiny::runApp(app_dir)
}