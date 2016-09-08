nodeProjection <- function(hypergraph) {
  nodeNetwork <- data.frame(sources = 0,
                            targets = 0)
  activeAffiliations <- unique(hypergraph[, 2])

  if (length(activeAffiliations) > 0) {
    for (i in 1:length(activeAffiliations)) {
      affiliationSet <- subset(hypergraph[, 1],
                               hypergraph[, 2] == activeAffiliations[i])
      connections <- data.frame(t(combn(affiliationSet,
                                        m = 2)))
      colnames(connections) <- c("sources",
                                 "targets")
      nodeNetwork <- rbind(nodeNetwork,
                           connections,
                           data.frame(sources = connections$targets,
                                      targets = connections$sources))
    }
    nodeNetwork <- nodeNetwork[-1, ]
    return(nodeNetwork)
  } else {
    return(print("No affiliations to project!"))
  }
}


affiliationProjection <- function(hypergraph) {
  affiliationNetwork <- data.frame(sources = 0,
                                   targets = 0,
                                   weight = 0)
  activeAffiliations <- unique(hypergraph[, 2])

  if (length(activeAffiliations) > 0) {
    for (i in 1:length(activeAffiliations)) {
      members <- subset(hypergraph[, 1],
                        hypergraph[, 2] == activeAffiliations[i])
      otherAffiliations <- setdiff(activeAffiliations,
                                   activeAffiliations[i])
      for (j in 1:length(otherAffiliations)) {
        overlap <- intersect(members,
                             subset(hypergraph[, 1],
                                    hypergraph[, 2] == otherAffiliations[j]))
        if (length(overlap) > 0) {
          affiliationNetwork <- rbind(affiliationNetwork,
                                      c(activeAffiliations[i],
                                        otherAffiliations[j],
                                        length(overlap)))
        }
      }
    }
  }
  affiliationNetwork <- affiliationNetwork[-1, ]
  return(affiliationNetwork)
}


filterNetwork <- function(network) {
  for (i in 1:(nrow(network) - 1)) {
    for (j in (i + 1):nrow(network)) {
      if (network$targets[i] == network$sources[j] &&
          network$sources[i] == network$targets[j]) {
        network[i, ] <- 0
      }
    }
  }
  row_sub <- apply(network, 1, function(row) all(row != 0))
  network <- network[row_sub, ]
  return(network)
}


affiliationSet <- function(hypergraph, nodeNames) {
  for (i in 1:nrow(nodeNames)) {
    if (i == 1) {
      affSet <- list(subset(hypergraph$affiliations,
                            hypergraph$nodes == nodeNames[i, 1]))
    } else {
      affSet[nodeNames[i, 1]] <- list(subset(hypergraph$affiliations,
                                             hypergraph$nodes == nodeNames[i, 1]))
    }
  }
  return(affSet)
}


hypergraphNeighbourhood <- function(hypergraph, nodeNames) {
  for (i in 1:nrow(nodeNames)) {
    affSet <- subset(hypergraph$affiliations,
                     hypergraph$nodes == nodeNames[i, 1])
    if (length(affSet) > 0) {
      for (j in 1:length(affSet)) {
        members <- subset(hypergraph$nodes,
                          hypergraph$affiliations == affSet[j])
        if (j == 1) {
          neighbours <- members
        } else {
          neighbours <- setdiff(union(neighbours, members),
                               nodeNames[i, 1])
        }
      }
    }
    if (i == 1) {
      neighbourhood <- list(neighbours)
    } else {
      neighbourhood[nodeNames[i, 1]] <- list(neighbours)
    }
  }
  return(neighbourhood)
}


affiliationEnviornment <- function(hypergraph, affiliationNames) {
  for (i in 1:nrow(affiliationNames)) {
    members <- subset(hypergraph$nodes,
                      hypergraph$affiliations == affiliationNames[i, 1])
    if (i == 1) {
      membersList <- list(members)
    } else {
      membersList[affiliationNames[i, 1]] <- list(members)
    }
  }
  for (i in 1:nrow(affiliationNames)) {
    environment <- 0
    for (j in setdiff(seq(1, nrow(affiliationNames)), i)) {
      if (length(intersect(membersList[[i]], membersList[[j]])) > 0) {
        environment <- c(environment,
                         j)
      }
    }
    if (i == 1) {
      affEnviornment <- list(setdiff(environment, 0))
    } else {
      affEnviornment[affiliationNames[i, 1]] <- list(setdiff(environment, 0))
    }
  }
  return(affEnviornment)
}


