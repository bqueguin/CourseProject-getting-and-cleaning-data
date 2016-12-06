# Clean up the workspace
rm(list = ls())

# Import packages
library(dplyr)

# Check if the files are available and download it if not
if(!file.exists("data")){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  "data.zip")
    unzip("data.zip", exdir = "data")
    file.remove("data.zip")
    
}

# Let's import the data

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

# Now our data are tidy but there are too many variables for us.
# Let's select those we need
variables_we_need <- grepl(".*mean[^F].*|.*std.*", variables)
variables_we_need <- c(rep(T,3), variables_we_need) # 3 TRUE for SubjectID, activity and dataFrom
smaller_full <- full[,variables_we_need]

# Let's make better and simpler descriptive variables names
variable_names <- names(smaller_full)
variable_names <- gsub("-mean\\(\\)", "Mean", variable_names)
variable_names <- gsub("-std\\(\\)", "Std", variable_names)
names(smaller_full) <- variable_names

# Let's sort our data.frame by SubjectID number and activity
smaller_full <- smaller_full %>% arrange(subjectID, activity)


# Let's change the values of activity for a descriptive factor
activities <- read.table("data/activity_labels.txt")[,2]
smaller_full$activity <- activities[smaller_full$activity]


# Now let's create a new data frame with the average 
# of each variable for each activity and each subject.
only_mean_and_std <- smaller_full[, names(smaller_full) != c("subjectID","activity","dataFrom")]
mean_by = aggregate(only_mean_and_std, by = list(subjectID = smaller_full$subjectID, activity = smaller_full$activity), mean)


# Let's output the 2 data.frame we want

write.csv(smaller_full, "tidyData1.csv")
write.csv(mean_by, "meanBySubjectAndActivity.csv")




