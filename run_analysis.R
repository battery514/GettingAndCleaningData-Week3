library(dplyr)
library(data.table)

##Download the file from the web and unzip it
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = "Week3Project.zip")
unzip("Week3Project.zip")

##Read "test" files 
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

##Read "train" files
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

##3-Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE, colClasses="character")
y_test$V1 <- factor(y_test$V1, levels = activity_labels$V1, labels = activity_labels$V2)
y_train$V1 <- factor(y_train$V1, levels = activity_labels$V1, labels = activity_labels$V2)

##4-Appropriately labels the data set with descriptive variable names
features <- read.table("UCI HAR Dataset/features.txt", header=FALSE, colClasses="character")
colnames(x_test) <- features$V2
colnames(x_train) <- features$V2
colnames(y_test) <- c("Activity")
colnames(y_train) <- c("Activity")
colnames(subject_test) <- c("Subject")
colnames(subject_train) <- c("Subject")

##1-Merges the training and the test sets to create one data set
x_test <- cbind(x_test, y_test)
x_test <- cbind(x_test, subject_test)
x_train <- cbind(x_train, y_train)
x_train <- cbind(x_train, subject_train)
Final_Data <- rbind(x_test, x_train)

##2-Extracts only the measurements on the mean and standard deviation for each measurement
Final_Data_Mean <- sapply(Final_Data,mean, na.rm=TRUE)
Final_Data_STDev <- sapply(Final_Data, sd, na.rm=TRUE)

##5-From the data set in step 4, creates a second independent tidy data set with the average of each
##variable for each activity and each subject
Data_Table <- data.table(Final_Data)
Tidy_Data_Set <- Data_Table[,lapply(.SD,mean), by="Activity,Subject"]
write.table(Tidy_Data_Set, file="Tidy Data Set.txt", row.names = FALSE)
