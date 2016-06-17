Exec sp_configure  'external scripts enabled' 

exec sp_execute_external_script  @language =N'R',  
@script=N'OutputDataSet<-InputDataSet',    
@input_data_1 =N'select 1 as hello'  
with result sets (([hello] int not null));  
go 

CREATE TABLE MyData_new ([Col1] int not null) ON [PRIMARY]    
   INSERT INTO MyData   VALUES (1);    
   INSERT INTO MyData   Values (10);    
   INSERT INTO MyData   Values (100) ;    
  GO   

  SELECT * from MyData_new 

  execute sp_execute_external_script    
      @language = N'R'    
    , @script = N' OutputDataSet <- InputDataSet;'    
    , @input_data_1 = N' SELECT *  FROM MyData_new;'    
    WITH RESULT SETS (([NewColName] int NOT NULL));

	 execute sp_execute_external_script    
      @language = N'R'    
    , @script = N' SQLOut <- SQLIn;'    
    , @input_data_1 = N' SELECT 12 as Col;'    
    , @input_data_1_name  = N'SQLIn'    
    , @output_data_1_name =  N'SQLOut'    
    WITH RESULT SETS (([NewColName] int NOT NULL));

	 execute sp_execute_external_script    
      @language = N'R'    
    , @script = N' mytextvariable <- c("hello", " ", "world");    
                         OutputDataSet <- as.data.frame(mytextvariable);'    
    , @input_data_1 = N' SELECT 1 as Temp1'    
    WITH RESULT SETS (([col] char(20) NOT NULL));  

	 execute sp_execute_external_script    
      @language = N'R'    
    , @script = N' OutputDataSet<- data.frame(c("hello"), " ", c("world"));'    
    , @input_data_1 = N'  '    
    WITH RESULT SETS (([col1] varchar(20) , [col2] char(1), [col3] varchar(20) ));   
	
	
	execute sp_execute_external_script    
    @language = N'R'    
  , @script = N'    
  x <- as.matrix(InputDataSet);    
  y <- array(12:15);    
  OutputDataSet <- as.data.frame(x %*% y);'    
  , @input_data_1 = N' SELECT [Col1]  from MyData;'    
  WITH RESULT SETS (([Col1] int, [Col2] int, [Col3] int, Col4 int));     

  execute sp_execute_external_script    
      @language = N'R'    
    , @script = N'    
                        df1 <- as.data.frame( array(1:6) );    
                        df2 <- as.data.frame( c( InputDataSet , df1 ));    
                        OutputDataSet <- df2'    
    , @input_data_1 = N' SELECT [Col1]  from MyData;'    
    with RESULT SETS (( [Col2] int not null, [Col3] int not null ));     


	execute sp_execute_external_script    
      @language = N'R'    
    , @script = N' str(InputDataSet);'    
    , @input_data_1 = N' SELECT *  FROM MyData;'    
    WITH RESULT SETS undefined;   


	execute sp_execute_external_script    
      @language = N'R'    
    , @script = N' OutputDataSet <- as.data.frame(rnorm(20, mean = 100));'    
    , @input_data_1 = N'   ;'    
    WITH RESULT SETS (([Density] float NOT NULL)); 


	
    execute sp_execute_external_script    
      @language = N'R'    
    , @script = N'    
    library(utils);    
    mymemory <- memory.limit();    
    OutputDataSet <- as.data.frame(mymemory);'    
    , @input_data_1 = N' ;'    
    with RESULT SETS (([Col1] int not null));  