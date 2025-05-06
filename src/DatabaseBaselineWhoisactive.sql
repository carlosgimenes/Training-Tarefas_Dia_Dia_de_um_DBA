/*
============================================================================================================================
-- SQL Database Baseline WhoisActive
-- Carlos Eduardo Gimenes
-- Last Modified: April, 2023

**Copyright (C) 2023 Carlos Eduardo Gimenes**  
All rights reserved.  
You may alter this code for your own _non-commercial_ purposes.  
You may republish altered code as long as you include this copyright and give due credit.

THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR 
A PARTICULAR PURPOSE.
============================================================================================================================

*/

/*
This script is used to create a baseline for the database using the WhoIsActive tool.
It captures the current state of the database and stores it in a table for future reference.
The script includes the following steps:
*/

-- =========================
-- 1. Create Database Traces
-- =========================

/*
----------------------------------------------------------------------------------------------------------------------------
	Title		:	Create Database Traces
----------------------------------------------------------------------------------------------------------------------------
	Author		:	Gimenes
	Date		:	19/04/2023
	Requester	:	Gimenes
	Purpose		:	Database Health Check
	Program		:	Not applicable
    Credito     :   http://www.fabriciolima.net/
			
----------------------------------------------------------------------------------------------------------------------------
*/
-- >>> Inicio da Query
IF NOT EXISTS (
        SELECT name
        FROM sys.databases
        WHERE name = 'Traces'
        )
    CREATE DATABASE [Traces] CONTAINMENT = NONE ON PRIMARY (
        NAME = N'Traces_Data'
        , FILENAME = N'/InformarCaminhoArquivoDatabase/Traces_Data.mdf' -- ATENCAO: Ajustar
        , SIZE = 2048000KB                                              -- ATENCAO: Ajustar (Aqui ficou definido com 2GB)
        , MAXSIZE = 3072000KB                                           -- ATENCAO: Ajustar (Aqui ficou definido com 3GB)
        , FILEGROWTH = 512000KB                                         -- ATENCAO: Ajustar (Aqui ficou definido com 500MB)
        ) LOG ON (
        NAME = N'Traces_log'                                            -- ATENCAO: Ajustar
        --, FILENAME = N'/var/opt/mssql/data/Traces_log.ldf'            -- ATENCAO: Ajustar (Exemplo em um SQL Server Linux)
        --, FILENAME = N'/var/opt/mssql/log/Traces_log.ldf'             -- ATENCAO: Ajustar (Exemplo em um SQL Server Linux)
        , FILENAME = N'/var/opt/mssql/log/Traces_log.ldf'               -- ATENCAO: Ajustar (Exemplo em um SQL Server Linux)
        , SIZE = 1024000KB                                              -- ATENCAO: Ajustar (Aqui ficou definido com 1GB)
        , MAXSIZE = 1536000KB                                           -- ATENCAO: Ajustar (Aqui ficou definido com 1.5GB)
        , FILEGROWTH = 512000KB
        )
GO

ALTER DATABASE [Traces]

SET COMPATIBILITY_LEVEL = 150
GO

ALTER DATABASE [Traces]

SET ANSI_NULL_DEFAULT OFF
GO

ALTER DATABASE [Traces]

SET ANSI_NULLS OFF
GO

ALTER DATABASE [Traces]

SET ANSI_PADDING OFF
GO

ALTER DATABASE [Traces]

SET ANSI_WARNINGS OFF
GO

ALTER DATABASE [Traces]

SET ARITHABORT OFF
GO

ALTER DATABASE [Traces]

SET AUTO_CLOSE OFF
GO

ALTER DATABASE [Traces]

SET AUTO_SHRINK OFF
GO

ALTER DATABASE [Traces]

SET AUTO_CREATE_STATISTICS ON (INCREMENTAL = ON)
GO

ALTER DATABASE [Traces]

SET AUTO_UPDATE_STATISTICS ON
GO

ALTER DATABASE [Traces]

