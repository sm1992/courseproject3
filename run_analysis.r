##setwd("~/UCI HAR Dataset") set working directory, uncomment if required
+### Create one R script called run_analysis.R that does the following ###
  +#1.- Merges the training and the test sets to create one data set.
  +#2.- Extracts only the measurements on the mean and standard deviation for each measurement. 
  +#3.- Uses descriptive activity names to name the activities in the data set
  +#4.- Appropriately labels the data set with descriptive activity names. 
  +#5.- Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

 
#read features to create colnames
features<-read.table("features.txt")
# read training data and labels
traindata<-read.table("train/X_train.txt")
trainlabel<-read.table("train/y_train.txt")
#rename labels to be more friendly
trainlabel[trainlabel[,1]==1,]<-"WALKING"
trainlabel[trainlabel[,1]==2,]<-"WALKING_UPSTAIRS"
trainlabel[trainlabel[,1]==3,]<-"WALKING_DOWNSTAIRS"
trainlabel[trainlabel[,1]==4,]<-"SITTING"
trainlabel[trainlabel[,1]==5,]<-"STANDING"
trainlabel[trainlabel[,1]==6,]<-"LAYING"
#create row vector to use as headers
features<-t(features[,2])
#combine training data and labels
traindata<-cbind(traindata,trainlabel)
#subject data
trainsubject<-read.table("train/subject_train.txt")
traindata<-cbind(traindata,trainsubject)
#same procedure for test data
testdata<-read.table("test/X_test.txt")
testlabel<-read.table("test/y_test.txt")
testsubject<-read.table("test/subject_test.txt")
testlabel[testlabel[,1]==1,]<-"WALKING"
testlabel[testlabel[,1]==2,]<-"WALKING_UPSTAIRS"
testlabel[testlabel[,1]==3,]<-"WALKING_DOWNSTAIRS"
testlabel[testlabel[,1]==4,]<-"SITTING"
testlabel[testlabel[,1]==5,]<-"STANDING"
testlabel[testlabel[,1]==6,]<-"LAYING"
testdata<-cbind(testdata,testlabel)
testdata<-cbind(testdata,testsubject)
#combine training and test data
traindata<-rbind(traindata,testdata)
#assign colnames
names(traindata)<-features
#grep to match all patters having "med" or "std" in name
colsWeWant <- grep(".*mean.*|.*std.*", features)
features2<-features[colsWeWant]
features2<-as.character(features2)
colsWeWant<-c(colsWeWant,562,563)
finaldata<-traindata
#shorten data to contain columns we need
finaldata<-finaldata[,colsWeWant]
colnames(finaldata)<-c(features2,"Activity","Subject")
#aggregate data based on activity and subject
finaldata2 = aggregate(finaldata, by=list(activity = finaldata$Activity, subject=finaldata$Subject), mean)
#reomve last two columns as they repeat useless information (activity and subject)
finaldata2<-finaldata2[,1:81]
#write final data without row names
write.table(finaldata2, "tidydata.txt", sep="\t",row.name=FALSE)
