library(car)
library(stringr)
library(ggplot2)
library(DataExplorer)

summary(crime_v2$polpc)
summary(crime_v2$taxpc)
summary(crime_v2$density)
summary(crime_v2$crmrte)

hist(crime_v2$polpc, main = "Histogram of Police per Capita", 
     xlab = NULL)

hist(crime_v2$taxpc, main = "Histogram of Tax Revenue per Capita", 
     xlab = NULL)

hist(crime_v2$density, main = "Histogram of People per Sq Mile", 
     xlab = NULL)

hist(crime_v2$crmrte, main = "Histogram of Crimes committed per Capita", 
     xlab = NULL)

#Crime vs Police PC
plot(crime_v2$polpc, crime_v2$crmrte, xlab = "Police per Capita", 
     ylab = "Crime Rate per Capita", main = "Crimes committed per Capita vs. Police per Capita")
abline(lm(crime_v2$crmrte ~ crime_v2$polpc))


# Crime vs. Taxes
plot(crime_v2$taxpc, crime_v2$crmrte, xlab = "Tax Revenue per Capita", 
     ylab = "Crime Rate per Capita", main = "Crimes committed per Capita vs. Tax Revenue per Capita")
abline(lm(crime_v2$crmrte ~ crime_v2$taxpc))


# Crime vs. Population Density
plot(crime_v2$density, crime_v2$crmrte, xlab = "Population per Square Mile", 
     ylab = "Crime Rate per Capita", main = "Crimes committed per Capita vs. Population Density")
abline(lm(crime_v2$crmrte ~ crime_v2$density))


(model1 = lm(crmrte ~ polpc, data = crime_v2))
(model2 = lm(crmrte ~ taxpc, data = crime_v2))
(model3 = lm(crmrte ~ density, data = crime_v2))