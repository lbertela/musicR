library(ggplot2)
library(hexSticker)

p <- ggplot(aes(x = mpg, y = wt), data = mtcars) + geom_point()
p <- p + theme_void() + theme_transparent()

sticker("C:/Users/ludov/Saved Games/Documents/GitHub/shiny_strava.png", package="shiny_strava", 
        p_size=12, p_y = 0.475, p_color = "#5BB4E1",
        s_x=1, s_y=1.08, s_width=1.8, s_height=1, h_color = "#0F151D", filename="test.png",
        white_around_sticker = T)
system("open test.png")
