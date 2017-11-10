#installilng the package reshape2
library(reshape2)

filename <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"  #downloaded file 


if (!file.exists(filename)){   #condition
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "    ## Download  the dataset:
  download.file(fileURL, filename, method="curl")  #downloading the file
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) #unziping the dataset
}

#loading files
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
labels[,2] <- as.character(labels[,2])
ftr <- read.table("UCI HAR Dataset/ftr.txt")
ftr[,2] <- as.character(ftr[,2])


ftrW <- grep(".*mean.*|.*std.*", ftr[,2])               #searching for the ftr column 2 
ftrW.names <- ftr[ftrW,2]
ftrW.names = gsub('-mean', 'Mean', ftrW.names)   #replacing the <mean> names
ftrW.names = gsub('-std', 'Std', ftrW.names)     #replacing the <std> names
ftrW.names <- gsub('[-()]', '', ftrW.names)        #replacing the brackets



Xtrain <- read.table("UCI HAR Dataset/Xtrain/X_Xtrain.txt")[ftrW]     #loading xtrain dataset
Ytrain <- read.table("UCI HAR Dataset/Xtrain/Y_Xtrain.txt")  #loading ytarin dataset
XtrainSub <- read.table("UCI HAR Dataset/Xtrain/subject_Xtrain.txt") #loading xtrain subject
Xtrain <- cbind(XtrainSub, Ytrain, Xtrain)   #binding the columns

Xtest <- read.table("UCI HAR Dataset/Xtest/X_Xtest.txt")[ftrW]     #loading xtest dataset
Ytest <- read.table("UCI HAR Dataset/Xtest/Y_Xtest.txt")          #loading ytest dataset
XtestSub <- read.table("UCI HAR Dataset/Xtest/subject_Xtest.txt")      #loading xtestsub 
Xtest <- cbind(XtestSub, Ytest, Xtest)         ##binding the columns 


data <- rbind(Xtrain, Xtest)  #binding the rows
colnames(data) <- c("subject", "activity", ftrW.names)  #naming the columns

data$activity <- factor(data$activity, levels = labels[,1], labels = labels[,2])  #factoring activity
data$subject <- as.factor(data$subject)     #factoring subjet

data.melted <- melt(data, id = c("subject", "activity"))   #spliting the data
data.mean <- dcast(data.melted, subject + activity ~ variable, mean)  

write.table(data.mean, "tidy.txt", row.names = FALSE, quote = FALSE) #summarizing the output into tidy.txt file