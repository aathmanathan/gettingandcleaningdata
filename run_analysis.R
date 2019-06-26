library(tidyverse)
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

#Get the data labels from the master collection
features <- read.table("Dataset from UCI/features.txt",header=FALSE)
features = as.character(features[,2])

#Pull data from test set files - SubjectID, Activity and Movement data
t.sub <- as_tibble(read.table("Dataset from UCI/test/subject_test.txt",col.name="SubjectID",header=FALSE))
t.act <- as_tibble(read.table("Dataset from UCI/test/y_test.txt",header=FALSE,col.names = "ActivityID"))
t.data <- as_tibble(read.table("Dataset from UCI/test/X_test.txt",col.names = features,header=FALSE))

#Pull data from training set files - SubjectID, Activity and Movement data
tr.sub <- as_tibble(read.table("Dataset from UCI/train/subject_train.txt",col.names = "SubjectID",header=FALSE))
tract <- as_tibble(read.table("Dataset from UCI/train/y_train.txt",header=FALSE,col.names = "ActivityID"))
trdata <- as_tibble(read.table("Dataset from UCI/train/X_train.txt",col.names = features,header=FALSE))

#Select only columns with 'mean' or 'standard deviation' in name
trdata = trdata[,grepl("*mean*",names(trdata))|grepl("*std*",names(trdata))]
t.data = t.data[,grepl("*mean*",names(t.data))|grepl("*std*",names(t.data))]

#Create final data frames and name
test = cbind(t.sub,t.act,t.data)
train = cbind(tr.sub,tract,trdata)

#Merge the data frames while maintaining the set it is from
train <- train %>% mutate(Dataset = "Training")
test <- test %>% mutate(Dataset = "Test")
Final = merge(test,train,all=TRUE)
Final = Final %>% select(Dataset,SubjectID,ActivityID,everything())

#Read the activity labels
ActID = as_tibble(read.csv("Dataset from UCI/activity_labels.txt",header=FALSE,col.names = c("ID","Activity"),sep = " ",colClasses = c("character","character")))
Final$ActivityID = as.character(Final$ActivityID)

#Replace the Activity ID numbers with the String values
for (i in 1:nrow(Final)) 
{ for (j in 1:nrow(ActID)){
                            if (ActID$ID[j]==Final$ActivityID[i]) {Final$ActivityID[i] = ActID$Activity[j]}
                              }

}

#Generate final data table
write.table(Final,file="Final Output.txt",row.names=FALSE)