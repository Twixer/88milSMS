# =============================================================================
#
# We will try some exploratory data analysis on the data.
#
# Questions : 
#  * when are sent the SMS  ?
#
# Assumptions :
#  * most SMS during the week-end
#  * most SMS during holidays
#  * Females are writing the most and longer SMS
#  * The vocabulary is reduced in SMS
#
# =============================================================================

# Load the data
source("scripts/get_clean_save_dataframe.R")
data <- load.data()

library("dplyr")
data <- select(data, -sms)

# ================
# Analysis of the data distribution

# Date distribution
summary(data$timestamp)
nb.days <- max(data$timestamp) - min(data$timestamp)
# 91 days

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

#analysis.per.day <- table(data$month, data$day)
max(table(data$month, data$day))

#analysis.per.hour <- table(data$hour) 
plot(table(data$hour), main="SMS per hour", ylab="Nb of SMS")

# User distribution
length(levels(data$id.mobile))
# 423 users 

sms.by.user <- table(data$id.mobile)
hist(sms.by.user, 
     breaks = 100, 
     #axes = F,
     xaxt='n',
     main="SMS distribution",
     xlab="Nb of SMS",
     ylab="Frequency of users")
axis(1,at = c(seq(0,2000,50), seq(2000, 8000, 2000)),labels = T,pos = 0)

sms.by.user <- as.data.frame.table(sms.by.user)
colnames(sms.by.user) <- c("id.mobile", "frequency")

# Outliers : < 50 sms and > 2000
data.less.than.91 <- filter(sms.by.user, frequency <= 91)
hist(data.less.than.91$frequency,
     breaks = 9, 
     #axes = F,
     xaxt='n',
     main="Nb of SMS by user with an average\n less than 1 SMS by day",
     xlab="Nb of SMS",
     ylab="Frequency of users")
axis(1,at = seq(0,91,10), labels = T,pos = 0)

# This population has an average from 1 SMS/day to 20 SMS/day
data.between.91.and.2000 <- filter(sms.by.user, frequency > 91 & frequency < 2000)
hist(data.between.91.and.2000$frequency,
     #breaks = 9, 
     #axes = F,
     xaxt='n',
     main="Nb of SMS by user within [91:2000] total SMS",
     xlab="Nb of SMS",
     ylab="Frequency of users")
axis(1,at = seq(90,2000,50), labels = T,pos = 0)

source("scripts//manipulate_data.R")
data <- add.frequency.class(data, verbose=T)

