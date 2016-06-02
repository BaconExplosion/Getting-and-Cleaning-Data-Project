# Getting-and-Cleaning-Data-Project

Project assignment for the Coursera JHU Getting and Cleaning Data class week 4.

This script merges the UCI HAR training and test dataset and cleans it by doing the following:
1. Creates the test and training data sets by reading from the files provided by the UCI HAR Data
2. Appends the test set to the training set
3. Selects the columns that contain the mean or standard deviation (std) of any measure
4. Returns a dataset with the mean of the selected columns grouped by each activity within each subject ID
