# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `course_project.R`, does the following:

1. Create a directory for downloadable file
2. Download the zipped data file
3. Unzip the downloaded data file
4. Read activity labels and features files
5. Identify names and numbers of required columns
6. Read training and test datasets while selecting only the required columns
7. Combine training and test datasets
8. Group the combined data by `Activity` and `Subject` columns
9. Calculate mean values of numerical columns of the grouped data
10. Write resultant data to `tidy_data.csv` file
11. Create `codebook.html` of output data
