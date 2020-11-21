###################
### Predictions ###
###################

#split
life.train <- life %>% filter(!is.na(Response))
life.test <- life %>% filter(is.na(Response))
plot_missing(life.train)

#10 folds repeat 3 times
control <- trainControl(method='repeatedcv', 
                        number=3, 
                        repeats=2)

grid_default <- expand.grid(
  nrounds = 50,
  max_depth = 35,
  eta = 0.3,
  gamma = 6,
  colsample_bytree = .5,
  min_child_weight = 12,
  subsample = 1)

#XGBoost
metric <- "Accuracy"
set.seed(123)
xgb_default <- train(as.factor(Response) ~ ., 
                    data=life.train %>% select(-Id),
                    method='xgbTree', 
                    trControl=control,
                    tuneGrid = grid_default)


names(xgb_default)
plot(xgb_default)
xgb_default$bestTune

#predict
predictions <- data.frame(Id=life.test$Id, Response=(predict(xgb_default, newdata=life.test)))
write.csv(predictions,"/Users/graceedriggs/Documents/STAT 495/Life-Insurance/GD_XGB_Life-Insurance-Predictions7.csv", row.names = FALSE)
