# Simulating the growth and development of the socio-economic space

## 1 About

This directory provides algorithms that correspond to the simulations of the socio-economic space discussed in Chapter 3 of the monograph. The simulations are written, and therefore executable, in the `Matlab` programming language. As we continue with development we intend to gradually replace these `Matlab` scripts with `R` functions. This replacement will allow for easier reading, debugging and continual development.

## 2 Types of governance system

A governance system refers to a set of institutions--or _rules-of-the-game_--that are used by socio-economic agents to interact with one another. Throughout the analysis we restrict ourselves to the assessment of different exchange mechanisms that represent different systems of governance within the socio-economic space.

We investigate the resulting interaction networks that evolve from the presence of two different exchange mechanisms:

1. Egalitarian exchange mechanism; and 
2. Cournot-Nash exchange mechanism. 

Both exchange mechanisms are quite self-explanatory. Since economic exchange is pairwise within a network, the egalitarian exchange mechanism allocates resources between all pairs of interacting economic agents equally. The Cournot-Nash exchange mechanism simulates a more competitive and efficient economic interaction where demand functions are derived and price levels are generated from the interaction between the demand and supply of the goods being exchanged.

Transaction costs, interaction inefficiencies, are also built into the simulations. So too are the learning effects from specialisation into a given output or socio-economic role. Note that economic agents can form multiple exchange relationships, but will only engage in an economic interaction if it is mutually beneficial to do so.
