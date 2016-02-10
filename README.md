Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

1. Load the necessary libraries
2. Download the dataset if it does not already exist in the working directory and unzip it
3. Loads the subject, data and label files
4. Merges the training and the test sets to create one data set
5. Loads the features table
6. Extracts only the measurements on the mean and standard deviation for each measurement
7. Subsets both tables together
8. Loads the activities labels table
9. Creates a column with the Activity Names in the final data
10. Melts and aggregate with dcast. The result is a table with the average for each subject (30) and each activity label (06)

The result is shown in the file tidyData.txt