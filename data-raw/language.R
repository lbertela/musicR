devtools::load_all()

language <- data.frame(EN = names(inventory),
                       FR = c("groupes", "couverture", "albums", "artistes", "années", 
                              "genres", "prix", "supports", "propiété", "lien"))

# Save the language data
usethis::use_data(language, overwrite = TRUE)
