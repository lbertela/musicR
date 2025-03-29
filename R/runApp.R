#' Launch the Music Center App
#'
#' @description This function launches the Shiny app included in the `musicr`.
#' @export
myApp <- function() {
     # Locate the app directory relative to the package
     app_dir <- system.file("app", package = "musicr")
     
     if (app_dir == "") {
          stop("Could not find the app directory. Please check the package structure.")
     }
     
     # Run the Shiny app
     shiny::runApp(app_dir)
}