SET CURSOR_CLOSE_ON_COMMIT OFF
GO

ALTER DATABASE [Traces]

SET CURSOR_DEFAULT GLOBAL
GO

ALTER DATABASE [Traces]

SET CONCAT_NULL_YIELDS_NULL OFF
GO

ALTER DATABASE [Traces]

SET NUMERIC_ROUNDABORT OFF
GO

ALTER DATABASE [Traces]

SET QUOTED_IDENTIFIER OFF
GO

ALTER DATABASE [Traces]

SET RECURSIVE_TRIGGERS OFF
GO

ALTER DATABASE [Traces]

SET DISABLE_BROKER
GO

ALTER DATABASE [Traces]

SET AUTO_UPDATE_STATISTICS_ASYNC ON
GO

ALTER DATABASE [Traces]

SET DATE_CORRELATION_OPTIMIZATION OFF
GO

ALTER DATABASE [Traces]

SET PARAMETERIZATION SIMPLE
GO

ALTER DATABASE [Traces]

SET READ_COMMITTED_SNAPSHOT OFF
GO

ALTER DATABASE [Traces]

SET READ_WRITE
GO

ALTER DATABASE [Traces]

SET RECOVERY FULL
GO

ALTER DATABASE [Traces]

SET MULTI_USER
GO

ALTER DATABASE [Traces]

SET PAGE_VERIFY CHECKSUM
GO

ALTER DATABASE [Traces]

SET TARGET_RECOVERY_TIME = 60 SECONDS
GO

ALTER DATABASE [Traces]

SET DELAYED_DURABILITY = DISABLED
GO

USE [Traces]
GO

ALTER DATABASE SCOPED CONFIGURATION

SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION
FOR SECONDARY

SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION

SET MAXDOP = 0;
GO

ALTER DATABASE SCOPED CONFIGURATION
FOR SECONDARY

SET MAXDOP = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION

SET PARAMETER_SNIFFING = ON;
GO

ALTER DATABASE SCOPED CONFIGURATION
FOR SECONDARY

SET PARAMETER_SNIFFING = PRIMARY;
GO

ALTER DATABASE SCOPED CONFIGURATION

SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION
FOR SECONDARY

SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO

USE [Traces]
GO

IF NOT EXISTS (
        SELECT name
        FROM sys.filegroups
        WHERE is_default = 1
            AND name = N'PRIMARY'
        )
    ALTER DATABASE [Traces] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

-- <<< Fim da Query

-- x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x

-- ======================================
-- 2. Create Table to Store Baseline Data
-- ======================================

/*
----------------------------------------------------------------------------------------------------------------------------
	Title		:	Create Table Resultado_WhoisActive
----------------------------------------------------------------------------------------------------------------------------
	Author		:	Gimenes
	Date		:	19/04/2023
	Requester	:	Gimenes
	Purpose		:	Database Health Check
	Program		:	Not applicable
    Credito     :   http://www.fabriciolima.net/
			
----------------------------------------------------------------------------------------------------------------------------
*/

-- >>> Inicio da Query

USE Traces
GO

if OBJECT_ID('Resultado_WhoisActive') is not null
	drop table Resultado_WhoisActive

CREATE TABLE Resultado_WhoisActive  (
      Dt_Log DATETIME ,
      [dd hh:mm:ss.mss] VARCHAR(8000) NULL ,
      [database_name] VARCHAR(128) NULL ,
      [session_id] SMALLINT NOT NULL ,
      blocking_session_id SMALLINT NULL ,
      [sql_text] XML NULL ,
      [login_name] VARCHAR(128) NOT NULL ,
      [wait_info] VARCHAR(4000) NULL ,
      [status] VARCHAR(30) NOT NULL ,
      [percent_complete] VARCHAR(30) NULL ,
      [host_name] VARCHAR(128) NULL ,
      [sql_command] XML NULL ,
      [CPU] VARCHAR(100) ,
      [reads] VARCHAR(100) ,
      [writes] VARCHAR(100),
	  [Program_Name] VARCHAR(100)
    );
