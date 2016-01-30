setwd("c:/R-Data-files/Data-Cleaning/Week-4-Quiz")

sub_test<-read.table("./test/subject_test.txt")
sub_train<-read.table("./train/subject_train.txt")
y_test<-read.table("./test/y_test.txt")
y_train<-read.table("./train/y_train.txt")
x_test<-read.table("./test/x_test.txt")
x_train<-read.table("./train/x_train.txt")


x_test_mean_std<-x_test[,c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,345:350,424:429,503:504,516,517,529,530,542,543)]

x_train_mean_std<-x_train[,c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,345:350,424:429,503:504,516,517,529,530,542,543)]


test<-cbind(sub_test,y_test,x_test_mean_std)
train<-cbind(sub_train,y_train,x_train_mean_std)
test_train<-rbind(test,train)

# rename col1 and col2 of test_train
colnames(test_train)[1]<-"sub"
colnames(test_train)[2]<-"activity"

# unique(y_train) or unique(y_test)

#reading the lookup table

activity_lbl<-read.table("./activity_labels.txt")

#creating a lookup index , this stmt will return the 1st match #of each test_train$activity in the lookup column ( Note : V1 )

index<-match(test_train$activity,activity_lbl$V1)

#replacing the activity column which has numbers with names 
#(Note: V2 ) 
test_train$activity<-activity_lbl$V2[index]

#removed "()" and "," from the original features file 
#to create features-1

features_lkup<-read.table("./features-1.txt")

features_lkup<-features_lkup[c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,345:350,424:429,503:504,516,517,529,530,542,543),]

features_lkup<-features_lkup[,-1]
features_lkup_1<-as.character(features_lkup)
colnames(test_train)[3:68]<-features_lkup_1

library(dplyr)
final<-test_train %>% group_by(sub,activity) %>% summarize_each(funs(mean))

write.table(final,file="tidy.txt",row.name=FALSE)