/*******************************************************************************************************************************
(C) 2015, Fabr�cio Lima Solu��es em Banco de Dados

Site: http://www.fabriciolima.net/

Feedback: contato@fabriciolima.net
*******************************************************************************************************************************/

/*******************************************************************************************************************************
--	OBS:	Mudar os caminhos da query abaixo para o caminho do servidor desejado:
--			C:\Fabricio\SQL Server\Treinamento\
*******************************************************************************************************************************/

--	Cria��o de uma database chamada Traces
if not exists(select name from sys.databases where name = 'Traces')
	create database Traces
GO

use Traces

--	Cria��o de uma tabela para armazenar os registros do Trace
if OBJECT_ID('Traces') is not null
	drop table Traces
	
CREATE TABLE [dbo].[Traces](
	[TextData] varchar(max) NULL,
	[NTUserName] [varchar](128) NULL,
	[HostName] [varchar](128) NULL,
	[ApplicationName] [varchar](128) NULL,
	[LoginName] [varchar](128) NULL,
	[SPID] [int] NULL,
	[Duration] [numeric](15, 2) NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[ServerName] [varchar](128) NULL,
	[Reads] [int] NULL,
	[Writes] [int] NULL,
	[CPU] [int] NULL,
	[DataBaseName] [varchar](128) NULL,
	[RowCounts] [int] NULL,
	[SessionLoginName] [varchar](128) NULL
) ON [PRIMARY]

--	Cria��o da procedure para criar o Trace

use Traces
if OBJECT_ID('stpCreate_Trace') is not null
	drop procedure stpCreate_Trace

GO

CREATE  Procedure [dbo].[stpCreate_Trace]
AS

BEGIN
--	Create a Queue
declare @rc int
declare @TraceID int
declare @maxfilesize bigint
set @maxfilesize = 50

--	Please replace the text InsertFileNameHere, with an appropriate
--	filename prefixed by a path, e.g., c:\MyFolder\MyTrace. The .trc extension
--	will be appended to the filename automatically. If you are writing from
--	remote server to local drive, please use UNC path and make sure server has
--	write access to your network share

--exec @rc = sp_trace_create @TraceID output, 0, N'C:\Fabricio\SQL Server\Treinamento\Duracao', @maxfilesize, NULL 
exec @rc = sp_trace_create @TraceID output, 0, N'/var/opt/mssql/traces/Duracao', @maxfilesize, NULL 
if (@rc != 0) goto error

--	Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1

--	10 RPC: Completed -> Ocorre quando uma RPC (chamada de procedimento remoto) � conclu�da. 
exec sp_trace_setevent @TraceID, 10, 1, @on		-- TextData: Valor de texto dependente da classe de evento capturada no rastreamento.
exec sp_trace_setevent @TraceID, 10, 6, @on		-- NTUserName: Nome de usu�rio do Microsoft Windows. 
exec sp_trace_setevent @TraceID, 10, 8, @on		-- HostName: Nome do computador cliente que originou a solicita��o. 
exec sp_trace_setevent @TraceID, 10, 10, @on	-- ApplicationName: Nome do aplicativo cliente que criou a conex�o com uma inst�ncia do SQL Server. 
												-- Essa coluna � populada com os valores passados pelo aplicativo e n�o com o nome exibido do programa.
exec sp_trace_setevent @TraceID, 10, 11, @on	-- LoginName: Nome de logon do cliente no SQL Server.
exec sp_trace_setevent @TraceID, 10, 12, @on	-- SPID: ID de processo de servidor atribu�da pelo SQL Server ao processo associado ao cliente.
exec sp_trace_setevent @TraceID, 10, 13, @on	-- Duration: Tempo decorrido (em milh�es de segundos) utilizado pelo evento. 
												-- Esta coluna de dados n�o � populada pelo evento Hash Warning.
exec sp_trace_setevent @TraceID, 10, 14, @on	-- StartTime: Hor�rio de in�cio do evento, quando dispon�vel.
exec sp_trace_setevent @TraceID, 10, 15, @on	-- EndTime: Hor�rio em que o evento foi encerrado. Esta coluna n�o � populada para classes de evento
												-- iniciais, como SQL:BatchStarting ou SP:Starting. Tamb�m n�o � populada pelo evento Hash Warning.
exec sp_trace_setevent @TraceID, 10, 16, @on	-- Reads: N�mero de leituras l�gicas do disco executadas pelo servidor em nome do evento. 
												-- Esta coluna n�o � populada pelo evento Lock:Released.
exec sp_trace_setevent @TraceID, 10, 17, @on	-- Writes: N�mero de grava��es no disco f�sico executadas pelo servidor em nome do evento.
exec sp_trace_setevent @TraceID, 10, 18, @on	-- CPU: Tempo da CPU (em milissegundos) usado pelo evento.
exec sp_trace_setevent @TraceID, 10, 19, @on	-- CPU: Tempo da CPU (em milissegundos) usado pelo evento.
exec sp_trace_setevent @TraceID, 10, 26, @on	-- ServerName: Nome da inst�ncia do SQL Server, servername ou servername\instancename, 
												-- que est� sendo rastreada
