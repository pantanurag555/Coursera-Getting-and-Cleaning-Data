library(plyr)

#Step 1
#Merge the subject, training and the test sets to create multiple datasets
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")

x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")

x_data<-rbind(x_train,x_test)
y_data<-rbind(y_train,y_test)
subject_data<-rbind(subject_train,subject_test)

#Step 2
#Extract only the measurements on the mean and standard deviation for each measurement 
features<-read.table("UCI HAR Dataset/features.txt")
mean_and_std_features<-grep("-(mean|std)\\(\\)",features[,2])
x_data<-x_data[,mean_and_std_features]
names(x_data)<-features[mean_and_std_features,2]

#Step 3
#Use descriptive activity names to name the activities in the data set
activities<-read.table("UCI HAR Dataset/activity_labels.txt")
y_data[,1]<-activities[y_data[,1],2]
names(y_data)<-"activity"

#Step 4
#Appropriately label the data set with descriptive variable names and merge the datasets into one dataset
names(subject_data)<-"subject"
all_data<-cbind(x_data,y_data,subject_data)

#Step 5
#Create a second, independent tidy data set with the average of each variable for each activity and each subject
avg_data<-ddply(all_data,.(subject,activity),function(x) colMeans(x[,1:66]))
write.table(avg_data,"average_data.txt",row.names=FALSE)