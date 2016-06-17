EXECUTE sp_execute_external_script
@language = N'R',
@script = N'OutputDataSet <- InputDataSet',
@input_data_1 = N'SELECT ''Hello World'' AS col'
WITH RESULT SETS((col char (11)))

EXECUTE sp_execute_external_script
@language = N'R',
@script = N'df <- InputDataSet',
@input_data_1 = N'SELECT ''Hello World 2'' AS col',
@output_data_1_name = N'df'
WITH RESULT SETS((col char (13)))


EXECUTE sp_execute_external_script
   @language = N'R',
   @script = N'OutputDataSet <- head(iris)',
   @input_data_1 = N''
WITH RESULT SETS (([Sepal.Length] float, [Sepal.Width] float,
                   [Petal.Length] float, [Petal.Width] float,
                   [Species] varchar(25)));


EXECUTE sp_execute_external_script
   @language = N'R',
   @script = N'OutputDataSet <- data.frame(str(iris))',
   @input_data_1 = N''
WITH RESULT SETS UNDEFINED;


EXECUTE sp_execute_external_script
   @language = N'R',
   @script = N'temp <- colMeans(iris[, 1:4])
               tempIris <- rbind(temp)
               OutputDataSet <- as.data.frame(tempIris)',
   @input_data_1 = N''
WITH RESULT SETS(([Sepal.Length] float, [Sepal.Width] float,
                  [Petal.Length] float, [Petal.Width] float));





USE DemoDB;
GO

CREATE TABLE dbo.irisMeans (
   SepalLength    float,
   SepalWidth     float,
   PetalLength    float,
   PetalWidth     float);
GO

CREATE PROCEDURE GetIrisMeans AS
EXECUTE sp_execute_external_script
   @language = N'R',
   @script = N'temp <- colMeans(iris[, 1:4])
               tempIris <- rbind(temp)
               OutputDataSet <- as.data.frame(tempIris)',
   @input_data_1 = N''
WITH RESULT SETS(([Sepal.Length] float, [Sepal.Width] float,
                  [Petal.Length] float, [Petal.Width] float));

INSERT INTO dbo.irisMeans(SepalLength, SepalWidth, PetalLength, PetalWidth)
EXECUTE GetIrisMeans;

SELECT * FROM dbo.irisMeans;

