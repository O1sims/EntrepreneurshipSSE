nodeNames <- c("1",
               "2",
               "3",
               "4",
               "5",
               "6")

sources <- c(1, 1, 2, 2, 2, 3, 3, 4, 4)
targets <- c(3, 4, 4, 5, 6, 5, 6, 5, 6)

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