exec sp_trace_setevent @TraceID, 10, 35, @on	-- DatabaseName: Nome do banco de dados especificado na instru��o USE banco de dados.
exec sp_trace_setevent @TraceID, 10, 40, @on	-- DBUserName: Nome de usu�rio do banco de dados do SQL Server do cliente.
exec sp_trace_setevent @TraceID, 10, 48, @on	-- RowCounts: N�mero de linhas no lote.
exec sp_trace_setevent @TraceID, 10, 64, @on	-- SessionLoginName: O nome de logon do usu�rio que originou a sess�o. Por exemplo, se voc� se
												-- conectar ao SQL Server usando Login1 e executar uma instru��o como Login2, SessionLoginName
												-- ir� exibir Login1, enquanto que LoginName exibir� Login2. 
												-- Esta coluna de dados exibe logons tanto do SQL Server, quanto do Windows.

exec sp_trace_setevent @TraceID, 12, 1,  @on	-- TextData: Valor de texto dependente da classe de evento capturada no rastreamento.
exec sp_trace_setevent @TraceID, 12, 6,  @on	-- NTUserName: Nome de usu�rio do Microsoft Windows. 
exec sp_trace_setevent @TraceID, 12, 8,  @on	-- HostName: Nome do computador cliente que originou a solicita��o. 
exec sp_trace_setevent @TraceID, 12, 10, @on	-- ApplicationName: Nome do aplicativo cliente que criou a conex�o com uma inst�ncia do SQL Server. 
												-- Essa coluna � populada com os valores passados pelo aplicativo e n�o com o nome exibido do programa.
exec sp_trace_setevent @TraceID, 12, 11, @on	-- LoginName: Nome de logon do cliente no SQL Server.
exec sp_trace_setevent @TraceID, 12, 12, @on	-- SPID: ID de processo de servidor atribu�da pelo SQL Server ao processo associado ao cliente.
exec sp_trace_setevent @TraceID, 12, 13, @on	-- Duration: Tempo decorrido (em milh�es de segundos) utilizado pelo evento. 
												-- Esta coluna de dados n�o � populada pelo evento Hash Warning.
exec sp_trace_setevent @TraceID, 12, 14, @on	-- StartTime: Hor�rio de in�cio do evento, quando dispon�vel.
exec sp_trace_setevent @TraceID, 12, 15, @on	-- EndTime: Hor�rio em que o evento foi encerrado. Esta coluna n�o � populada para classes de evento
												-- iniciais, como SQL:BatchStarting ou SP:Starting. Tamb�m n�o � populada pelo evento Hash Warning.
exec sp_trace_setevent @TraceID, 12, 16, @on	-- Reads: N�mero de leituras l�gicas do disco executadas pelo servidor em nome do evento. 
												-- Esta coluna n�o � populada pelo evento Lock:Released.
exec sp_trace_setevent @TraceID, 12, 17, @on	-- Writes: N�mero de grava��es no disco f�sico executadas pelo servidor em nome do evento.
exec sp_trace_setevent @TraceID, 12, 18, @on	-- CPU: Tempo da CPU (em milissegundos) usado pelo evento.
exec sp_trace_setevent @TraceID, 12, 26, @on	-- ServerName: Nome da inst�ncia do SQL Server, servername ou servername\instancename, 
												-- que est� sendo rastreada
exec sp_trace_setevent @TraceID, 12, 35, @on	-- DatabaseName: Nome do banco de dados especificado na instru��o USE banco de dados.
exec sp_trace_setevent @TraceID, 12, 40, @on	-- DBUserName: Nome de usu�rio do banco de dados do SQL Server do cliente.
exec sp_trace_setevent @TraceID, 12, 48, @on	-- RowCounts: N�mero de linhas no lote.
exec sp_trace_setevent @TraceID, 12, 64, @on	-- SessionLoginName: O nome de logon do usu�rio que originou a sess�o. Por exemplo, se voc� se conectar
												-- ao SQL Server usando Login1 e executar uma instru��o como Login2, SessionLoginName ir� exibir Login1,
												-- enquanto que LoginName exibir� Login2. 
												-- Esta coluna de dados exibe logons tanto do SQL Server, quanto do Windows.

--	Set the Filters
declare @intfilter int
declare @bigintfilter bigint

exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Server Profiler - 4d8f4bca-f08c-4755-b90c-6ec17a6f1275'
exec sp_trace_setfilter @TraceID, 10, 0, 7, N'DatabaseMail90%'

set @bigintfilter = 3000000 -- 3 segundos
exec sp_trace_setfilter @TraceID, 13, 0, 4, @bigintfilter

set @bigintfilter = null
exec sp_trace_setfilter @TraceID, 13, 0, 1, @bigintfilter

exec sp_trace_setfilter @TraceID, 1, 0, 7, N'NO STATS%'

exec sp_trace_setfilter @TraceID, 1, 0, 7, N'NULL%'

--	Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

--	Display trace id for future references
select TraceID = @TraceID
goto finish

error: 
select ErrorCode=@rc

finish: 
END