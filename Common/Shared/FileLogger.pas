{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit FileLogger;

interface

uses
  System.Classes, System.SysUtils, SyncObjs, Vcl.Forms, WinApi.Windows, System.Types,
  WinApi.Messages, System.Generics.Collections, CustomThread,  Vcl.FileCtrl,
  System.IOUtils, System.DateUtils, Utilities;

const
  LOG_NONE = 0;
  LOG_FATAL = 1;
  LOG_ERROR = 2;
  LOG_WARN = 3;
  LOG_INFO = 4;
  LOG_DEBUG = 5;
  MAX_LOG_FILE_SIZE = 2*1024*1024; //10MB

type
  IScopeLogger = interface
    procedure LogFatal(AValue: String; const AArgs: array of TVarRec);
    procedure LogError(AValue: String; const AArgs: array of TVarRec);
    procedure LogWarn(AValue: String; const AArgs: array of TVarRec);
    procedure LogInfo(AValue: String; const AArgs: array of TVarRec);
    procedure LogDebug(AValue: String; const AArgs: array of TVarRec);
  end;

  TMessageProc = procedure(AValue: String) of Object;
  TFileLogger = class(TCustomThread)
  private
    { Private declarations }
    FIsConsoleApp: Boolean;
    FLogMessageQueue: TQueue<String>;
    FLogLevel: Integer;
    FLogFile: String;
    FLogEvent: THandle;
    FMessageProc: TMessageProc;
    FFileLock: TCriticalSection;
    function RolloverLogs: Byte;
    procedure SetLogLevel(AValue: Integer);
    function GetLogLevel: Integer;
    procedure SetLogFile(AValue: String);
    function GetLogFile: String;
  protected
    class function FormatLogMessage(ALogLevel: Integer; AValue: String): String; overload;
    class function FormatLogMessage(ALogLevel: Integer; AValue: String; const AArgs: array of TVarRec): String; overload;
    function OnBeforeThreadBegin(AWaitTillStarted: Boolean = FALSE): Boolean; override;
    function OnAfterThreadEnd: Boolean; override;
    procedure EnqueueFatal(AValue: String); overload;
    procedure EnqueueFatal(AValue: TStrings); overload;
    procedure EnqueueError(AValue: String); overload;
    procedure EnqueueError(AValue: TStrings); overload;
    procedure EnqueueWarning(AValue: String); overload;
    procedure EnqueueWarning(AValue: TStrings); overload;
    procedure EnqueueInfo(AValue: String); overload;
    procedure EnqueueInfo(AValue: TStrings); overload;
    procedure EnqueueDebug(AValue: String); overload;
    procedure EnqueueDebug(AValue: TStrings); overload;
    procedure WriteFatal(AValue: String); overload;
    procedure WriteError(AValue: String); overload;
    procedure WriteWarning(AValue: String); overload;
    procedure WriteInfo(AValue: String); overload;
    procedure WriteDebug(AValue: String); overload;
    procedure WriteFatal(AValue: TStrings); overload;
    procedure WriteError(AValue: TStrings); overload;
    procedure WriteWarning(AValue: TStrings); overload;
    procedure WriteInfo(AValue: TStrings); overload;
    procedure WriteDebug(AValue: TStrings); overload;
    procedure WriteFatal(AValue: String; const AArgs: array of TVarRec); overload;
    procedure WriteError(AValue: String; const AArgs: array of TVarRec); overload;
    procedure WriteWarning(AValue: String; const AArgs: array of TVarRec); overload;
    procedure WriteInfo(AValue: String; const AArgs: array of TVarRec); overload;
    procedure WriteDebug(AValue: String; const AArgs: array of TVarRec); overload;
    function OnThreadExecute: Boolean; override;
  public
    constructor Create(AMessageProc: TMessageProc = nil); reintroduce;
    destructor Destroy; override;
    function GetCurrentLogContents: TStringList;
    procedure Flush;
    property Loglevel: Integer read GetLogLevel write SetLogLevel;
    property LogFile: String read GetLogFile write SetLogFile;
    class procedure SetFileLogLevel(AValue: Integer; AMessageProc: TMessageProc = nil);
    class function LogLevelString: String;
    class function CurrentLogLevel: Integer;
    class function CurrentLogFile: String;
    class function CurrentLogFileContents: TStringList;
    class function LogLevelToString(ALogLevel: Integer): String;
    class procedure Fatal(AValue: String); overload;
    class procedure Error(AValue: String); overload;
    class procedure Warn(AValue: String); overload;
    class procedure Info(AValue: String); overload;
    class procedure Debug(AValue: String); overload;
    class procedure Fatal(AValue: TStrings); overload;
    class procedure Error(AValue: TStrings); overload;
    class procedure Warn(AValue: TStrings); overload;
    class procedure Info(AValue: TStrings); overload;
    class procedure Debug(AValue: TStrings); overload;
    class procedure Fatal(AValue: String; const AArgs: array of TVarRec); overload;
    class procedure Error(AValue: String; const AArgs: array of TVarRec); overload;
    class procedure Warn(AValue: String; const AArgs: array of TVarRec); overload;
    class procedure Info(AValue: String; const AArgs: array of TVarRec); overload;
    class procedure Debug(AValue: String; const AArgs: array of TVarRec); overload;
    class procedure CloseLog;
    class procedure PurgeLog;
  end;
  TScopeLogger = class(TInterfacedObject, IScopeLogger)
  private
    FLogOnExceptionOnly: Boolean;
    FFatalMessages: TStrings;
    FErrorMessages: TStrings;
    FWarningMessages: TStrings;
    FInfoMessages: TStrings;
    FDebugMessages: TStrings;
  public
    constructor Create(ALogOnExceptionOnly: Boolean = FALSE);
    destructor Destroy; override;
    procedure LogFatal(AValue: String; const AArgs: array of TVarRec);
    procedure LogError(AValue: String; const AArgs: array of TVarRec);
    procedure LogWarn(AValue: String; const AArgs: array of TVarRec);
    procedure LogInfo(AValue: String; const AArgs: array of TVarRec);
    procedure LogDebug(AValue: String; const AArgs: array of TVarRec);
  end;

procedure LogFatal(AValue: String); overload;
procedure LogError(AValue: String); overload;
procedure LogWarn(AValue: String); overload;
procedure LogInfo(AValue: String); overload;
procedure LogDebug(AValue: String); overload;
procedure LogFatal(AValue: TStrings); overload;
procedure LogError(AValue: TStrings); overload;
procedure LogWarn(AValue: TStrings); overload;
procedure LogInfo(AValue: TStrings); overload;
procedure LogDebug(AValue: TStrings); overload;
procedure LogFatal(const AValue: String; const AArgs: array of TVarRec); overload;
procedure LogError(const AValue: String; const AArgs: array of TVarRec); overload;
procedure LogWarn(const AValue: String; const AArgs: array of TVarRec); overload;
procedure LogInfo(const AValue: String; const AArgs: array of TVarRec); overload;
procedure LogDebug(const AValue: String; const AArgs: array of TVarRec); overload;
procedure PurgeLog;


implementation

var
  MyLogThread: TFileLogger = nil;

procedure LogFatal(AValue: String);
begin
  TFileLogger.Fatal(AValue);
end;

procedure LogError(AValue: String);
begin
  TFileLogger.Error(AValue);
end;

procedure LogWarn(AValue: String);
begin
  TFileLogger.Warn(AValue);
end;

procedure LogInfo(AValue: String);
begin
  TFileLogger.Info(AValue);
end;

procedure LogDebug(AValue: String);
begin
  TFileLogger.Debug(AValue);
end;

procedure LogFatal(AValue: TStrings);
begin
  TFileLogger.Fatal(AValue);
end;

procedure LogError(AValue: TStrings);
begin
  TFileLogger.Error(AValue);
end;

procedure LogWarn(AValue: TStrings);
begin
  TFileLogger.Warn(AValue);
end;

procedure LogInfo(AValue: TStrings);
begin
  TFileLogger.Info(AValue);
end;

procedure LogDebug(AValue: TStrings);
begin
  TFileLogger.Debug(AValue);
end;

procedure LogFatal(const AValue: String; const AArgs: array of TVarRec);
begin
  TFileLogger.Fatal(AValue, AArgs);
end;

procedure LogError(const AValue: String; const AArgs: array of TVarRec);
begin
  TFileLogger.Error(AValue, AArgs);
end;

procedure LogWarn(const AValue: String; const AArgs: array of TVarRec);
begin
  TFileLogger.Warn(AValue, AArgs);
end;

procedure LogInfo(const AValue: String; const AArgs: array of TVarRec);
begin
  TFileLogger.Info(AValue, AArgs);
end;

procedure LogDebug(const AValue: String; const AArgs: array of TVarRec);
begin
  TFileLogger.Debug(AValue, AArgs);
end;

procedure PurgeLog;
begin
  TFileLogger.PurgeLog;
end;

{$REGION 'TFileLogger'}
class procedure TFileLogger.SetFileLogLevel(AValue: Integer; AMessageProc: TMessageProc = nil);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create(AMessageProc);
    MyLogThread.Loglevel := AValue;
    MyLogThread.ThreadStart;
  end else
    MyLogThread.Loglevel := AValue;
end;

class function TFileLogger.LogLevelString: String;
begin
  Result := 'UNKNOWN';
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;

  var LLogLevel := MyLogThread.Loglevel;
  case LLogLevel of
    LOG_NONE: Result := 'LOG_NONE';
    LOG_FATAL: Result := 'LOG_FATAL';
    LOG_ERROR: Result := 'LOG_ERROR';
    LOG_WARN: Result := 'LOG_WARN';
    LOG_INFO: Result := 'LOG_INFO';
    LOG_DEBUG: Result := 'LOG_DEBUG';
  end;
end;

class function TFileLogger.CurrentLogLevel: Integer;
begin
  Result := MyLogThread.Loglevel;
end;

class function TFileLogger.CurrentLogFile: String;
begin
  Result := MyLogThread.GetLogFile;
end;

class function TFileLogger.CurrentLogFileContents: TStringList;
begin
  Result := MyLogThread.GetCurrentLogContents;
end;

class function TFileLogger.LogLevelToString(ALogLevel: Integer): String;
begin
  case ALogLevel of
    LOG_NONE: Result := 'LOG_NONE';
    LOG_FATAL: Result := 'LOG_FATAL';
    LOG_ERROR: Result := 'LOG_ERROR';
    LOG_WARN: Result := 'LOG_WARN';
    LOG_INFO: Result := 'LOG_INFO';
    LOG_DEBUG: Result := 'LOG_DEBUG';
  else
    Result := 'INVALID';
  end;
end;

class procedure TFileLogger.Fatal(AValue: String);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteFatal(AValue);
end;

class procedure TFileLogger.Error(AValue: String);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteError(AValue);
end;

class procedure TFileLogger.Warn(AValue: String);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteWarning(AValue);
end;

class procedure TFileLogger.Info(AValue: String);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteInfo(AValue);
end;

class procedure TFileLogger.Debug(AValue: String);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteDebug(AValue);
end;

class procedure TFileLogger.Fatal(AValue: TStrings);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteDebug(AValue);
end;

class procedure TFileLogger.Error(AValue: TStrings);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteDebug(AValue);
end;

class procedure TFileLogger.Warn(AValue: TStrings);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteDebug(AValue);
end;

class procedure TFileLogger.Info(AValue: TStrings);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteDebug(AValue);
end;

class procedure TFileLogger.Debug(AValue: TStrings);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteDebug(AValue);
end;

class procedure TFileLogger.Fatal(AValue: String; const AArgs: array of TVarRec);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteFatal(AValue, AArgs);
end;

class procedure TFileLogger.Error(AValue: String; const AArgs: array of TVarRec);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteError(AValue, AArgs);
end;

class procedure TFileLogger.Warn(AValue: String; const AArgs: array of TVarRec);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteWarning(AValue, AArgs);
end;

class procedure TFileLogger.Info(AValue: String; const AArgs: array of TVarRec);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteInfo(AValue, AArgs);
end;

class procedure TFileLogger.Debug(AValue: String; const AArgs: array of TVarRec);
begin
  if nil = MyLogThread then
  begin
    MyLogThread := TFileLogger.Create;
    MyLogThread.ThreadStart;
  end;
  MyLogThread.WriteDebug(AValue, AArgs);
end;

class procedure TFileLogger.CloseLog;
begin
  if nil = MyLogThread then
  begin
    MyLogThread.ThreadStop(TRUE);
    MyLogThread.Free;
    MyLogThread := nil;
  end;
end;

class procedure TFileLogger.PurgeLog;
begin
  if nil <> MyLogThread then
    MyLogThread.Flush;
end;

constructor TFileLogger.Create(AMessageProc: TMessageProc = nil);
begin
  inherited Create;
  FFileLock := TCriticalSection.Create;
  FMessageProc := AMessageProc;
  FLogLevel := LOG_NONE;
  if not Assigned(FMessageProc) then
  begin
    var LLogFolder := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Log';
    //var LLogFolder := String.Format('%s\Oamaru\WinEvtSvc\Log', [TUtilities.CommonAppDataDir]);
    if not TDirectory.Exists(LLogFolder) then
      TDirectory.CreateDirectory(LLogFolder);

    var LLogFileName := ChangeFileExt(ExtractFileName(Application.ExeName), '.log');
    FLogFile := String.Format('%s\%s', [LLogFolder, LLogFileName]);
  end;
  FLogMessageQueue := TQueue<String>.Create;
end;

destructor TFileLogger.Destroy;
begin
  FLogMessageQueue.Free;
  FFileLock.Free;
  inherited Destroy;
end;

function TFileLogger.RolloverLogs: Byte;
begin
  Result := $00;
  var LLogFolder := ExcludeTrailingPathDelimiter(ExtractFilePath(FLogFile));

  if not TDirectory.Exists(LLogFolder) then
    EXIT;

  if not TFile.Exists(FLogFile) then
    EXIT;

  if (TUtilities.GetFileSize(FlogFile) < MAX_LOG_FILE_SIZE) then
    EXIT
  else
    Result := (Result or $01);

  var LFileList := TDirectory.GetFiles(LLogFolder, '*.log');
  for var i := 0 to (Length(LFileList) - 1)  do
  begin
    var LCreationTime := TFile.GetCreationTime(LFileList[i]);
    var LDaysBetween := DaysBetween(Date, LCreationTime);
    if 7 < LDaysBetween  then
      DeleteFile(PChar(LFileList[i]));
    Result := (Result or $02);
  end;

  var LBaseLogFileName := ChangeFileExt(ExtractFileName(FLogFile), String.Empty);
  var LNewFile := String.Format('%s\%s%s.log', [LLogFolder, LBaseLogFileName, FormatDateTime('YYYYMMDDhhnnsszzz', Now)]);
  MoveFileEx(PChar(FLogFile), PChar(LNewFile), MOVEFILE_REPLACE_EXISTING);
end;

procedure TFileLogger.SetLogLevel(AValue: Integer);
begin
  FLogLevel := AValue;
end;

function TFileLogger.GetLogLevel: Integer;
begin
  Result := FLogLevel;
end;

procedure TFileLogger.SetLogFile(AValue: String);
begin
  Lock;
  try
    FLogFile := AValue;
  finally
    Unlock;
  end;
end;

function TFileLogger.GetLogFile: String;
begin
  Lock;
  try
    Result := FLogFile;
  finally
    Unlock;
  end;
end;

function TFileLogger.OnBeforeThreadBegin(AWaitTillStarted: Boolean = FALSE): Boolean;
begin
  if (inherited OnBeforeThreadBegin) then
  begin
    FLogEvent := CreateEvent( nil, TRUE, FALSE, nil );
    var Stdout := GetStdHandle(Std_Output_Handle);
    Win32Check(Stdout <> Invalid_Handle_Value);
    FIsConsoleApp := Stdout <> 0;
  end;
  Result := TRUE;
end;

function TFileLogger.OnAfterThreadEnd: Boolean;
begin
  CloseHandle(FLogEvent);
  Result := inherited OnAfterThreadEnd();
end;

class function TFileLogger.FormatLogMessage(ALogLevel: Integer; AValue: String): String;
begin
  case ALogLevel of
  LOG_FATAL: Result := FormatDateTime('YYYY-MMM-DD hh:nn:ss.zzz', Now) + ' ' + Format('[0x%.8x]', [GetCurrentThreadId]) + ' FATAL - ' + AValue;
  LOG_ERROR: Result := FormatDateTime('YYYY-MMM-DD hh:nn:ss.zzz', Now) + ' ' + Format('[0x%.8x]', [GetCurrentThreadId]) + ' ERROR - ' + AValue;
  LOG_WARN : Result := FormatDateTime('YYYY-MMM-DD hh:nn:ss.zzz', Now) + ' ' + Format('[0x%.8x]', [GetCurrentThreadId]) + ' WARN  - ' + AValue;
  LOG_INFO : Result := FormatDateTime('YYYY-MMM-DD hh:nn:ss.zzz', Now) + ' ' + Format('[0x%.8x]', [GetCurrentThreadId]) + ' INFO  - ' + AValue;
  LOG_DEBUG: Result := FormatDateTime('YYYY-MMM-DD hh:nn:ss.zzz', Now) + ' ' + Format('[0x%.8x]', [GetCurrentThreadId]) + ' DEBUG - ' + AValue;
  end;
end;

class function  TFileLogger.FormatLogMessage(ALogLevel: Integer; AValue: String; const AArgs: array of TVarRec): String;
begin
  case ALogLevel of
  LOG_FATAL: Result := FormatDateTime('YYYY-MMM-DD hh:nn:ss.zzz', Now) + ' ' + Format('[0x%.8x]', [GetCurrentThreadId]) + ' FATAL - ' + String.Format(AValue, AArgs);
  LOG_ERROR: Result := FormatDateTime('YYYY-MMM-DD hh:nn:ss.zzz', Now) + ' ' + Format('[0x%.8x]', [GetCurrentThreadId]) + ' ERROR - ' + String.Format(AValue, AArgs);
  LOG_WARN : Result := FormatDateTime('YYYY-MMM-DD hh:nn:ss.zzz', Now) + ' ' + Format('[0x%.8x]', [GetCurrentThreadId]) + ' WARN  - ' + String.Format(AValue, AArgs);
  LOG_INFO : Result := FormatDateTime('YYYY-MMM-DD hh:nn:ss.zzz', Now) + ' ' + Format('[0x%.8x]', [GetCurrentThreadId]) + ' INFO  - ' + String.Format(AValue, AArgs);
  LOG_DEBUG: Result := FormatDateTime('YYYY-MMM-DD hh:nn:ss.zzz', Now) + ' ' + Format('[0x%.8x]', [GetCurrentThreadId]) + ' DEBUG - ' + String.Format(AValue, AArgs);
  end;
end;

procedure TFileLogger.EnqueueFatal(AValue: String);
begin
  if FLogLevel < LOG_FATAL then
    EXIT;
  Lock;
  try
    FLogMessageQueue.Enqueue(AValue);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.EnqueueFatal(AValue: TStrings);
begin
  if FLogLevel < LOG_FATAL then
    EXIT;
  Lock;
  try
    for var LMsg in AValue do
      FLogMessageQueue.Enqueue(LMsg);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.EnqueueError(AValue: String);
begin
  if FLogLevel < LOG_ERROR then
    EXIT;
  Lock;
  try
    FLogMessageQueue.Enqueue(AValue);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.EnqueueError(AValue: TStrings);
begin
  if FLogLevel < LOG_ERROR then
    EXIT;
  Lock;
  try
    for var LMsg in AValue do
      FLogMessageQueue.Enqueue(LMsg);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.EnqueueWarning(AValue: String);
begin
  if FLogLevel < LOG_WARN then
    EXIT;
  Lock;
  try
    FLogMessageQueue.Enqueue(AValue);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.EnqueueWarning(AValue: TStrings);
begin
  if FLogLevel < LOG_WARN then
    EXIT;
  Lock;
  try
    for var LMsg in AValue do
      FLogMessageQueue.Enqueue(LMsg);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.EnqueueInfo(AValue: String);
begin
  if FLogLevel < LOG_INFO then
    EXIT;
  Lock;
  try
    FLogMessageQueue.Enqueue(AValue);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.EnqueueInfo(AValue: TStrings);
begin
  if FLogLevel < LOG_INFO then
    EXIT;
  Lock;
  try
    for var LMsg in AValue do
      FLogMessageQueue.Enqueue(LMsg);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.EnqueueDebug(AValue: String);
begin
  if FLogLevel < LOG_DEBUG then
    EXIT;
  Lock;
  try
    for var LMsg in AValue do
      FLogMessageQueue.Enqueue(LMsg);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.EnqueueDebug(AValue: TStrings);
begin
  if FLogLevel < LOG_DEBUG then
    EXIT;
  Lock;
  try
    for var LMsg in AValue do
      FLogMessageQueue.Enqueue(LMsg);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteFatal(AValue: String);
begin
  if FLogLevel < LOG_FATAL then
    EXIT;

  var LLogMessage := FormatLogMessage(LOG_FATAL, AValue);
  Lock;
  try
    FLogMessageQueue.Enqueue(LLogMessage);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteError(AValue: String);
begin
  if FLogLevel < LOG_ERROR then
    EXIT;

  var LLogMessage := FormatLogMessage(LOG_ERROR, AValue);
  Lock;
  try
    FLogMessageQueue.Enqueue(LLogMessage);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteWarning(AValue: String);
begin
  if FLogLevel < LOG_WARN then
    EXIT;

  var LLogMessage := FormatLogMessage(LOG_WARN, AValue);
  Lock;
  try
    FLogMessageQueue.Enqueue(LLogMessage);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteInfo(AValue: String);
begin
  if FLogLevel < LOG_INFO then
    EXIT;

  var LLogMessage := FormatLogMessage(LOG_INFO, AValue);
  Lock;
  try
    FLogMessageQueue.Enqueue(LLogMessage);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteDebug(AValue: String);
begin
  if FLogLevel < LOG_DEBUG then
    EXIT;

  var LLogMessage := FormatLogMessage(LOG_DEBUG, AValue);
  Lock;
  try
    FLogMessageQueue.Enqueue(LLogMessage);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteFatal(AValue: TStrings);
var
  LLogMessage: String;
  i: Integer;
begin
  if FLogLevel < LOG_FATAL then
    EXIT;
  Lock;
  try
    for i := 0 to (AValue.Count - 1) do
    begin
      LLogMessage := FormatLogMessage(LOG_FATAL, AValue[i]);
      FLogMessageQueue.Enqueue(LLogMessage);
    end;
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteError(AValue: TStrings);
begin
  if FLogLevel < LOG_ERROR then
    EXIT;
  Lock;
  try
    for var i := 0 to (AValue.Count - 1) do
    begin
      var LLogMessage := FormatLogMessage(LOG_ERROR, AValue[i]);
      FLogMessageQueue.Enqueue(LLogMessage);
    end;
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteWarning(AValue: TStrings);
begin
  if FLogLevel < LOG_WARN then
    EXIT;
  Lock;
  try
    for var i := 0 to (AValue.Count - 1) do
    begin
      var LLogMessage := FormatLogMessage(LOG_WARN, AValue[i]);
      FLogMessageQueue.Enqueue(LLogMessage);
    end;
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteInfo(AValue: TStrings);
begin
  if FLogLevel < LOG_INFO then
    EXIT;
  Lock;
  try
    for var i := 0 to (AValue.Count - 1) do
    begin
      var LLogMessage := FormatLogMessage(LOG_INFO, AValue[i]);
      FLogMessageQueue.Enqueue(LLogMessage);
    end;
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteDebug(AValue: TStrings);
begin
  if FLogLevel < LOG_DEBUG then
    EXIT;
  Lock;
  try
    for var i := 0 to (AValue.Count - 1) do
    begin
      var LLogMessage := FormatLogMessage(LOG_DEBUG, AValue[i]);
      FLogMessageQueue.Enqueue(LLogMessage);
    end;
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteFatal(AValue: String; const AArgs: array of TVarRec);
begin
  if FLogLevel < LOG_FATAL then
    EXIT;

  var LLogMessage := FormatLogMessage(LOG_FATAL, AValue, AArgs);
  Lock;
  try
    FLogMessageQueue.Enqueue(LLogMessage);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteError(AValue: String; const AArgs: array of TVarRec);
begin
  if FLogLevel < LOG_ERROR then
    EXIT;

  var LLogMessage := FormatLogMessage(LOG_ERROR, AValue, AArgs);
  Lock;
  try
    FLogMessageQueue.Enqueue(LLogMessage);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteWarning(AValue: String; const AArgs: array of TVarRec);
begin
  if FLogLevel < LOG_WARN then
    EXIT;

  var LLogMessage := FormatLogMessage(LOG_WARN, AValue, AArgs);
  Lock;
  try
    FLogMessageQueue.Enqueue(LLogMessage);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteInfo(AValue: String; const AArgs: array of TVarRec);
begin
  if FLogLevel < LOG_INFO then
    EXIT;

  var LLogMessage := FormatLogMessage(LOG_INFO, AValue, AArgs);
  Lock;
  try
    FLogMessageQueue.Enqueue(LLogMessage);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

procedure TFileLogger.WriteDebug(AValue: String; const AArgs: array of TVarRec);
begin
  if FLogLevel < LOG_DEBUG then
    EXIT;

  var LLogMessage := FormatLogMessage(LOG_DEBUG, AValue, AArgs);
  Lock;
  try
    FLogMessageQueue.Enqueue(LLogMessage);
    SetEvent(FLogEvent);
  finally
    Unlock;
  end;
end;

function TFileLogger.GetCurrentLogContents: TStringList;
begin
  Result := TStringList.Create;
  FFileLock.Acquire;
  try
    Result.LoadFromFile(FLogFile);
  finally
    FFileLock.Release;
  end;
end;

procedure TFileLogger.Flush;
const
  UnicodeBOM: array[0..1] of Byte = ($FF, $FE);
begin
  //Do an A <-> B Swap to minimise lock time
  var LQueue: TQueue<String>;
  var LTemp := TQueue<String>.Create;
  Lock;
  try
    LQueue := FLogMessageQueue;
    FLogMessageQueue := LTemp;
  finally
    Unlock;
  end;


  if Assigned(FMessageProc) then
  begin
    while LQueue.Count > 0 do
    begin
      var LLogMessage := LQueue.Dequeue;
      if IsConsole then
         WriteLn(Output, LLogMessage);
      if Assigned(FMessageProc) then
        FMessageProc(LLogMessage);
    end;
  end else
  begin
    var LRolledOver: Byte := 0;
    FFileLock.Acquire;
    try
      try
        LRolledOver := RolloverLogs;
      except
      end;
      if IsConsole then
      begin
        for var LMsg in  LQueue do
          WriteLn(Output, LMsg);
      end;

      var LFlags := fmOpenReadWrite;
      if not FileExists(FLogFile) then
        LFlags := fmCreate;

      var LFS : TFileStream;
      LFS := TFileStream.Create(FLogFile, LFlags, fmShareDenyWrite);
      try
        LFS.Position := LFS.Size;
        if (0 = LFS.Position) then
          LFS.Write(UnicodeBOM, Sizeof(UnicodeBOM));

        if 0 <> LRolledOver then
        begin
          if ($01 = (LRolledOver and $01)) then
          begin
            var LRolledOverMsg := FormatLogMessage(LOG_INFO, 'Log Rolled Over. File Size Exceded') + #13#10;
            LFS.Write(LRolledOverMsg[1], LRolledOverMsg.Length * SizeOf(Char));
          end;
          if ($02 = (LRolledOver and $01)) then
          begin
            var LRolledOverMsg := FormatLogMessage(LOG_INFO, 'At least one log file aged out') + #13#10;
            LFS.Write(LRolledOverMsg[1], LRolledOverMsg.Length * SizeOf(Char));
          end;
        end;

        while LQueue.Count > 0 do
        begin
          var LLogMessage := LQueue.Dequeue  + #13#10;
          LFS.Write(LLogMessage[1], LLogMessage.Length * SizeOf(Char));
        end;
      finally
        LFS.Free;
      end;
    finally
      FFileLock.Release;
    end;
  end;
  LQueue.Free;
end;

function TFileLogger.OnThreadExecute: Boolean;
var
  LWaitObject: Cardinal;
  LEvents: array[0..1] of THandle;
begin
  Result := TRUE;
  LEvents[0] := FShouldFinishEvent;
  LEvents[1] := FLogEvent;
  while (not Terminated) do
  begin
    LWaitObject := WaitForMultipleObjects(2, @LEvents, FALSE, INFINITE);
    case (LWaitObject - WAIT_OBJECT_0) of
      0:begin
        Self.Info('Queue Processor Received Should Finish Event');
        BREAK;
      end;
      1:begin
        ResetEvent(FLogEvent);
        try
          Flush;
        except
          On E:Exception do
          begin
            Result := FALSE;
            WriteLn(String.Format('Exception In Log processing: %s', [E.Message]));
          end;
        end;
      end;
    end;
  end;
  try
    Flush;
  except
    On E:Exception do
    begin
      Result := FALSE;
      WriteLn(String.Format('Exception In Log processing: %s', [E.Message]));
    end;
  end;
  SetEvent(FFinishedEvent);
end;
{$ENDREGION}

{$REGION 'TScopeLogger'}
constructor TScopeLogger.Create(ALogOnExceptionOnly: Boolean = FALSE);
begin
  inherited Create;
  FLogOnExceptionOnly := ALogOnExceptionOnly;
  FFatalMessages := TStringList.Create;
  FErrorMessages := TStringList.Create;
  FWarningMessages := TStringList.Create;
  FInfoMessages := TStringList.Create;
  FDebugMessages := TStringList.Create;
end;

destructor TScopeLogger.Destroy;
begin
  var LShouldLog := TRUE;
  if FLogOnExceptionOnly then
  begin
     if nil <> AcquireExceptionObject then
     begin
      //Exceptions are also reference counted
      //So we must relase if we managed to aquire it.
      ReleaseExceptionObject;
     end else
       LShouldLog := FALSE;
  end;

  if LShouldLog then
  begin
    if nil = MyLogThread then
    begin
      MyLogThread := TFileLogger.Create;
      MyLogThread.ThreadStart;
    end;
    MyLogThread.EnqueueFatal(FFatalMessages);
    MyLogThread.EnqueueError(FErrorMessages);
    MyLogThread.EnqueueWarning(FWarningMessages);
    MyLogThread.EnqueueInfo(FInfoMessages);
    MyLogThread.EnqueueDebug(FDebugMessages);
  end;

  FDebugMessages.Free;
  FInfoMessages.Free;
  FWarningMessages.Free;
  FErrorMessages.Free;
  FFatalMessages.Free;
  inherited Destroy;
end;


procedure TScopeLogger.LogFatal(AValue: String; const AArgs: array of TVarRec);
begin
  if 0 <> Length(AArgs)then
    FFatalMessages.Add(TFileLogger.FormatLogMessage(LOG_FATAL, AValue))
  else
    FFatalMessages.Add(TFileLogger.FormatLogMessage(LOG_FATAL, AValue, AArgs));
end;

procedure TScopeLogger.LogError(AValue: String; const AArgs: array of TVarRec);
begin
  if 0 <> Length(AArgs)then
    FErrorMessages.Add(TFileLogger.FormatLogMessage(LOG_ERROR, AValue))
  else
    FErrorMessages.Add(TFileLogger.FormatLogMessage(LOG_ERROR, AValue, AArgs));
end;

procedure TScopeLogger.LogWarn(AValue: String; const AArgs: array of TVarRec);
begin
  if 0 <> Length(AArgs)then
    FWarningMessages.Add(TFileLogger.FormatLogMessage(LOG_WARN, AValue))
  else
    FWarningMessages.Add(TFileLogger.FormatLogMessage(LOG_WARN, AValue, AArgs));
end;

procedure TScopeLogger.LogInfo(AValue: String; const AArgs: array of TVarRec);
begin
  if 0 <> Length(AArgs)then
    FInfoMessages.Add(TFileLogger.FormatLogMessage(LOG_INFO, AValue))
  else
    FInfoMessages.Add(TFileLogger.FormatLogMessage(LOG_INFO, AValue, AArgs));
end;

procedure TScopeLogger.LogDebug(AValue: String; const AArgs: array of TVarRec);
begin
  if 0 <> Length(AArgs)then
    FDebugMessages.Add(TFileLogger.FormatLogMessage(LOG_DEBUG, AValue))
  else
    FDebugMessages.Add(TFileLogger.FormatLogMessage(LOG_DEBUG, AValue, AArgs));
end;
{$ENDREGION}

end.
