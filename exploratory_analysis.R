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

analysis.per.day <- table(data$month, data$day)
plot(analysis.per.day, main="SMS per day", ylab="Nb of SMS")
max(analysis.per.day)

analysis.per.hour <- table(data$hour)
plot(analysis.per.hour, main="SMS per hour", ylab="Nb of SMS")

analysis.per.day.type <- table(data$day.type)
barplot(analysis.per.day.type, main="SMS per type of day",, ylab="Nb of SMS")

boxplot(data$timestamp ~ data$id.mobile)
