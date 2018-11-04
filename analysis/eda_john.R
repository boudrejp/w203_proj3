# load data
data <- read.csv("../data/crime_v2.csv")

# summary stats, basic visualizations
summary(data)

for(i in 1:ncol(data)){
  if(is.numeric(data[[i]])){
    hist(data[[i]], breaks = 15, main = colnames(data)[i])
    boxplot(data[[i]], breaks = 15, main = colnames(data)[i])
  }
}

# which rows have NA values... these will need treatment

na.rows <- lapply(data, function(x){which(is.na(x))})
# rows 92-97 are NA for all cols except col prbconv


# see which ones are outliers as picked by boxplot... only can do this if it's numeric
iqr.outliers <- lapply(data, function(x){
  if(is.numeric(x)){
    return(boxplot(x)$out)
    } else{
      return(NA)
    }
  })
