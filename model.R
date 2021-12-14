
#loading the dataset
setwd('C:/Users/pocha/Documents/sunderland/shiny/sensor-heroku')
df_first <- read.table("datatest.txt", header = TRUE, sep = ',')
df_second <- read.table("datatest2.txt", header = TRUE, sep = ',')
df_third <- read.table("datatraining.txt", header = TRUE, sep = ',')

#combining all the dataset
set.seed(03)
df_combined <- rbind(df_first, df_second, df_third)

#display the data
head(df_combined)

#changing the data column to categories
library(lubridate)
dates <- as.POSIXlt(df_combined$date)
date.hour <- hour(dates)

#obtaining a time Period from the date
Period <- vector()
for (i in 1:nrow(data.frame(date.hour))) {
  if (date.hour[i] >= 3 && date.hour[i] < 9) {
    Period[i] = "earlydaytime"
  } else if (date.hour[i] >= 9 && date.hour[i] < 15) {
    Period[i] = "daytime"
  } else if (date.hour[i] >= 15 && date.hour[i] < 21) {
    Period[i] = "eveningtime"
  } else {
    Period[i] = "lateevening"
  }
}

#removing the date and adding a time Period gotten from the date
df_combined$date <- NULL
set.seed(111)
df_combined$Period <- Period
occupancy <- df_combined$Occupancy
df_combined$Occupancy  <- NULL
df_combined$Occupancy <- occupancy
library(caret)


#preprocessing the data
library(caret)
set.seed(10)
preProcValuesN <- preProcess(df, method = c("range"))
df <- predict(preProcValuesN, df)


#using the factors
df_combined$Occupancy <- as.factor(df_combined$Occupancy)
set.seed(42)

#creating train and test set
index <-
  createDataPartition(df_combined$Occupancy, p = 0.7, list = FALSE)
train_set <- df_combined[index, ] # train set created
test_set <- df_combined[-index, ] # test set creates
set.seed(43)

#writing the trainset to the storage
write.table(
  train_set,
  "./train_set.csv",
  sep = ",",
  quote = FALSE,
  row.names = FALSE,
  col.names = TRUE
)


#setting the control parameters
set.seed(31)
ctrl <-
  trainControl(method = "repeatedcv",
               repeats = 5,
               number = 10) #setting parameters

#training the model with the exoanded grid of 1 to 20
set.seed(32)
knnModel <- train(
  Occupancy  ~ .,
  method = "knn",
  data = train_set,
  tuneGrid = expand.grid(k = 1:10),
  trControl = ctrl,
  metric = "Accuracy"
)
print(knnModel)

plot(knnModel)



# using the test data for validation
set.seed(423)
validate <- predict(knnModel, newdata = test_set, type = "raw")

# Accuracy and other metrics
confusionMatrix(validate, test_set$Occupancy)  #98.99% accuracy

#saving the model
saveRDS(knnModel, "knnmodel.rds")
