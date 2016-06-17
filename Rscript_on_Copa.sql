use akash
go

exec sp_execute_external_script
		  @language = N'R',
		  @script = N'
		  library(randomForest)
		  library(caret)
		 

datafiles <- datafile[with(datafile, order(V5)),]

datafiles  <- datafiles[!is.na(datafiles$V5),-c(20,21,22,32,33)]

inTrain <- createDataPartition(datafiles$V24, p=0.7, list = FALSE)
train <- datafiles[inTrain,]
test <- datafiles[-inTrain,]
rf <- randomForest(V24 ~., data=train, mtry=6, ntree=1000)
pred <- predict(rf, test)
summary(rf)
plot(rf)
plot(importance(rf))
mean((pred-test$V24)^2)
test $predicted <- pred
plot(test$V24,test$predicted, geom="line", color=3)
OutputDataSet <-data.frame(data=readBin(file(image_file,"rb"),what=raw(),n=1e6));'
,@input_data_1 = N'SELECT * FROM copa_data_new;'
	,@input_data_1_name = N'copa_data_new'
	,@output_data_1_name = N'copa_R'
WITH RESULT SETS ((plot varbinary(max)));


---------------------------------------------------------------------------------------------



use akash
go



CREATE PROC generate_copa_model 
AS 
BEGIN 
EXEC sp_execute_external_script 
@language = N'R' 
, @script = N' library(e1071); 
copamodel <-naiveBayes(small[,1:4], small[,5]); 
trained_model <- data.frame(payload = as.raw(serialize(copamodel, connection=NULL)));' 
, @input_data_1 = N'select "MANDT", "PALEDGER", "VRGAR", "VERSI", "PERIO" from small' 
, @input_data_1_name = N'small' 
, @output_data_1_name = N'trained_model' 
WITH RESULT SETS ((model varbinary(max))); 
END


CREATE TABLE [dbo].[model_copa]( 
[model_copa] [varbinary](max) NULL 
) 
GO 
insert into model_copa exec generate_copa_model 
GO


declare @model varbinary(MAX) 
select @model=model from model 
EXEC sp_execute_external_script 
@language = N'R' 
, @script = N' library(e1071) 
model <-unserialize(as.raw(copamodel)) 
pred<-predict(model, small) 
result<-cbind(small, pred)' 
, @input_data_1 = N'select "MANDT", "PALEDGER", "VRGAR", "VERSI", "PERIO" from small' 
, @input_data_1_name = N'small' 
, @output_data_1_name = N'result' 
, @params = N'@copamodel varbinary(MAX)' 
, @copamodel= @model 
WITH RESULT SETS (("MANDT" varchar(100), "PALEDGER" varchar(100) 
,"VRGAR" varchar(100), "VERSI" varchar(100), "PERIO" varchar(100), "PERIOPredicted" varchar(100)))