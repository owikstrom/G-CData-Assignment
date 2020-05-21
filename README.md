---
output: 
  html_document: 
    keep_md: yes
---

# Gathering and Cleaning Data Project


---
#### Setting up the environment
Since I will be using DPLYR I have to include a reference


#### Download and loading the files
I downloaded the files from the site, unzipped them and loaded the relevant .csv into memory


```r
x_test <- read.table("UCI HAR Dataset/test/x_test.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
```

#### Merging test & train data

Merging the train/test data was relatively simple using RBIND into new datasets _full


```r
x_full <- rbind(x_test, x_train)
y_full <- rbind(y_test, y_train)
subject_full <- rbind(subject_test, subject_train)
```

#### Setting column names and reducing columns

I set the column names from the features data and used GSUB to remove the parenthesis for tidier names. with grep I got the column names that contained 'mean(' or 'standard(' and kept only those columns.


```r
colnames(x_full) <- gsub("\\(|\\)","",features$V2)
cols <- grep("(mean|std)\\(",features$V2)
x_reduced <- x_full[,cols]
```

#### Preparing the tidy dataset

I added a factored activity column to the 'y' file to get the literal names names and bound together the data with subject and activity columns.
The finished file was then stored to a .csv file


```r
y_full$activity <-factor(y_full$V1, labels = labels$V2)
tidydataset <- cbind(activity= y_full$activity, subject=subject_full$V1, x_reduced)
write.csv(tidydataset, file='tidydataset.csv', row.names = FALSE)
```

#### Preparing the summary dataset
With DPLYR the grouping and summary was trivial. The tidy dataset was piped and summarized by mean values an written to file.
Finally I closed all open objects.


```r
sumdataset <- tidydataset %>% group_by(subject, activity) %>% summarise_all(list(mean))
write.csv(sumdataset, file='summary.csv', row.names = FALSE)
          
# Cleanup
rm(list = ls())
```
