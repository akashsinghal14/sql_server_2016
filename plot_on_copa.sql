/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 10 [MANDT]
      ,[PALEDGER]
      ,[VRGAR]
      ,[VERSI]
      ,[PERIO]
      ,[BELNR]
      ,[POSNR]
      ,[GJAHR]
      ,[PERDE]
      ,[VKORG]
      ,[VTWEG]
      ,[SPART]
      ,[GSBER]
      ,[PVRTNR1]
      ,[KUNNR]
      ,[KUNWE]
      ,[PRCTR]
      ,[ARTNR]
      ,[BWTAR]
      ,[SKOST]
      ,[REC_WAERS]
      ,[ABSMG_ME]
      ,[ABSMG]
      ,[VV001]
      ,[VV002]
      ,[VV009]
      ,[VV0010]
      ,[COGS]
      ,[VV003]
      ,[VV004]
      ,[VV005]
      ,[VV006]
      ,[ROW_COUNT]
  FROM [akash].[dbo].[copa_data_new]



  CREATE PROCEDURE copa
As
  EXEC   sp_execute_external_script
      @language = N'R'
     ,@script = N'	df <- inputDataSet; #read input data
				image_file = "E:\\TEst.jpeg"; #create a temporary file
				jpeg(filename = image_file, width=500, height=500); #create a JPEG graphic device
				plot(df$ABSMG); #plot the histogram
				dev.off(); #dev.off returns the number and name of the new active device (after the specified device has been shut down). (device = graphical device)
				#file() opens a file, in this case the image. rb = read binary
				#readBin() reads binary data. what = described the mode of the data. In this case, it''s raw data. n = maximum number of records to read.
				#data.frame converts the data to a data frame, which is required as output by SQL Server. The result is written to the OutputDataset variable.
				OutputDataset <- data.frame(data=readBin(file(image_file,"rb"),what=raw(),n=1e6));
					'
	,@input_data_1 = N'SELECT ABSMG FROM copa_data_new;'
	,@input_data_1_name = N'inputDataSet'
	,@output_data_1_name = N'OutputDataset'
WITH RESULT SETS ((plot varbinary(max)));

exec copa

 EXEC   sp_execute_external_script
      @language = N'R'
     ,@script = N'	
				
				df <- inputDataSet; #read input data
				image_file = "E:\\TEst.jpeg"; #create a temporary file
				jpeg(filename = image_file, width=500, height=500); #create a JPEG graphic device
				plot(df$MANDT); #plot the histogram
				
				dev.off(); #dev.off returns the number and name of the new active device (after the specified device has been shut down). (device = graphical device)
				#file() opens a file, in this case the image. rb = read binary
				#readBin() reads binary data. what = described the mode of the data. In this case, it''s raw data. n = maximum number of records to read.
				#data.frame converts the data to a data frame, which is required as output by SQL Server. The result is written to the OutputDataset variable.
				OutputDataset <- data.frame(data=readBin(file(image_file,"rb"),what=raw(),n=1e6));
					'
	,@input_data_1 = N'SELECT MANDT FROM copa_data_new;'
	,@input_data_1_name = N'inputDataSet'
	,@output_data_1_name = N'OutputDataset'
WITH RESULT SETS ((plot varbinary(max)));