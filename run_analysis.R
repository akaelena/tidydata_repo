library(reshape2)
#Load all data
xTrain <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
yTrain <- read.csv("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
subjectTrain <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = " ", header = FALSE)
xTest <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
yTest <- read.csv("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
subjectTest <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = " ", header = FALSE)
features <- read.csv("UCI HAR Dataset/features.txt", sep = " ", header = FALSE)
activities <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = " ", header = FALSE)
#Merge data
test <- cbind(xTest, yTest, subjectTest)
train <- cbind(xTrain, yTrain, subjectTrain)
m <- rbind(test, train)
#Label data (remove special chars and apply to column names)
features <- gsub("-", ".", gsub("[\\(\\)]", "", as.character(features$V2)))
cols <- c(features, "activity", "subject")
colnames(m) <- cols
#Label activites
for (i in 1:6) {
m$activity[m$activity == i] <- as.character(activities$V2[[i]])
}
#Extract means and standard deviations
s <- subset(m, select = cols[grep("mean\\.|mean$|std\\.|std$|activity|subject", cols)])
#Now reshape as tidy and output
ml <- melt(s, id=c("subject", "activity"), measure.vars=colnames(s)[1:66])
tidy <- dcast(ml, subject + activity ~ variable, mean)
write.table(tidy, "tidyoutput.txt",row.name=FALSE)
