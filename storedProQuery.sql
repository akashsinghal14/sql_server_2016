

USE [akash]
GO


SELECT [Studentid]
      ,[Firstname]
      ,[Lastname]
      ,[Email]
  FROM [dbo].[tbl_Students]
GO


Create  PROCEDURE Getstudentname(

@studentid INT                   --Input parameter ,  Studentid of the student 

)
AS
BEGIN
SELECT Firstname+' '+Lastname FROM tbl_Students WHERE studentid=@studentid 
END

GO


Execute Getstudentname 1

Create Procedure InsertStudentrecord
(
 @StudentFirstName Varchar(200),
 @StudentLastName  Varchar(200),
 @StudentEmail     Varchar(50)
) 
As
 Begin
   Insert into tbl_Students (Firstname, lastname, Email)
   Values(@StudentFirstName, @StudentLastName,@StudentEmail)
 End

 Execute InsertStudentrecord "Akash", "Singhal", "akashsinghal14@yahoo.com"



  /* 
GetstudentnameInOutputVariable is the name of the stored procedure which
uses output variable @Studentname to collect the student name returns by the
stored procedure
*/

Create  PROCEDURE GetstudentnameInOutputVariable
(

@studentid INT,                       --Input parameter ,  Studentid of the student
@studentname VARCHAR(200)  OUT        -- Out parameter declared with the help of OUT keyword
)
AS
BEGIN
SELECT @studentname= Firstname+' '+Lastname FROM tbl_Students WHERE studentid=@studentid
END


---------------------
Declare @Studentname as nvarchar(200)   -- Declaring the variable to collect the Studentname
--Declare @Studentemail as nvarchar(50)     -- Declaring the variable to collect the Studentemail
Execute GetstudentnameInOutputVariable 6 , @Studentname output --, @Studentemail output
select @Studentname --,@Studentemail      -- "Select" Statement is used to show the output from Procedure





/* 
Stored Procedure GetstudentnameInOutputVariable is modified to collect the
email address of the student with the help of the Alert Keyword
*/ 

Alter  PROCEDURE GetstudentnameInOutputVariable
(

@studentid INT,                   --Input parameter ,  Studentid of the student
@studentname VARCHAR (200) OUT,    -- Output parameter to collect the student name
@StudentEmail VARCHAR (200)OUT     -- Output Parameter to collect the student email
)
AS
BEGIN
SELECT @studentname= Firstname+' '+Lastname, 
    @StudentEmail=email FROM tbl_Students WHERE studentid=@studentid
END


Declare @Studentname as nvarchar(200)   -- Declaring the variable to collect the Studentname
Declare @Studentemail as nvarchar(50)     -- Declaring the variable to collect the Studentemail
Execute GetstudentnameInOutputVariable 1 , @Studentname output, @Studentemail output
select @Studentname,@Studentemail      -- "Select" Statement is used to show the output from Procedure




---small S or capital S in studentid
Create  PROCEDURE Getstudentname1(

@Studentid INT                   --Input parameter ,  Studentid of the student 

)
AS
BEGIN
SELECT Firstname+' '+Lastname FROM tbl_Students WHERE studentid=@Studentid 
END


exec Getstudentname1 4