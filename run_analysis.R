
# Merges the training and the test sets to create one data set.
x_test <- read.table("UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
features <- read.table("UCI HAR Dataset/features.txt")
labels <= read.table("UCI HAR Dataset/activity_labels.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

x_join <- rbind(x_test, x_train)
y_join <- rbind(y_test, y_train)
subject_join <- rbind(subject_test, subject_train)


# Extracts only the measurements on the mean and standard deviation for each measurement.
colselect <- features[grep("(mean|std)\\(", features$V2),]


# Uses descriptive activity names to name the activities in the data set
activity_names <- merge(y_test, y_train, labels)

# Appropriately labels the data set with descriptive variable names.
t1 <- x_test[, colselect$V1]


# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
