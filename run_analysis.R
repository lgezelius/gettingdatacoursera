# download and expand Samsung data set
if (!file.exists("data")) {
  dir.create("data")
}
download.file(
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
  file.path("data","Dataset.zip"), 
  method="curl"
)
unzip(file.path("data","Dataset.zip"), exdir="data")

# function to convert a space delimited string of numbers to a numeric vector
library(stringr)
stringAsNV <- function(s) {
  as.numeric(unlist(strsplit(gsub("  ", " ", str_trim(as.character(s))), split=" ")))
}

# read and combine the test and train data for subjects
subject <- rbind(
  read.csv(file.path("data","UCI HAR Dataset","test","subject_test.txt"), header=FALSE, col.names=("subject")),
  read.csv(file.path("data","UCI HAR Dataset","train","subject_train.txt"), header=FALSE, col.names=("subject"))
)

# read the activity levels and labels from a space delimited file
activity_labels <- read.csv(
  file.path("data","UCI HAR Dataset","activity_labels.txt"),
  header=FALSE, 
  sep="",
  col.names=c("level", "label")
)

# read and combine the test and train data for activities
y <- rbind(
  read.csv(file.path("data","UCI HAR Dataset","test","y_test.txt"), header=FALSE, col.names=("activity")),
  read.csv(file.path("data","UCI HAR Dataset","train","y_train.txt"), header=FALSE, col.names=("activity"))  
)
y$activity <- factor(y$activity, levels = activity_labels$level, labels = activity_labels$label)

# read the column labels for the feature data
columns <- read.csv(
  file.path("data","UCI HAR Dataset","features.txt"),
  header=FALSE,
  sep="",
  col.names=c("number", "name")
)
library(stringr)
# replace apparent "BodyBody" typo in columns$name vector with "Body"
columns$name <- str_replace(string=columns$name, pattern="BodyBody", replacement="Body")

# read and combine the test and train data for features
X <- rbind(
  read.csv(file.path("data","UCI HAR Dataset","test","X_test.txt"), header=FALSE),
  read.csv(file.path("data","UCI HAR Dataset","train","X_train.txt"), header=FALSE)  
)

# create a character vector of column names containing "mean()" or "std()"
mean_and_std_columns <- grep("(mean\\(\\)|std\\(\\))", columns$name, value=TRUE)

# create the first tidy data set:
# convert the strings of space delimited feature data to vectors
t <- t(sapply(X[, 1], stringAsNV))
# apply the labels for the feature columns
colnames(t) <- columns$name
# include only the mean() and std() feature data
t <- t[, mean_and_std_columns]
# join subject, activity, and feature data
t <- cbind(subject, y, t)

# create and write out the second tidy data set:
library(plyr)
# compute the mean of feature data, grouped by subject and activity
t2 <- aggregate(t[, mean_and_std_columns], by=list(t$subject, t$activity), FUN=mean)
t2 <- rename(t2, c("Group.1"="subject", "Group.2"="activity"))
write.table(t2, file=file.path("data","aggregate.txt"), append=FALSE, row.names=FALSE)

# generate code book fragment
for(n in mean_and_std_columns[3:66]) {
  cat(paste("Variable:", n, "  \n"))
  cat(paste("Variable Type:", class(t2[, n]), "  \n"))
  cat(paste("Allowable Values: -1 to 1  \n"))
  en <- n
  en <- sub("^t","time domain signals for",en)
  en <- sub("^f","frequency domain signals for",en)
  en <- sub("Body"," body",en)
  en <- sub("Acc"," accelerometer",en)
  en <- sub("Gyro"," gyroscope",en)
  en <- sub("Jerk"," jerk",en)
  en <- sub("Mag"," magnitude",en)
  en <- sub("-mean\\(\\)"," means",en)
  en <- sub("-std\\(\\)"," standard deviations",en)
  en <- sub("-X"," on X axis",en)
  en <- sub("-Y"," on Y axis",en)
  en <- sub("-Z"," on Z axis",en)
  cat(paste("Description: average of all",en,"for subject and activity  \n"))
  cat("\n")
}


