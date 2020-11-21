#libraries
library(tidyverse)
library(caret)
library(DataExplorer)
library(gtools)

# https://www.kaggle.com/c/prudential-life-insurance-assessment/data

#import data
life.train <- read_csv("/Users/graceedriggs/Documents/Stat 495/Life-Insurance/train.csv")
life.test <- read_csv("/Users/graceedriggs/Documents/Stat 495/Life-Insurance/test.csv")

life <- bind_rows(life.train, life.test)


# Correlation Plot.... its super messy... but it seems like there may be some collinearity
corrplot::corrplot(cor(lapply(life, is.numeric) %>% unlist() %>% life[,.]))

# Plot missing
missingPlot <- plot_missing(life %>% .[,colSums(is.na(life)) > 0])

# These are the variables that have missing data
missingVars <- missingPlot$data$feature
missingVars

# We should probably look at each one of them and see if they are necessary to
# keep in our model
life %>% select(-missingVars)

sum(is.na(life %>% select(-Response))) # good, so all the columns with NAs are listed abova


################
### Cleaning ###
################

life <- life %>% select(- c(Medical_History_15, Medical_History_10, Medical_History_24, Medical_History_32, Family_Hist_5, Family_Hist_3, Insurance_History_5, Family_Hist_2))
plot_missing(life %>% .[,colSums(is.na(life)) > 0])

str(life)

#Employment_Info_1
life$Employment_Info_1 <- na.replace(life$Employment_Info_1, mean(life$Employment_Info_1, na.rm= TRUE)) #continuous

#Employment_Info_4
life$Employment_Info_4 <- na.replace(life$Employment_Info_4, mean(life$Employment_Info_4, na.rm= TRUE)) #discrete

#Medical_History_1
life$Medical_History_1 <- na.replace(life$Medical_History_1, mean(life$Medical_History_1, na.rm= TRUE)) #discrete

#Employment_Info_6 
life$Employment_Info_6 <- na.replace(life$Employment_Info_6, mean(life$Employment_Info_6, na.rm= TRUE)) #continuous

#Family_Hist_4
life$Family_Hist_4 <- na.replace(life$Family_Hist_4, mean(life$Family_Hist_4, na.rm= TRUE)) #continuous




##### Try taking all these values out of the model
life2 <- life %>% select(- c(Medical_History_15, Medical_History_10, Medical_History_24, Medical_History_32, Family_Hist_5, Family_Hist_3, Insurance_History_5, Family_Hist_2, Employment_Info_4, Medical_History_1, Employment_Info_6, Family_Hist_4))
