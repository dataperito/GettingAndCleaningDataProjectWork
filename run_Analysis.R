# download the data from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" in the working directory
# set working directory
setwd("C:/Users/I65057/ZZZZ003-GettingAndCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/")
# read training data 
training = read.csv("train/X_train.txt", sep="", header=FALSE) 
training[,562] = read.csv("train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("train/subject_train.txt", sep="", header=FALSE) 
# read test data 
testing = read.csv("test/X_test.txt", sep="", header=FALSE) 
testing[,562] = read.csv("test/Y_test.txt", sep="", header=FALSE) 
testing[,563] = read.csv("test/subject_test.txt", sep="", header=FALSE) 
 
#read activity labels
activityLabels = read.csv("activity_labels.txt", sep="", header=FALSE) 
 
# read features and make sure about the feature names better with some conventions 
features = read.csv("features.txt", sep="", header=FALSE) 
features[,2] = gsub('-mean', 'Mean', features[,2]) 
features[,2] = gsub('-std', 'Std', features[,2]) 
features[,2] = gsub('[-()]', '', features[,2]) 
 
 
# merge training and test sets together 
allData = rbind(training, testing) 
 
 
# get the data on mean and std. dev. 
colsRequired <- grep(".*Mean.*|.*Std.*", features[,2]) 
# reduce the features table as required 
features <- features[colsRequired,] 
# add the columns subject and activity 
colsRequired <- c(colsRequired, 562, 563) 
# remove the not required columns from allData 
allData <- allData[,colsRequired] 
# Add the column names (features) to allData 
colnames(allData) <- c(features$V2, "Activity", "Subject") 
colnames(allData) <- tolower(colnames(allData)) 
 
currentActivity = 1 
for (currentActivityLabel in activityLabels$V2) { 
   allData$activity <- gsub(currentActivity, currentActivityLabel, allData$activity) 
   currentActivity <- currentActivity + 1 
 } 

 
allData$activity <- as.factor(allData$activity) 
allData$subject <- as.factor(allData$subject) 
 
tidy = aggregate(allData, by=list(activity = allData$activity, subject=allData$subject), mean) 
# remove the subject and activity columns, no use of means for these columns
tidy[,90] = NULL 
tidy[,89] = NULL 
write.table(tidy, "tidy.txt", sep="\t", row.names = FALSE) 
