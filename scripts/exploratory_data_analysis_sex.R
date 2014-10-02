# =============================================================================
#
# We will try some exploratory data analysis on the data.
#
# Assumptions :
#  * Females are writing the most and longer SMS
# =============================================================================

# Load the data
source("scripts/get_clean_save_dataframe.R")
source("scripts//manipulate_data.R")
data <- load.data()

library("dplyr")
data <- select(data, -sms)

# Sex comparisons
data <- add.sex.information(data, verbose=T)
# Males : 142 (34%)
# Females : 262 (62%)
# Unknow : 18 (4%)

table(data$id.mobile,data$sex, useNA = T)
barplot(table(data$sex, useNA = "always"), 
        main="SMS per sex", 
        ylab="Nb of SMS",
        col = rich.colors(4),
        legend=names(table(data$sex, useNA = "always")))

data.without.outlier <- data %>% 
    group_by(id.mobile, sex) %>%
    select(id.mobile, sex, id.sms) %>%
    summarise(nb.sms = n()) %>%
    filter(nb.sms < 2000) %>%
    group_by(sex) %>%
    summarise(total=sum(nb.sms))
data.without.outlier$percent <- data.without.outlier$total / sum(data.without.outlier$total) * 100
data.without.outlier

library(gplots)
barplot(data.without.outlier$total, 
        main="SMS per sex", 
        ylab="Nb of SMS",
        col = rich.colors(4),
        legend=data.without.outlier$sex)

# The proportion of SMS sent by males and females is roughly identical to the 
# distribution of males and females in the dataset.
# The assumptions that females are written most SMS is wrong on these data 
# (+6/7% of difference).
# Outliers corresponding to users with more than 2000 SMS have been removed from 
# the comparison.

# TODO : modify the max limit for SMS and observe the variation on the
#       male/female distribution.