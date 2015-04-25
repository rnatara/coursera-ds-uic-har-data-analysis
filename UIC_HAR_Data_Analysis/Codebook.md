# UIC HAR Data Analysis Codebook
# nram, Apr 25, 2015
# Pl see RAW Version for readability

-----------------------------------------------------------------------------
Libraries
-----------------------------------------------------------------------------
   Required
	plyr 
	dplyr
	reshape2

-----------------------------------------------------------------------------
Files
-----------------------------------------------------------------------------
   Input files
	UCI_HAR_Dataset/features.txt
	UCI_HAR_Dataset/activity_labels.txt
	UCI_HAR_Dataset/test/X_test.txt
	UCI_HAR_Dataset/test/y_test.txt
	UCI_HAR_Dataset/test/subject_test.txt
	UCI_HAR_Dataset/train/X_train.txt
	UCI_HAR_Dataset/train/y_train.txt
	UCI_HAR_Dataset/train/subject_train.txt

   Output files
	UCI_HAR_Dataset/avg_per_activity_and_subject.txt

-----------------------------------------------------------------------------
Variables:
-----------------------------------------------------------------------------
   features
   	This is the data read from features.txt
   activity_labels
   	This is data read from activyt_labels.txt
   x_test
   	This is the data read from x_test.txt
	This is also used as tidy version of test data
	using merge functions
   y_test
   	This is the data read from y_test.txt
	This is also used as tidy version of train data
	using merge functions
   l_test
   	This is an intermediate combining activity index and label
   subject_test
   	This is the data read from subject_test.txt
   x_train
   	This is the data read from x_train.txt
   y_train
   	This is the data read from y_train.txt
   subject_train
   	This is the data read from subject_train.txt
   l_train
   	This is an intermediate combining activity index and label
   comb_data
   	This is the tidy data with combined data from
	x_test (tidied test data) and y_test (tidied training data)
   header
   	This is the tidied header (column names) for data set
   mean_and_std_of_comb_data
   	This the tidy data with only mean and standard deviation
	columns from the comb_data
   cols
   	This is the column names of mean_and_std_of_comb_data
   narrow_data
   	This is the narrow data with Activity and Subject as id
	and all other measumrements as variables (one per row)
	This is the intermediate data for calculating average
   avg_per_activity_and_subject
   	This is the average (mean) of each measuremement for each
	Activity and Subject

-----------------------------------------------------------------------------
Column names of mean_and_std_of_comb_data (cols)
-----------------------------------------------------------------------------
	Activity             
	Subject               
	TimeBodyAccMeanX     
	TimeBodyAccMeanY      
	TimeBodyAccMeanZ      
	TimeBodyAccStdX      
	TimeBodyAccStdY       
	TimeBodyAccStdZ       
	TimeGravityAccMeanX  
	TimeGravityAccMeanY   
	TimeGravityAccMeanZ   
	TimeGravityAccStdX   
	TimeGravityAccStdY    
	TimeGravityAccStdZ    
	TimeBodyAccJerkMeanX 
	TimeBodyAccJerkMeanY  
	TimeBodyAccJerkMeanZ  
	TimeBodyAccJerkStdX  
	TimeBodyAccJerkStdY   
	TimeBodyAccJerkStdZ   
	TimeBodyGyroMeanX    
	TimeBodyGyroMeanY     
	TimeBodyGyroMeanZ     
	TimeBodyGyroStdX     
	TimeBodyGyroStdY      
	TimeBodyGyroStdZ      
	TimeBodyGyroJerkMeanX
	TimeBodyGyroJerkMeanY 
	TimeBodyGyroJerkMeanZ 
	TimeBodyGyroJerkStdX 
	TimeBodyGyroJerkStdY  
	TimeBodyGyroJerkStdZ  
	TimeBodyAccMagMean   
	TimeBodyAccMagStd     
	TimeGravityAccMagMean
-----------------------------------------------------------------------------
