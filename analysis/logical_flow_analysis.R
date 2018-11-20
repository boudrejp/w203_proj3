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

# density appears to have a strong correlation with log crimerate
# pctymle also appears to be close to independent of most other variables, let's try this

linear.model.1 <- lm(log.crmrte ~ density + pctymle, data = data)
summary(linear.model.1)

# now let's look at adding a few more terms
# pctmin80 should be largely independent here and i think could help
# wages all appear to be correlated with density... probably will absorb some causality. keep them out
# polpc should decrease crime and be relatively independent of others
# taxpc might be correlated with polpc but is independent of all others more or less

linear.model.2 <- lm(log.crmrte ~ density + pctymle + polpc + taxpc + pctmin80, data = data)
summary(linear.model.2)

# now let's just dump all of them in here
linear.model.3 <- lm(log.crmrte ~ ., data = data)
summary(linear.model.3)

# we have highest r squared value here with this one