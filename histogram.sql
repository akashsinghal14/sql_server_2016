/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Col1]
  FROM [akash].[dbo].[MyData]

  use akash

  EXEC sp_execute_external_script
@language = N'R'
,@script = N' df <- inputDataSet;
image_file = "E:\\TEst.jpeg"
jpeg(filename = image_file, width=500, height=500); #create a JPEG graphic device
hist(df$id);
dev.off();
OutputDataset <- data.frame(data=readBin(file(image_file,"rb"),what=raw(),n=1e6));'
,@input_data_1 = N'SELECT * FROM student;'    --Provide your table name
,@input_data_1_name = N'inputDataSet'
,@output_data_1_name = N'OutputDataset'
WITH RESULT SETS ((plot varbinary(max)));


CREATE PROCEDURE Sp_Test111
As
EXEC sp_execute_external_script
@language = N'R'
,@script = N' df <- inputDataSet;
image_file = tempfile()
jpeg(filename = image_file, width=500, height=500); #create a JPEG graphic device
hist(2); #column name
dev.off();
OutputDataset <- data.frame(data=readBin(file(image_file,"rb"),what=raw(),n=1e6));'
,@input_data_1 = N'SELECT * FROM MyData;'   --Provide your table name
,@input_data_1_name = N'inputDataSet'
,@output_data_1_name = N'OutputDataset'
WITH RESULT SETS ((plot varbinary(max)));

 exec Sp_Test111








EXEC   sp_execute_external_script
      @language = N'R'
     ,@script = N'	df <- inputDataSet; #read input data
				image_file = "E:\\TEst.jpeg"; #create a temporary file
				jpeg(filename = image_file, width=500, height=500); #create a JPEG graphic device
				plot(df$id); #plot the histogram
				dev.off(); #dev.off returns the number and name of the new active device (after the specified device has been shut down). (device = graphical device)
				#file() opens a file, in this case the image. rb = read binary
				#readBin() reads binary data. what = described the mode of the data. In this case, it''s raw data. n = maximum number of records to read.
				#data.frame converts the data to a data frame, which is required as output by SQL Server. The result is written to the OutputDataset variable.
				OutputDataset <- data.frame(data=readBin(file(image_file,"rb"),what=raw(),n=1e6));
					'
	,@input_data_1 = N'SELECT id
						FROM iris_data;'
	,@input_data_1_name = N'inputDataSet'
	,@output_data_1_name = N'OutputDataset'
WITH RESULT SETS ((BarPlot varbinary(max)));


