library(dplyr)

# Download files
url1 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url1, basename(url1))
filenames <- unzip(basename(url1), list=TRUE)

# Read all necessary tables intp memory
x_test <- read.table("UCI HAR Dataset/test/x_test.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")


# Bind the different train and test sets
x_full <- rbind(x_test, x_train)
y_full <- rbind(y_test, y_train)
subject_full <- rbind(subject_test, subject_train)

# Select mean & std columns and add proper column names to reduced set
colnames(x_full) <- gsub("\\(|\\)","",features$V2) #Set titles without parenthesis
cols <- grep("(mean|std)\\(",features$V2)
x_reduced <- x_full[,cols]


# Consolidate the tidy dataset with subject and activity data
y_full$activity <-factor(y_full$V1, labels = labels$V2)
tidydataset <- cbind(activity= y_full$activity, subject=subject_full$V1, x_reduced)
write.csv(tidydataset, file='tidydataset.csv')


# Create and save the summary dataset
sumdataset <- tidydataset %>% group_by(subject, activity) %>% summarise_all(list(mean))
write.csv(sumdataset, file='summary.csv')
          
# Cleanup
rm(list = ls())