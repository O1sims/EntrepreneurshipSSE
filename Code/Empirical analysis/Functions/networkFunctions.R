numberToName <- function(nodeNumbers, nodeNames) {
  translation <- ""
  translation <- sapply(1:length(nodeNumbers), function(x) {
    match <- match(nodeNumbers[x], nodeNames[, 1])
    translation[x] <- as.character(nodeNames[match, 2])
  })
  return(translation)
}


randomGraph <- function(n, p, undirected) {
  if (n < 2) {
    return(print("You need a population of more than 1 node..."))
  }
  if (p < 0  || p > 1) {
    return(print("p can't be below zero or greater than 1..."))
  } else if (p == 0) {
    network <- data.frame(sources = NA,
                          targets = NA)
    return(network)
  } else {
    m <- max(1, n * round(n * p,
                          digits = 0))
  }
  if (missing(undirected)) {
    undirected <- FALSE
  }
  network <- data.frame(sources = round(runif(n = m,
                                              min = 1,
                                              max = n),
                                        digits = 0),
                        targets = round(runif(n = m,
                                              min = 1,
                                              max = n),
                                        digits = 0))
  network <- unique(network[,])
  for (i in 1:nrow(network)) {
    if (network$sources[i] == network$targets[i]) {
      network[i, ] <- 0
    }
  }
  row_sub <- apply(network, 1, function(row) all(row != 0))
  network <- network[row_sub, ]
  if (nrow(network) < m) {
    while (nrow(network) < m) {
      buffer <- m - nrow(network)
      addNetwork <- data.frame(sources = round(runif(n = buffer,
                                                     min = 1,
                                                     max = n),
                                               digits = 0),
                               targets = round(runif(n = buffer,
                                                     min = 1,
                                                     max = n),
                                               digits = 0))
      addNetwork <- unique(addNetwork[,])
      for (i in 1:nrow(addNetwork)) {
        if (addNetwork$sources[i] == addNetwork$targets[i]) {
          addNetwork[-i, ] <- 0
        }
      }
      if (0 %in% addNetwork$sources) {
        row_sub <- apply(addNetwork, 1, function(row) all(row != 0))
        addNetwork <- addNetwork[row_sub, ]
      }
      network <- rbind(network, addNetwork)
      network <- unique(network[,])
    }
  }
  if (undirected == TRUE) {
    unNetwork <- data.frame(sources = network$targets,
                            targets = network$sources)
    network <- rbind(network, unNetwork)
  }
  return(network)
}


adjacenyMatrix <- function(network, nodeNames) {
  networkMatrix <- matrix(data = 0L,
                          nrow = nrow(nodeNames),
                          ncol = nrow(nodeNames))
  for (i in 1:nrow(network)) {
    networkMatrix[network[i, 1], network[i, 2]] <- networkMatrix[network[i, 1], network[i, 2]] + 1
  }
  return(networkMatrix)
}


isUndirected <- function(network, nodeNames, adjMatrix) {
  if (missing(adjMatrix)) {
    adjMatrix <- adjacenyMatrix(network,
                                nodeNames)
  }
  return(FALSE %in% (adjMatrix == t(adjMatrix)) == FALSE)
}


undirectedAdjMatrix <- function(network, nodeNames, adjMatrix) {
  if (missing(adjMatrix)) {
    adjMatrix <- adjacenyMatrix(network,
                                nodeNames)
  }
  adjMatrix <- adjMatrix + t(adjMatrix)
  adjMatrix[, ] <- !adjMatrix %in% c("0", "FALSE")
  return(adjMatrix)
}


adjacenyDF <- function(network, nodeNames) {
  networkDF <- adjacenyMatrix(network = network,
                              nodeNames = nodeNames)
  networkDF <- as.data.frame.matrix(networkDF)
  colnames(networkDF) <- rownames(networkDF) <- nodeNames[, 2]
  return(networkDF)
}


