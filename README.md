# Getting and Cleaning Data Course Project

##Enable dplyr package
library(dplyr)

##List of all features that will be used to label the columns in the data
label <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)

##Data in the test set
test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = label[,2])

##Volunteer which corresponds to the data in the test set
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "subject")

##Activity which corresponds to the data in the test set
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "activity")

##Data in the train set
train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = label[,2])

##Volunteer which corresponds to the data in the train set
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "subject")

##Activity which corresponds to the data in the train set
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = "activity")

##Aligning the volunteer and the activity to the results of the experiments in the test set
test_data <- cbind(test_subjects, test_activity, test)

##Aligning the volunteer and the activity to the results of the experiments in the train set
train_data <- cbind(train_subjects, train_activity, train)

##Merging data from the 2 sets
complete_data <- rbind(test_data, train_data)

##Replacing the activity label with the activity name
complete_data$activity <- recode_factor(complete_data$activity,'1' = "Walking",  '2' = "Walking Upstairs", '3' = "Walking Downstairs", '4' = "Sitting", '5' = "Standing", '6' = "Laying")

##Getting only the variables with the measurements on mean and standard deviation
new_data <- select(complete_data, subject, activity, matches("mean|std"))

##Editing the variable names
names(new_data) <- gsub("\\.","",names(new_data),)

##Creating the second dataset
tidy_data <- new_data %>%

##Grouping the data by subjects and activities
  group_by(subject, activity) %>%
 
##Getting the mean of all measurements for each group
  summarise_at(vars(-c(subject,activity)), funs(mean(., na.rm=TRUE))) %>%

##Create a copy of the dataset
  write.table(file = "tidy_data.txt", sep = "\t", row.names = FALSE)
