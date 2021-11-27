# load required packages
library("tidyverse")
library("dplyr")
library("readr")
library("data.table")
library("dataMaid")

# download the zipped data file
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileDir <- "./data"
fileName <- "FUCI_HAR_Dataset.zip"
filePath <- file.path(fileDir, fileName)

# if the directory does not exist, create it
if (!file.exists(fileDir)) {
    dir.create(fileDir)
}

# if downloadable file does not exist, download it
if (!file.exists(filePath)) {
    download.file(fileURL, filePath)
}

# if downloaded file exists, unzip it
if (file.exists(filePath)) {
    unzip(filePath, exdir = fileDir)
}

dataDir <- "UCI HAR Dataset"
# read activity labels
activityLabels <- read.table(file.path(fileDir, dataDir, "activity_labels.txt"),
                             col.names = c("index", "ActivityLabel"),
                             colClasses = c("integer", "character"))

# read features
features <- read.table(file.path(fileDir, dataDir, "features.txt"),
                             col.names = c("index", "featureName"),
                             colClasses = c("integer", "character"))

# identify numbers and names of required columns
featuresRequiredColumns <- grep("mean|std", features$featureName)
featuresRequiredNames <-features[featuresRequiredColumns, "featureName"]
featuresRequiredNames <- gsub("[()]", "", featuresRequiredNames)
featuresRequiredNames

# read training data set
xTrain <- fread(file.path(fileDir, dataDir, "train/X_train.txt"),
      select = featuresRequiredColumns)
yTrain <- fread(file.path(fileDir, dataDir, "train/y_train.txt"),
                colClasses = "character", stringsAsFactors = TRUE)
subjectsTrain <- fread(file.path(fileDir, dataDir, "train/subject_train.txt"),
                       colClasses = "character", stringsAsFactors = TRUE)
train <- cbind(yTrain, subjectsTrain, xTrain)

# read test data set
xTest <- fread(file.path(fileDir, dataDir, "test/X_test.txt"),
               select = featuresRequiredColumns)
yTest <- fread(file.path(fileDir, dataDir, "test/y_test.txt"),
               colClasses = "character", stringsAsFactors = TRUE)
subjectsTest <- fread(file.path(fileDir, dataDir, "test/subject_test.txt"),
                      colClasses = "character", stringsAsFactors = TRUE)
test <- cbind(yTest, subjectsTest, xTest)

# combine training and test data sets
allData <- rbind(train, test)

# provide column names to the combined data
colnames(allData) <- c("Activity", "Subject", featuresRequiredNames)

# group the combined data by Activity and Subject
groupedData <- group_by(allData, Activity, Subject)

# calculate mean values of the grouped data
result <- summarise(groupedData, .groups = "keep",
                    across(everything(), list(mean)))

# write output to csv file
write.csv(result, file = file.path(fileDir, "tidy_data.csv"),
          row.names = FALSE)

# create codebook of output data
dataMaid::makeCodebook(result,
                       reportTitle = "Codebook for UCI HAR Tidy Dataset",
                       file = "codebook.Rmd")