degree <- function(network, nodeNames) {
  inDeg <- outDeg <- degree <- 0
  for (i in 1:nrow(nodeNames)) {
    inDeg[i] <- sum(network[, 2] == i)
    outDeg[i] <- sum(network[, 1] == i)
    neighbours <- c(subset(network[, 2],
                           network[, 1] == i),
                    subset(network[, 1],
                           network[, 2] == i))
    degree[i] <- length(unique(neighbours))
  }
  deg <- data.frame(name = nodeNames[, 2],
                    inDegree = inDeg,
                    outDegree = outDeg,
                    degree = degree)
  return(deg)
}


degreeDistribution <- function(network, nodeNames) {
  deg <- degree(network, nodeNames)
  degDistPlot <- ggplot(deg,
                        aes(x = deg$degree)) +
    geom_histogram(binwidth = 0.5,
                   alpha = 0.8) +
    labs(title = "Degree distribution",
         x = "Degree",
         y = "Count") +
    theme(legend.position = "none")
  return(degDistPlot)
}


connectivity <- function(network, nodeNames, adjMatrix) {
  if (missing(adjMatrix)) {
    adjMatrix <- adjacenyMatrix(network,
                                nodeNames)
  }
  adjMatrix[, ] <- !adjMatrix %in% c("0", "FALSE")
  for (i in 1:nrow(adjMatrix)) {
    adjMatrix <- adjMatrix + (adjMatrix %^% i)
    adjMatrix[, ] <- !adjMatrix %in% c("0", "FALSE")
  }
  for (i in 1:nrow(adjMatrix)) {
    adjMatrix[i, i] <- 0
  }
  k <- sum(adjMatrix)
  return(k)
}


predecessorsSuccessors <- function(network, nodeNames, adjMatrix) {
  if (missing(adjMatrix)) {
    adjMatrix <- adjacenyMatrix(network, nodeNames)
  }
  adjMatrix[, ] <- !adjMatrix %in% c("0", "FALSE")
  for (i in 1:nrow(adjMatrix)) {
    adjMatrix <- adjMatrix + (adjMatrix %^% i)
    adjMatrix[, ] <- !adjMatrix %in% c("0", "FALSE")
  }
  for (i in 1:nrow(adjMatrix)) {
    adjMatrix[i, i] <- 0
  }
  noSuccessors <- noPredecessors <- 0
  for (i in 1:nrow(adjMatrix)) {
    noSuccessors[i] <- length(which(adjMatrix[i, ] == 1))
    noPredecessors[i] <- length(which(adjMatrix[, i] == 1))
  }
  adjMatrix <- adjacenyMatrix(network, nodeNames)
  noPredecessorsSuccessors <- data.frame(nodeNumber = seq(1, nrow(adjMatrix)),
                                         nodeName = nodeNames[, 2],
                                         noPred = noPredecessors,
                                         noSucc = noSuccessors)
  return(noPredecessorsSuccessors)
}


potentialBrokerage <- function(network, nodeNames, adjMatrix) {
  d <- degree(network, nodeNames)
  PS <- predecessorsSuccessors(network, nodeNames, adjMatrix)
  potBrokerage <- 0
  for (i in 1:nrow(nodeNames)) {
    potBrokerage <- potBrokerage + (PS$noSucc[i] - d$outDegree[i])
  }
  potBrokerage <- max(potBrokerage, 1)
  return(potBrokerage)
}


