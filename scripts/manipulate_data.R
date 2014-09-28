# =============================================================================
#
# This script load raw data, manipulate them and finally save them in a R data 
# structure.
#
# =============================================================================

add.sex.information <- function(data=data, verbose = F) {
    if (verbose) {
        data.size <- object.size(data)
        message(paste0("Initial size of the data frame : ", format(data.size, unit="auto")))
    }
    
    # Get the data 
    library("openxlsx")
    if (verbose) message("Loading questions dataframe ...")
    data.questionnaire <- read.xlsx("data/reponses_questionnaire.xlsx", 
                                    sheet = 1, 
                                    colNames = T)
    library("dplyr")  
    data.questionnaire <- select(data.questionnaire, 
                                 ID_NUMERO_TEL,
                                 SEXE_MASC,
                                 SEXE_FEM)    
    
    # Sex information
    if (verbose) message ("Getting the sex of each user ...")
    
    data.questionnaire$male <- ifelse(data.questionnaire$SEXE_MASC == 1, "male", NA)
    data.questionnaire$female <- ifelse(data.questionnaire$SEXE_FEM == 1, "female", NA)
    data.questionnaire$sex <- ifelse(is.na(data.questionnaire$male), data.questionnaire$female, "male")    
    
    if (verbose) message("Merging sex information with the input dataframe ...")
    data.questionnaire$id.mobile <- factor(data.questionnaire$ID_NUMERO_TEL)
    data.questionnaire.light <- select(data.questionnaire, id.mobile, sex) 
    #data.questionnaire.light$sex <- factor(data.questionnaire.light$sex)
    data.result <- merge(data, data.questionnaire.light, by="id.mobile")
    
    if(verbose){
        data.size <- object.size(data.result)    
        message(paste0("Final size of the data frame : ", format(data.size, unit="auto")))
    }
    
    return(data.result)
}

add.frequency.class <- function(data=data, verbose = F) {
    if (verbose) {
        data.size <- object.size(data)
        message(paste0("Initial size of the data frame : ", format(data.size, unit="auto")))
    }
    
    # Nb of sms per users
    # I use a table transformed in a dataframe to get the values.
    sms.by.user <- as.data.frame.table(table(data$id.mobile))
    colnames(sms.by.user) <- c("id.mobile", "frequency")
    
    # I will classify the users by the number of SMS sent : 
    #       very rare < rare < occasionnal < frequent < very frequent < intensive
    #
    # With : 
    #       very rare : [0:20]
    #       rare : [21:45]
    #       occasional : [46:91]
    #       frequent : [91:200]
    #       very frequent : [200:900]
    #       intensive : [900:]
    frequency.levels <- c("very rare", "rare", "occasional", "frequent", "very frequent", "intensive")
    sms.by.user$frequency.class <- factor(cut(sms.by.user$frequency, 
                                              breaks = c(0, 20, 45, 91, 200, 900, Inf), 
                                              labels = frequency.levels, 
                                              right = FALSE), levels=frequency.levels, ordered=T)
    data <- merge(data, sms.by.user, by = "id.mobile")
    
    # We can arrange the columns but we have to know the input data frame
    # TODO : check if the frequency doesn't yet exist and re-order the columns
    #data <- select(data, id.sms, id.mobile, frequency.class, frequency, timestamp, month, day, hour, day.type, holidays)
    
    if(verbose){
        data.size <- object.size(data)    
        message(paste0("Final size of the data frame : ", format(data.size, unit="auto")))
    }
    
    return(data)
}