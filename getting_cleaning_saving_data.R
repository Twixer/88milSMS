# =============================================================================
#
# This script load raw data, manipulate them and finally save them in a R data 
# structure.
#
# =============================================================================

setwd("F:/applis/workspace-r/88milSMS")

# ================
# Getting and saving raw data
# ================

# This function extract data from an EXCEL file and save them in a RDATA
# file. The function return the dataframe.
#
# Args : 
#    filename (string) : a string for the filename destination 
#                       of the extracted data.
#    timeout (integer) : an integer for the time allowed for the data extraction.
#
# Returns : 
#    datafram : the data frame reprensenting the extracted raw data.
getting.and.saving.raw.data <- function (filename="data/data_raw.RData", timeout=120) {
    
    #set the timeout (2min by default)
    setTimeLimit(elapsed=timeout, transient=TRUE);
    
    on.exit({
        #reset time limit
        setTimeLimit(cpu=Inf, elapsed=Inf, transient=FALSE);
    })
    
    # The data file to load needs a lot of memory. We need to apply this 
    # parameter before the library rJava is loaded.
    options(java.parameters = "-Xmx3000m")
    
    # The xlsx library use rJava to manipulate the Excel file.
    # The loading of the xlsx library is just a trick at this point
    # to ensure that the dependencies are loaded.
    library("xlsx")
    
    #     Rprof(tf <- "logs/rprof.log", memory.profiling=TRUE)    
    #      [code to profile]
    #     Rprof(NULL)
    #     summaryRprof(tf)
    
    data.raw <- read.xlsx2("data/88milSMS_88522.xlsx", sheetName = "data")    
    
    # The data frame is saved. 
    # The loading operation is too long to reproduce.
    save(data.raw, file = filename)
    
    return(data.raw)
}

# ================
# Cleaning raw data and saving them
# ================


# ================
# Loading data
# ================
