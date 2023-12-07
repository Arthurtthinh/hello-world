CREATE or alter   PROC [dbo].[sp_Task] @Command NVARCHAR(400) = NULL          
 ,@ID NVARCHAR(50) = NULL          
 ,@PAGE INT = NULL          
 ,@LIMIT INT = NULL          
 ,@SEARCH_STATUS int = NULL          
 ,@SEARCH_TASK_NAME NVARCHAR(MAX) = NULL          
 ,@SEARCH_PriorityLevelID INT = NULL          
 ,@SEARCH_NGUOINHAN NVARCHAR(100) = NULL          
 ,@SEARCH_NGUOIGIAO NVARCHAR(100) = NULL          
 ,@SEARCH_DATEADD_FROM NVARCHAR(1000) = NULL          
 ,@SEARCH_DATEADD_TO NVARCHAR(1000) = NULL          
 ,@SEARCH_DEADLINE NVARCHAR(1000) = NULL          
 ,@SEARCH_NGAYGIAO NVARCHAR(1000) = NULL          
 ,@USER_ID VARCHAR(100) = NULL          
 ,@ISLATE BIT = 0          
 ,@ISDEADLINETODAY BIT = 0          
 ,@ISCOUNTGETID BIT = 0          
 ,@ISCOMPLETED BIT = 0          
 ,@ISNEXTTODEADLINE BIT = 0          
 ,@CUSTOMSTT NVARCHAR(1000) = NULL          
 ,@ISNEW BIT = 0          
 ,@ISLateComplete BIT = 0          
 ,@ISEarlyComplete BIT = 0          
 ,@ISPunctualCompleted BIT = 0          
 ,@ISRecipient NVARCHAR(100) = NULL          
 ,@SEARCH_JOB_TITLE VARCHAR(1000) = NULL          
 ,@ISReturnWork BIT = 0          
 ,@ISReci_Suppor int = null          
 ,@SEARCH_PHONGBAN NVARCHAR(1000)  = NULL          
 ,@SEARCH_RESULT INT = NULL          
 ,@ISChangeDeadline BIT = 0          
 ,@Biendotrehan bit = 0          
 ,@DeadLine datetime = null          
 ,@SEARCH_MONTH NVARCHAR(400) = NULL          
 ,@SEARCH_YEAR NVARCHAR(400) = NULL          
 ,@ISSHARERESULT BIT = 0          
 ,@ISPOORREWORK INT = 0          
 ,@ISFAILWORK INT = 0          
 ,@IsEvaluate BIT = 0          
 ,@IsInOrganization bit = 0 --0: tất cả     
AS   
begin  
   -- list access  
   declare @tbl_Users table (UserPositionId bigint, UserId varchar(50), PhongBan int, ChucVu int, FullName nvarchar(500))    
  
IF @Command = 'LoadAll_NguoiGiao'          
 OR @Command = 'LoadAll_NguoiNhan'           
  or @Command = 'LoadAll_NguoiGiao_CountListAllHasDelivery'          
