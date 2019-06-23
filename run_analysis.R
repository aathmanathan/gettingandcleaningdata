library(tidyverse)
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

#Pull data from test set files - SubjectID, Activity and Movement data
tsubID <- as_tibble(read.table("/Users/Arun/Documents/R codes/Coursera R work/Getting and Cleaning Data/Course project/Dataset from UCI/test/subject_test.txt",col.name="SubjectID",header=FALSE))
tact <- as_tibble(read.table("/Users/Arun/Documents/R codes/Coursera R work/Getting and Cleaning Data/Course project/Dataset from UCI/test/y_test.txt",header=FALSE,col.names = "ActivityID"))
tdata <- as_tibble(read.table("/Users/Arun/Documents/R codes/Coursera R work/Getting and Cleaning Data/Course project/Dataset from UCI/test/X_test.txt",header=FALSE))

#Pull data from training set files - SubjectID, Activity and Movement data
trsubID <- as_tibble(read.table("/Users/Arun/Documents/R codes/Coursera R work/Getting and Cleaning Data/Course project/Dataset from UCI/train/subject_train.txt",header=FALSE))
tract <- as_tibble(read.table("/Users/Arun/Documents/R codes/Coursera R work/Getting and Cleaning Data/Course project/Dataset from UCI/train/y_train.txt",header=FALSE))
trdata <- as_tibble(read.table("/Users/Arun/Documents/R codes/Coursera R work/Getting and Cleaning Data/Course project/Dataset from UCI/train/X_train.txt",header=FALSE))

#Create final data frames and name
test = cbind(tsubID,tact,tdata)
train = cbind(tsubID,tact,tdata)

dim = paste0("Dimension",seq(1:ncol(tdata)))

colnames(train)=c("SubjectID","ActivityID",dim)
colnames(test)=c("SubjectID","ActivityID",dim)

#Take the mean and SD & MERGE
train2 <- train %>% group_by(SubjectID,ActivityID) %>% summarize_all(list("mean" = mean,"SD" = sd)) %>% mutate(Datatype = "Training")
test2 <- test %>% group_by(SubjectID,ActivityID) %>% summarize_all(list("mean" = mean,"SD" = sd)) %>% mutate(Datatype = "Test")
Final = merge(test2,train2,all=TRUE)
rm(tact,tdata,test,test2,tract,train,train2,trdata,tsubID,trsubID)

#Activity labels
ActID = as_tibble(read.csv("/Users/Arun/Documents/R codes/Coursera R work/Getting and Cleaning Data/Dataset/activity_labels.txt",header=FALSE,col.names = c("ID","Activity"),sep = " ",colClasses = c("character","character")))
Final$ActivityID = as.character(Final$ActivityID)
A = character(nrow(Final))
for (i in 1:nrow(Final)) 
{A[i] = ActID$Activity[ActID$ID==Final[i,"ActivityID"]]
  
}
Final = Final %>% mutate(ActivityID=t(t(A)))
Final = Final %>% arrange(SubjectID)
Final = Final %>% select(SubjectID,ActivityID,Datatype,Dim.1_mean:Dim.561_SD)

#Sorting to keep Mean and SD of the same factor together 
Final = Final %>% mutate(ActivityID=t(t(A)))
Final = Final %>% arrange(SubjectID)
Final = Final %>% select(SubjectID,ActivityID,Datatype,Dim.1_mean:Dim.561_SD)
D = Final[,-(1:3)]
D = D[,order(names(D))]
Final = cbind(Final[,1:3],D)

write.table(Final,file="Final Output.txt",row.names=FALSE)