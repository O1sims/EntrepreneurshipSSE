installRLibraries <- function() {
  libraries <- c("data.table",
                 "expm",
                 "ggplot2",
                 "igraph")
  newLibraries <-
    libraries[!(libraries %in% installed.packages()[, "Package"])]
  if (length(newLibraries) > 0) {
    install.packages(newLibraries,
                     repos = "https://cloud.r-project.org/")
  }
}


initRWorkspace <- function() {
  installRLibraries()
  libraries <- c("data.table",
                 "expm",
                 "ggplot2",
                 "igraph")
  catch <- capture.output(lapply(libraries,
                                 library,
                                 character.only = TRUE))
}


# Remember to compile the relevant set of functions :
# source(file = "~/path/to/initRWorkspace.R")
# source(file = "~/path/to/networkFunctions.R")
# source(file = "~/path/to/hypergraphFunctions.R")
