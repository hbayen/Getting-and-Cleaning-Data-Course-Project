library(dplyr)

label <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)

test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = label[,2])

test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "subject")

test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "activity")

train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = label[,2])

train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "subject")

train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = "activity")

test_data <- cbind(test_subjects, test_activity, test)

train_data <- cbind(train_subjects, train_activity, train)

complete_data <- rbind(test_data, train_data)

##activity_names <- list(1 = "Walking",  2 = "Walking Upstairs", 3 = "Walking Downstairs", 4 = "Sitting", 5 = "Standing", 6 = "Laying")

complete_data$activity <- recode_factor(complete_data$activity,'1' = "Walking",  '2' = "Walking Upstairs", '3' = "Walking Downstairs", '4' = "Sitting", '5' = "Standing", '6' = "Laying")

new_data <- select(complete_data, subject, activity, matches("mean|std"))

names(new_data) <- gsub("\\.","",names(new_data),)

tidy_data <- new_data %>%
  group_by(subject, activity) %>%
  summarise_at(vars(-c(subject,activity)), funs(mean(., na.rm=TRUE))) %>%
  write.table(file = "tidy_data.txt", sep = "\t", row.names = FALSE)
