##Download and processing data from the given URL

new="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(new, destfile="C:/Users/User/Downloads/gacd.zip")
dest<-"C:/Users/User/Downloads/gacd"
unzip("C:/Users/User/Downloads/gacd.zip", files=NULL, overwrite = FALSE,junkpaths = FALSE, exdir=dest)



#Reading all the text file data into R

features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subject_train <- read.table("subject_train.txt", col.names = "subject")
xtrain <- read.table("X_train.txt", col.names = features$functions)
ytrain <- read.table("y_train.txt", col.names = "code")

##Merging the dataset

X <- rbind(xtrain, xtest)
Y <- rbind(ytrain, ytest)
subject <- rbind(subject_train, subject_test)
final <- cbind(subject, Y, X)

##Extracts only the measurements on the mean and standard deviation for each measurement.

newdata <- final %>% select(subject, code, contains("mean"), contains("std"))

##Using descriptive activity names to name the activities in the data set.
newdata$code <- activities[newdata$code, 2]

##Appropriately labels the data set with descriptive variable names.
names(newdata)[2] = "activity"
names(newdata)<-gsub("Acc", "Accelerometer", names(newdata))
names(newdata)<-gsub("Gyro", "Gyroscope", names(newdata))
names(newdata)<-gsub("BodyBody", "Body", names(newdata))
names(newdata)<-gsub("Mag", "Magnitude", names(newdata))
names(newdata)<-gsub("^t", "Time", names(newdata))
names(newdata)<-gsub("^f", "Frequency", names(newdata))
names(newdata)<-gsub("tBody", "TimeBody", names(newdata))
names(newdata)<-gsub("-mean()", "Mean", names(newdata), ignore.case = TRUE)
names(newdata)<-gsub("-std()", "STD", names(newdata), ignore.case = TRUE)
names(newdata)<-gsub("-freq()", "Frequency", names(newdata), ignore.case = TRUE)
names(newdata)<-gsub("angle", "Angle", names(newdata))
names(newdata)<-gsub("gravity", "Gravity", names(newdata))


##Calculate average of each variable for each activity and each subject.
d1<-aggregate(newdata, by=list(newdata$activity,newdata$subject), FUN=mean)

##Final Data set
write.table(d1,"C:/Users/User/Downloads/gacd/UCI HAR Dataset/data.txt", row.name=FALSE)
