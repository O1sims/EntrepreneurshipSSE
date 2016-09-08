nodeNames <- c("1",
               "2",
               "3",
               "4",
               "5")
affiliationNames <- c("A",
                      "B",
                      "C")
weights <- c(21, 15, 8)

nodes <- c(1, 2, 3, 4, 4, 4, 5, 5)
affiliations <- c(3, 2, 1, 3, 2, 1, 2, 1)

N <- data.frame(number = seq(from = 1,
                             to = length(nodeNames),
                             by = 1),
                nodes = nodeNames)

H <- data.frame(number = seq(from = 1,
                             to = length(affiliationNames),
                             by = 1),
                affiliations = affiliationNames)

hypergraph <- data.frame(nodes = nodes,
                         affiliations = affiliations)
