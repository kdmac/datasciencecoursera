# unzip data set
unzip(zipfile = "F:\\Coursera\\Getting and cleaning data\\getdata_projectfiles_UCI HAR Dataset.zip",exdir = "F:\\Coursera\\Getting and cleaning data")


# definging path where unzip data is saved
pathdata = file.path("F:\\Coursera\\Getting and cleaning data\\UCI HAR Dataset")

files = list.files(pathdata,recursive = T)


# Reding training tables
xtrain = read.table(file.path(pathdata,"train","X_train.txt"),header = F)
ytrain = read.table(file.path(pathdata,"train","y_train.txt"),header = F)
subject_train = read.table(file.path(pathdata,"train","subject_train.txt"),header = F)

#Reading the testing tables
xtest = read.table(file.path(pathdata,"test","X_test.txt"),header = F)
ytest = read.table(file.path(pathdata,"test","y_test.txt"),header = F)
subject_test = read.table(file.path(pathdata,"test","subject_test.txt"),header = F)

#Read the features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)

#Read activity labels data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#Create Sanity and Column Values to the Train Data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"

#Create Sanity and column values to the test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"

#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')


#Merging the train and test data - important outcome of the project
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)

#Create the main data table merging both table tables - this is the outcome of 1
setAllInOne = rbind(mrg_train, mrg_test)


# Need step is to read all the values that are available
colNames = colnames(setAllInOne)
#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]


setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)


# New tidy set has to be created 
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#The last step is to write the ouput to a text file 
setwd("F:\\Coursera\\Getting and cleaning data")
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