sigmaScore <- function(hypergraph, nodeNames, affiliationNames, weights) {
  if (missing(weights)) {
    weights <- rep(1, nrow(affiliationNames))
  }
  sigma <- affiliationMembership <- 0
  activeAffiliations <- unique(hypergraph[, 2])
  for (i in 1:length(unique(hypergraph[, 2]))) {
    affiliationMembership[activeAffiliations[i]] <- length(unique(subset(hypergraph[, 1],
                                                                         hypergraph[, 2] == activeAffiliations[i])))
  }
  for (i in 1:nrow(nodeNames)) {
    sigma[i] <- 0
    affiliations <- subset(hypergraph[, 2],
                           hypergraph[, 1] == nodeNames[i, 1])
    for (j in 1:length(affiliations)) {
      sigma[i] <- sigma[i] + (weights[affiliations[j]]/affiliationMembership[affiliations[j]])
    }
  }
  return(round(sigma, digits = 3))
}


normSigmaScore <- function(hypergraph, nodeNames, affiliationNames, weights) {
  if (missing(weights)) {
    weights <- rep(1,
                   nrow(affiliationNames))
  }
  sigma <- sigmaScore(hypergraph,
                      nodeNames,
                      affiliationNames,
                      weights)
  sigma <- sigma/sum(weights)
  return(sigma)
}


sigmaScoreAffiliation <- function(hypergraph, nodeNames, affiliationNames, weights) {
  if (missing(weights)) {
    weights <- rep(1,
                   max(affiliationNames$number))
  }
  sigma <- affiliationMembership <- 0
  activeAffiliations <- unique(hypergraph[, 2])
  affiliationNetwork <- affiliationProjection(hypergraph)
  for (i in 1:length(unique(hypergraph[, 2]))) {
    affiliationMembership[activeAffiliations[i]] <- length(unique(subset(hypergraph[, 1],
                                                                         hypergraph[, 2] == activeAffiliations[i])))
  }
  for (i in 1:nrow(affiliationNames)) {
    sigma[affiliationNames[i, 1]] <- weights[affiliationNames[i, 1]]
    subNetwork <- unique(subset(affiliationNetwork,
                                affiliationNetwork[, 1] == affiliationNames[i, 1]))
    if (nrow(subNetwork) > 0) {
      neighbours <- subNetwork[, 2]
      for (j in 1:length(neighbours)) {
        sigma[affiliationNames[i, 1]] <-
          sigma[affiliationNames[i, 1]] + (weights[neighbours[j]] * (subNetwork[j, 3]/max(affiliationMembership[neighbours[j]], 1)))
      }
    }
  }
  return(sigma)
}


externalInfluence <- function(hypergraph, nodeNames, affiliationNames, weights) {
  if (missing(weights)) {
    weights <- rep(1,
                   nrow(affiliationNames))
  }
  external <- affiliationMembership <- 0
  activeAffiliations <- unique(hypergraph[, 2])
  affiliationNetwork <- affiliationProjection(hypergraph)
  for (i in 1:length(unique(hypergraph[, 2]))) {
    affiliationMembership[activeAffiliations[i]] <- length(unique(subset(hypergraph[, 1],
                                                                         hypergraph[, 2] == activeAffiliations[i])))
  }
  for (i in 1:nrow(affiliationNames)) {
    external[affiliationNames[i, 1]] <- 0
    subNetwork <- unique(subset(affiliationNetwork,
                                affiliationNetwork[, 1] == affiliationNames[i, 1]))
    neighbours <- subNetwork[, 2]

    if (length(neighbours) > 0) {
      for (j in 1:length(neighbours)) {
        external[affiliationNames[i, 1]] <- external[affiliationNames[i, 1]] + (weights[neighbours[j]] * (subNetwork[j, 3]/affiliationMembership[neighbours[j]]))
      }
    }
  }
  return(external)
}

