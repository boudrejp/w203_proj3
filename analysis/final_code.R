# code from final async report
# sanity checks to make sure things work

# block 1
data <- read.csv("../data/crime_v2.csv")
# summary(data) # alternate means to explore data
str(data)

#block 2
county <- data$county
data$county <- NULL
year <- data$year
data$year <- NULL

# block 3
data$prbconv

# block 4
data$prbconv <- as.numeric(as.character(data$prbconv))


#block 5
na.rows <- lapply(data, function(x){which(is.na(x))})
na.rows


# block 6
data <- data[-c(92:97),]

# block 7
# command for running all boxplots, histograms for all variables 
# for(i in 1:ncol(data)){
#   if(is.numeric(data[[i]])){
#     hist(data[[i]], breaks = 15, main = colnames(data)[i])
#     boxplot(data[[i]], main = colnames(data)[i]
#   }
# }

# commands for exploring prbconv, prbarr
par(mfrow = c(1,2))
hist(data$prbconv, breaks = 20, main = 'prbconv')
hist(data$prbarr, breaks = 20, main = 'prbarr')

# block 8
# basic stats for sanity
mean(data$wser, na.rm = TRUE)
median(data$wser, na.rm = TRUE)
par(mfrow = c(1,1))
boxplot(data$wser, main = 'wser')


# calculate IQR outlying-ness
third.q <- as.numeric(summary(data$wser)[5]) # this is 3rd quartile
iqr.wser <- IQR(data$wser)
times.iqr <- (max(data$wser) - third.q)/iqr.wser
print(paste("outlier is", times.iqr, 
            "times the inter-quartile range away from 3rd quartile"))

# let's set our major outlier to NA just for wser
data$wser[data$wser > 1500] <- NA

# block 9
par(mfrow = c(1,2))
hist(data$crmrte, main = 'Crime Rate')
hist(log(data$crmrte), main = 'Log Transform of Crime Rate')
data$log.crmrte <- log(data$crmrte)

# block 10
par(mfrow = c(1,3))
hist(data$polpc, main = "Histogram of Police per Capita", 
     xlab = NULL)
hist(data$taxpc, main = "Histogram of Tax Revenue per Capita", 
     xlab = NULL)
hist(data$density, main = "Histogram of People per Sq Mile", 
     xlab = NULL)
print(paste0('polpc | median: ', median(data$polpc), 
             ' | mean: ', mean(data$polpc),
             ' | max: ', max(data$polpc)))
print(paste0('taxpc | median: ', median(data$taxpc), 
             ' | mean: ', mean(data$taxpc),
             ' | max: ', max(data$taxpc)))
print(paste0('polpc | median: ', median(data$density), 
             ' | mean: ', mean(data$density),
             ' | max: ', max(data$density)))

# block 11
par(mfrow = c(2,3))
hist(data$avgsen, main = "Histogram of Average Sentence Length (Days)", 
     xlab = NULL)
hist(data$wsta, main = "Histogram of Weekly NC State Salaries", 
     xlab = NULL)
hist(data$central, main = "Central", 
     xlab = NULL)
hist(data$urban, main = "Urban", 
     xlab = NULL)
hist(data$west, main = "West", 
     xlab = NULL)
print(paste0('avgsen | median: ', median(data$avgsen), 
             ' | mean: ', mean(data$avgsen),
             ' | max: ', max(data$avgsen)))
print(paste0('wsta | median: ', median(data$wsta), 
             ' | mean: ', mean(data$wsta),
             ' | max: ', max(data$wsta)))
print(paste0('central | mean: ', mean(data$central)))
print(paste0('urban | mean: ', mean(data$urban)))
print(paste0('west | mean: ', mean(data$west)))

# block 12
par(mfrow = c(1,1))
plot(data$polpc, log(data$crmrte), xlab = "police per capita", 
     ylab = "crime rate", main = "police per capita vs. crime rate")
linear.model.1 <- lm(log(crmrte) ~ polpc, data = data)
abline(linear.model.1, col = "red")
print(paste0("R squared: ", summary(linear.model.1)$r.square))
print("Coefficients: ")
linear.model.1$coefficients

# block 13
# row for outlier
print("Data from the row with the outlier:")
print(data[data$polpc > 0.006,])

# medians for comparison
print("The median values for our data:")
print(apply(data, 2, function(x){median(x, na.rm = TRUE)}))

# block 14

plot(linear.model.1, which = 5)

# block 15
par(mfrow = c(1,3))
plot(linear.model.1, which = 1) # residuals vs fitted plot 
plot(linear.model.1, which = 3) # scale-location plot 
plot(linear.model.1, which = 2) # normal qq plot


# block 16
library(lmtest)
library(sandwich)

coeftest(linear.model.1, vcov = vcovHC)

# block 16.1
data$log.polpc <- log(data$polpc)
par(mfrow = c(1,1))
hist(data$log.polpc, breaks = 15, main = "Log Transform of Police per Capita")

# block 17
library(car)
scatterplotMatrix(~ density + log.polpc + taxpc, data = data)


# block 18
linear.model.2 <- lm(log.crmrte ~ density + log.polpc + taxpc, data = data)
print("Coefficients:")
linear.model.2$coefficients

# block 19
par(mfrow = c(1,3))
plot(linear.model.2, which = 1)
plot(linear.model.2, which = 3)
plot(linear.model.2, which = 2)

# block 19.1
par(mfrow = c(1,1))
plot(linear.model.2, which = 5)

# block 20
coeftest(linear.model.2, vcov = vcovHC)


# block 21
plot(linear.model.2, which = 5)

# block 22
# creation of polpc * density
data$polpc.density <- data$polpc * data$density

library(corrplot)
corrplot.data <- data[,c('density', 'log.polpc', 'taxpc', 
                         'avgsen', 'west', 'urban', 'central', 'wsta', 'polpc.density')]
corrplot(cor(corrplot.data), type = "upper")

# block 23
linear.model.3 <- lm(log.crmrte ~ 
                       density + log.polpc + taxpc + west + central + 
                       urban + wsta + avgsen + polpc.density, data = data)
print("Coefficients:")
linear.model.3$coefficients

# block 23.2
coeftest(linear.model.3, vcov = vcovHC)

# block 24
par(mfrow = c(2,2))
plot(linear.model.3, which = 1)
plot(linear.model.3, which = 3)
plot(linear.model.3, which = 2)
plot(linear.model.3, which = 5)


# block 25
durbinWatsonTest(linear.model.3)

# block 26
# remove urban
linear.model.3.r3 <- lm(log.crmrte ~ 
                       density + log.polpc + taxpc + west + central + 
                       wsta + avgsen + polpc.density, data = data)
print("Coefficients:")
coeftest(linear.model.3.r3, vcov = vcovHC)


### future block for stargazer
compute.robust.errors <- function(linear.model){
  robust.errors <- sqrt(diag(vconvHC(linear.model)))
  return(robust.errors)
}
### replace pars
stargazer(model1, model2, type = 'text', omit.stat = 'f',
          se = list(se1, se2), 
          star.cutoffs = c(0.05, 0.01, 0.001))


