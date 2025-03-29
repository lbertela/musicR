#' Inventory Data
#'
#' This dataset contains information about various music albums, including 
#' their group, artist, year, genre, price, and more.
#'
#' @format A data frame:
#' \describe{
#'   \item{group}{Factor: Music group or artist.}
#'   \item{cover_html}{Character: HTML string for displaying album covers.}
#'   \item{album}{Character: Name of the album.}
#'   \item{artist}{Character: Artist or group name.}
#'   \item{year}{Numeric: Year of release.}
#'   \item{genre}{Character: Genre of the album.}
#'   \item{price}{Numeric: Price of the album in CHF.}
#'   \item{type}{Character: Format of the album (e.g., CD, Vinyl).}
#'   \item{location}{Character: location of the album.}
#' }
#' @source The data was collected from an excel file.
"inventory"