GO

-- <<< Fim da Query

-- x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x

-- =========================================
-- 3. Creation of Job to process WhoisActive
-- =========================================

/*
Make sure you are connected a msdb system database
*/

/*
----------------------------------------------------------------------------------------------------------------------------
	Title		:	Job creation to process WhoisActive
----------------------------------------------------------------------------------------------------------------------------
	Author		:	Gimenes
	Date		:	19/04/2023
	Requester	:	Gimenes
	Purpose		:	Database Health Check
	Program		:	Not applicable
    Credito     :   http://www.fabriciolima.net/
			
----------------------------------------------------------------------------------------------------------------------------
    Job Name	:	DBA - Carga Whoisactive
    Job Owner	:	sa
    Job Category:	Database Maintenance
    Job Steps	:	DBA - WhoisActive
    Description :	No description available.
    Schedule	:	DBA - WhoisActive
    Frequency	:	Daily
    Time		:	05:00 to 22:00
*/

-- >>> Inicio da Query

USE [msdb]
GO
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA - Carga Whoisactive')
EXEC msdb.dbo.sp_delete_job @job_name=N'DBA - Carga Whoisactive', @delete_unused_schedule=1
GO

USE [msdb]
GO

/****** Object:  Job [DBA - Carga Whoisactive]    Script Date: 04/23/2014 19:59:41 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 04/23/2014 19:59:41 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Carga Whoisactive', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [DBA - WhoisActive]    Script Date: 04/23/2014 19:59:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'DBA - WhoisActive', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC sp_WhoIsActive @get_outer_command = 1,
            @output_column_list = ''[collection_time][d%][session_id][blocking_session_id][sql_text][login_name][wait_info][status][percent_complete]
      [host_name][database_name][sql_command][CPU][reads][writes][program_name]'',
    @destination_table = ''Resultado_WhoisActive''
', 
		@database_name=N'Traces', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'DBA - WhoisActive', 
		@enabled=1, 
		@freq_type=4, 					-- Frequency, Occurs = Daily
		@freq_interval=1, 				-- Frequency, Recurs every = 1 day(s)
		@freq_subday_type=4, 			-- Daily frequency, Occurs every = 1 minute(s)
		@freq_subday_interval=1, 		
		@freq_relative_interval=0,
		@freq_recurrence_factor=0, 
		@active_start_date=20140101, 	-- Duration, Start date = 01/01/2014
		@active_end_date=99991231, 		-- Duration, End date = No end date
		@active_start_time=50000, 		-- Daily frequency, Starting at = 05:00:00
		@active_end_time=220000, 		-- Daily frequency, Ending at = 22:00:00
		@schedule_uid=N'c8a3eb26-b2ed-456d-8c4d-ae7c95e88163'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

-- <<< Fim da Query

-- x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x

-- ===============================
-- 4. Create Procedure WhoisActive
-- ===============================

/*
Make sure you are connected a master system database
*/

/*
----------------------------------------------------------------------------------------------------------------------------
	Title		:	Job creation to process WhoisActive
----------------------------------------------------------------------------------------------------------------------------
	Author		:	Gimenes
	Date		:	19/09/2023
	Requester	:	Gimenes
	Purpose		:	Database Health Check
	Program		:	Not applicable
    Credito     :   http://www.fabriciolima.net/
                    http://whoisactive.com
			
-------------------------------------------------------------------------------------------------------------------------
*/

-- >>> Inicio da Query

-- Execute a procedure sp_WhoIsActive (./src/sp_whoisactive-12.00/sp_WhoIsActive.sql) to capture the current state of 
-- the database and store it in the Resultado_WhoisActive table.
-- The procedure sp_WhoIsActive is a tool that provides information about the current activity in SQL Server.

-- <<< Fim da Query

-- x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x

