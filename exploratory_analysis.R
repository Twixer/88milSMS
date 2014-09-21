# =============================================================================
#
# We will try some exploratory data analysis on the data.
#
# =============================================================================

# Load the data
source("getting_cleaning_saving_data.R")
data <- load.data()

# histograms
hist(data$timestamp, 
     breaks="days", 
     main="Histogram of SMS by day", 
     xlab="Days",
     ylab="Frequency")

hist(data$timestamp, 
     breaks="hours",
     main="Histogram of SMS by hour", 
     xlab="Hours",
     ylab="Frequency")

boxplot(data$timestamp ~ data$id.mobile)
