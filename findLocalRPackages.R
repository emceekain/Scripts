my_packages <- as.data.frame(installed.packages()[ , c(1, 3:4)])            # Apply installed.packages()
my_packages <- my_packages[is.na(my_packages$Priority), 1:2, drop = FALSE]  # Remove NA rows
#rownames(my_packages) <- NULL                                              # Rename rows
my_packages