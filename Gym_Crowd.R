

#NipunAllurwar B2020031
library(car)
library(corrplot)
library(caret)
library(caTools)
library(psych)
library(ggplot2) 
library(rgdal) 
library(dplyr)
library(lubridate)
library(knitr)
library(Metrics)
library(rattle)
library(rpart)
library(rpart.plot)
library(ROCR)
library(ranger)

?RMSE

Gym_Data <- read.csv("data.csv", na.strings = c(""," ","NA"))
View(Gym_Data)
summary(Gym_Data)
anyNA(Gym_Data)
sum(duplicated(Gym_Data))
nrow(Gym_Data)

Gym_Data$date <- as.numeric(Gym_Data$date)

class(Gym_Data$minute)
Gym_Data$minute <- minute(Gym_Data$date)
Gym_Data$date <- ymd_hms(Gym_Data$date)
Gym_Data$temperature <- Gym_Data$temperature - 32


Gym_Data_1 <- select(Gym_Data, -c(date))
View(Gym_Data)

ggplot(Gym_Data, aes(x=month, y=number_people,  fill = as.factor(month))) + geom_boxplot() + 
  scale_fill_discrete(name="month",labels=month.abb[1:12]) +
  scale_x_discrete(limits=1:12, labels=month.abb[1:12])

cr <- cor(Gym_Data_1)
cr
corrplot(cr,type="full")
corrplot(cr,method="number")
corrplot.mixed(cr)

# pending
ggplot(Gym_Data, aes(x=date(date), y=number_people, color=as.factor(is_during_semester))) + scale_x_date(name="date", date_breaks = "1 month", date_minor_breaks = "1 week", date_labels = "%B-%Y") + 
  scale_color_discrete(name="During semester", labels=c("False", "True")) + geom_point() +  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))



ggplot(Gym_Data, aes(x=hour, y=number_people, fill=factor(is_weekend))) + geom_bar(stat = "summary", fun.y = "mean") +
  scale_fill_discrete(name="weekend", labels=c("False", "True")) +
  scale_x_discrete(limits=0:23, labels=0:23)


ggplot(Gym_Data, aes(x=temperature, y=number_people)) + geom_point() + geom_smooth(method="lm") +
  #scale_x_discrete(limits=sort(unique(round(training$temperature))), labels=sort(unique(round(training$temperature)))) +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))


split <- sample.split(Gym_Data$number_people,0.70)
training_data <- subset(Gym_Data, split=="TRUE")
testing_data <- subset(Gym_Data,split=="FALSE")
summary(training_data)


fitControl <- trainControl(method="cv", number = 5)

model_rpart <- train(number_people~.-date-timestamp,
                     training_data,
                     method="rpart",
                     metric="RMSE",
                     tuneLength=10,
                     trControl=fitControl)

names(training_data)
model_gini <- rpart(number_people ~ day_of_week+is_weekend+is_holiday+temperature+is_start_of_semester+is_during_semester+month+hour+minute, data = training_data,method = "class",parms =list(split="gini"))

summary(model_gini)

summary(model_rpart)

pred_rpart <- predict(model_rpart, testing_data)
rmse(pred_rpart, testing_data$number_people)

pred_rpart <- predict(model_gini, testing_data)
rmse(pred_rpart, testing_data$number_people)

round(head(pred_rpart))
head(testing_data)

rpart.plot(model_rpart$finalModel, type = 2, fallen.leaves = T, cex = 0.8)

varImp(model_rpart)

##
# res <- predict(model_rpart,hr_ts,type = "response")
# 
# head(res)
# 
# 
# 
# table1 <- table(Actualvalue=testing_data$number_people,Predictedvalue=pred_rpart>0.5)
# 
# table1
# 
# ROCR_Pred <- prediction(pred_rpart,testing_data$number_people)
# 
# plot(ROCRperf,colorize=TRUE,print.cutoffs.at=seq(0.20,by=0.3))
# 
# confusionMatrix(pred_rpart,testing_data$number_people)
# #pred_test<-predict(model14,hr_ts,type ="binary")
# 
# ROCRperf <- performance(ROCR_Pred,"tpr","fpr")
##

#Linear Regression  

model_lm <- train(number_people~.-date-timestamp,
                  training_data,
                   method="lm",
                   metric="RMSE",
                   trControl=fitControl)
summary(model_lm)

pred_lm <- round(predict(model_lm, testing_data))
rmse(pred_lm, testing_data$number_people)

head(training_data$number_people,10)
head(pred_lm,10)

plot(pred_lm,col="Green",type="l")
lines(testing_data$number_people,col="red",type = "l")

#Random Forest


model_rf<- train(number_people~.-date-timestamp,
                 training_data,
                 method="ranger",
                 #tuneLength=20,
                 #tuneGrid = expand.grid(.mtry=8),
                 metric="RMSE",
                 trControl=fitControl)

?ranger
library(ranger)

pred_rf <- round(predict(model_rf, testing_data))
rmse(pred_rf, testing_data$number_people)



