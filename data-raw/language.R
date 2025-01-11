## code to prepare `language` dataset goes here

language <- data.frame(EN = names(inventory),
                       FR = c("groupes", "couverture", "albums", "artistes", "années", 
                              "genres", "prix", "supports", "propiété"))

# Save the language data
usethis::use_data(language, overwrite = TRUE)
