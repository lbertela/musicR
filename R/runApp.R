#' Launch the Music Center App
#'
#' @description This function launches the Shiny app included in the `musicr`.
#' @export
myApp <- function() {
     app_dir <- system.file("app", package = "musicr")
     if (app_dir == "") stop("Could not find the app directory")
     shiny::runApp(app_dir)
}
