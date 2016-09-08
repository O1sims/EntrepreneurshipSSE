N <- 100
learningEffectX <- 1
learningEffectY <- 2
cost <- 0
roles <- c(1,2,3,4)


egalitarianTrade <- function(N, learningEffectX, learningEffectY, autarky, cost, roles) {
  
  I <- matrix(c(learningEffectX, 0, 0, learningEffectY, autarky, autarky),
              nrow = 3,
              ncol = 2,
              byrow = TRUE)
  
  C <- c(0, learningEffectY)
  
  S <- data.frame(agents = seq(1:N),
                  specialisations = rep(roles[2], N))
  
  U <- data.frame(agents = seq(1:N),
                  utility = rep(0, N))
  
  g <- data.frame(sources = NA,
                  targets = NA)
  
  for (i in 2:N) {
    
    consumptionX <- consumptionY <- matrix(0L,
                                           nrow = N,
                                           ncol = length(roles))
    
    utility <- rbind(matrix(0L,
                            nrow = N,
                            ncol = length(roles)),
                     c(roles))
    
    
  }
  
  
  
}
