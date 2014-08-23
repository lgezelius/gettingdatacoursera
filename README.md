gettingdatacoursera
===================

Homework assignment for Coursera Getting and Cleaning Data.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The assignment includes the following files:
============================================

* [run_analysis.R](run_analysis.R): create tidy data sets from Samsung test and train data sets  
    * download and expand Samsung data set
    * read and combine the test and train data for subjects
    * read the activity levels and labels from a space delimited file
    * read and combine the test and train data for activities
    * read the column labels for the feature data
    * replace apparent "BodyBody" typo in columns$name vector with "Body"
    * read and combine the test and train data for features
    * create a character vector of column names containing "mean()" or "std()"
    * create the first tidy data set
    * convert the strings of space delimited feature data to vectors
    * apply the labels for the feature columns
    * include only the mean() and std() feature data
    * join subject, activity, and feature data
    * create and write out the second tidy data set (data/aggregate.txt)
    * compute the mean of feature data, grouped by subject and activity
    * generate code book fragment    
- [data/aggregate.txt](data/aggregate.txt): tidy data set that returns the average of measurement mean and standard deviation variables.
- [CodeBook.md](CodeBook.md): description of the data in aggregate.txt







