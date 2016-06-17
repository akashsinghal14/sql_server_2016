use churn_sim
go



CREATE PROC generate_churn_model 
AS 
BEGIN 
EXEC sp_execute_external_script 
@language = N'R' 
, @script = N' library(e1071); 
churnmodel <-naiveBayes(Churn[,1:4], Churn[,5]); 
trained_model <- data.frame(payload = as.raw(serialize(churnmodel, connection=NULL)));' 
, @input_data_1 = N'select "Day Mins" , "Eve Mins" ,"Night Mins" , "CustServ Calls" , "Churn" from Churn' 
, @input_data_1_name = N'Churn' 
, @output_data_1_name = N'trained_model' 
WITH RESULT SETS ((model varbinary(max))); 
END


CREATE TABLE [dbo].[model_churn]( 
[model_churn] [varbinary](max) NULL 
) 
GO 
insert into model_churn exec generate_churn_model 
GO

CREATE PROC pred_churn_model 
AS 
BEGIN 
 
declare @model_churn varbinary(MAX) 
select @model_churn=model_churn from model_churn
EXEC sp_execute_external_script 
@language = N'R' 
, @script = N' library(e1071) 
model <-unserialize(as.raw(churnmodel)) 
pred<-predict(model, Churn) 
result<-cbind(Churn, pred)' 
, @input_data_1 = N'select "Day Mins" , "Eve Mins" ,"Night Mins" , "CustServ Calls" , "Churn"  from Churn' 
, @input_data_1_name = N'Churn' 
, @output_data_1_name = N'result' 
, @params = N'@churnmodel varbinary(MAX)' 
, @churnmodel= @model_churn 
WITH RESULT SETS (("Day Mins" varchar(50), "Eve Mins" varchar(50) 
,"Night Mins" varchar(50), "CustServ Calls" varchar(50), "Churn" varchar(50), "ChurnPredicted" varchar(50)))
END



create table pred_churn 
( 
 "Day Mins" varchar(50), "Eve Mins" varchar(50) 
,"Night Mins" varchar(50), "CustServ Calls" varchar(50), "Churn" varchar(50), "ChurnPredicted" varchar(50)
) 
GO 
INSERT INTO pred_churn Exec pred_churn_model  
GO

select @@VERSION
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------




------------------------------Trying with Parameters---------------------------------------------------------
use churn_sim
go


create table churn_rx_models (
	model_name varchar(30) not null default('default model') primary key,
	model varbinary(max) not null
);
go


---------------------parameter 1----------------------------------------------------------------
CREATE PROC generate_churn_model_parameter 
AS 
BEGIN 
EXEC sp_execute_external_script 
@language = N'R' 
, @script = N' library(e1071); 
churnmodel_para <-naiveBayes(Churn[,1:4], Churn[,5]); 
trained_model_para <- data.frame(payload = as.raw(serialize(churnmodel_para, connection=NULL)));' 
, @input_data_1 = N'select "Day Mins" , "Eve Mins" ,"Night Mins" , "CustServ Calls" , "Churn" from Churn' 
, @input_data_1_name = N'Churn' 
, @output_data_1_name = N'trained_model_para' 
WITH RESULT SETS ((model varbinary(max))); 
END

------------------------------------------------------------------------------------------------



------------------------------prameter 2--------------------------------------------------

CREATE PROC generate_churn_model_parameter2 
AS 
BEGIN 
EXEC sp_execute_external_script 
@language = N'R' 
, @script = N' library(e1071); 
churnmodel_para <-naiveBayes(Churn[,1:4], Churn[,5]); 
trained_model_para <- data.frame(payload = as.raw(serialize(churnmodel_para, connection=NULL)));' 
, @input_data_1 = N'select "Eve Calls" , "Eve Charge" ,"Night Calls" , "Night Charge" , "Churn" from Churn' 
, @input_data_1_name = N'Churn' 
, @output_data_1_name = N'trained_model_para' 
WITH RESULT SETS ((model varbinary(max))); 
END


------------------------------------insert parameter in churn_rx_models--------------------------------------------------------

insert into churn_rx_models (model)
exec generate_churn_model_parameter;
update churn_rx_models set model_name = 'rxLinMod' where model_name = 'default model';
select * from churn_rx_models;
go

-------------------------------insert parameter2 in churn_rx_models---------------------------------------------------------------

insert into churn_rx_models (model)
exec generate_churn_model_parameter2;
update churn_rx_models set model_name = 'rxLinMod2_1' where model_name = 'default model';
select * from churn_rx_models;
go
--------------------------------------------------------------------------------------------


---------------------------procedure to predict churn----------------------------------
CREATE PROC pred_churn_model_para (@model varchar(100))
AS 
BEGIN
declare @rx_model varbinary(max) = (select model from churn_rx_models where model_name = @model);

--select @model_churn=model_churn from model_churn

EXEC sp_execute_external_script 
@language = N'R' 
, @script = N' library(e1071) 
require("RevoScaleR")
model_para <-unserialize(as.raw(rx_model)) 
pred_para<-predict(model_para, Churn) 
result_para<-cbind(Churn, pred_para)' 
, @input_data_1 = N'select "Day Mins" , "Eve Mins" ,"Night Mins" , "CustServ Calls" , "Churn"  from Churn' 
, @input_data_1_name = N'Churn' 
--, @output_data_1_name = N'result_para' 
, @params = N'@rx_model varbinary(MAX)' 
, @rx_model = @rx_model 
WITH RESULT SETS (("Day Mins" varchar(50), "Eve Mins" varchar(50) 
,"Night Mins" varchar(50), "CustServ Calls" varchar(50), "Churn" varchar(50), "ChurnPredicted" varchar(50)))
END;
go
--------------------------------------------------------------------------------------------.


-------------------execute procedure of prediction -----------------------
exec pred_churn_model_para 'rxLinMod';
go
--------------------------------------------
exec pred_churn_model_para 'rxLinMod2_1';