middlemanPower <- function(network, nodeNames, adjMatrix, normalised) {
  if (missing(adjMatrix)) {
    originalAdjMatrix <- adjMatrix <- adjacenyMatrix(network, nodeNames)
  } else {
    originalAdjMatrix <- adjMatrix
  }
  if (missing(normalised)) {
    normalised <- FALSE
  }
  PS <- predecessorsSuccessors(network = network,
                               nodeNames = nodeNames,
                               adjMatrix = adjMatrix)
  K <- connectivity(adjMatrix = originalAdjMatrix)
  power <- 0
  for (i in 1:nrow(adjMatrix)) {
    adjMatrix <- originalAdjMatrix
    adjMatrix[i, ] <- adjMatrix[, i] <- 0
    kappa <- connectivity(adjMatrix = adjMatrix)
    power[i] <- K - kappa - PS$noPred[i] - PS$noSucc[i]
  }
  if (normalised == TRUE) {
    potBroker <- potentialBrokerage(network,
                                    nodeNames)
    power <- round(power/as.integer(potBroker),
                   digits = 3)
  }
  return(power)
}


strongWeak <- function(network, nodeNames, adjMatrix) {
  if (missing(adjMatrix)) {
    adjMatrix <- adjacenyMatrix(network, nodeNames)
  }
  power <- middlemanPower(network, nodeNames, adjMatrix)
  unAdjMatrix <- undirectedAdjMatrix(network, nodeNames, adjMatrix)
  unPower <- middlemanPower(network, nodeNames, unAdjMatrix)
  middlemanType <- sapply(1:length(power), function(x) {
    if (unPower[x] == 0 & power[x] == 0) {
      "Non-middleman"
    } else if (unPower[x] == 0 & power[x] > 0) {
      "Weak middleman"
    } else {
      "Strong middleman"
    }
  })
  return(middlemanType)
}


middlemanPowerDetail <- function(network, nodeNames, adjMatrix) {
  if (missing(adjMatrix)) {
    adjMatrix <- adjacenyMatrix(network,
                                nodeNames)
  }
  power <- middlemanPower(network,
                          nodeNames,
                          adjMatrix)
  normPower <- round(power/as.integer(potentialBrokerage(network,
                                                         nodeNames)),
                     digits = 3)
  type <- strongWeak(network,
                     nodeNames,
                     adjMatrix)
  details <- data.frame(number = nodeNames[, 1],
                        name = nodeNames[, 2],
                        power = power,
                        normPower = normPower,
                        type = type)
  return(details)
}


