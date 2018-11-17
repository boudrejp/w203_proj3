# load data
data <- read.csv("../data/crime_v2.csv")

# summary stats, basic visualizations
summary(data)
str(data)
#prbconv looks like it has some funky values
#according to documentation, it should be a probability


for(i in 1:ncol(data)){
  if(is.numeric(data[[i]])){
    hist(data[[i]], breaks = 15, main = colnames(data)[i])
    boxplot(data[[i]], breaks = 15, main = colnames(data)[i])
  }
}
#wser looks suspect for outliers
#urban, central, west, county perhaps needs to be translated to a factor
#taxpc looks suspect for outlier
#density looks liek candidate for log transform lol jk no
#polpc looks either log transform or outlier


# which rows have NA values... these will need treatment

na.rows <- lapply(data, function(x){which(is.na(x))})
# rows 92-97 are NA for all cols except col prbconv. can probably get rid of these


# see which ones are outliers as picked by boxplot... only can do this if it's numeric
iqr.outliers <- lapply(data, function(x){
  if(is.numeric(x)){
    return(boxplot(x)$out)
    } 
  })

### processing variables

# remove majority NA rows
data <- data[-c(92:97),]

