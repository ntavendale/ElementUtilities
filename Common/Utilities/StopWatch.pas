{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit StopWatch;

interface

uses
  System.Classes, System.SysUtils, WinApi.Windows, WinApi.Messages;

type
  THiResStopWatch = record
  private
    class var FTicksPerSecond: TLargeInteger;
    FStartTicks: TLargeInteger;
    FStopTicks: TLargeInteger;
    function GetElapsedSeconds: Double;
    function GetElapsedMilliseconds: Double;
    function GetElapsedMicroseconds: Double;
  public
    class function Create: THiResStopWatch; static;
    class function CreateNew: THiResStopWatch; static;
    procedure Start;
    procedure Stop;
    property ElapsedSeconds: Double read GetElapsedSeconds;
    property ElapsedMilliseconds: Double read GetElapsedMilliseconds;
    property ElapsedMicroseconds: Double read GetElapsedMicroseconds;
end;

implementation

class function THiResStopWatch.Create: THiResStopWatch;
begin
  QueryPerformanceFrequency(FTicksPerSecond);
  FStartTicks := 0;
  FStopTicks := 0;
end;

class function THiResStopWatch.CreateNew: THiResStopWatch;
begin
  Result := THiResStopWatch.Create;
  Result.Start;
end;

function THiResStopWatch.GetElapsedSeconds: Double;
begin
  Result := (FStopTicks - FStartTicks) / FTicksPerSecond;
end;

function THiResStopWatch.GetElapsedMilliseconds: Double;
begin
  Result := 1000 * ((FStopTicks - FStartTicks) / FTicksPerSecond);
end;

function THiResStopWatch.GetElapsedMicroseconds: Double;
begin
  Result := 1000000 * ((FStopTicks - FStartTicks) / FTicksPerSecond);
end;

procedure THiResStopWatch.Start;
begin
  FStopTicks := 0;
  QueryPerformanceCounter(FStartTicks);
end;

procedure THiResStopWatch.Stop;
begin
  QueryPerformanceCounter(FStopTicks);
end;


end.
