#' Function to prepare the data to be displaysed with a reactable
#'
#' @param data Data to be prepare
#' @param filter_date Shiny filter on date
#' @param filter_price Shiny filter on price
#' @param filter_location Shiny filter on location
#' @param filter_group Shiny filter on group
#' @param filter_artist Shiny filter on artist
#' @param filter_album Shiny filter on album
#' @param filter_genre Shiny filter on genre
#' @param filter_type Shiny filter on type
#'
#' @return a dataframe filtered with the Shiny inputs
#' @export
#'
#' @examples
prepare_data <- function(data,
                        filter_date,
                        filter_price,
                        filter_location,
                        filter_group,
                        filter_artist,
                        filter_album,
                        filter_genre,
                        filter_type) {
     
     data <-  data %>% 
          filter(year >= filter_date[1] & year <= filter_date[2],
                 price >= filter_price[1] & price <= filter_price[2],
                 case_when(
                      length(filter_location) %in% c(0, 2) ~ location %in% data$location,
                      length(filter_location) == 1 & filter_location == 2 ~ location == "RBR",
                      length(filter_location) == 1 & filter_location == 1 ~ location == "AB",
                      TRUE ~ TRUE
                 ),
                 ifelse(is.null(filter_group), group %in% data$group, group %in% filter_group),
                 ifelse(is.null(filter_artist), artist %in% data$artist, artist %in% filter_artist),
                 ifelse(is.null(filter_album), album %in% data$album, album %in% filter_album),
                 ifelse(is.null(filter_genre), genre %in% data$genre, genre %in% filter_genre),
                 ifelse(is.null(filter_type), type %in% data$type, type %in% filter_type))
     
     return(data)
}