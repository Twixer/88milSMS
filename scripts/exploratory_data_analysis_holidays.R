# =============================================================================
#
# We will try some exploratory data analysis on the data.
#
# Assumptions :
#  * most SMS during holidays
#
# =============================================================================

library("ggplot2")

# ================
# Weekdays vs Weekends / holidays or not

# finally the average of SMS during the weekdays are greater than during the 
# weekend
analysis.per.day.type <- table(data$day.type) / c(5, 2)
barplot(analysis.per.day.type, main="SMS per type of day",, ylab="Nb of SMS")

# =================
# Holidays 

sms.by.day.type <- data %>%
    group_by(id.mobile, day.type) %>%
    select(id.mobile, day.type, id.sms) %>%
    #filter(day.type == "Weekend") %>%
    summarise(nb.sms = n())

# sms.weekdays <- data %>%
#     group_by(id.mobile) %>%
#     select(id.mobile, day.type, id.sms) %>%
#     filter(day.type == "Weekday") %>%
#     summarise(nb.sms = length(id.sms))


# ggplot(data = sms.by.day.type,
#        aes(y = nb.sms, x = id.mobile, fill=day.type)) +
#     #theme_bw() + 
#     geom_bar(stat = "identity",
#              position = "stack",
#              width=1,
#              #binwidth = max(sms.weekend$count)/9, 
#              colour = "red",
#              alpha = 0.6) +
#     scale_x_discrete("Users", labels=levels(sms.by.day.type$id.mobile)) + 
#     scale_fill_manual(values=c("blue", "red")) +
#     coord_flip() +
#     ylab(NULL)
#facet_grid(. ~ day.type, space="free_x", scales="free_x", labeller=label_both)    

d<- filter(data, frequency.class == "very rare")
ggplot(data = data,
       aes(x = id.mobile, fill=day.type)) +
    #theme_bw() + 
    geom_bar(stat = "bin",
             position = "stack",
             width=1,
             #binwidth = max(sms.weekend$count)/9, 
             colour = "red",
             alpha = 0.6) +
    scale_x_discrete("Users", labels=levels(data$id.mobile)) + 
    scale_fill_manual(values=c("blue", "red")) +
    coord_flip() +
    facet_wrap(~ day.type, ncol=2)

ggplot(data = data,
       aes(x = id.mobile, fill=day.type)) +
    #theme_bw() + 
    geom_bar_horizontal(stat = "bin",
                        position = "stack",
                        width=1,
                        #binwidth = max(sms.weekend$count)/9, 
                        colour = "red",
                        alpha = 0.6) +
    scale_x_discrete("Users", labels=levels(data$id.mobile)) + 
    scale_fill_manual(values=c("blue", "red")) +
    #coord_flip() +
    facet_grid(~ frequency.class, space="free", scales="free", labeller=label_both)


p1 <- ggplot(data = subset(data, frequency.class=="rare"),
             aes(x = as.numeric(id.mobile), fill=day.type)) +
    labs(title="Very rare", fill ="Type of day") +
    theme(#axis.line.x=element_line(linetype=NULL),
        #axis.line.y=element_line(linetype=NULL),
        #panel.grid=element_line(linetype=NULL),
        axis.text.x= element_blank(),
        axis.ticks=element_blank(),
        panel.background=element_rect(fill = "white", color="white")) +    
    #theme_bw() + 
    geom_bar(stat = "bin",
             position = "stack",
             width=1,
             #binwidth = max(sms.weekend$count)/9, 
             binwidth = 5,
             colour = "red",
             alpha = 0.6) +
    scale_x_discrete("", breaks=levels(data$id.mobile), drop=F) + 
    scale_fill_brewer(palette="Spectral")
#scale_fill_manual(values=c("blue", "red")) 

p2 <- ggplot(data = subset(data, frequency.class=="rare"),
             aes(x = as.numeric(id.mobile), fill=day.type)) +
    labs(title="Rare", fill ="Type of day") +
    theme(axis.text.x= element_blank(),
          axis.ticks=element_blank(),
          panel.background=element_rect(fill = "white", color="white")) +    
    geom_bar(stat = "bin",
             position = "stack",
             width=1,
             binwidth = 5,
             colour = "red",
             alpha = 0.6) +
    scale_x_discrete("Users", labels=levels(data$id.mobile), drop=F) + 
    scale_fill_brewer(palette="Spectral")

p3 <- ggplot(data = subset(data, frequency.class=="occasional"),
             aes(x = as.numeric(id.mobile), fill=day.type)) +
    labs(title="Occasionnal", fill ="Type of day") +
    theme(axis.text.x= element_blank(),
          axis.ticks=element_blank(),
          panel.background=element_rect(fill = "white", color="white")) +  
    geom_bar(stat = "bin",
             position = "stack",
             width=1,
             binwidth = 5,
             colour = "red",
             alpha = 0.6) +
    scale_x_discrete("Users", labels=levels(data$id.mobile), drop=F) + 
    scale_fill_brewer(palette="Spectral")

p4 <- ggplot(data = subset(data, frequency.class=="frequent"),
             aes(x = as.numeric(id.mobile), fill=day.type)) +
    labs(title="Frequent", fill ="Type of day") +
    theme(axis.text.x= element_blank(),
          axis.ticks=element_blank(),
          panel.background=element_rect(fill = "white", color="white")) +  
    geom_bar(stat = "bin",
             position = "stack",
             width=1,
             binwidth = 5,
             colour = "red",
             alpha = 0.6) +
    scale_x_discrete("Users", labels=levels(data$id.mobile), drop=F) + 
    scale_fill_brewer(palette="Spectral")

p5 <- ggplot(data = subset(data, frequency.class=="very frequent"),
             aes(x = as.numeric(id.mobile), fill=day.type)) +
    labs(title="Very frequent", fill ="Type of day") +
    theme(axis.text.x= element_blank(),
          axis.ticks=element_blank(),
          panel.background=element_rect(fill = "white", color="white")) + 
    geom_bar(stat = "bin",
             position = "stack",
             width=1,
             binwidth = 5,
             colour = "red",
             alpha = 0.6) +
    scale_x_discrete("Users", labels=levels(data$id.mobile), drop=F) + 
    scale_fill_brewer(palette="Spectral")

p6 <- ggplot(data = subset(data, frequency.class=="intensive"),
             aes(x = as.numeric(id.mobile), fill=day.type)) +
    labs(title="Intensive", fill ="Type of day") +
    theme(axis.text.x= element_blank(),
          axis.ticks=element_blank(),
          panel.background=element_rect(fill = "white", color="white")) + 
    geom_bar(stat = "bin",
             position = "stack",
             width=1,
             binwidth = 5,
             colour = "red",
             alpha = 0.6) +
    scale_x_discrete("Users", labels=levels(data$id.mobile), drop=F) + 
    scale_fill_brewer(palette="Spectral")

grid.arrange(p1, p2, p3, p4, p5, p6, 
             main="Distribution of SMS for weekend/weekday\n by type of user")
