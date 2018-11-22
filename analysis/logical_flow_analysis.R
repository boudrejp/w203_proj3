#logical flow of eda / linear models

# target variable is crmrte

#load data

data <- read.csv("../data/crime_v2.csv")

# summary stats, basic visualizations
summary(data)
str(data)

# we only have odd numbered counties
data$county
# this is a categorical variable.. doesn't really make sense to keep it in here

# where are we mising data?
na.rows <- lapply(data, function(x){which(is.na(x))})
na.rows

# nearly all columns are missing data for the last 5 rows
# we can probably get rid of these without losing any loss in fidelity of the data
data <- data[-c(92:97),]

# prbconv had a random asterisk. this was removed by getting rid of the last few rows
# however R still thinks this is a factor. We need to change to numeric
data$prbconv <- as.numeric(as.character(data$prbconv))

# now we have all numerical data
# it makes more sense to think of west, central, and urban as factors
# but we can leave as numeric

# at this point, all of our data makes sense from a formatting point of view.
# let's take a look for outliers

for(i in 1:ncol(data)){
  if(is.numeric(data[[i]])){
    hist(data[[i]], breaks = 15, main = colnames(data)[i])
  }
}

# we are only looking for outliers that we have reason to believe were not generated
# from the same mechanism as the rest of the data, and may be erroneous

# see which ones are outliers as picked by boxplot... only can do this if it's numeric
iqr.outliers <- lapply(data, function(x){
  if(is.numeric(x)){
    return(boxplot(x)$out)
  } 
})
iqr.outliers

# wser looks to have a major outlier
mean(data$wser, na.rm = TRUE)
median(data$wser, na.rm = TRUE)
boxplot(data$wser)
# let's set our major outlier to NA just for wser
data$wser[data$wser > 1500] <- NA

# for prbarr, this is supposed to be a probability
# values above 1 do not make sense
data$prbconv[data$prbconv > 1] <- NA

# county label and year both do not provide us any practical information
# get rid of these to not screw up further analysis
data$county <- NULL
data$year <- NULL

# without knowing more about our data, the rest of the data seem logically consistent

# let's zoom in at our target valiable
hist(data$crmrte)
hist(log(data$crmrte))
# it may make sense here to think about the log transform
# this allows us to talk about relative differences rather than absolute differences
# reference: https://stats.stackexchange.com/questions/18844/when-and-why-should-you-take-the-log-of-a-distribution-of-numbers

# continuing analysis with log transform of crmrte
data$log.crmrte <- log(data$crmrte)
data$crmrte <- NULL

# now let's start looking at correlations
library(corrplot)
cor.matrix <- cor(data, use = "pairwise.complete.obs")
corrplot(cor.matrix, type = "upper")

# prbarr is calculated using crime rate, prbconv using prbarr, and prbpris using prbconv
# for a first pass, we probably want to avoid these as they are covariates

# explore polpc before putting into linear model number 1
summary(data$polpc)
hist(data$polpc, breaks = 15)

# we have one value that appears to be higher than the rest, let's take a look at this value in particular
data[data$polpc > 0.007,]
# this is the value that we manually assigned to have a prbconv to NA.
# We should be skeptical about this point, but given no other context we will keep it

linear.model.1 <- lm(log.crmrte ~ polpc, data = data)
summary(linear.model.1)
plot(x = data$polpc, y = data$log.crmrte,
     main = "Police presence relationship to Log Crime Rate",
     xlab = "Police per capita", ylab = "Log(Crime Rate)")
abline(linear.model.1, col = "red")
plot(linear.model.1, which = 1)

# it appears a few points are weighting our model. let's take them out and see how much better we can get
data2 <- data[data$polpc < 0.0027,]
linear.model.1.2 <- lm(log.crmrte ~ polpc, data = data2)
plot(linear.model.1.2, which = 5)
plot(x = data2$polpc, y = data2$log.crmrte,
     main = "Police presence relationship to Log Crime Rate",
     xlab = "Police per capita", ylab = "Log(Crime Rate)")
abline(linear.model.1.2, col = "red")
# need to ask... is this valid though? can we really take these out??

# explore all of our variables before we put them into linear model 2

library(car)
scatterplotMatrix(~ density + polpc + taxpc, data = data)

# polpc and taxpc appear to be positively correlated
# maybe we look at log transforms?
scatterplotMatrix(~ log(density) + log(polpc) + log(taxpc), data = data)
# this doesn't really help find any relationships. let's just stay with the regular

linear.model.2 <- lm(log.crmrte ~ density + polpc + taxpc, data = data)
summary(linear.model.2)

plot(x = linear.model.2$fitted.values, y =linear.model.2$residuals,
     main = "Model with covariates residuals",
     xlab = "Fitted Value", ylab = "Residual")
abline(h = 0, col = "red")

# now let's just dump all of them in here
linear.model.3 <- lm(log.crmrte ~ density + polpc + taxpc + west + central + wsta + avgsen, data = data)
summary(linear.model.3)

# we have highest r squared value here with this one