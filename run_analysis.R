#getting the dataset from the link provided in the exercise description
if(!file.exists("./Getting_and_cleaning_data")) 
  {dir.create("./Getting_and_cleaning_data")}
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file.url, destfile = "./Getting_and_cleaning_data/dataset.zip", method = "curl")

#The file dataset.zip is a zipped file and needs to be unzipped, Lets do this
unzip ("dataset.zip", exdir = "./")

#Importing the files for training and test data
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
testsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
trainsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merging the training and test dataset
x_merged <- rbind(x_train, x_test)
y_merged <- rbind(y_train, y_test)
Subjects <- rbind(trainsubjects, testsubjects)
merged_final <- cbind(Subjects, y_merged, x_merged)
library(dplyr)
library(tidyr)
#subsetting the columns with Mean and STD in the column names
Column_Selected <- merged_final %>% select(subject, code, contains ("mean"), contains("std"))

names(Column_Selected) <- gsub("tBodyAcc", "TimeBodyAccleration", names(Column_Selected))
names(Column_Selected) <- gsub("tGravityAcc", "TimeGravityAccleration", names(Column_Selected))
names(Column_Selected) <- gsub("tBodyGyro", "TimeBodyGyroscopy", names(Column_Selected))
names(Column_Selected) <- gsub("fBodyAcc", "FrequencyBodyAccleration", names(Column_Selected))
names(Column_Selected) <- gsub("fBodyGyro", "FrequencyBodyGyroscopy", names(Column_Selected))
names(Column_Selected) <- gsub("fBodyBodyAcc", "FrequencyBodyAccleration", names(Column_Selected))
names(Column_Selected) <- gsub("fBodyBodyGyro", "FrequencyBodyGyroscopy", names(Column_Selected))

TidyData <- Column_Selected %>% group_by(subject, code) %>% summarize_all(funs(mean))

names(TidyData)[2] = "Activity"
TidyData$Activity <- activity[TidyData$Activity, 2]
write.table(TidyData, "TidyData.txt", row.name=FALSE)

