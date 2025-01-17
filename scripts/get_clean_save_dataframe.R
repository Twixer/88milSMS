# =============================================================================
#
# This script load raw data, manipulate them and finally save them in a R data 
# structure.
#
# =============================================================================

# ================
# Getting and saving raw data
# ================

# This function extract data from an EXCEL file and save them in a RDATA
# file. The function return the dataframe.
#
# Args : 
#    filename (string) : a string for the filename destination 
#                       of the extracted data.
#    timeout (integer) : an integer for the time allowed for the data 
#                       extraction.
#
# Returns : 
#    dataframe : the data frame reprensenting the extracted raw data.
getting.and.saving.raw.data <- function (filename="data/data_raw.RData", 
                                         timeout=120) {
    
    message("Start the getting data process ...")
    
    #set the timeout (2min by default)
    setTimeLimit(elapsed=timeout, transient=TRUE);
    
    on.exit({
        #reset time limit
        setTimeLimit(cpu=Inf, elapsed=Inf, transient=FALSE);
    })
    
    # Get the data 
    library("openxlsx")
    data.raw <- read.xlsx("data/88milSMS_88522.xlsx", 
                          sheet = 1, 
                          colNames = T)
    
    data.size <- object.size(data)
    message(paste0("Raw data frame size is : ", format(data.size, unit="auto")))
    
    # The data frame is saved. 
    # The loading operation is too long to reproduce.
    save(data.raw, file = filename)
    
    message(paste0("Raw data are saved in a RData file : ", filename))
    
    return(data.raw)
}

# ================
# Cleaning raw data and saving them
# ================

# This function manipulates raw data in order to get tidy data more easy to 
# analyse.
# 
# Operations performed are  : 
#  1. rename columns : id.sms, timestamp, id.mobile, sms
#  2. Column types : id.sms as integer, id.mobile as factor, timestamp as POSIXct
#  3. add columns : day(factor), hour(factor), weekday/weekend(factor), holidays
#  4. ordering columns : id.sms, id.mobile, timestamp, month, day, hour, day.type, sms
#
# Args : 
#    data (dataframe) : a data frame with the raw data to manipulate.
#    filename (string) : the filename for saving the resulting data frame in a 
#                       RData structure.
#    timeout (integer) : an integer for the time allowed for the data 
#                       extraction.
#
# Returns : 
#    dataframe : the data frame with the cleaned data.
cleaning.and.saving.data <- function(data=data.raw,
                                     filename="data/data_clean.RData", 
                                     timeout=120) {
    message("Start the cleaning process ...")
    #set the timeout (2min by default)
    setTimeLimit(elapsed=timeout, transient=TRUE);
    
    on.exit({
        #reset time limit
        setTimeLimit(cpu=Inf, elapsed=Inf, transient=FALSE);
    })
    
    data.size <- object.size(data)
    message(paste0("Initial raw data frame size is : ", format(data.size, unit="auto")))
    
    data.clean <- data
    data.columns <- c("id.sms", "timestamp", "id.mobile", "sms")
    message("Data manipulation : renaming columns.")
    data.columns
    
    colnames(data.clean) <- data.columns
    
    message("Data manipulation : column types.")    
    data.clean$id.sms <- as.integer(data.clean$id.sms)
    data.clean$timestamp <- as.POSIXct(strptime(data.clean$timestamp, format = "%d %b %Y %T", tz = "Europe/Paris"))
    data.clean$id.mobile <- factor(data.clean$id.mobile)

    message("Adding columns : day, hour, weekend/weekday, holidays")
    # month
    data.clean$month <- factor(as.integer(format(data.clean$timestamp, "%m")))
        
    # day
    data.clean$day <- factor(as.integer(format(data.clean$timestamp, "%d")))
    
    # hour
    data.clean$hour <- factor(as.integer(format(data.clean$timestamp, "%H")))
    
    # weekday / weekend
    locale.lc_time <- Sys.getlocale(category = "LC_TIME")
    Sys.setlocale(category = "LC_TIME", locale ="English")
    data.clean$day.type <- as.factor(ifelse(
                    weekdays(data.clean$timestamp) %in% c("Saturday","Sunday"), 
                    "Weekend", 
                    "Weekday"))
    Sys.setlocale(category = "LC_TIME", locale = locale.lc_time)
    
    # Holidays
    # holidays in France for the data period are : 22/10/2011 to 03/11/2011    
    data.clean$holidays <- as.factor(ifelse(
        data.clean$timestamp > as.POSIXct(as.Date("21/09/2011", format="%d/%m/%Y"))
        &  data.clean$timestamp < as.POSIXct(as.Date("04/11/2011", format="%d/%m/%Y")), 
        1, 
        0))
    
    # ordering columns
    columns <- c("id.sms", 
                 "id.mobile", 
                 "timestamp", 
                 "month",
                 "day", 
                 "hour", 
                 "day.type",
                 "holidays",
                 "sms")    
    message(paste("Ordering columns."))
    columns
    data.clean <- data.clean[, columns]
    
    data.clean.size <- object.size(data.clean)
    message(paste0("Final cleaned data frame size is : ", format(data.clean.size, unit="auto")))
    

    save(data.clean, file = filename)
    message(paste0("Cleaned and tidy data are saved in a RData file : ", 
                   filename))
    
    return(data.clean)
}

# ================
# Loading data
# ================

# This function load and send back the cleaned data.
# If this function is called for the first time, the process is as following : 
#       1. get raw data
#       2. save raw data
#       3. clean data
#       4. save cleaned data
#       5. returns cleaned data
# 
# These operations are performed by the following functions : 
#  - getting.and.saving.raw.data()
#  - cleaning.and.saving.data()
# 
# If this function has already been called, we can assume that the data are
# already saved in RData structure on disk. We just load them and send them 
# back.
#
# Args : 
#    data.raw.file (string) : the filename for the RData file containing
#                       the raw file.
#    data.clean.file (string) : the filename for the RData file containing
#                       the clean file.
#    timeout (integer) : an integer for the time allowed for the data 
#                       extraction.
#    force (boolean) : if TRUE, all the process is performed (from getting raw
#                   data to cleaning them). FALSE by default.
#
# Returns : 
#    dataframe : the data frame reprensenting the extracted raw data.
load.data <- function (data.raw.file= "data/data_raw.RData", 
                       data.clean.file = "data/data_clean.RData",
                       timeout = 120,
                       force = F) {
    
    # All processes if forced or if first time
    if (force | !file.exists(data.raw.file)) {
        message("All the getting and cleaning process is performed.")
        data.raw <- getting.and.saving.raw.data(filename=data.raw.file, 
                                                timeout=timeout)
        data.clean <- cleaning.and.saving.data(data=data.raw, 
                                               filename=data.clean.file, 
                                               timeout=timeout)
        return(data.clean)        
    }
    
    # The clean data already exists ?
    if (file.exists(data.clean.file)) {
        message("The clean data file already exists.")
        load(data.clean.file)
    } else {
        message("The raw data file already exists.")
        load(data.raw.file)
        data.clean <- cleaning.and.saving.data(data=data.raw, 
                                               filename=data.clean.file, 
                                               timeout=timeout)
    }
    
    return(data.clean)
}