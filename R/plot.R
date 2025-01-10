#' Plot the frequency of a variable on horizontal bars
#'
#' @param data data.frame to use
#' @param variable variable we are interested in
#'
#' @return plot of type ggplot
#' @export
plot_freq_bar <- function(data, variable) {
     
     dt_plot <- data.frame(table(data[, variable])) %>% 
          rename(group = Var1) %>% 
          rename(value = Freq) %>%
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
     
     return(p)
     
}

#' Plot the frequency of a variable on a histogram
#'
#' @param data data.frame to use
#' @param variable variable we are interested in
#'
#' @return plot of type ggplot
#' @export
plot_freq_hist <- function(data, variable) {
     
     dt_plot <- data.frame(var = data[, variable])
     
     p <- ggplot(dt_plot, aes(x=var)) +
          geom_histogram(binwidth=3, colour="black", fill="#f68060", 
                         alpha=0.7, linewidth=0.25) +
          theme_minimal() +
          xlab(variable) +
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
     
     return(p)
     
}
