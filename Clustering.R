#################################################################################################
## OZKAN EMRE OZDEMIR                                                                           #
## HOMEWORK 3 : Clustering Assignment, Lecture # 4                                              #
## 07/29/16                                                                                     #
## Class:  Deriving Knowledge from Data at Scale                                                #
#################################################################################################
## 
## An online shopping site has the following primary pages or sections:
## Home, Products, Search, Prod_A, Prod_B, Prod_C, Cart, Purchase.
## A user may browse from "Home" to "Products" and then to one of the
## individual products. The user may also search for a specific product by
## using the "Search" function.
## A visit to "Cart" implies that the user has placed an item in the shopping
## cart, and "Purchase" indicates the user completed the purchase of items
## in the shopping cart.
## The site has collect the hypothetical session data for 100 sessions. This
## data is available in CSV format, Sessions.CSV, on course website.
## Use K-means clustering algorithm to cluster these user sessions into
## segments. 
##################################################################################################
## Clear objects from Memory :
rm(list=ls())
##Clear Console:
cat("\014")

## Set Working Directory
setwd('~/DataAtScale/class4')

##---- Load Libraries
library(stats)
library(datasets)

##-----Load Data-----
sessions = read.csv('Sessions.csv', stringsAsFactors = FALSE)


## Try different clustering runs with various numbers of clusters (e.g.,
## between 4 and 8), and select the result set(s) that seem to best answer as
## many of the following questions as possible.

## First look at the data and run for 4 cluster only
summary(sessions)
results <- kmeans(sessions, 4)
results$size
results$centers

## "One solution often used to identifiy the optimal number of clusters is called the 
## Elbow method and it involves observing a set of possible numbers of clusters relative 
## to how they minimise the within-cluster sum of squares. In other words, the Elbow method 
## examines the within-cluster dissimilarity as a function of the number of clusters."
## https://rpubs.com/FelipeRego/K-Means-Clustering

mydata <- sessions
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var))
        for (i in 2:10) wss[i] <- sum(kmeans(mydata,
                                     centers=i,100)$withinss)
plot(1:10, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares",
     main="Assessing the Optimal Number of Clusters with the Elbow Method",
     pch=20, cex=2)

## Between 4 and 8,  from the example above, we can say that after 6 clusters 
## the observed difference in the within-cluster dissimilarity is not substantial. 

results <- kmeans(sessions, 6)
results$size
results$centers
#################################################################################################
## Question 1A - If a new user is observed to access the following pages:
## Home => Search => Prod_B, according to your clusters, what other
## product should be recommended to this user?

Question_1A <- sessions[ which(sessions$Home==1 & sessions$Search==1 & sessions$Prod_B==1),]
Results_1A <- kmeans(Question_1A, 6, 100)
Results_1A$centers

## Answer 1A : Product A should be reccomended to the user
#################################################################################################
## Question 1B - Explain your answer based on your clustering results. What if the new
## user has accessed the following sequence instead: Products => Prod_C? 

Question_1B <- sessions[ which(sessions$Products==1 & sessions$Prod_C==1),]
Results_1B <- kmeans(Question_1B, 6, 100)
Results_1B$centers

## Answer 1B :Product B should be reccomended to the user
#################################################################################################
## Question 2 - any clustering help us identify casual browsers ("window
## shoppers"), focused browsers (those who seem to know what products
## they are looking for), and searchers (those using the search function to
## find items they want)? If so, are any of these groups show a higher or
## lower propensity to make a purchase?

Question_2 <- sessions[ which(sessions$Products==1 & sessions$Search==1),]
Results_2  <- kmeans(Question_2, 6, 100)
Results_2$centers

## Answer 2 : when user search and check Product C and B at the same time, 
##  they less like to Purchase
## On the other hand, when a user check Product C and A, they will more likely to
## purchase
#################################################################################################
## (Optional Questions)
## Question_3 - Do any of the segments show particular interest in one or more
## products, and if so, can we identify any special characteristics about
## their navigational behavior or their purchase propensity?

Results_3 <- kmeans(sessions, 6)
Results_3$centers

## Answer 3 : Home => Products = > Prod_A and/or Prod_B and/or Prod_C 
#################################################################################################
## Question_4 - If we know that, during the time of data collection, independent
## banner ads had been placed on some popular sites pointing to products A
## and B, can we identify segments corresponding to visitors that respond
## to the ads? If so, can we determine if either of these promotional
## campaigns are having any success?

Question_4 <- sessions[ which(sessions$Prod_A==1 & sessions$Prod_B==1),]
Results_4  <- kmeans(Question_4, 6, 100)
Results_4$centers

## Answer 4 : 50 % successfull 
#################################################################################################
## END