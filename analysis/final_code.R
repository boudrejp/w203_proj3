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
print(paste0('polpc | median: ', median(data$polpc), ' | mean: ', mean(data$polpc)))
print(paste0('taxpc | median: ', median(data$taxpc), ' | mean: ', mean(data$taxpc)))
print(paste0('polpc | median: ', median(data$density), ' | mean: ', mean(data$density)))

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

# block 12


                  
