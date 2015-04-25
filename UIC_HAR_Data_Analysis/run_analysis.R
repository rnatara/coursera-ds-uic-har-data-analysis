# run_analysis.R
# Analyze wearable device data
# Getting And Cleaning Data - Project work
# nram, 04/24/2015

library(plyr); library(dplyr)
library(reshape2)

#----------------------------------------------------------------------------
# Download and unzip file
#
#if(!file.exists("./")){dir.create("./")}
#cat ("\nDownloading file ...\n")
#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#zipfile <- "./getdata-projectfiles-UCI_HAR_Dataset.zip"
#download.file(url, zipfile, method="curl")
#cat ("Uncompressing ...\n")
#unzip(zipfile, exdir="./", overwrite=T)

#----------------------------------------------------------------------------
# Read data files
#
cat ("\nReading data files:\n")
if(!file.exists("UCI_HAR_Dataset/features.txt")){cat ("\nNo Samsung data found in current dir\n"); stop();}

# read meta data
cat ("\nReading meta info:\n")
features <- read.table("I:/Coursera/Data/UCI_HAR_Dataset/features.txt",header=F)
activity_labels <- read.table("I:/Coursera/Data/UCI_HAR_Dataset/activity_labels.txt",header=F)
# read data sets
cat ("\nReading test dataset\n")
x_test<-read.table("I:/Coursera/Data/UCI_HAR_Dataset/test/X_test.txt", header=F)
y_test<-read.table("I:/Coursera/Data/UCI_HAR_Dataset/test/y_test.txt", header=F)
subject_test<-read.table("I:/Coursera/Data/UCI_HAR_Dataset/test/subject_test.txt", header=F)

cat ("\nReading training dataset\n")
x_train<-read.table("I:/Coursera/Data/UCI_HAR_Dataset/train/X_train.txt", header=F)
y_train<-read.table("I:/Coursera/Data/UCI_HAR_Dataset/train/y_train.txt", header=F)
subject_train<-read.table("I:/Coursera/Data/UCI_HAR_Dataset/train/subject_train.txt", header=F)

#----------------------------------------------------------------------------
# Cleanup header
#
header <- gsub("\\(\\)" , "" , features[,2]) 	                 # replace () with ""
header <- gsub("[\\(\\),]", "_", header)                         # replace remaining ( and ) with _
header <- gsub("_$", "", header)                                 # get rid of trailing _
header <- gsub("^f", "Freq", header)                             # replace starting 'f' with Freq(uency)
header <- gsub("^t", "Time", header)                             # replace starting 't' with Time
header <- gsub("[-_]([[:alpha:]])", "\\U\\1", header, perl=TRUE) # replace -abc with -Abc (eg: -mean -> Mean)
header <- gsub("-", "_", header)                                 # replace remaining - with _ 
header <- gsub("__", "_", header)                                # and any spurious __ with _
#header <- gsub("(.*)_([XYZxyz])_(.*$)", "\\1\\3\\U\\2", header, perl=TRUE) # transform abc_X_Def to abcDefX
header <- gsub("(^[[:alpha:]])", "\\U\\1", header, perl=TRUE)    # capitalize starting alphabet 
header <- gsub("[-_]([[:alpha:]])", "\\U\\1", header, perl=TRUE) # handle any left over _abc and make it Abc
header <- c(as.vector(header),"Activity", "Subject", "Type")     # Add names of columns being added here


#----------------------------------------------------------------------------
# Merge data
#
# merge activity index with activity label
l_test <- join_all(list(y_test, activity_labels))
# take activity label and merge with test data 
x_test<-cbind(x_test, l_test[,2])
# merge with subject data
x_test<-cbind(x_test, subject_test)
# add data type (test/training)
x_test$type<-"test"
# name it
names(x_test) <- header

# repeat the same for training data
l_train <- join_all(list(y_train, activity_labels))
x_train<-cbind(x_train, l_train[,2])
x_train<-cbind(x_train, subject_train)
x_train$type<-"train"
names(x_train) <- header 

# ---------------------------------------------------------------------------
# Question 1: 
#
# Merges the training and the test sets to create one data set.
comb_data <- rbind(x_test, x_train)
#> dim(comb_data)
#[1] 10299   564


# ---------------------------------------------------------------------------
# Question 2: 
#
# Extracts only the measurements on the mean and standard deviation for each measurement
cols<-c(grep("Std|Mean",header),562:564)       # list of column indices we want to filter
mean_and_std_of_comb_data  <- comb_data[,cols] # Filter combined data (I belive thats whats being asked)
mean_and_std_of_test_data  <- x_test[,cols]    # if filtering test or travel data is required
mean_and_std_of_train_data <- x_train[,cols]   # here we go ...
#> dim(mean_and_std_of_comb_data)
#[1] 10299    89

# ---------------------------------------------------------------------------
# Questsion 3
# Uses descriptive activity names to name the activities in the data set
#
#>  table(mean_and_std_of_comb_data$Activity)
#
#            LAYING            SITTING           STANDING            WALKING WALKING_DOWNSTAIRS   WALKING_UPSTAIRS 
#              1944               1777               1906               1722               1406               1544 

