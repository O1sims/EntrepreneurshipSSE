nodeNames <- c("1",
               "2",
               "3",
               "4",
               "5",
               "6",
               "7",
               "8",
               "9",
               "10")

sources <- c(1, 2, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8)
targets <- c(4, 5, 6, 7, 8, 7, 8, 7, 8, 9, 10, 9, 10)

N <- data.frame(number = seq(from = 1,
                             to = length(nodeNames),
                             by = 1),
                nodes = nodeNames)

network <- data.frame(sources = sources,
                      targets = targets)

isTrue <- isUndirected(network, N) == FALSE

plot(graph_from_data_frame(network,
                           directed = isTrue),
     vertex.color = "orange",
     vertex.label.dist = 3,
     vertex.label.color = "black",
     vertex.size = 20,
     edge.color = "black",
     edge.arrow.size = 0.5)
