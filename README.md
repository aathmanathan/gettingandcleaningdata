# gettingandcleaningdata
Coursera Course Module 3

- The unzipped folder from UCI has been renamed “Dataset from UCI”
- The R code, Dataset from UCI, Codebook for Submission and this README file must all be in the same folder

CODEBOOK for assignment

The tidied data frame contains the data from test and training sets, each of which has been summarized over 561 dimensions to generate mean and standard deviation.

The dataset has been organized into the following columns:
1. Datatype: Whether data is from the training set or the test set
2. Subject ID: The number denoting the subject, ranging 1-30
2. ActivityID: The specific activity for which data was collected. The ID (string was established based on the ‘activity_labels.txt’ file supplied with original data set. It can take one of 6 levels.
3. The selected dimensions, which contain either ‘mean’ or ‘std’ in the column name. Out of 561, 79 were picked.