# ---------------------------------------------------------------------------
# Questsion 4
#
#> names(mean_and_std_of_comb_data)
# [1] "TimeBodyAccMeanX"                  "TimeBodyAccMeanY"                  "TimeBodyAccMeanZ"                  "TimeBodyAccStdX"                   "TimeBodyAccStdY"                  
# [6] "TimeBodyAccStdZ"                   "TimeGravityAccMeanX"               "TimeGravityAccMeanY"               "TimeGravityAccMeanZ"               "TimeGravityAccStdX"               
#[11] "TimeGravityAccStdY"                "TimeGravityAccStdZ"                "TimeBodyAccJerkMeanX"              "TimeBodyAccJerkMeanY"              "TimeBodyAccJerkMeanZ"             
#[16] "TimeBodyAccJerkStdX"               "TimeBodyAccJerkStdY"               "TimeBodyAccJerkStdZ"               "TimeBodyGyroMeanX"                 "TimeBodyGyroMeanY"                
#[21] "TimeBodyGyroMeanZ"                 "TimeBodyGyroStdX"                  "TimeBodyGyroStdY"                  "TimeBodyGyroStdZ"                  "TimeBodyGyroJerkMeanX"            
#[26] "TimeBodyGyroJerkMeanY"             "TimeBodyGyroJerkMeanZ"             "TimeBodyGyroJerkStdX"              "TimeBodyGyroJerkStdY"              "TimeBodyGyroJerkStdZ"             
#[31] "TimeBodyAccMagMean"                "TimeBodyAccMagStd"                 "TimeGravityAccMagMean"             "TimeGravityAccMagStd"              "TimeBodyAccJerkMagMean"           
#[36] "TimeBodyAccJerkMagStd"             "TimeBodyGyroMagMean"               "TimeBodyGyroMagStd"                "TimeBodyGyroJerkMagMean"           "TimeBodyGyroJerkMagStd"           
#[41] "FreqBodyAccMeanX"                  "FreqBodyAccMeanY"                  "FreqBodyAccMeanZ"                  "FreqBodyAccStdX"                   "FreqBodyAccStdY"                  
#[46] "FreqBodyAccStdZ"                   "FreqBodyAccMeanFreqX"              "FreqBodyAccMeanFreqY"              "FreqBodyAccMeanFreqZ"              "FreqBodyAccJerkMeanX"             
#[51] "FreqBodyAccJerkMeanY"              "FreqBodyAccJerkMeanZ"              "FreqBodyAccJerkStdX"               "FreqBodyAccJerkStdY"               "FreqBodyAccJerkStdZ"              
#[56] "FreqBodyAccJerkMeanFreqX"          "FreqBodyAccJerkMeanFreqY"          "FreqBodyAccJerkMeanFreqZ"          "FreqBodyGyroMeanX"                 "FreqBodyGyroMeanY"                
#[61] "FreqBodyGyroMeanZ"                 "FreqBodyGyroStdX"                  "FreqBodyGyroStdY"                  "FreqBodyGyroStdZ"                  "FreqBodyGyroMeanFreqX"            
#[66] "FreqBodyGyroMeanFreqY"             "FreqBodyGyroMeanFreqZ"             "FreqBodyAccMagMean"                "FreqBodyAccMagStd"                 "FreqBodyAccMagMeanFreq"           
#[71] "FreqBodyBodyAccJerkMagMean"        "FreqBodyBodyAccJerkMagStd"         "FreqBodyBodyAccJerkMagMeanFreq"    "FreqBodyBodyGyroMagMean"           "FreqBodyBodyGyroMagStd"           
#[76] "FreqBodyBodyGyroMagMeanFreq"       "FreqBodyBodyGyroJerkMagMean"       "FreqBodyBodyGyroJerkMagStd"        "FreqBodyBodyGyroJerkMagMeanFreq"   "AngleTBodyAccMeanGravity"         
#[81] "AngleTBodyAccJerkMeanGravityMean"  "AngleTBodyGyroMeanGravityMean"     "AngleTBodyGyroJerkMeanGravityMean" "AngleXGravityMean"                 "AngleYGravityMean"                
#[86] "AngleZGravityMean"  

# ---------------------------------------------------------------------------
#  Questsion 5
#
# From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
# form a narrow data of all measures for each Activity/Subject
narrow_data <- melt(mean_and_std_of_comb_data, id=c("Activity","Subject"), 
		    measure.vars=names(mean_and_std_of_comb_data)[1:33])
avg_per_activity_and_subject <- dcast(narrow_data, Activity + Subject ~ variable, mean)
#> dim(narrow_data)
#[1] 339867      4
#> head(narrow_data)
#  Activity Subject        variable  value
#1 STANDING       2 TimeBodyAccStdX -0.938
#2 STANDING       2 TimeBodyAccStdX -0.975
#3 STANDING       2 TimeBodyAccStdX -0.994
#4 STANDING       2 TimeBodyAccStdX -0.995
#5 STANDING       2 TimeBodyAccStdX -0.994
#6 STANDING       2 TimeBodyAccStdX -0.994
#> dim(avg_per_activity_and_subject)
#[1] 180  35
#> head(avg_per_activity_and_subject[,1:3])
#  Activity Subject TimeBodyAccMeanX
#1   LAYING       1            0.222
#2   LAYING       2            0.281
#3   LAYING       3            0.276
#4   LAYING       4            0.264
#5   LAYING       5            0.278
#6   LAYING       6            0.249

# ---------------------------------------------------------------------------
# Write the output data to file
#
write.table(avg_per_activity_and_subject, "I:/Coursera/Data/UCI_HAR_Dataset/avg_per_activity_and_subject.txt", row.name=FALSE);


# cleanup
rm(x_test); rm(y_test); rm(subject_test)
rm(x_train); rm(y_train); rm(subject_train)
rm(comb_data); rm(narrow_data)
rm(mean_and_std_of_comb_data);rm(mean_and_std_of_test_data);rm(mean_and_std_of_train_data);
#rm(avg_per_activity_and_subject)
rm(activity_labels);rm(cols);rm(features);rm(header);
rm(l_test);rm(l_train)
cat ("\nDone!\n")
