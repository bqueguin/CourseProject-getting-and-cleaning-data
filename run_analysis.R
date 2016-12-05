# Set the good directory
setwd("C:/Users/QUEGUINER/Desktop/Cours/Autre/Coursera/Getting and Cleaning Data/week4/CourseProject getting and cleaning data")

# Import some packages
library(dplyr)

# Let's read the data

# First we create a variables vector with the future column names of our data.
features <- read.table("data/features.txt", stringsAsFactors = F)
variables <- features[,2]

# Import the train and test data and assign it the relevant column names
trainSet <- read.table("data/train/X_train.txt")
testSet <- read.table("data/test/X_test.txt")
names(trainSet) <- variables
names(testSet) <- variables

# Import the labels and subjects data 
trainLabels <- read.table("data/train/y_train.txt")
testLabels <- read.table("data/test/y_test.txt")
names(trainLabels) <- "activity"
names(testLabels) <- "activity"
trainSubject <- read.table("data/train/subject_train.txt")
testSubject <- read.table("data/test/subject_test.txt")
names(trainSubject) <- "subjectID"
names(testSubject) <- "subjectID"

# Here we combine our subjects and labels with the "big" data set
train <- cbind(trainSubject, trainLabels, dataFrom = "train", trainSet)
test <- cbind(testSubject, testLabels, dataFrom = "test", testSet)

# Finally we merge the train and test data with rbind function
full <- rbind(train, test)
View(full)

# Now our data are tidy but there are too many variables for us.
# Let's select those we need
smaller_full <- full[,1:9]
smaller_full <- tbl_df(smaller_full)

# Let's sort our data.frame by SubjectID number and activity
smaller_full <- smaller_full %>% arrange(subjectID, activity)

# Let's make better and simpler descriptive variables names
names(smaller_full)[4:9] <- c("meanX","meanY","meanZ","stdX","stdY", "stdZ")

# Let's change the values of activity fr a descriptive factor
activities <- read.table("data/activity_labels.txt")[,2]
smaller_full$activity <- activities[smaller_full$activity]

# Let's check if everything is OK
str(smaller_full)
View(smaller_full)
# OK that's nice


# Now let's create a new data frame with the average 
# of each variable for each activity and each subject.

mean_by <- smaller_full %>% 
    group_by(subjectID, activity) %>% 
    summarize(meanX = mean(meanX), meanY = mean(meanY), meanZ = mean(meanZ),
              stdX = mean(stdX), stdY = mean(stdY), stdZ = mean(stdZ))






