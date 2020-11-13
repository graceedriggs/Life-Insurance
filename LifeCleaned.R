#libraries
library(tidyverse)
library(caret)
library(DataExplorer)

life.train <- read_csv("/Users/graceedriggs/Documents/Stat 495/Life-Insurance/train.csv")
life.test <- read_csv("/Users/graceedriggs/Documents/Stat 495/Life-Insurance/test.csv")

life <- bind_rows(life.train, life.test)
