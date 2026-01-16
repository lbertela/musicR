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
prepare_data <- function(data,
                         filter_date,
                         filter_price,
                         filter_location,
                         filter_group,
                         filter_artist,
                         filter_album,
                         filter_genre,
                         filter_type) {
     
     df <- data %>% 
          filter(year >= filter_date[1] & year <= filter_date[2],
                 price >= filter_price[1] & price <= filter_price[2],
                 if(length(filter_location) == 2){
                      location %in% data$location  
                 } else if(length(filter_location) == 0){
                      location %in% data$location
                 } else if (length(filter_location) == 1 & filter_location == 2){
                      location == "RBR"  
                 } else if(length(filter_location) == 1 & filter_location == 1){
                      location == "AB"  
                 },
                 if(is.null(filter_group)) TRUE else group %in% filter_group,
                 if(is.null(filter_artist)) TRUE else artist %in% filter_artist,
                 if(is.null(filter_album)) TRUE else album %in% filter_album,
                 if(is.null(filter_genre)) TRUE else genre %in% filter_genre,
                 if(is.null(filter_type)) TRUE else type %in% filter_type) %>% 
          arrange(group, album)
     
     return(df)
}