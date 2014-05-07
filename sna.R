
library(sna)

# generate a random graph with 20 nodes with edge probability = 0.1
g <- rgraph(20, tprob = 0.1)

#visualize and see the network look like
gplot(g)

# check the in-degreae distribution
degree(g, cmode="indegree")

# check the out-degree distribution
degree(g,cmode="outdegree")

# compute closeness centrality
closeness(g)

# compute betweenness centrality
betweenness(g)

# eigenvector centrality
evcent(g)

# see how the density of a network is (i.e. the sum of tie values divided by the number of possible ties)
gden(g)

# Calculate the dyadic reciprocity of a graph (which is the proportion of dyads are symmetric)
grecip(g, measure = "edgewise")

# calculate the transitivity of a graph
gtrans(g)

# calculate the centralization of a network (i.e. how centrality distribute in a graph) using outdegree
centralization(g, degree, cmode= "outdegree")

# calculate the centralization of a network (i.e. how centrality distribute in a graph) using betweenness
centralization(g, betweenness)

# compute the Krackhardt efficiency scores
efficiency(g)

#compute Krackhardt connectedness scores
connectedness(g)

# compute Krackhardt hierarchy scores
hierarchy(g)

# calculate a reachability matrices from the network g
reachability(g)

# Compute a Holland and Leinhardt dyad census to see how the graph is connected
dyad.census(g)

# Compute the Davis and Leinhardt triad census to see how different types of triads distribute
triad.census(g)

# see how the network can be divided into several components
component.dist(g)

# generate another graph
g2 <- rgraph(20)

# compare and see how these two graphs correlate using product-moment correlation
gcor(g, g2)

# find the product-moment structural correlation between adjacency matrics
gscor(g, g2)



