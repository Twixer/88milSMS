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
#  - ...
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
    
    # All process if forced
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
        load(data.clean.file)
    } else {
        load(data.raw.file)
        data.clean <- cleaning.and.saving.data(data=data.raw, 
                                               filename=data.clean.file, 
                                               timeout=timeout)
    }
    
    return(data.clean)
}