# README for UIC HAR Data Analysis script
# nram, Apr 24, 2015

The script run_analysis.R does the following 
#----------------------------------------------------------------------------
1) Download and unzip file 
   using download.file() and unzip() respectively

#----------------------------------------------------------------------------
2) Read the unzipped data files using read.table(). It checks the data 
   directory and a file (features.txt) exists as a sanity check before 
   reading the file

#----------------------------------------------------------------------------
3) Cleansup the header using a series of gsub().
   Instead of manually assigning the headers, the header names
   are converted to CamelShell format, getting rid of () and -
   It also addes additional columns that are generated with in the script.

   This results in header like this:
  > sample(header,10)
 [1] "TimeGravityAccMadY"       "TimeBodyGyroMeanZ"       
 [3] "TimeGravityAccArCoeffY_2" "FreqBodyAccKurtosisX"    
 [5] "TimeBodyAccJerkEnergyZ"   "TimeBodyGyroJerkMeanZ"   
 [7] "TimeBodyAccIqrZ"          "TimeBodyGyroJerkIqrY"    
 [9] "TimeBodyAccJerkMagEnergy" "TimeGravityAccMagMad"  


#----------------------------------------------------------------------------
4) Merge data files.
   activity_labels and y_test (activity_index) are merged with join_all 
   this gives a wide table in the form
   > head(l_test)
  V1       V2
1  5 STANDING
2  5 STANDING
3  5 STANDING
4  5 STANDING
5  5 STANDING
6  5 STANDING

   Then this is meraged with x_test (dataset) using cbind
   with additional columns for activity name and subject
   A column type is added and assigned value "test" to identify this

   The same is repeated for training data with resulting x_train dataset
   with additional columns for activity name and subject
   A column type is added and assigned value "train" to identify this

   Both x_test and x_train are assitned common header (so they can be 
   combined)

   At the end, x_test and x_train are combined with rbind creating a huge 
   dataset with both test and training data
> dim(comb_data)
[1] 10299   564

   This combined data has the activty labels for each measurement.
>  table(mean_and_std_of_comb_data$Activity)

            LAYING            SITTING           STANDING            WALKING WALKING_DOWNSTAIRS   WALKING_UPSTAIRS 
              1944               1777               1906               1722               1406               1544 

#----------------------------------------------------------------------------
5) Extract only select colums (that have Std or Mean) that have mean and 
   standard deviation from this combined data called 
   mean_and_std_of_comb_data
> dim(mean_and_std_of_comb_data)
[1] 10299    89



#----------------------------------------------------------------------------
6) The mean_and_std_of_comb_data is flattenned to create a narrow data with 
   melt, with Activity and Subject as id and all other fields as variables. 

   The resulting data (narrow_data) is a long list of measurements, 
   one per line for each of Activity and Subject combination
> dim(narrow_data)
[1] 339867      4
> head(narrow_data)
  Activity Subject        variable  value
1 STANDING       2 TimeBodyAccStdX -0.938
2 STANDING       2 TimeBodyAccStdX -0.975
3 STANDING       2 TimeBodyAccStdX -0.994
4 STANDING       2 TimeBodyAccStdX -0.995
5 STANDING       2 TimeBodyAccStdX -0.994
6 STANDING       2 TimeBodyAccStdX -0.994

	From this using dcast, aggregate of Activity/Subjet for each measure 
	is calculated with mean function to get the average of each measure 
	per Activity/Subject.
> head(avg_per_activity_and_subject[,1:3])
  Activity Subject TimeBodyAccMeanX
1   LAYING       1            0.222
2   LAYING       2            0.281
3   LAYING       3            0.276
4   LAYING       4            0.264
5   LAYING       5            0.278
6   LAYING       6            0.249

#----------------------------------------------------------------------------
7) The resultting average value is writen to file (for uploading to github as 
   required for the assignment)

#----------------------------------------------------------------------------
8) All large datasets created in the file are removed before exiting.