-- ===============================================================================
-- 5. Creation of a Job to process the cleaning of the Resultado_WhoisActive table
-- ===============================================================================

/*
Make sure you are connected a msdb system database
*/

-- Part I - Query que realiza a limpeza (Não é executada de forma individual, está contida no 
-- Job [DBA - Limpeza tabela Resultado_WhoisActive]

/*
-------------------------------------------------------------------------------------------------------------------------
	Title		:	Job creation to process Resultado_WhoisActive table cleanup
-------------------------------------------------------------------------------------------------------------------------
	Author		:	Gimenes
	Date		:	19/04/2023
	Requester	:	Gimenes
	Purpose		:	Database Health Check
	Program		:	Not applicable
    			
-------------------------------------------------------------------------------------------------------------------------
*/
-- >>> Inicio da Query

DELETE
FROM Traces.dbo.Resultado_WhoisActive
WHERE Dt_Log <= DATEADD(DAY, - 15, GETDATE())		-- Excluir registros superiores a 15 dias

-- <<< Fim da Query

-- Part II - Query para criação do Job que irá processar a Query de limpeza

/*
----------------------------------------------------------------------------------------------------------------------------
	Title		:	Job creation to process Resultado_WhoisActive table cleanup
----------------------------------------------------------------------------------------------------------------------------
	Author		:	Gimenes
	Date		:	19/04/2023
	Requester	:	Gimenes
	Purpose		:	Database Health Check
	Program		:	Not applicable
    			
----------------------------------------------------------------------------------------------------------------------------
    Job Name	:	DBA - Limpeza tabela Resultado_WhoisActive
    Job Owner	:	sa
    Job Category:	Database Maintenance
    Job Steps	:	Step_1
    Description :	Exclui da tabela Resultado_WhoisActive registros com data anterior a 15 dais.
    Schedule	:	Schedule_1
    Frequency	:	Weekly
    Time		:	23:00 to No end date
*/

-- Make sure you are connected a msdb system database

-- >>> Inicio da Query

USE [msdb]
GO

/****** Object:  Job [DBA - Limpeza tabela Resultado_WhoisActive]    Script Date: 19/04/2023 14:56:32 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 19/04/2023 14:56:32 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Limpeza tabela Resultado_WhoisActive', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Exclui da tabela Resultado_WhoisActive registros com data anterior a 15 dais.', 	-- Ajustar de acordo com a Query
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'carlos.gimenes', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step_1]    Script Date: 19/04/2023 14:56:32 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step_1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'/*
-------------------------------------------------------------------------------------------------------------------------
	Title		:	Job creation to process Resultado_WhoisActive table cleanup
-------------------------------------------------------------------------------------------------------------------------
	Author		:	Gimenes
	Date		:	19/04/2023
	Requester	:	Gimenes
	Purpose		:	Database Health Check
	Program		:	Not applicable
    			
-------------------------------------------------------------------------------------------------------------------------
*/
-- >>> Inicio da Query

DELETE
FROM Traces.dbo.Resultado_WhoisActive
WHERE Dt_Log <= DATEADD(DAY, - 15, GETDATE())

-- <<< Fim da Query
', 
		@database_name=N'Traces', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Schedule_1', 
		@enabled=1, 
		@freq_type=8,                       -- Frequency, Occurs = Weekly
		@freq_interval=1,                   -- Frequency, Recurs every = 1 week(s)
		@freq_subday_type=1,                -- Daily frequency, Recurs every = 1 week(s) on Sunday
		@freq_subday_interval=0,
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20230419,        -- Duration, Stard date = 19/04/2023
		@active_end_date=99991231,          -- Duration, End date = No end date
		@active_start_time=230000,          -- Daily frequency, Occurs once at = 23:00:00
		@active_end_time=235959,
		@schedule_uid=N'c4bc93ed-4e7f-42e0-93f3-ae3e6f464e7f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

-- <<< Fim da Query

-- x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x

-- Fim de arquivo