setPredSucc <- function(network, nodeNames, s, adjMatrix, approximate) {
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (s > nrow(nodeNames) - 2) {
    return(print("s must be less than or equal to number of nodes in network minus 2 [s <= nrow(nodeNames) - 2]"))
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  if (missing(adjMatrix)) {
    adjMatrix <- adjacenyMatrix(network,
                                nodeNames)
  }
  adjMatrix[, ] <- !adjMatrix %in% c("0", "FALSE")
  for (i in 1:nrow(adjMatrix)) {
    adjMatrix <- adjMatrix + (adjMatrix %^% i)
    adjMatrix[, ] <- !adjMatrix %in% c("0", "FALSE")
  }
  for (i in 1:nrow(adjMatrix)) {
    adjMatrix[i, i] <- 0
  }
  time <- Sys.time()
  for (i in 1:s) {
    sets <- combn(seq(1:nrow(adjMatrix)),
                  m = i)
    if (approximate == TRUE) {
      if (ncol(sets) > 500000) {
        sets <- sets[, sample(ncol(sets))]
        sets <- sets[, sample(1:ncol(sets),
                              size = 500000,
                              replace = FALSE)]
      }
    }
    print(paste0("s = ", i, ". Analysing ", ncol(sets)," sets."))
    for (j in 1:ncol(sets)) {
      set <- sets[, j]
      successors <- predecessors <- noSucc <- noPred <- 0
      for (k in 1:i) {
        successors <- c(successors,
                        which(adjMatrix[set[k], ] == 1))
        predecessors <- c(predecessors,
                          which(adjMatrix[, set[k]] == 1))
      }
      if (length(successors) > 1) {
        successors <- setdiff(unique(successors),
                              c(set, 0))
        noSucc <- length(successors)
      } else {
        successors <- noSucc <- 0
      }
      if (length(predecessors) > 1) {
        predecessors <- setdiff(unique(predecessors),
                                c(set, 0))
        noPred <- length(predecessors)
      } else {
        predecessors <- noPred <- 0
      }
      if (i == 1 & j == 1 & k == 1) {
        PS <- list(set = list(set),
                   setSize = i,
                   successors = list(successors),
                   predecessors = list(predecessors),
                   noSucc = list(noSucc),
                   noPred = list(noPred))
      } else {
        a <- list(set = list(set),
                  setSize = i,
                  successors = list(successors),
                  predecessors = list(predecessors),
                  noSucc = list(noSucc),
                  noPred = list(noPred))
        PS <- rbindlist(list(PS, a), use.names = TRUE, fill = TRUE)
      }
    }
    print(paste0("Finished s = ", i, " (Time taken ", Sys.time() - time,")"))
  }
  return(PS)
}


coverage <- function(network, nodeNames, s, adjMatrix, setPS, perCapita, approximate) {
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  if (missing(perCapita)) {
    perCapita <- FALSE
  }
  if (missing(adjMatrix)) {
    originalAdjMatrix <- adjMatrix <- adjacenyMatrix(network, nodeNames)
  } else {
    originalAdjMatrix <- adjMatrix
  }
  if (missing(setPS)) {
    setPS <- setPredSucc(network, nodeNames, s, adjMatrix, approximate = approximate)
  }
  ps <- setPredSucc(network,
                    nodeNames,
                    s = 1)
  coverage <- 0
  for (i in 1:nrow(setPS)) {
    for (h in 1:length(setPS$set[[i]])) {
      if (h == 1) {
        cov <- expand.grid(c(setdiff(ps$predecessors[[setPS$set[[i]][h]]], setPS$set[[i]])), c(setdiff(ps$successors[[setPS$set[[i]][h]]], setPS$set[[i]])))
      } else {
        cov <- rbind(cov, expand.grid(c(setdiff(ps$predecessors[[setPS$set[[i]][h]]], setPS$set[[i]])), c(setdiff(ps$successors[[setPS$set[[i]][h]]], setPS$set[[i]]))))
      }
    }
    row_sub = apply(cov, 1, function(row) all(row != 0))
    cov <- cov[row_sub, ]
    if (nrow(cov) > 0) {
      for (j in 1:nrow(cov)) {
        if (cov[j, 1] == cov[j, 2]) {
          cov[j, 1] <- cov[j, 2] <- 0
        }
      }
    }
    row_sub = apply(cov, 1, function(row) all(row != 0))
    cov <- cov[row_sub, ]
    coverage[i] <- nrow(unique(cov[, ]))
  }
  setPS$coverage <- coverage
  return(setPS)
}


# Brokerage of node set `perCapita` generates the Brokerage measure
blockPower <- function(network, nodeNames, s, adjMatrix, setPS, perCapita, approximate) {
  if (missing(adjMatrix)) {
    originalAdjMatrix <- adjMatrix <- adjacenyMatrix(network,
                                                     nodeNames)
  } else {
    originalAdjMatrix <- adjMatrix
  }
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  if (missing(perCapita)) {
    perCapita <- FALSE
  }
  if (missing(setPS)) {
    setPS <- setPredSucc(network,
                         nodeNames,
                         s,
                         adjMatrix,
                         approximate = approximate)
  }
  K <- connectivity(adjMatrix = originalAdjMatrix)
  setPS$power <- 0
  for (i in 1:nrow(setPS)) {
    adjMatrix <- originalAdjMatrix
    K <- allSucc <- 0
    for (j in 1:nrow(nodeNames)) {
      if (!(length(setPS$successors[[j]]) == 0 || setPS$successors[[j]] == 0)) {
        if (!(j %in% setPS$set[[i]])) {
          inSet <- setPS$set[[i]] %in% setPS$successors[[j]]
          noSet <- sum(inSet == TRUE)
          if (noSet > 0) {
            l <- length(setPS$successors[[j]]) - noSet + 1
            K <- K + l
          } else {
            K <- K + length(unique(setPS$successors[[j]]))
          }
        } else {
          allSucc <- c(allSucc, setPS$successors[[j]])
        }
      }
    }
    K <- K + length(setdiff(unique(allSucc), setPS$set[[i]])) - 1
    for (j in 1:length(setPS$set[[i]])) {
      adjMatrix[setPS$set[[i]][j], ] <- adjMatrix[, setPS$set[[i]][j]] <- 0
    }
    kappa <- connectivity(adjMatrix = adjMatrix)
    setPS$power[i] <- K - kappa - setPS$noSucc[[i]] - setPS$noPred[[i]]
    print(paste0("i = ", i))
  }
  potBroker <- potentialBrokerage(network = network, nodeNames = nodeNames)
  setPS$power <- round(setPS$power/1,
                       digits = 3)
  if (perCapita == TRUE) {
    setPS$powerCapita <- round(setPS$power/setPS$setSize,
                               digits = 3)
  } else {
    setPS$powerCapita <- setPS$power
  }
  return(setPS)
}


# Return all critical sets of network
criticalSets <- function(network, nodeNames, s, adjMatrix, setPS, setPower, approximate) {
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  if (missing(setPower)) {
    setPower <- blockPower(network,
                           nodeNames,
                           s,
                           adjMatrix,
                           setPS,
                           perCapita = TRUE,
                           approximate = approximate)
  }
  criticalSets <- subset(setPower,
                         setPower$power > 0)
  return(criticalSets)
}


# Coverage measure (\gamma(B))
coverageMeasure <- function(network, nodeNames, s, adjMatrix, setPS, setPower, approximate) {
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  crits <- criticalSets(network,
                        nodeNames,
                        s,
                        approximate = approximate)
  critsCov <- coverage(network,
                       nodeNames,
                       s,
                       setPS = crits)
  critsCov$coverageMeasure <- round(critsCov$coverage/critsCov$setSize,
                                    digits = 3)
  return(critsCov)
}


# SNE for block game
blockSNE <- function(network, nodeNames, c, s, adjMatrix, setPS, setPower, approximate) {
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  if (missing(setPower)) {
    setPower <- blockPower(network,
                           nodeNames,
                           s,
                           adjMatrix,
                           setPS,
                           perCapita = TRUE,
                           approximate = approximate)
  }
  if (missing(c)) {
    c <- 0
  }
  setPower$powerCapita <- setPower$powerCapita - (c * (setPower$setSize - 1))
  setPower <- subset(setPower,
                     setPower$powerCapita > 0)
  setPower <- setPower[order(-setPower$powerCapita), ]
  for (i in 1:(nrow(setPower) - 1)) {
    for (j in (i + 1):nrow(setPower)) {
      if (setPower$setSize[j] != 0) {
        if (TRUE %in% (setPower$set[[i]] %in% setPower$set[[j]])) {
          setPower$set[[j]] <- setPower$setSize[j] <- 0
        }
      }
    }
  }
  SNE <- setPower[!(setPower$setSize == 0), ]
  return(SNE)
}


# Criticality Measure (\rho(B))
criticalityMeasure <- function(network, nodeNames, s, adjMatrix, setPS, setPower, approximate) {
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  critMeasure <- blockSNE(network,
                          nodeNames,
                          s = s,
                          approximate = approximate)
  colnames(critMeasure) <- c("set", "setSize", "successors", "predecessors", "noSucc",
                             "noPred", "criticality", "criticalityMeasure")
  return(critMeasure)
}


# \overline{\beta}_i
nodeSetBrokerage <- function(network, nodeNames, s, perCapita, adjMatrix, setPS, setPower, approximate) {
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (missing(perCapita)) {
    perCapita <- TRUE
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  setBrokerage <- blockPower(network,
                             nodeNames,
                             s = s,
                             perCapita = perCapita,
                             approximate = approximate)
  nodeSetBrokerage <- 0
  for (i in 1:nrow(nodeNames)) {
    r <- setBrokerage
    t <- sapply(1:nrow(r), function(x) i %in% r$set[[x]])
    r <- r[t, ]
    nodeSetBrokerage[i] <- sum(r$powerCapita)
  }
  nodeSetBrokerage <- round(nodeSetBrokerage/sum(setBrokerage$powerCapita),
                            digits = 3)
  return(nodeSetBrokerage)
}


# \widehat{\rho}_i
nodeCriticality <- function(network, nodeNames, s, adjMatrix, setPS, setPower, approximate) {
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  critMeasure <- criticalityMeasure(network,
                                    nodeNames,
                                    s = s,
                                    approximate = approximate)
  nodeCriticality <- 0
  for (i in 1:nrow(nodeNames)) {
    r <- critMeasure
    t <- sapply(1:nrow(r), function(x) i %in% r$set[[x]])
    r <- r[t, ]
    if (nrow(r) > 0) {
      nodeCriticality[i] <- sum(r$criticalityMeasure)
    } else {
      nodeCriticality[i] <- 0
    }
  }
  return(nodeCriticality)
}


# \overline{\rho}_i
nodeNormCriticality <- function(network, nodeNames, s, adjMatrix, setPS, setPower, approximate) {
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  critMeasure <- criticalityMeasure(network,
                                    nodeNames,
                                    s = s,
                                    approximate = approximate)
  normaliser <- sum(critMeasure$criticalityMeasure)
  nodeNormCriticality <- 0
  for (i in 1:nrow(nodeNames)) {
    r <- critMeasure
    t <- sapply(1:nrow(r), function(x) i %in% r$set[[x]])
    r <- r[t, ]
    if (nrow(r) > 0) {
      nodeNormCriticality[i] <- sum(r$criticalityMeasure)
    } else {
      nodeNormCriticality[i] <- 0
    }
  }
  nodeNormCriticality <- round(nodeNormCriticality/normaliser,
                               digits = 3)
  return(nodeNormCriticality)
}


# \overline{\gamma}_i
nodeCoverage <- function(network, nodeNames, s, adjMatrix, setPS, setPower, approximate) {
  if (missing(s)) {
    s <- nrow(nodeNames) - 2
  }
  if (missing(approximate)) {
    approximate <- FALSE
  }
  coverage <- coverageMeasure(network,
                              nodeNames,
                              s,
                              approximate = approximate)
  normaliser <- sum(coverage$coverageMeasure)
  nodeNormCoverage <- 0
  for (i in 1:nrow(nodeNames)) {
    r <- coverage
    t <- sapply(1:nrow(r), function(x) i %in% r$set[[x]])
    r <- r[t, ]
    if (nrow(r) > 0) {
      nodeNormCoverage[i] <- sum(r$coverageMeasure)
    } else {
      nodeNormCoverage[i] <- 0
    }
  }
  nodeNormCoverage <- round(nodeNormCoverage/normaliser,
                            digits = 3)
  return(nodeNormCoverage)
}


# \beta_{i}(D) Beta measure (Gilles and van den Brink)
# This is a generalised measure and will take in a weighted network
betaMeasure <- function(network, nodeNames) {
  inDeg <- Beta <- 0
  for (i in 1:nrow(nodeNames)) {
    inDeg[i] <- sum(network[, 2] == i)
  }
  for (i in 1:nrow(nodeNames)) {
    Beta[i] <- 0
    successorSet <- subset(network,
                           network[, 1] == i)
    successorSet <- successorSet[, 2]

    if (length(successorSet) > 0) {
      for (j in 1:length(successorSet)) {
        Beta[i] <- Beta[i] + (1/inDeg[successorSet[j]])
      }
    }
  }
  if (sum(Beta) == sum(inDeg > 0)) {
    return(round(Beta, digits = 3))
  } else {
    return(print("We made a mistake in the calculation. HALP!"))
  }
}