BEGIN          
 DECLARE @STR_STATUS NVARCHAR(1000) = NULL          
  ,@STR_TASK_NAME NVARCHAR(1000) = NULL          
  ,@STR_PriorityLevelID NVARCHAR(1000) = NULL          
  ,@STR_NGUOINHAN NVARCHAR(1000) = NULL          
  ,@STR_NGUOIGIAO NVARCHAR(1000) = NULL          
  ,@STR_DATEADD NVARCHAR(1000) = NULL          
  ,@STR_DEADLINE NVARCHAR(1000) = NULL          
  ,@STR_NGAYGIAO NVARCHAR(1000) = NULL          
  ,@STR_LATE NVARCHAR(1000) = NULL          
  ,@STR_LATE_COLUM NVARCHAR(1000) = NULL          
  ,@STR_LATE_COLUM_NEXTTODEADLINE NVARCHAR(1000) = NULL          
  ,@STR_LATE_COLUM_COPLETED NVARCHAR(1000) = NULL          
  ,@STR_DEADLINETODAY NVARCHAR(1000) = NULL          
  ,@STR_SHOWCALDATE NVARCHAR(1000) = ' '          
  ,@STR_COMPLETED NVARCHAR(1000) = ' '          
  ,@STR_NEXTTODEADLINE NVARCHAR(1000) = ' '          
  ,@STR_CUSTOMSTT NVARCHAR(1000) = ' '          
  ,@STR_ISNEW NVARCHAR(1000) = ' '          
  ,@STR_User NVARCHAR(1000) = '  '          
  ,@STR_LateComplete NVARCHAR(1000) = NULL          
  ,@STR_EarlyComplete NVARCHAR(1000) = NULL          
  ,@STR_PunctualCompleted NVARCHAR(1000) = NULL          
  ,@STR_Recipient NVARCHAR(1000) = NULL          
  ,@STR_UsersID NVARCHAR(1000) = NULL          
  ,@STR_FinishedDate NVARCHAR(1000) = NULL          
  ,@STR_ReturnWork NVARCHAR(1000) = NULL          
  ,@STR_COLUM_RETURNWORK NVARCHAR(1000) = NULL          
  ,@STR_JOB_TITLE NVARCHAR(1000) = NULL          
  ,@STR_COLUM_ERALYCOMPLETED NVARCHAR(1000) = NULL          
  ,@STR_COLUM_LATECOMPLETED NVARCHAR(1000) = NULL          
  ,@STR_CheckedTaskTime NVARCHAR(1000) = NULL          
  ,@STR_LATE_COMPLETE NVARCHAR(1000) = NULL          
  ,@STR_EARLY_COMPLETE NVARCHAR(1000) = NULL          
  ,@STR_PUNCTUAL_COMPLETE NVARCHAR(1000) = NULL          
  ,@STR_UserAdd NVARCHAR(1000) = NULL          
  ,@STR_UserId NVARCHAR(1000) = NULL          
  ,@STR_Voting NVARCHAR(1000) = NULL          
  ,@STR_DEPARTMENT NVARCHAR(1000) = NULL          
  ,@STR_PHONGBAN NVARCHAR(1000) = NULL          
  ,@STR_TASKREVIEWER NVARCHAR(1000) = NULL          
  ,@STR_RESULT NVARCHAR(1000) = NULL          
  ,@STR_RANKING NVARCHAR(1000) = NULL          
  ,@STR_DEALINE NVARCHAR(1000) = NULL          
  ,@STR_COLUM_DEADLINE NVARCHAR(1000) = NULL          
  ,@STR_IsChangeDeadline NVARCHAR(1000) = NULL          
  ,@STR_Biendotrehan nvarchar(1000) = NULL          
  ,@STR_Biendotrehan_where nvarchar(1000) = NULL          
  ,@STR_ISNEW_CONDITION nvarchar(max) = ' '          
  ,@STR_MONTH NVARCHAR(MAX) = ''          
  ,@STR_YEAR NVARCHAR(MAX) = ''          
  ,@STR_SHARERESULT NVARCHAR(MAX) = ' '          
  ,@STR_LAM_LAI_CHO_TOT NVARCHAR(MAX) = ' '          
  ,@STR_DIEUKIEN_NGUOINHAN NVARCHAR(MAX) = ' and (Recipient = ''' + @USER_ID + ''' OR  CHARINDEX(''{'' + CAST(''' + @USER_ID + ''' AS VARCHAR(500)) + ''}'', Supporter) > 0) '      ,@STR_PoorRework nvarchar(max) = ' '          
  ,@STR_FailWork NVARCHAR(MAX) = ' '          
  ,@STR_Evaluate NVARCHAR(MAX) = ' '          
     
  
 -- Trạng thái công việc          
 -- 0: đang tạo, 1: đang chờ giao (ở chỗ thư ký) , 2: da giao; 3: da nhan; 4: Dang xu ly; 5: Da hoan thanh; 7: viec khong nhan tra lai ; 8 : Huy viec ; 9: Đong viec          
          
 IF ISNULL(@SEARCH_STATUS, NULL) IS NOT NULL          
 BEGIN          
  IF @SEARCH_STATUS = 17          
  BEGIN          
   SET @STR_STATUS = ' AND TaskStatus in(1,7)'          
  END          
  ELSE IF @SEARCH_STATUS IN (          
    3          
    ,4          
    )          
  BEGIN          
   SET @STR_STATUS = ' AND TaskStatus = ' + Cast(@SEARCH_STATUS AS VARCHAR(500)) + ' '          
   SET @STR_SHOWCALDATE = ', DATEDIFF(MINUTE, AssignmentDate,GETDATE()) AS NumberOfWorking '          
  END          
  ELSE IF @SEARCH_STATUS = 34          
  BEGIN          
   SET @STR_STATUS = ' AND DATEDIFF(MINUTE, DeadLine,GETDATE()) >0 '          
  END          
  ELSE IF @SEARCH_STATUS = 345          
  BEGIN           
   SET @STR_STATUS = ' AND DATEDIFF(MINUTE, FinishedDate , DeadLine) < 0 and FinishedDate IS NOT NULL '          
  END          
  ELSE IF @SEARCH_STATUS = 0          
  BEGIN          
   SET @STR_STATUS = ' AND TaskStatus = ' + Cast(@SEARCH_STATUS AS VARCHAR(500)) + ''          
  END          
  ELSE IF @SEARCH_STATUS = 2          
  BEGIN          
   SET @STR_STATUS = ' AND TaskStatus = ' + Cast(@SEARCH_STATUS AS VARCHAR(500)) + ''          
  END          
  ELSE IF @SEARCH_STATUS = 5          
  BEGIN          
   SET @STR_STATUS = ' AND TaskStatus = ' + Cast(@SEARCH_STATUS AS VARCHAR(500)) + ''          
  END          
  ELSE IF @SEARCH_STATUS = 7          
  BEGIN          
   SET @STR_STATUS = ' AND TaskStatus = ' + Cast(@SEARCH_STATUS AS VARCHAR(500)) + ''          
  END          
  ELSE          
  BEGIN          
   SET @STR_STATUS = ' AND TaskStatus not in (0,1,7)'          
  END          
 END          
 ELSE          
 BEGIN          
  SET @STR_STATUS = ' '          
 END          
          
 -- Các trường hợp điền từ visual          
          
 IF ISNULL (@CUSTOMSTT, NULL) IS NOT NULL          
 BEGIN          
  SET @STR_CUSTOMSTT = '' +@CUSTOMSTT+ ''          
  SET @STR_SHOWCALDATE = ', DATEDIFF(MINUTE, AssignmentDate,GETDATE()) AS NumberOfWorking '          
 END          
 ELSE           
 BEGIN          
  SET @STR_CUSTOMSTT = ' '          
 END          
          
 -- Tên công việc          
          
 IF ISNULL(@SEARCH_TASK_NAME, NULL) IS NOT NULL          
 BEGIN          
  SET @STR_TASK_NAME = ' AND TaskName like N''%' + Cast(@SEARCH_TASK_NAME AS NVARCHAR(MAX)) + '%'''          
 END          
 ELSE          
 BEGIN          
  SET @STR_TASK_NAME = ' '          
 END          
          
 -- Tên người nhận          
          
 IF ISNULL(@SEARCH_NGUOINHAN, NULL) IS NOT NULL          
 BEGIN          
  IF @ISReci_Suppor = 1           
  BEGIN          
   SET @STR_NGUOINHAN = ' AND Recipient = ''' + @SEARCH_NGUOINHAN +''''          
   SET @STR_User = ',(CASE  WHEN ''' + @SEARCH_NGUOINHAN +''' = Recipient THEN 1 ELSE 0 END) AS IsRecipient'          
  END          
  ELSE IF @ISReci_Suppor = 2          
  BEGIN          
   SET @STR_NGUOINHAN = ' AND (CHARINDEX(''{'' + CAST(''' + @SEARCH_NGUOINHAN + ''' AS VARCHAR(500)) + ''}'', Supporter) > 0)'          
   SET @STR_User = ',(CASE  WHEN ''' + @SEARCH_NGUOINHAN +''' = Recipient THEN 1 ELSE 0 END) AS IsRecipient'          
  END          
  ELSE          
  BEGIN          
   SET @STR_NGUOINHAN = ' AND (Recipient = ''' + @SEARCH_NGUOINHAN + ''' OR  CHARINDEX(''{'' + CAST(''' + @SEARCH_NGUOINHAN + ''' AS VARCHAR(500)) + ''}'', Supporter) > 0)'          
   SET @STR_User = '  '          
  END          
 END          
 ELSE          
 BEGIN          
  SET @STR_NGUOINHAN = ' '          
 END          
          
 -- Tên người giao          
          
 IF ISNULL(@SEARCH_NGUOIGIAO, NULL) IS NOT NULL          
 BEGIN          
  SET @STR_NGUOIGIAO = ' AND TaskOwner = ''' + @SEARCH_NGUOIGIAO + ''''          
 END          
 ELSE          
 BEGIN          
  SET @STR_NGUOIGIAO = ' '          
 END          
          
 -- Mức độ          
          
 IF ISNULL(@SEARCH_PriorityLevelID, 0) != 0          
 BEGIN          
  SET @STR_PriorityLevelID = ' AND PriorityLevelID = ' + Cast(@SEARCH_PriorityLevelID AS VARCHAR(500)) + ''          
 END          
 ELSE          
 BEGIN          
  SET @STR_PriorityLevelID = ' '          
 END          
          
 -- Ngày giao          
          
 IF ISNULL(@SEARCH_DATEADD_FROM, NULL) IS NOT NULL          
  AND ISNULL(@SEARCH_DATEADD_TO, NULL) IS NOT NULL          
 BEGIN          
  SET @STR_DATEADD = ' AND AssignmentDate between ''' + @SEARCH_DATEADD_FROM + ''' and ''' + @SEARCH_DATEADD_TO + ''''          
 END          
 ELSE IF ISNULL(@SEARCH_DATEADD_FROM, NULL) IS NOT NULL          
  AND ISNULL(@SEARCH_DATEADD_TO, NULL) IS NULL          
 BEGIN          
  SET @SEARCH_DATEADD_TO = Cast(GETDATE() AS NVARCHAR(MAX))          
  SET @STR_DATEADD = ' AND AssignmentDate between ''' + @SEARCH_DATEADD_FROM + ''' and ''' + @SEARCH_DATEADD_TO + ''''          
 END          
 ELSE          
 BEGIN          
  SET @STR_DATEADD = ' '          
 END          
 --IF ISNULL(@SEARCH_DATEADD_FROM, NULL) IS NOT NULL          
 -- AND ISNULL(@SEARCH_DATEADD_TO, NULL) IS NOT NULL          
 --BEGIN   -- SET @STR_DATEADD = ' AND [DateAdd] between ''' + @SEARCH_DATEADD_FROM + ''' and ''' + @SEARCH_DATEADD_TO + ''''          
 --END          
 --ELSE IF ISNULL(@SEARCH_DATEADD_FROM, NULL) IS NOT NULL          
 -- AND ISNULL(@SEARCH_DATEADD_TO, NULL) IS NULL          
 --BEGIN          
 -- SET @STR_DATEADD = ' AND [DateAdd] between ''' + @SEARCH_DATEADD_FROM + ''' and ''' + Cast(GETDATE() AS NVARCHAR(MAX)) + ''''          
 --END          
 --ELSE          
 --BEGIN          
 -- SET @STR_DATEADD = ' '          
 --END          
          
 -- Deadline          
          
 IF ISNULL(@SEARCH_DEADLINE, NULL) IS NOT NULL          
 BEGIN          
  SET @STR_DEADLINE = ' AND DATEDIFF(DAY, ''' + @SEARCH_DEADLINE + ''', DeadLine) = 0'          
 END          
 ELSE          
 BEGIN          
  SET @STR_DEADLINE = ' '          
 END          
          
 -- Ngày giao          
          
 IF ISNULL(@SEARCH_NGAYGIAO, NULL) IS NOT NULL          
 BEGIN          
  SET @STR_NGAYGIAO = ' AND DATEDIFF(DAY, ''' + @SEARCH_NGAYGIAO + ''', AssignmentDate) = 0'          
 END          
 ELSE          
 BEGIN          
  SET @STR_NGAYGIAO = ' '          
 END          
          
 -- Công việc trễ hạn          
          
 IF @ISLATE = 1          
 BEGIN          
  SET @STR_LATE = ' AND DATEDIFF(MINUTE, GETDATE() ,        
  (DATEADD(MINUTE, ( cast(DATEDIFF(MINUTE, AssignmentDate, Deadline) as decimal(18,2))/ cast(100 as decimal(18,2)) * cast((SELECT BienDoTreHan from Sys_Configs)as decimal(18,2))), Deadline))) < 0 AND FinishedDate is null          
        AND (SELECT count(*) FROM Task_History WHERE TaskID=Task.ID)=0 '          
  SET @STR_LATE_COLUM = ' ,DATEDIFF(MINUTE, (DATEADD(MINUTE, ( cast(DATEDIFF(MINUTE, AssignmentDate, Deadline) as decimal(18,2))/ cast(100 as decimal(18,2)) * cast((SELECT BienDoTreHan from Sys_Configs)as decimal(18,2))), Deadline)), GETDATE()) as DayLate
  
    
      
        
 '          
 END          
 ELSE          
 BEGIN          
  SET @STR_LATE = ' '          
  SET @STR_LATE_COLUM = ' '          
 END          
          
 -- Công việc tới hạn hôm nay          
          
 IF @ISDEADLINETODAY = 1          
 BEGIN          
  SET @STR_DEADLINETODAY = ' AND DATEDIFF(DAY, GETDATE() , DeadLine) = 0 '          
 END          
 ELSE          
 BEGIN          
  SET @STR_DEADLINETODAY = ' '          
 END          
          
 -- Công việc chờ duyệt          
          
 IF @ISCOMPLETED = 1           
 BEGIN          
  SET @STR_COMPLETED = ' AND (SELECT COUNT(*) FROM Task_History WHERE TaskID = Task.ID and ISNULL(Checked,NULL)IS NULL) > 0 and FinishedDate is not null'          
          
  SET @STR_COLUM_ERALYCOMPLETED = ' ,DATEDIFF(MINUTE, FinishedDate ,DeadLine ) as DayEarly '          
  SET @STR_COLUM_LATECOMPLETED = ' ,DATEDIFF(MINUTE, DeadLine, FinishedDate) as DayLate '          
  SET @STR_CheckedTaskTime = ' , (SELECT CheckedTaskTime FROM PriorityLevel WHERE ID= Task.PriorityLevelID) as CheckTaskTime '          
          
 END          
 ELSE           
 BEGIN          
  SET @STR_COMPLETED = ' '          
  SET @STR_COLUM_ERALYCOMPLETED = '  '          
  SET @STR_COLUM_LATECOMPLETED = '  '          
  SET @STR_CheckedTaskTime = '  '          
 END          
          
 -- Công việc gần đến hạn          
          
 IF @ISNEXTTODEADLINE = 1          
 BEGIN          
  SET @STR_NEXTTODEADLINE =' AND DATEDIFF(MINUTE, GETDATE(), DeadLine) > 0           
 and AssignmentDate is not null          
 and ( cast (DATEDIFF(MINUTE, GETDATE(), DeadLine) as decimal(18,2)) / cast( DATEDIFF(MINUTE, AssignmentDate, DeadLine) as decimal(18,2)) * 100) <=           
  (cast((select RemindDeadline from Sys_Configs) as decimal(18,2)))'          
  SET @STR_LATE_COLUM_NEXTTODEADLINE = ' ,DATEDIFF(MINUTE, GETDATE() ,DeadLine ) as DayLate '          
  SET @STR_SHOWCALDATE = ', DATEDIFF(MINUTE, AssignmentDate,GETDATE()) AS NumberOfWorking '          
 END          
 ELSE          
 BEGIN           
  SET @STR_NEXTTODEADLINE =' '          
  SET @STR_LATE_COLUM_NEXTTODEADLINE = ' '          
 END          
          
 --          
          
 IF (@ISNEW = 1)          
 BEGIN          
  IF @SEARCH_STATUS = 17          
  BEGIN          
   SET @STR_ISNEW = ' AND TaskOwner = ''' + @USER_ID + ''''          
  END          
  ELSE          
  BEGIN          
   IF (@USER_ID IS NOT NULL)          
   BEGIN          
    IF (@ISCOMPLETED = 1)          
    BEGIN          
     SET @STR_ISNEW = ' AND ( TaskOwner = ''' + @USER_ID + ''' or TaskReviewer = ''' + @USER_ID + ''')'          
    END          
    ELSE          
    BEGIN          
  IF @SEARCH_STATUS = 0        
  BEGIN        
   SET @STR_ISNEW = ' AND UserAdd = ''' + @USER_ID + ''''          
  END        
  ELSE        
  BEGIN        
   SET @STR_ISNEW = ' AND TaskOwner = ''' + @USER_ID + ''''          
  END        
    END          
   END          
   ELSE          
   BEGIN          
    SET @STR_ISNEW = '  '          
   END          
  END          
 END          
 ELSE          
 BEGIN          
  IF (@USER_ID IS NOT NULL)          
  BEGIN          
   SET @STR_ISNEW_CONDITION = '          
   declare @stringCut nvarchar(max) = REPLACE(REPLACE(dbo.fn_HELPER_Get_ListUserData(''' + @USER_ID + '''), ''{'', '',''), ''}'', '','')          
   declare @table_danhsachphongminh as table (Id nvarchar(50));          
   insert into @table_danhsachphongminh            
   select [Name] from splitstring(@stringCut)          
  '          
   SET @STR_ISNEW = ' AND (CHARINDEX ( ''{'' + Recipient +''}'' ,(select dbo.fn_HELPER_Get_ListUserData(''' + @USER_ID + '''))  )  > 0            
   OR          
   (           
   select COUNT(*) from @table_danhsachphongminh where CHARINDEX(''{'' + Id + ''}'', (Task.Supporter) ) > 0 ) > 0          
   ) '          
  END          
  ELSE          
  BEGIN          
   SET @STR_ISNEW = '  '          
   SET @STR_ISNEW_CONDITION = ' '          
  END          
 END          
          
 --          
           
 IF(@USER_ID IS NOT NULL)          
 BEGIN          
  SET @STR_UsersID = ' '           
  SET @STR_Recipient = ' '           
 END          
 ELSE          
 BEGIN          
  IF(@ISRecipient IS NOT NULL)          
  BEGIN          
  SET @STR_UsersID = ', (CASE  WHEN ''' + @ISRecipient +''' = Recipient THEN 1 ELSE 0 END) AS IsRecipient '          
  SET @STR_Recipient = ' and (Recipient = '''           
  + @ISRecipient + ''' OR  CHARINDEX(''{'' + CAST(''' + @ISRecipient + ''' AS VARCHAR(500)) + ''}'', Supporter) > 0) '          
  END          
  ELSE          
   BEGIN          
   SET @STR_UsersID = ' '           
   SET @STR_Recipient = ' '           
  END          
 END          
          
 -- Công việc hoàn thành trễ hạn          
          
 IF @ISLateComplete = 1          
 BEGIN          
  SET @STR_LateComplete = ' AND DATEDIFF(MINUTE, FinishedDate , (DATEADD(MINUTE, ( cast(DATEDIFF(MINUTE, AssignmentDate, Deadline) as decimal(18,2))/ cast(100 as decimal(18,2)) * cast((SELECT BienDoTreHan from Sys_Configs)as decimal(18,2))), Deadline))) <
  
    
      
      
 0 AND FinishedDate IS NOT NULL'          
  SET @STR_LATE_COLUM_COPLETED = ' ,DATEDIFF(MINUTE, (DATEADD(MINUTE, ( cast(DATEDIFF(MINUTE, AssignmentDate, Deadline) as decimal(18,2))/ cast(100 as decimal(18,2)) * cast((SELECT BienDoTreHan from Sys_Configs)as decimal(18,2))), Deadline)), FinishedDate
  
    
      
        
) as DayLate'          
 END          
 ELSE          
 BEGIN          
  SET @STR_LateComplete = ' '          
  SET @STR_LATE_COLUM_COPLETED = ' '          
 END          
          
 -- Công việc hoàn thành sớm hạn          
          
 IF @ISEarlyComplete = 1          
 BEGIN          
  SET @STR_EarlyComplete = ' AND DATEDIFF(MINUTE, FinishedDate, DeadLine) > 0           
 and AssignmentDate is not null           
 AND FinishedDate IS NOT NULL          
 and ( cast (DATEDIFF(MINUTE, FinishedDate, DeadLine) as decimal(18,2)) / cast( DATEDIFF(MINUTE, AssignmentDate, DeadLine) as decimal(18,2)) * 100) >=           
  (cast((select CompletedEarly from Sys_Configs) as decimal(18,2))) '          
  SET @STR_LATE_COLUM = ' ,DATEDIFF(MINUTE, FinishedDate ,DeadLine ) as DayEarly '          
  SET @STR_SHOWCALDATE = ', DATEDIFF(MINUTE, AssignmentDate,FinishedDate) AS NumberOfWorking '          
          
 END          
 ELSE          
 BEGIN          
  SET @STR_EarlyComplete = ' '          
 END          
 --IF @ISPunctualCompleted = 1          
 --BEGIN          
 -- SET @STR_PunctualCompleted = ' AND DATEDIFF(MINUTE, FinishedDate, DeadLine) > 0           
 --and AssignmentDate is not null          
 --AND FinishedDate IS NOT NULL          
 --and ( cast (DATEDIFF(MINUTE, FinishedDate, DeadLine) as decimal(18,2)) / cast( DATEDIFF(MINUTE, AssignmentDate, DeadLine) as decimal(18,2)) * 100) <          
 -- (cast((select CompletedEarly from Sys_Configs) as decimal(18,2)))           
 --'          
 --END          
 --ELSE          
 --BEGIN          
 -- SET @STR_PunctualCompleted = ' '          
 --END          
          
 -- Công việc hoàn thành đúng hạn          
          
 IF @ISPunctualCompleted = 1          
 BEGIN          
  SET @STR_PunctualCompleted = ' AND DATEDIFF(MINUTE, FinishedDate, (DATEADD(MINUTE, ( cast(DATEDIFF(MINUTE, AssignmentDate, Deadline) as decimal(18,2))/ cast(100 as decimal(18,2)) * cast((SELECT BienDoTreHan from Sys_Configs)as decimal(18,2))), Deadline)
  
    
      
        
)) > 0           
 and AssignmentDate is not null          
 AND FinishedDate IS NOT NULL          
 and ( cast (DATEDIFF(MINUTE, FinishedDate, DeadLine) as decimal(18,2))           
 / cast( DATEDIFF(MINUTE, AssignmentDate, (DATEADD(MINUTE, ( cast(DATEDIFF(MINUTE, AssignmentDate, Deadline) as decimal(18,2))/ cast(100 as decimal(18,2)) * cast((SELECT BienDoTreHan from Sys_Configs)as decimal(18,2))), Deadline))) as decimal(18,2)) * 100
  
    
      
        
) <          
  (cast((select CompletedEarly from Sys_Configs) as decimal(18,2)))           
 '          
 END          
 ELSE          
 BEGIN          
  SET @STR_PunctualCompleted = ' '          
 END          
          
 -- Công việc đang xử lý bị trả lại          
          
 IF @ISReturnWork = 1          
 BEGIN          
  SET @STR_ReturnWork = ' and (select count(*) from Task_History where TaskID = Task.ID and Checked=0)>0 and TaskStatus = 4 '          
  SET @STR_SHOWCALDATE = ', DATEDIFF(MINUTE, AssignmentDate,GETDATE()) AS NumberOfWorking '          
  SET @STR_LAM_LAI_CHO_TOT = ' ,case when  (select COUNT(*) from Task_History_Details where CheckedDate =          
    (select MAX(Task_History_Details.CheckedDate) CD from Task_History_Details           
    where Task_History_Details.TaskID = Task.ID           
    and IsRepicient = 1          
    group by TaskID) and TaskScoreCardID = 12) > 0 then 1 else 0 end Is_lamlai_chotot '          
 END          
 ELSE          
 BEGIN          
  SET @STR_ReturnWork = ' '           
  SET @STR_LAM_LAI_CHO_TOT = ' '          
 END          
 --IF( @ISRecipient is not NULL)          
 -- BEGIN          
 --  SET @STR_Recipient = ' and (Recipient = '''           
 -- + @USER_ID + ''' OR  CHARINDEX(''{'' + CAST(''' + @USER_ID + ''' AS VARCHAR(500)) + ''}'', Supporter) > 0) '          
 --  SET @STR_UsersID = ' (CASE  WHEN ''' + @USER_ID +''' = Recipient THEN 1 ELSE 0 END) AS IsRecipient '          
 -- end          
          
 --          
          
 IF ISNULL(@SEARCH_JOB_TITLE, NULL) IS NOT NULL          
 BEGIN          
  SET @STR_JOB_TITLE = ' AND CHARINDEX ( ''{'' + ''' +@SEARCH_JOB_TITLE+ '''+''}'' ,TaskListID) > 0'          
 END          
 ELSE          
 BEGIN          
  SET @STR_JOB_TITLE = ' '          
 END          
          
 -- Phòng ban          
          
 IF ISNULL(@SEARCH_PHONGBAN, NULL) IS NOT NULL          
 BEGIN          
  SET @STR_DEPARTMENT =' AND (SELECT count(PhongBan) from Users where Id=Task.Recipient and PhongBan = '+@SEARCH_PHONGBAN+') > 0'          
  SET @STR_PHONGBAN = ' ,(SELECT PhongBan from Users where Id=Task.Recipient) as PhongBan'          
 END          
 ELSE          
 BEGIN          
  SET @STR_DEPARTMENT = ' '          
  SET @STR_PHONGBAN = ' '          
 END          
          
 -- Kết quả công việc          
          
 IF ISNULL(@SEARCH_RESULT, NULL)IS NOT NULL          
 BEGIN          
  SET @STR_RESULT = ' AND TaskStatus = 5 and TaskScorecardID is not null '           
  IF @SEARCH_RESULT = 1          
  BEGIN          
   SET @STR_RANKING = '  AND TaskScorecardID = 1 '          
  END          
ELSE IF @SEARCH_RESULT = 2           
  BEGIN          
   SET @STR_RANKING  = '  AND TaskScorecardID = 2 '          
  END          
  ELSE IF @SEARCH_RESULT = 3           
  BEGIN          
   SET @STR_RANKING  = '  AND TaskScorecardID = 3 '          
  END          
  ELSE IF @SEARCH_RESULT = 4           
  BEGIN          
   SET @STR_RANKING  = ' AND TaskScorecardID = 4   '          
  END          
 END          
 ELSE          
 BEGIN          
  SET @STR_RESULT = '  '          
  SET @STR_RANKING = '  '          
 END          
          
 -- Thay đổi deadline          
          
 IF @ISChangeDeadline = 1          
 BEGIN          
  SET @STR_IsChangeDeadline = ' AND  (          
        SELECT COUNT(*)          
        FROM Task_ChangeDeadLine          
        WHERE Task.ID = TaskID          
          AND IsResult IS NULL)  > 0 '          
 END          
 ELSE          
 BEGIN          
  SET @STR_IsChangeDeadline = '  '          
 END          
          
 -- Biên độ trễ hạn          
          
 IF @Biendotrehan = 1          
  BEGIN          
   --SET @Biendotrehan = (SELECT BienDoTreHan from Sys_Configs)          
   SET @STR_Biendotrehan = ''          
   SET @STR_Biendotrehan_where = ' AND (DATEADD(MINUTE, ( cast(DATEDIFF(MINUTE, AssignmentDate, Deadline) as decimal(18,2))/ cast(100 as decimal(18,2)) * cast((SELECT BienDoTreHan from Sys_Configs)as decimal(18,2))), Deadline) > GETDATE())'          
          
  END          
 ELSE          
  BEGIN          
   SET @Biendotrehan = '  '          
   SET @STR_Biendotrehan =  ''          
   SET @STR_Biendotrehan_where = ''          
  END          
          
 -- Tìm kiếm tháng          
          
 IF @SEARCH_MONTH IS NOT NULL          
  BEGIN           
  IF @SEARCH_MONTH = 0          
  BEGIN           
   SET @STR_MONTH = ' '          
  END          
  ELSE          
  BEGIN           
   SET @STR_MONTH = ' AND MONTH(AssignmentDate) = ' + CAST(@SEARCH_MONTH AS NVARCHAR(50)) + ' '          
  END          
 END          
          
 -- Tìm kiếm năm          
          
 IF @SEARCH_YEAR IS NOT NULL          
  BEGIN           
  IF @SEARCH_YEAR = 0          
  BEGIN          
   SET @STR_YEAR = '  '          
  END          
  ELSE          
  BEGIN          
   SET @STR_YEAR = ' AND YEAR(AssignmentDate) = ' + CAST(@SEARCH_YEAR AS NVARCHAR(50)) + ' '          
  END          
 END          
          
 -- Công việc chia sẻ          
          
 IF @ISSHARERESULT = 1          
 BEGIN          
  SET @STR_SHARERESULT = ' AND CHARINDEX ( ''{'' + ''' +@USER_ID+ '''+''}'' ,UserShare) > 0 '          
  SET @STR_DIEUKIEN_NGUOINHAN = ' '          
 END          
          
 -- Công việc trả về làm lại          
 -- kém trả lại          
 IF @ISPOORREWORK = 1          
 BEGIN          
  SET @STR_PoorRework = ' and (select count(*) from Task_History where TaskID = Task.ID and Checked=0)>0          
        and (select COUNT(*) from Task_History_Details where CheckedDate =          
           (select MAX(Task_History_Details.CheckedDate) CD from Task_History_Details           
           where Task_History_Details.TaskID = Task.ID           
           and IsRepicient = 1          
           group by TaskID) and TaskScoreCardID = 4) >0 '          
 END          
 -- trả lại làm cho tốt hơn          
 ELSE IF @ISPOORREWORK = 2          
 BEGIN          
  SET @STR_PoorRework = ' and (select count(*) from Task_History where TaskID = Task.ID and Checked=0)>0          
        and (select COUNT(*) from Task_History_Details where CheckedDate =          
           (select MAX(Task_History_Details.CheckedDate) CD from Task_History_Details           
           where Task_History_Details.TaskID = Task.ID           
           and IsRepicient = 1          
           group by TaskID) and TaskScoreCardID = 12) >0 '          
 END          
 ELSE          
 BEGIN          
  SET @STR_PoorRework = ''          
 END          
          
 --Công việc kém           
          
 -- Kém chuyển việc          
 IF @ISFAILWORK = 1          
 BEGIN          
  SET @STR_FailWork = ' and TaskScorecardID=4 and (select count(*) from Task ts where ts.IDLegacyWork=Task.ID)>0 '          
 END          
          
 -- Kém kết thúc công việc          
          
 ELSE IF @ISFAILWORK = 2           
 BEGIN          
  SET @STR_FailWork = ' and TaskScorecardID=4 and (select count(*) from Task ts where ts.IDLegacyWork=Task.ID)=0 '          
 END          
 ELSE          
 BEGIN          
  SET @STR_FailWork = '  '          
 END          
          
 -- Danh sách các công việc không đánh giá          
          
 IF @IsEvaluate = 1          
 BEGIN          
 SET @STR_Evaluate = ' AND IsEvaluate=0 '          
 END           
 ELSE           
 BEGIN          
  SET @STR_Evaluate = '  '          
 END          
           
 ------------------------------------------------------------------------------          
END          
          
IF @Command = 'LoadAll_NguoiGiao'           
BEGIN          
 DECLARE @stringsql_nguoigiao AS NVARCHAR(max) = '          
 '+@STR_ISNEW_CONDITION+'          
 SELECT Task.ID          
   ,TaskName          
   ,TaskCode          
   ,TaskListID                 
   ,dbo.[fn_HELPER_Get_TaskListName_By_TaskListID](TaskListID)AS TaskListName '           
   +           
   @STR_SHOWCALDATE +           
   @STR_User +          
   @STR_UsersID +           
   @STR_PHONGBAN +          
   @STR_Biendotrehan+          
   @STR_LAM_LAI_CHO_TOT +          
   '           
             
   ,PriorityLevelID          
   ,(          
    SELECT A.PriorityLevelName          
    FROM PriorityLevel A          
    WHERE A.ID = PriorityLevelID          
    ) AS PriorityLevelName          
   ,SecurityLevelID          
   ,(          
    SELECT B.SecurityLevelName          
   FROM SecurityLevel B          
    WHERE B.ID = SecurityLevelID          
    ) AS SecurityLevelName          
   ,DifficultLevelID          
   ,(          
    select DifficultLevelName           
    from DifficultLevel C           
    where C.ID=DifficultLevelID           
    )AS DifficultLevelName          
   ,LoaiViecID          
   ,(          
    SELECT B.ParameterValue          
    FROM Li_Parameter B          
    WHERE B.ParameterID = LoaiViecID          
    ) AS LoaiViecName          
   ,NguonViecID          
   --,(          
   -- SELECT B.ParameterValue          
   -- FROM Li_Parameter B          
   -- WHERE B.ParameterID = NguonViecID          
   -- ) AS NguonViecName          
   ,QuyTrinhID          
   ,(          
    SELECT B.tenquytrinh          
    FROM Li_QuyTrinh B          
    WHERE B.id = QuyTrinhID          
    ) AS QuyTrinhName          
   ,RefCode          
   , DATEDIFF(MINUTE, AssignmentDate,GETDATE()) AS NumberOfWorking           
   ,case when (select count(*) from Task_ChangeDeadLine TC where Task.ID =  TC.TaskID and TC.IsResult is null ) > 0 then 1 else 0 end  as IsExtend          
   ,case when (select count(*) from Task_Content_History TCH where Task.ID = TCH.Task_ContentID and TCH.Checked is null ) > 0 then 1 else 0 end as IsCompleted          
   ,case when (select count(*) from Task_History TH where Task.ID = TH.TaskID and TH.Checked is null ) > 0 then 1 else 0 end as IsCompleted_History          
   ,(select count(*) from Task_History where Checked=0 and TaskID=Task.ID) AS NumberReturnWork           
   ,(DATEADD(MINUTE, ( cast(DATEDIFF(MINUTE, AssignmentDate, Deadline) as decimal(18,2))/ cast(100 as decimal(18,2)) * cast((SELECT BienDoTreHan from Sys_Configs)as decimal(18,2))), Deadline)) AS NewDeadline          
   ,Recipient          
   ,(          
    SELECT C.FullName          
    FROM Users C          
    WHERE C.ID = Recipient          
    ) AS RecipientName          
   ,Supporter          
   ,dbo.[fn_HELPER_Get_ListUserName_By_UserIDList](Supporter) AS SupporterName          
   ,DeadLine          
   ,AssignmentDate          
   ,[Description]          
   ,Notes          
   ,FinishedContent          
   ,TaskStatus          
   ,ListFiles          
   ,ListFilesName          
   ,ResultFiles          
   ,ResultFilesName          
   ,UserAdd          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE Users.Id=UserAdd          
   )As UserAddName          
   ,[DateAdd]          
   ,UserModify          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE Users.Id=Task.UserModify          
   )As UserModifyName          
   ,DateModify          
   ,Deleted          
   ,DateDeleted          
   ,TaskOwner          
   ,(          
    SELECT C.FullName          
    FROM Users C          
    WHERE C.ID = TaskOwner          
    ) as TaskOwnerName          
   ,DateSent          
   ,IsForce          
   ,IsRemind          
   ,CountGetId          
   ,FinishedDate          
   ,TaskScorecardID          
   ,(          
    Select A.[Name]           
    from Task_TaskScorecard A           
    where A.ID = TaskScorecardID          
    ) as TaskScorecardName          
   ,DeadlineConfirm          
   ,IsManagerFail          
   ,TaskReviewer          
   ,(          
    select FullName           
    from Users           
    where Id=Task.TaskReviewer          
    )TaskReviewerName          
  ,UserShare          
      
   '          
   DECLARE @stringsql_nguoigiao1 AS NVARCHAR(max) =   
   
   ',(          
    SELECT FullName          
    FROM Users          
    WHERE Users.Id=UserShare          
   )As UserShareName          
   ,IDRole          
   ,dbo.[fn_HELPER_Get_ListUserName_By_UserIDList](IDRole) AS IDRoleName          
   ,IDLegacyWork          
   ,(select TaskName from Task E where E.ID=Task.IDLegacyWork)LegacyWorkName               
   ,HoursUsed          
             
   ,HoursUsed_Supporter          
   ,IsExChange          
   ,IsEvaluate          
   ,AA.PhanTram          
  ,TongSoBuoc          
   ,TongSoBuocHoanThanh          
   ,(select top(1)VotingTime           
    from Task_Voting TV          
    where TV.TaskId=Task.ID          
    )          
   as VotingTime          
   '           
   + @STR_LATE_COLUM + @STR_LATE_COLUM_COPLETED + @STR_LATE_COLUM_NEXTTODEADLINE +           
   @STR_COLUM_LATECOMPLETED +@STR_COLUM_ERALYCOMPLETED + @STR_CheckedTaskTime + '          
  FROM Task          
  left join (          
   select ID,TongSoBuoc,TongSoBuocHoanThanh, case when isnull(TongSoBuoc,0) = 0 AND TaskStatus != 5 then 0 else           
   (case when TaskStatus = 5 AND isnull(TongSoBuoc,0) = 0 then 100 else (CAST( TongSoBuocHoanThanh / TongSoBuoc AS decimal(3,2)) * 100 ) end)   end PhanTram          
   from (          
   select t.*          
   ,cast ((select COUNT(*) sobuoc from Task_Content where TaskID = t.ID) as decimal(18,2)) TongSoBuoc          
   ,cast((select COUNT(*) sobuoc from Task_Content where TaskID = t.ID          
    and Task_Content.ID in ( select Task_ContentID from Task_Content_History where Task_ContentID = Task_Content.ID)          
   ) as decimal(18,2)) TongSoBuocHoanThanh          
   from Task t          
   ) A ) AA on AA.ID = Task.ID          
  WHERE ISNULL(Deleted, 0) = 0           
  '          
  + @STR_Recipient +          
  + @STR_STATUS + @STR_TASK_NAME + @STR_PriorityLevelID +  @STR_COMPLETED + @STR_ReturnWork +  @STR_DEPARTMENT + @STR_JOB_TITLE +          
  @STR_NGUOINHAN + @STR_DATEADD  + @STR_NEXTTODEADLINE + @STR_CUSTOMSTT + @STR_ISNEW + @STR_RESULT + @STR_RANKING +           
  @STR_LATE + @STR_DEADLINETODAY + @STR_LateComplete + @STR_EarlyComplete + @STR_PunctualCompleted + @STR_Evaluate +           
  @STR_DEADLINE + @STR_IsChangeDeadline + @STR_Biendotrehan_where + @STR_MONTH + @STR_YEAR + @STR_PoorRework + @STR_FailWork +          
  + ' ORDER BY DeadLine DESC '          
  + Case when ISNULL(@LIMIT,0)=0 then '' else + ' OFFSET ' + Cast(@PAGE AS VARCHAR(50)) + ' * ' + Cast(@LIMIT AS VARCHAR(50)) + ' ROWS FETCH NEXT ' + Cast(@LIMIT AS VARCHAR(50)) + ' ROWS ONLY ' end          
  EXEC (@stringsql_nguoigiao+@stringsql_nguoigiao1)          
     PRINT (@stringsql_nguoigiao)          
  PRINT (@stringsql_nguoigiao1)          
END          
          
IF @Command = 'LoadAll_NguoiGiao_CountListAllHasDelivery'           
BEGIN          
 DECLARE @stringsql_nguoigiao_count AS NVARCHAR(max) = '          
           
 '+@STR_ISNEW_CONDITION+'          
 SELECT count(*)          
  FROM Task          
  left join (          
   select ID,TongSoBuoc,TongSoBuocHoanThanh, case when isnull(TongSoBuoc,0) = 0 AND TaskStatus != 5 then 0 else           
   (case when TaskStatus = 5 AND isnull(TongSoBuoc,0) = 0 then 100 else (CAST( TongSoBuocHoanThanh / TongSoBuoc AS decimal(3,2)) * 100 ) end)   end PhanTram          
   from (          
   select t.*          
   ,cast ((select COUNT(*) sobuoc from Task_Content where TaskID = t.ID) as decimal(18,2)) TongSoBuoc          
   ,cast((select COUNT(*) sobuoc from Task_Content where TaskID = t.ID          
    and Task_Content.ID in ( select Task_ContentID from Task_Content_History where Task_ContentID = Task_Content.ID)          
   ) as decimal(18,2)) TongSoBuocHoanThanh          
   from Task t          
   ) A ) AA on AA.ID = Task.ID          
  WHERE ISNULL(Deleted, 0) = 0           
  '           
          
  + @STR_Recipient +          
  + @STR_STATUS + @STR_TASK_NAME + @STR_PriorityLevelID +  @STR_COMPLETED + @STR_ReturnWork +  @STR_DEPARTMENT + @STR_JOB_TITLE +          
  @STR_NGUOINHAN + @STR_DATEADD  + @STR_NEXTTODEADLINE + @STR_CUSTOMSTT + @STR_ISNEW + @STR_RESULT + @STR_RANKING +           
  @STR_LATE + @STR_DEADLINETODAY + @STR_LateComplete + @STR_EarlyComplete + @STR_PunctualCompleted + @STR_Evaluate +          
  @STR_DEADLINE + @STR_IsChangeDeadline + @STR_Biendotrehan_where + @STR_MONTH + @STR_YEAR + @STR_PoorRework + @STR_FailWork          
            
  EXEC (@stringsql_nguoigiao_count)          
     --PRINT @stringsql_nguoigiao_count          
END       
          
IF @Command = 'LoadAll_NguoiNhan'          
BEGIN          
 DECLARE @stringsql_nguoinhan AS NVARCHAR(max) =           
 'SELECT Task.ID          
   ,TaskName          
   ,TaskCode          
   ' + @STR_SHOWCALDATE +           
   @STR_PHONGBAN +          
   @STR_LAM_LAI_CHO_TOT +          
   '          
   ,TaskListID          
   ,dbo.[fn_HELPER_Get_TaskListName_By_TaskListID](TaskListID)AS TaskListName           
   ,PriorityLevelID          
   ,(          
    SELECT A.PriorityLevelName          
    FROM PriorityLevel A          
    WHERE A.ID = PriorityLevelID          
    ) AS PriorityLevelName          
   ,SecurityLevelID          
   ,(          
    SELECT B.SecurityLevelName          
    FROM SecurityLevel B          
    WHERE B.ID = SecurityLevelID          
    ) AS SecurityLevelName          
   ,DifficultLevelID          
   ,(          
    select DifficultLevelName           
    from DifficultLevel C           
    where C.ID=DifficultLevelID           
    )AS DifficultLevelName          
   ,LoaiViecID          
   ,(          
    SELECT B.ParameterValue          
    FROM Li_Parameter B          
    WHERE B.ParameterID = LoaiViecID          
    ) AS LoaiViecName          
   ,NguonViecID          
   --,(          
   -- SELECT B.ParameterValue          
   -- FROM Li_Parameter B          
   -- WHERE B.ParameterID = NguonViecID          
   -- ) AS NguonViecName          
   ,QuyTrinhID          
   ,(          
    SELECT B.tenquytrinh          
    FROM Li_QuyTrinh B          
    WHERE B.id = QuyTrinhID          
    ) AS QuyTrinhName          
   ,RefCode          
   ,(CASE  WHEN ''' + @USER_ID +''' = Recipient THEN 1 ELSE 0 END) AS IsRecipient          
   ,case when (select count(*) from Task_ChangeDeadLine TC where Task.ID =  TC.TaskID and TC.IsResult is null ) > 0 then 1 else 0 end  as IsExtend          
   ,case when (select count(*) from Task_Content_History TCH where Task.ID = TCH.Task_ContentID and TCH.Checked is null ) > 0 then 1 else 0 end as IsCompleted          
   ,case when (select count(*) from Task_History TH where Task.ID = TH.TaskID and TH.Checked is null ) > 0 then 1 else 0 end as IsCompleted_History          
   ,(DATEADD(MINUTE, ( cast(DATEDIFF(MINUTE, AssignmentDate, Deadline) as decimal(18,2))/ cast(100 as decimal(18,2)) * cast((SELECT BienDoTreHan from Sys_Configs)as decimal(18,2))), Deadline)) AS NewDeadline          
   ,Recipient          
   ,(          
    SELECT C.FullName          
    FROM Users C          
    WHERE C.ID = Recipient          
    ) AS RecipientName          
   ,Supporter          
   ,dbo.[fn_HELPER_Get_ListUserName_By_UserIDList](Supporter) AS SupporterName          
   ,DeadLine          
   ,AssignmentDate          
   ,[Description]          
   ,Notes          
   ,FinishedContent          
   ,TaskStatus          
   ,ListFiles           
   ,(          
    SELECT C.FullName          
    FROM Users C          
    WHERE C.ID = TaskOwner          
    ) as TaskOwnerName          
   ,ListFilesName          
   ,ResultFiles          
   ,ResultFilesName          
   ,UserAdd          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE Users.Id=UserAdd          
   )As UserAddName          
   ,[DateAdd]          
   ,UserModify          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE Users.Id=Task.UserModify          
   )As UserModifyName          
   ,DateModify          
   ,UserDeleted          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE Users.Id=UserDeleted          
   )As UserDeletedName          
   ,DateDeleted          
   ,TaskOwner          
   ,(          
    SELECT C.FullName          
    FROM Users C          
    WHERE C.ID = TaskOwner          
    ) as TaskOwnerName          
   ,IsForce          
   ,IsRemind          
   ,CountGetId          
   ,FinishedDate          
   ,TaskScorecardID          
   ,(          
    Select A.[Name]           
    from Task_TaskScorecard A           
    where A.ID = TaskScorecardID          
    ) as TaskScorecardName          
   ,DeadlineConfirm          
   ,IsManagerFail          
   ,TaskReviewer          
   ,(          
    select FullName           
    from Users           
    where Id=Task.TaskReviewer          
    )TaskReviewerName          
   ,UserShare          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE Users.Id=UserShare          
   )As UserShareName          
   ,IDRole          
   ,dbo.[fn_HELPER_Get_ListUserName_By_UserIDList](IDRole) AS IDRoleName          
   ,IDLegacyWork          
   ,(select TaskName from Task E where E.ID=Task.IDLegacyWork)LegacyWorkName          
   ,HoursUsed          
             
   ,case when (select count(1) from Task_History_Details where TaskID=Task.ID and IsRepicient=0 ) = 0 then 0 else 1 end as IsCheckSupporter          
   '           
   DECLARE @stringsql_nguoinhan1 AS NVARCHAR(max) =           
   '          
   ,HoursUsed_Supporter          
   ,IsExChange          
   ,IsEvaluate          
   ,AA.PhanTram          
   ,TongSoBuoc          
   ,TongSoBuocHoanThanh          
   '          
   + @STR_LATE_COLUM + @STR_LATE_COLUM_COPLETED + @STR_LATE_COLUM_NEXTTODEADLINE +'           
  FROM Task           
  left join (          
   select ID,TongSoBuoc,TongSoBuocHoanThanh, case when isnull(TongSoBuoc,0) = 0 AND TaskStatus != 5 then 0 else           
   (case when TaskStatus = 5 AND isnull(TongSoBuoc,0) = 0 then 100 else (CAST( TongSoBuocHoanThanh / TongSoBuoc AS decimal(3,2)) * 100 ) end)   end PhanTram          
   from (          
   select t.*          
   ,cast ((select COUNT(*) sobuoc from Task_Content where TaskID = t.ID) as decimal(18,2)) TongSoBuoc          
   ,cast((select COUNT(*) sobuoc from Task_Content where TaskID = t.ID          
    and Task_Content.ID in ( select Task_ContentID from Task_Content_History where Task_ContentID = Task_Content.ID)          
   ) as decimal(18,2)) TongSoBuocHoanThanh          
   from Task t          
          
   ) A ) AA on AA.ID = Task.ID          
  WHERE ISNULL(Deleted, 0) = 0           
  ' + @STR_DIEUKIEN_NGUOINHAN          
  + @STR_LATE + @STR_STATUS + @STR_SHARERESULT + @STR_TASK_NAME + @STR_DEADLINETODAY + @STR_CUSTOMSTT + @STR_DATEADD +          
  + @STR_PriorityLevelID + @STR_NGUOIGIAO + @STR_COMPLETED + @STR_NEXTTODEADLINE + @STR_ReturnWork + @STR_RESULT + @STR_RANKING           
  + @STR_NGAYGIAO + @STR_DEADLINE + @STR_LateComplete + @STR_EarlyComplete + @STR_PunctualCompleted  + @STR_DEPARTMENT + @STR_JOB_TITLE           
 + @STR_IsChangeDeadline+ @STR_MONTH + @STR_YEAR + @STR_PoorRework + @STR_FailWork + @STR_Evaluate +          
  ' ORDER BY DeadLine DESC '          
  + Case when ISNULL(@LIMIT,0)=0 then '' else + ' OFFSET ' + Cast(@PAGE AS VARCHAR(50)) + ' * ' + Cast(@LIMIT AS VARCHAR(50)) + ' ROWS FETCH NEXT ' + Cast(@LIMIT AS VARCHAR(50)) + ' ROWS ONLY ' end          
   EXEC (@stringsql_nguoinhan+@stringsql_nguoinhan1)          
   print @stringsql_nguoinhan          
END          
          
IF @Command = 'LoadOne'          
BEGIN          
 IF @ISCOUNTGETID = 1          
 BEGIN          
  DECLARE @CHECKTASKSTATUS INT = (SELECT TaskStatus FROM Task WHERE ID = @ID)          
  IF @CHECKTASKSTATUS = 3          
  BEGIN          
  DECLARE @COUNTCONFIG INT = (SELECT Solanduocxemchitiet FROM Sys_Configs WHERE ID =1) -1          
  DECLARE @COUNTOFTASK INT = (SELECT CountGetId FROM Task WHERE ID = @ID)          
          
  IF @COUNTOFTASK < @COUNTCONFIG OR ISNULL(@COUNTOFTASK, NULL) IS NULL          
   BEGIN          
    UPDATE Task          
    SET CountGetId = (          
      CASE           
       WHEN ISNULL(CountGetId, NULL) IS NULL          
        THEN 1          
       ELSE CountGetId + 1          
       END          
      )          
    WHERE LTRIM(RTRIM(UPPER(ID))) = LTRIM(RTRIM(UPPER(@ID)))          
   END          
  ELSE IF @COUNTOFTASK = @COUNTCONFIG          
  BEGIN          
  UPDATE Task          
    SET CountGetId = (          
      CASE           
       WHEN ISNULL(CountGetId, NULL) IS NULL          
        THEN 1          
       ELSE CountGetId + 1          
       END          
      ), TaskStatus = 4          
    WHERE LTRIM(RTRIM(UPPER(ID))) = LTRIM(RTRIM(UPPER(@ID)))          
  END          
  ELSE          
   BEGIN          
    UPDATE Task SET TaskStatus = 4 WHERE ID = RTRIM(LTRIM(@ID))          
   END          
  END          
           
 END          
 SELECT ID          
  ,TaskName          
  ,TaskCode          
  ,TaskListID                 
  ,dbo.[fn_HELPER_Get_TaskListName_By_TaskListID](TaskListID)AS TaskListName           
  ,PriorityLevelID          
  ,(          
   SELECT A.PriorityLevelName          
   FROM PriorityLevel A          
   WHERE A.ID = PriorityLevelID          
   ) AS PriorityLevelName          
  ,(          
   SELECT A.Color          
   FROM PriorityLevel A          
   WHERE A.ID = PriorityLevelID          
   ) AS PriorityLevelColor          
  ,SecurityLevelID          
  ,(          
   SELECT B.SecurityLevelName          
   FROM SecurityLevel B          
   WHERE B.ID = SecurityLevelID          
   ) AS SecurityLevelName          
  ,(          
   SELECT B.Color          
   FROM SecurityLevel B          
   WHERE B.ID = SecurityLevelID          
   ) AS SecurityLevelColor          
  ,DifficultLevelID          
  ,(          
   SELECT D.DifficultLevelName           
   FROM           
   DifficultLevel D WHERE D.ID = DifficultLevelID          
   )AS DifficultLevelName          
  ,LoaiViecID          
  ,(          
   SELECT B.ParameterValue          
   FROM Li_Parameter B          
   WHERE B.ParameterID = LoaiViecID          
   ) AS LoaiViecName          
  ,NguonViecID          
  --,(          
  -- SELECT B.ParameterValue          
  -- FROM Li_Parameter B          
  -- WHERE B.ParameterID = NguonViecID          
  -- ) AS NguonViecName          
  ,QuyTrinhID          
  ,(          
   SELECT B.tenquytrinh          
   FROM Li_QuyTrinh B          
   WHERE B.id = QuyTrinhID          
   ) AS QuyTrinhName          
  ,RefCode          
            
  ,(CASE  WHEN  @USER_ID  = Recipient THEN 1 ELSE 0 END) AS IsRecipient          
  ,Recipient          
  ,(          
   SELECT C.FullName          
   FROM Users C          
   WHERE C.ID = Recipient          
   ) AS RecipientName          
  ,case when (select count(1) from Task_History TH where Task.ID = TH.TaskID and TH.Checked is null ) > 0 then 1 else 0 end as IsCompleted_History          
  ,case when len(isnull(Task.Supporter,'')) = 0 then 1        
   when (select count(1) from Task_History_Details where TaskID=Task.ID and IsRepicient=0 ) = 0 then 0 else 1 end as IsCheckSupporter          
  ,Supporter          
  ,dbo.[fn_HELPER_Get_ListUserName_By_UserIDList](Supporter) AS SupporterName          
  ,DeadLine          
  ,AssignmentDate          
  ,[Description]          
  ,Notes          
  ,FinishedContent          
  ,TaskStatus          
  ,ListFiles          
  ,ListFilesName          
  ,ResultFiles          
  ,HoursUsed          
  ,HoursUsed_Supporter          
  ,ResultFilesName          
  ,UserAdd          
  ,(          
   SELECT FullName          
   FROM Users          
   WHERE Users.Id=UserAdd          
  )As UserAddName          
  ,[DateAdd]          
  ,UserModify          
  ,(          
   SELECT FullName          
   FROM Users          
   WHERE Users.Id=Task.UserModify          
  )As UserModifyName          
  ,DateModify          
  ,UserDeleted          
  ,(          
   SELECT FullName          
   FROM Users          
   WHERE Users.Id=UserDeleted          
  )As UserDeletedName          
  ,DateDeleted          
  ,TaskOwner          
  ,(          
   SELECT C.FullName          
   FROM Users C          
   WHERE C.ID = TaskOwner          
   ) AS TaskOwnerName          
  ,DateSent          
  ,IsForce          
  ,IsRemind          
  ,CountGetId          
  ,FinishedDate          
  ,(select top(1)VotingTime           
   from Task_Voting TV          
   where TV.TaskId=Task.ID          
  )as VotingTime          
  ,TaskScorecardID          
  ,(          
Select A.[Name]           
   from Task_TaskScorecard A           
   where A.ID = TaskScorecardID          
   ) as TaskScorecardName          
  ,DeadlineConfirm          
  ,TaskReviewer          
  ,(          
   select FullName           
   from Users           
   where Id=Task.TaskReviewer          
   )TaskReviewerName          
  ,UserShare          
  ,(          
   SELECT FullName          
   FROM Users          
   WHERE Users.Id=UserShare          
  )As UserShareName          
  ,IDRole          
  ,dbo.[fn_HELPER_Get_ListUserName_By_UserIDList](IDRole) AS IDRoleName          
  ,(SELECT PhongBan FROM Users WHERE ID = Recipient) AS IDPhongban          
  ,IDLegacyWork          
  ,(select TaskName from Task E where E.ID=Task.IDLegacyWork)LegacyWorkName          
  ,HoursUsed          
  --,(select Hours_in_month_used from Sys_Hours_In_Month_User where UserId=Recipient)As Hours_in_month_used          
  --,(select Hours_in_month_remaining from Sys_Hours_In_Month_User where UserId=Recipient)As Hours_in_month_remaining          
  ,HoursUsed_Supporter          
  ,IsExChange          
  ,IsEvaluate    ,    
  IDClone    
  --,(select top(1)TaskScorecardID from Task_Voting where Task.ID=TaskId) as TaskScorecardID          
  --,(Select A.[Name] from Task_TaskScorecard A where A.ID = TaskScorecardID) as TaskScorecardName          
 FROM Task          
 WHERE ISNULL(Deleted, 0) = 0          
  AND LTRIM(RTRIM(UPPER(ID))) = LTRIM(RTRIM(UPPER(@ID)))          
          
           
END          
          
IF @Command = 'LoadTask_Content' OR @Command = 'LoadTask_Result' OR @Command = 'LoadTask_Infotext'          
BEGIN          
          
 declare @IDLegacyWork nvarchar(50) = (select IDLegacyWork from Task where ID=@ID)          
          
END          
          
IF @Command = 'LoadTask_Content'          
BEGIN          
          
 IF RTRIM(LTRIM(UPPER(@IDLegacyWork))) IS NULL           
   OR LEN(@ID) <= 0          
  BEGIN          
   SELECT *          
    ,(          
     SELECT FullName          
     FROM Users          
     WHERE ID = UserDo          
     ) AS UserDoName          
   FROM Task_Content          
   WHERE TaskID = @ID AND ISNULL(Deleted,0) = 0          
   ORDER BY SortOrder          
  END          
 ELSE          
 BEGIN          
  SELECT *          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE ID = UserDo          
    ) AS UserDoName          
  FROM Task_Content          
  WHERE (TaskID = @ID or TaskID=@IDLegacyWork) AND ISNULL(Deleted,0) = 0          
  ORDER BY SortOrder          
 END          
          
           
END          
          
IF @Command = 'LoadTask_Result'          
BEGIN          
 IF RTRIM(LTRIM(UPPER(@IDLegacyWork))) IS NULL           
   OR LEN(@ID) <= 0          
 BEGIN          
  SELECT *          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE ID = UserChecked          
    ) AS UserCheckedName          
  FROM Task_Result          
  WHERE TaskID = @ID AND ISNULL(Deleted,0) = 0          
 END          
 ELSE          
 BEGIN          
  SELECT *          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE ID = UserChecked          
    ) AS UserCheckedName          
  FROM Task_Result          
  WHERE (TaskID = @ID or TaskID=@IDLegacyWork) AND ISNULL(Deleted,0) = 0          
 END          
END          
          
IF @Command = 'LoadTask_Infotext'          
BEGIN          
 IF RTRIM(LTRIM(UPPER(@IDLegacyWork))) IS NULL           
   OR LEN(@ID) <= 0          
 BEGIN          
  SELECT *          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE ID = Task_InfoText.UserAdd          
    ) AS UserAddName          
  FROM Task_InfoText          
  WHERE TaskID = @ID          
  ORDER BY [DateAdd]           
 END          
 ELSE          
 BEGIN          
  SELECT *          
   ,(          
    SELECT FullName          
    FROM Users          
    WHERE ID = Task_InfoText.UserAdd          
    ) AS UserAddName          
  FROM Task_InfoText            WHERE (TaskID = @ID or TaskID=@IDLegacyWork)          
  ORDER BY [DateAdd]           
 END          
END          
          
declare @_workday float = 24          
          
          
IF @Command = 'LoadList_PhongBan_QuaTai'          
BEGIN          
--select sum(hours_in_month) him from  Sys_Hours_In_Month_User where [Month]=Month(getdate()) and [Year] = Year(getdate())          
          
          
 DECLARE @PBOverloadBusy INT = (          
   SELECT TOP 1 isnull(OverloadBusy, 0)          
   FROM Sys_Configs          
   );          
 DECLARE @PBOverloadFree INT = (          
   SELECT TOP 1 isnull(OverloadFree, 0)          
   FROM Sys_Configs          
   );          
 DECLARE @PBOverloadFull INT = (          
   SELECT TOP 1 isnull(OverloadFull, 0)          
   FROM Sys_Configs          
   );          
          
   select _A_.*          
   ,CASE           
   WHEN Hours_in_month_used_percent <= OverloadFree          
    THEN N'#107c41'          
   ELSE CASE           
     WHEN  Hours_in_month_used_percent<OverloadBusy          
      THEN N'#FFAA00'          
     ELSE           
         N'#ff0000'          
                 
     END          
   END ColorText          
   from (          
 SELECT pb.ParameterID IdPhongBan          
  ,pb.ParameterValue TenPhongBan          
  ,@PBOverloadFree OverloadFree,@PBOverloadBusy OverloadBusy,@PBOverloadFull OverloadFull          
 ,Hours_in_month,Hours_in_month_used,Hours_in_month_remaining          
 ,100 Hours_in_month_percent          
 ,case when isnull(hours_in_month,0)=0 then 0 else round(cast(isnull(Hours_in_month_used,0) as float)/isnull(hours_in_month,0)  * 100,2) end Hours_in_month_used_percent          
 ,case when isnull(hours_in_month,0)=0 then 0 else round(cast(isnull(Hours_in_month_remaining,0) as float)/isnull(hours_in_month,0)  * 100,2) end Hours_in_month_remaining_percent          
 FROM Li_Parameter pb           
  left join (          
     SELECT           
   --_u.id,          
   _u.PhongBan ,sum(isnull(_HIM.hours_in_month,0)) hours_in_month, SUM(isnull(_HIM.Hours_in_month_used,0)) Hours_in_month_used, sum(isnull(_HIM.Hours_in_month_remaining,0)) Hours_in_month_remaining          
   FROM Sys_Hours_In_Month_User _HIM          
   left join Users _u on _u.Id = _HIM.UserId          
   where _HIM.[Month]=Month(getdate()) and _HIM.[Year] = Year(getdate())          
   group by _u.PhongBan          
  ) _HIM_ on _HIM_.PhongBan = pb.ParameterID          
 WHERE pb.ParameterKey = 'LI_PHONGBAN' AND isnull(pb.Deleted, 0) = 0 AND ISNULL(pb.IsActive, 0) = 1          
          
 )_A_           
          
          
END          
          
IF @Command = 'LoadList_NguoiNhan_QuaTai'          
BEGIN          
 DECLARE @NNOverloadBusy INT = (          
   SELECT TOP 1 isnull(OverloadBusy, 0)          
   FROM Sys_Configs          
   );          
 DECLARE @NNOverloadFree INT = (          
   SELECT TOP 1 isnull(OverloadFree, 0)          
   FROM Sys_Configs          
   );          
 DECLARE @NNOverloadFull INT = (          
   SELECT TOP 1 isnull(OverloadFull, 0)          
   FROM Sys_Configs          
   );          
    
   -- Task UserGroup     
 insert into @tbl_Users          
 exec P_Users_GetListAcceptView_In_Organization @USER_ID, @SEARCH_PHONGBAN, @IsInOrganization    
    
  select Id ,UserName ,FullName,      
   Hours_in_month , Hours_in_month_used_percent, Hours_in_month_remaining_percent,   
   OverloadFree, OverloadFree, OverloadBusy, OverloadFull, DataLevel,  
   STRING_AGG(IdPhongBan, ',') IdPhongBan, STRING_AGG(TenPhongBan,'|') TenPhongBan         
   ,CASE           
   WHEN Hours_in_month_used_percent <= OverloadFree          
    THEN N'#107c41'          
   ELSE CASE           
     WHEN  Hours_in_month_used_percent<OverloadBusy          
      THEN N'#FFAA00'          
     ELSE           
         N'#ff0000'          
                 
     END          
   END ColorText          
   from (          
          
    SELECT           
   _u.Id ,UserName ,_u.FullName,  C.PhongBan IdPhongBan, pb.ParameterValue TenPhongBan          
   ,_HIM.Hours_in_month , _HIM.Hours_in_month_used, _HIM.Hours_in_month_remaining          
   ,100 Hours_in_month_percent           
   ,case when isnull(hours_in_month,0)=0 then 0 else round(cast(isnull(Hours_in_month_used,0) as float)/isnull(hours_in_month,0)  * 100,2) end Hours_in_month_used_percent          
   ,case when isnull(hours_in_month,0)=0 then 0 else round(cast(isnull(Hours_in_month_remaining,0) as float)/isnull(hours_in_month,0)  * 100,2) end Hours_in_month_remaining_percent          
   ,@NNOverloadFree OverloadFree,@NNOverloadBusy OverloadBusy,@NNOverloadFull OverloadFull,          
          
   (          
    SELECT TOP(1) max(DataLevel)          
    FROM Users a          
     INNER JOIN UserGroup b ON a.Id = b.UserID          
     INNER JOIN Sys_DataLevel c ON b.GroupID = c.GroupID          
    WHERE a.Id = _u.Id          
   ) AS DataLevel  
   
   FROM Sys_Hours_In_Month_User _HIM          
   left join Users _u on _u.Id = _HIM.UserId  
   inner join @tbl_Users C on C.UserId = _u.id   
   left join  Li_Parameter pb  on C.PhongBan = pb.ParameterID AND pb.ParameterKey = 'LI_PHONGBAN'  
   where _HIM.[Month]=Month(getdate()) and _HIM.[Year] = Year(getdate())          
   --AND pb.ParameterKey = 'LI_PHONGBAN' AND isnull(pb.Deleted, 0) = 0 AND ISNULL(pb.IsActive, 0) = 1      
  
   ) _A_     
   GROUP BY  Id ,UserName ,FullName,      
   Hours_in_month , Hours_in_month_used_percent, Hours_in_month_remaining_percent,   
   OverloadFree, OverloadFree, OverloadBusy, OverloadFull, DataLevel         
   , Hours_in_month_percent    
   --where _A_.DataLevel <  ( SELECT TOP (1) max(DataLevel)          
   --         FROM Users a          
   --         INNER JOIN UserGroup b ON a.Id = b.UserID          
   --         INNER JOIN Sys_DataLevel c ON b.GroupID = c.GroupID          
   --         WHERE a.Id = @USER_ID)          
          
END          
          
IF @Command = 'LoadList_PhongBan_QuaTai_ByUser_ID'          
BEGIN          
           
 DECLARE @PBIsActiveOverload_UID BIT = (          
   SELECT TOP 1 isnull(IsActiveOverload, 0)          
   FROM Sys_Configs          
   );          
 DECLARE @PBOverloadType_UID INT = (          
   SELECT TOP 1 isnull(OverloadType, 0)          
   FROM Sys_Configs          
   );          
 DECLARE @PBOverloadBusy_UID INT = (          
   SELECT TOP 1 isnull(OverloadBusy, 0)          
   FROM Sys_Configs          
   );          
 DECLARE @PBOverloadFree_UID INT = (          
   SELECT TOP 1 isnull(OverloadFree, 0)          
   FROM Sys_Configs          
   );          
 DECLARE @PBOverloadFull_UID INT = (          
   SELECT TOP 1 isnull(OverloadFull, 0)          
   FROM Sys_Configs          
   );          
--declare @_levelbyID int = 0          
--set @_levelbyID =          
--(          
--select max (lvl) lvl from(          
--select max(B.Lvl) lvl ,A.GroupID          
--from          
-- (          
-- select distinct GroupID           
-- from UserGroup           
-- where UserID = @USER_ID          
-- )A left join (select distinct GroupID, max(DataLevel) Lvl FROM Sys_DataLevel group by GroupID)B on B.GroupID = A.GroupID group by  A.GroupID)C)          
          
--declare @_level_assign_level3 int = null          
--set @_level_assign_level3 =           
--(          
-- select IsActiveOffice           
-- from Users          
-- where Id= @USER_ID          
--)          
          
          
--declare @_listpb as table          
--(ParameterID int)          
   
 -- Task UserGroup     
 insert into @tbl_Users          
 exec P_Users_GetListAcceptView_In_Organization @USER_ID, @SEARCH_PHONGBAN, @IsInOrganization    
   
--if (ISNULL(@_levelbyID,1)  = 3  )          
--begin          
--insert into @_listpb select ParameterID from Li_Parameter where isnull(Deleted,0) = 0 and isnull(IsActive,0) = 1 and  ParameterKey = 'LI_PHONGBAN'          
--end          
--else if (ISNULL(@_levelbyID,1)  = 2  )          
-- begin          
-- if @_level_assign_level3 = 1          
-- insert into @_listpb select ParameterID from Li_Parameter where isnull(Deleted,0) = 0 and isnull(IsActive,0) = 1 and  ParameterKey = 'LI_PHONGBAN'          
-- else if @_level_assign_level3 =0          
-- insert into @_listpb select ParameterID from Li_Parameter where isnull(Deleted,0) = 0 and isnull(IsActive,0) = 1 and  ParameterKey = 'LI_PHONGBAN'           
-- and ParameterID = (select top 1 PhongBan from Users where Id = @USER_ID)          
-- end          
          
--else          
-- begin          
-- if @_level_assign_level3 = 1          
-- insert into @_listpb select ParameterID from Li_Parameter where isnull(Deleted,0) = 0 and isnull(IsActive,0) = 1 and  ParameterKey = 'LI_PHONGBAN'          
-- else if @_level_assign_level3 =0          
-- insert into @_listpb select ParameterID from Li_Parameter where isnull(Deleted,0) = 0 and isnull(IsActive,0) = 1 and  ParameterKey = 'LI_PHONGBAN' and ParameterID = 0          
-- end          
          
   select _A_.*          
   ,CASE           
   WHEN Hours_in_month_used_percent <= OverloadFree          
    THEN N'#107c41'          
   ELSE CASE           
     WHEN  Hours_in_month_used_percent<OverloadBusy          
      THEN N'#FFAA00'          
     ELSE           
         N'#ff0000'          
                 
     END          
   END ColorText          
   from (          
 SELECT pb.ParameterID IdPhongBan,pb.RefID          
  ,pb.ParameterValue TenPhongBan          
  ,@PBOverloadFree_UID OverloadFree,@PBOverloadBusy_UID OverloadBusy,@PBOverloadFull_UID OverloadFull          
 ,Hours_in_month,Hours_in_month_used,Hours_in_month_remaining          
 ,100 Hours_in_month_percent          
 ,case when isnull(hours_in_month,0)=0 then 0 else round(cast(isnull(Hours_in_month_used,0) as float)/isnull(hours_in_month,0)  * 100,2) end Hours_in_month_used_percent          
 ,case when isnull(hours_in_month,0)=0 then 0 else round(cast(isnull(Hours_in_month_remaining,0) as float)/isnull(hours_in_month,0)  * 100,2) end Hours_in_month_remaining_percent          
 FROM Li_Parameter pb  
  left join (          
     SELECT           
   --_u.id,          
   _u.PhongBan ,sum(_HIM.hours_in_month) hours_in_month, SUM(_HIM.Hours_in_month_used) Hours_in_month_used, sum(_HIM.Hours_in_month_remaining) Hours_in_month_remaining          
   FROM Sys_Hours_In_Month_User _HIM          
   left join Users _u on _u.Id = _HIM.UserId          
   where _HIM.[Month]=Month(getdate()) and _HIM.[Year] = Year(getdate())          
   group by _u.PhongBan          
  ) _HIM_ on _HIM_.PhongBan = pb.ParameterID          
 WHERE   exists(select 1 from  @tbl_Users B where pb.ParameterID = b.PhongBan)               
 )_A_             
          
          
END   
  
end