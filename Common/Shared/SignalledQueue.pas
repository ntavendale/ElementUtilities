{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit SignalledQueue;

interface

uses
  System.Classes, System.SysUtils, WinApi.Windows, WinApi.Messages,
  System.SyncObjs, System.Generics.Collections, LockableObject;

type
  TSignalledQueue<T> = class(TLockableobject)
    private
      { Private declarations }
      function GetCapacity: Integer;
      function GetCount: Integer;
    protected
      { Protected declarations }
      FQueue: TQueue<T>;
      FEvent: THandle;
    public
      { Public declarations }
      constructor Create; override;
      destructor Destroy; override;
      procedure Enqueue(const Value: T);
      procedure EnqueueBatch(const AValue: TList<T>);
      function Dequeue: T;
      function DequeueAll: TList<T>;
      function GetAll: TQueue<T>;
      function Extract: T;
      function Peek: T;
      procedure Clear;
      procedure TrimExcess;
      property QueueEvent: THandle read FEvent;
      property Capacity: Integer read GetCapacity;
      property Count: Integer read GetCount;
  end;

implementation

constructor TSignalledQueue<T>.Create;
begin
  inherited Create;
  FEvent := CreateEvent(nil, TRUE, FALSE, nil);
  FQueue := TQueue<T>.Create;
end;

destructor TSignalledQueue<T>.Destroy;
begin
  FQueue.Free;
  CloseHandle(FEvent);
  inherited Destroy;
end;

function TSignalledQueue<T>.GetCapacity: Integer;
begin
  Lock;
  try
    Result := FQueue.Capacity;
  finally
    Unlock;
  end;
end;

function TSignalledQueue<T>.GetCount: Integer;
begin
  Lock;
  try
    Result := FQueue.Count;
  finally
    Unlock;
  end;
end;

procedure TSignalledQueue<T>.Enqueue(const Value: T);
begin
  Lock;
  try
    FQueue.Enqueue(Value);
    SetEvent(FEvent);
  finally
    Unlock;
  end;
end;

procedure TSignalledQueue<T>.EnqueueBatch(const AValue: TList<T>);
var
  i: Integer;
begin
  Lock;
  try
    for i := 0 to (AValue.Count - 1) do
      FQueue.Enqueue(AValue[i]);
    SetEvent(FEvent);
  finally
    Unlock;
  end;
end;

function TSignalledQueue<T>.Dequeue: T;
begin
  Lock;
  try
    Result := FQueue.Dequeue;
    if 0 = FQueue.Count then
      ResetEvent(FEvent);
  finally
    Unlock;
  end;
end;

function TSignalledQueue<T>.DequeueAll: TList<T>;
begin
  Result := TList<T>.Create;
  Lock;
  try
    while 0 <> FQueue.Count do
      Result.Add(FQueue.Dequeue);
    ResetEvent(FEvent);
  finally
    Unlock;
  end;
  if 0 = Result.Count then
  begin
    Result.Free;
    Result := nil;
  end;
end;

function TSignalledQueue<T>.GetAll: TQueue<T>;
var
  LTemp: TQueue<T>;
begin
  LTemp := TQueue<T>.Create;
  Lock;
  try
    Result := FQueue;
    FQueue := LTemp;
  finally
    Unlock;
  end;
end;

function TSignalledQueue<T>.Extract: T;
begin
  Lock;
  try
    Result := FQueue.Extract;
    if 0 = FQueue.Count then
      ResetEvent(FEvent);
  finally
    Unlock;
  end;
end;

function TSignalledQueue<T>.Peek: T;
begin
  Lock;
  try
    Result := FQueue.Peek;
  finally
    Unlock;
  end;
end;

procedure TSignalledQueue<T>.Clear;
begin
  Lock;
  try
    FQueue.Clear;
  finally
    Unlock;
  end;
end;

procedure TSignalledQueue<T>.TrimExcess;
begin
  Lock;
  try
    FQueue.TrimExcess;
  finally
    Unlock;
  end;
end;

end.
