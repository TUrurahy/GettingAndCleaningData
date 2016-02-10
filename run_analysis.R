## Loading the libraries
library(downloader)
library(data.table)
library(reshape2)
library(dplyr)

## Downloading Zip File
path <- getwd()
download <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "Data.zip"
if (!file.exists(path)) {dir.create(path)}
download.file(download, file.path(path, zipFile))

## unziping and setting the new working directory
unzip(zipfile = "Data.zip")
setwd(paste0(path,"/UCI HAR Dataset"))

## read the subject, data and label files
dataSubTrain <- read.table("./train/subject_train.txt")
dataSubTest  <- read.table("./test/subject_test.txt" )
dataTrain <- read.table("./train/X_train.txt")
dataTest <- read.table("./test/X_test.txt")
dataLabTrain <- read.table("./train/y_train.txt")
dataLabTest <- read.table("./test/y_test.txt")

## 1. Merges the training and the test sets to create one data set
        ## using rbind to put the tables together and cbind to combine the columns.
dataSubject <- rbind(dataSubTrain, dataSubTest)
setnames(dataSubject, "V1", "subject")
dataLab <- rbind(dataLabTrain, dataLabTest)
setnames(dataLab, "V1", "labelNumber")
data <- rbind(dataTrain, dataTest)
dataSubject <- cbind(dataSubject, dataLab)
data <- cbind(dataSubject, data)
View(data)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
        ## as seen on README.txt => 'features.txt': List of all features.
features <- read.table("features.txt")
setnames(features, names(features), c("featNum", "featName"))

        ## subset MEAN and STD except meanFreq
features2 <- features[grepl("mean\\.*[^Freq]|std\\.*[^Freq]", features$featName),]
features2


        ## subseting both tables together
dataTable <- data.table(data)
features2$featCrossCode <- paste0("V", features2$featNum)
View(features2)
View(dataTable)
fields <- c("subject", "labelNumber", features2$featCrossCode)

FinalData <- dataTable[, fields, with = FALSE]
View(FinalData)

## 3. Uses descriptive activity names to name the activities in the data set and;
## 4. Appropriately labels the data set with descriptive variable names.
## as seen on README.txt => 'activity_labels.txt': Links the class labels with their activity name.
activityNames <- read.table("activity_labels.txt")
View(activityNames)
FinalData <- merge(FinalData, activityNames, by.x = "labelNumber", by.y = "V1", all.x = TRUE)
        ## now we have a column with the Activity Names in FinalData

## 5. From the data set in step 4, creates a second, independent tidy data set with the average
## of each variable for each activity and each subject.

tidyData <- mutate(FinalData, Activity = V2.y)
View(tidyData)
str(tidyData)      ## check if Activity is a FACTOR

## Melt setting the ids
DataMelt <- melt(tidyData, id = c("labelNumber","subject","Activity", "V2.y"))
View(DataMelt)

## agregate with dcast setting the function as MEAN
tidyData <- dcast(DataMelt, Activity + variable ~ subject, mean)
View(tidyData)