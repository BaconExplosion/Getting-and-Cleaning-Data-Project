 input <- readline("Before continuing, make sure your working directory is set 
 to the root of UCI HAR Dataset directory. Press Enter to continue")

##load necessary packages and data
require(reshape2)
require(dplyr)
require(data.table)
feature.labels <- as.vector(read.table("features.txt")$V2)
activity.key <- read.table("activity_labels.txt")

# build necessary functions
createHeaderLabels <- function(x) {
  # args
  #   x: a data frame whose header needs to be relabeled to the names listed 
  #      in the features.txt file
  # returns
  #   a data frame where the header is relabeled based on the features.txt file
  
  labeled <- setnames(x, old = colnames(x), new = c("subject", "activity", feature.labels))
  return(labeled)
}
labelActivities <- function(y) {
  # args: 
  #   x: a data frame where the activity codes are in the 2nd column
  # returns:
  #   a data frame where the activity codes are replaced by the corresponding activity in 
  #   activity.labels
  names(activity.key) <- c("activity", "activity.name")
  named.activities <- left_join(y, activity.key, by = "activity", match = 'all')
  named.activities$activity <- named.activities$activity.name
  return(named.activities)
  #return(select(named.activities, -activity.name))
  
  }

## build the training set
setwd(paste(getwd(), "/", "train", sep=""))
data.train <- read.table("X_train.txt")
subject.train <- read.table("subject_train.txt")
activity.labels <- read.table("y_train.txt")

train <- data.frame(subject.train, activity.labels, data.train)

train.labeled <- createHeaderLabels(train)
train.full.labeled <- labelActivities(train.labeled)


setwd("..")

## build the test set

setwd(paste(getwd(), "/", "test", sep=""))
data.test <- read.table("X_test.txt")
subject.test <- read.table("subject_test.txt")
activity.test <- read.table("y_test.txt")

test <- data.frame(subject.test, activity.test, data.test)
test.labeled <- createHeaderLabels(test)
test.full.labeled <- labelActivities(test.labeled)

setwd("..")

## merge train and test

merged.activity <- rbind(train.full.labeled, test.full.labeled)

## find mean and std columns and select for them
mean.index <- grep("[Mm]ean|[Ss]td", names(merged.activity))
merged.selected <- merged.activity[ , c(1, 2, mean.index)]

melted <- melt(merged.selected, id = c("subject", "activity"))
casted <- dcast(melted, subject + activity ~ variable, mean)
show(casted)

