####Data######
setwd("C:/Users/flemina4/OneDrive - Lincoln University/2021/Rcourse/Cleandata_project")
URL <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
download.file(URL, destfile = "C:/Users/flemina4/OneDrive - Lincoln University/2021/Rcourse/Cleandata_project/Dataset.zip", mode = 'wb')
unzip(zipfile = "C:/Users/flemina4/OneDrive - Lincoln University/2021/Rcourse/Cleandata_project/Dataset.zip", exdir = "C:/Users/flemina4/OneDrive - Lincoln University/2021/Rcourse/Cleandata_project")
##define path where folder has been unzipped###
pathdata = file.path("C:/Users/flemina4/OneDrive - Lincoln University/2021/Rcourse/Cleandata_project", "UCI HAR Dataset")
files = list.files(pathdata, recursive = TRUE)
files
#Reading train tables
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
##Reading test tables###
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
#Reading features
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)
#Read activity labels data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)
######Tagging the test and train dataset #4 label data set with descriptive variable names####
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"

colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')
####1 Merge training test sets #####
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)
#Create the main data table merging both table tables - this is the outcome of 1
setAllInOne = rbind(mrg_train, mrg_test)
####2 Extract the mean and SD for each measurement####
colNames = colnames(setAllInOne)
meand_and_sd = (grepl("activityId", colNames) | grepl("subjectId", colNames) | grepl("mean...", colNames) | grepl("std..", colNames))
setForMeanAndStd <- setAllInOne[, meand_and_sd == TRUE]
####3 Name the activity names####
setWithActivityNames = merge(setForMeanAndStd, activityLabels, by = 'activityId', all.x = TRUE)
###step 4 labeling data set with descriptive vcariables already completed above###
####5 from each data set in 4, create a second tidy data set with mean of each variable for each activity and subject#### 
secTidySet <- aggregate(. ~ subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
write.table(secTidySet, "secTidySet.txt", row.name = FALSE)
