CREATE PROC get_iris_dataset 
AS 
BEGIN 
EXEC sp_execute_external_script 
@language = N'R' 
, @script = N'iris_data <- iris;' 
, @input_data_1 = N'' 
, @output_data_1_name = N'iris_data' 
WITH RESULT SETS (("Sepal.Length" float not null, "Sepal.Width" float not null,"Petal.Length" float not null, "Petal.Width" float not null, "Species" varchar(100))); 
END;

create table iris_data 
( 
"Sepal.Length" float not null, 
"Sepal.Width" float not null, 
"Petal.Length" float not null, 
"Petal.Width" float not null, 
"Species" varchar(100) 
) 
GO 
INSERT INTO iris_data Exec get_iris_dataset 
GO


CREATE PROC generate_iris_model 
AS 
BEGIN 
EXEC sp_execute_external_script 
@language = N'R' 
, @script = N' library(e1071); 
irismodel <-naiveBayes(iris_data[,1:4], iris_data[,5]); 
trained_model <- data.frame(payload = as.raw(serialize(irismodel, connection=NULL)));' 
, @input_data_1 = N'select "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species" from iris_data' 
, @input_data_1_name = N'iris_data' 
, @output_data_1_name = N'trained_model' 
WITH RESULT SETS ((model varbinary(max))); 
END;



CREATE TABLE [dbo].[model]( 
[model] [varbinary](max) NULL 
) 
GO 
insert into model exec generate_iris_model 
GO


declare @model varbinary(MAX) 
select @model=model from model 
EXEC sp_execute_external_script 
@language = N'R' 
, @script = N' library(e1071) 
model <-unserialize(as.raw(iris_model)) 
pred<-predict(model, iris_data) 
result<-cbind(iris_data, pred)' 
, @input_data_1 = N'select "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species" from iris_data' 
, @input_data_1_name = N'iris_data' 
, @output_data_1_name = N'result' 
, @params = N'@iris_model varbinary(MAX)' 
, @iris_model= @model 
WITH RESULT SETS (("Sepal.Length" float not null, "Sepal.Width" float not null 
,"Petal.Length" float not null, "Petal.Width" float not null, "Species" varchar(100), "SpeciesPredicted" varchar(100)))