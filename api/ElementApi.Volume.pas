{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit ElementApi.Volume;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  ElementApi.Link;

const
  API_VOLUME_PATH = 'api/volumes';

type
  TNAS = class
  protected
    FPath: String;
    FUnixGroupID: Integer;
    FUnixUserID: Integer;
    FUnixPermissions: String;
    procedure Init;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(ANAS: TNAS); overload; virtual;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Path: String read FPAth write FPAth;
    property UnixGroupID: Integer read FUnixGroupID write FUnixGroupID;
    property UnixUserID: Integer read FUnixUserID write FUnixUserID;
    property UnixPermissions: String read FUnixPermissions write FUnixPermissions;
    property AsJson: String read ToJson write FromJson;
  end;

  TLogicalSpace = class
  protected
    FAvailable: UInt64;
    FUsedByAFS: UInt64;
    procedure Init;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(ALogicalSpace: TLogicalSpace); overload; virtual;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Available: UInt64 read FAvailable write FAvailable;
    property UsedByAFS: UInt64 read FUsedByAFS write FUsedByAFS;
    property AsJson: String read ToJson write FromJson;
  end;

  TSnapshot = class
  protected
    FUsed: UInt64;
    FReservedPct: Integer;
    procedure Init;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(ASnapshot: TSnapshot); overload; virtual;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Used: UInt64 read FUsed write FUsed;
    property ReservedPct: Integer read FReservedPct write FReservedPct;
    property AsJson: String read ToJson write FromJson;
  end;

  TVolume = class
  protected
    FLinks: TLinks;
    FNAS: TNAS;
    FLogicalSpace: TLogicalSpace;
    FSnapshot: TSnapshot;
  public
    property Links: TLinks read FLinks;
    property FNA: TNAS read FNAS;
    property LogicalSpace: TLogicalSpace read FLogicalSpace;
    property Snapshot: TSnapshot read FSnapshot;
  end;

implementation

{$REGION 'TNAS'}
constructor TNAS.Create;
begin
  inherited Create;
  Init;
end;

constructor TNAS.Create(AJSON: String);
begin
  inherited Create;
  FromJson(AJSON);
end;

constructor TNAS.Create(ANAS: TNAS);
begin
  inherited Create;
  FPath := ANAS.Path;
  FUnixGroupID := ANAS.UnixGroupID;
  FUnixUserID := ANAS.UnixUserID;
  FUnixPermissions := ANAS.UnixPermissions;
end;

procedure TNAS.Init;
begin
  FPath := String.Empty;
  FUnixGroupID := 0;
  FUnixUserID := 0;
  FUnixPermissions := '0775';
end;

function TNAS.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TNAS.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TNAS.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('path', FPath);
  Result.AddPair('gid', TJSONNumber.Create(FUnixGroupID));
  Result.AddPair('uid', TJSONNumber.Create(FUnixUserID));
  Result.AddPair('unixPermissions', FUnixPermissions);
end;

procedure TNAS.FromJsonObject(AJSONObject: TJSONObject);
begin
  Init;
  if nil <> AJSONObject.Values['path'] then
    FPath := AJSONObject.Values['path'].Value;
  if nil <> AJsonObject.Values['gid'] then
    FUnixGroupID := StrToIntDef(AJsonObject.Values['gid'].Value, 0);
  if nil <> AJsonObject.Values['gid'] then
    FUnixUserID := StrToIntDef(AJsonObject.Values['uid'].Value, 0);
  if nil <> AJsonObject.Values['unixPermissions'] then
    FUnixPermissions := AJsonObject.Values['unixPermissions'].Value;
end;
{$ENDREGION}

{$REGION 'TLogicalSpace'}
constructor TLogicalSpace.Create;
begin
  inherited Create;
  Init;
end;

constructor TLogicalSpace.Create(AJSON: String);
begin
  inherited Create;
  FromJSON(AJSON);
end;

constructor TLogicalSpace.Create(ALogicalSpace: TLogicalSpace);
begin
  inherited Create;
  FAvailable := ALogicalSpace.Available;
  FUsedByAFS := ALogicalSpace.UsedByAFS;
end;

procedure TLogicalSpace.Init;
begin
  FAvailable := 0;
  FUsedByAFS := 0;
end;

function TLogicalSpace.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TLogicalSpace.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TLogicalSpace.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('available', TJSONNUmber.Create(FAvailable));
  Result.AddPair('usedByAfs', TJSONNUmber.Create(FUsedByAFS));
end;

procedure TLogicalSpace.FromJsonObject(AJSONObject: TJSONObject);
begin
  Init;
  if nil <> AJsonObject.Values['available'] then
    FAvailable := StrToUInt64Def(AJsonObject.Values['available'].Value, 0);
  if nil <> AJsonObject.Values['usedByAfs'] then
    FUsedByAfs := StrToUInt64Def(AJsonObject.Values['usedByAfs'].Value, 0);
end;
{$ENDREGION}

{$REGION 'TSnapshot'}
constructor TSnapshot.Create;
begin
  inherited Create;
  Init;
end;

constructor TSnapshot.Create(AJSON: String);
begin
  inherited Create;
  FromJson(AJSON);
end;

constructor TSnapshot.Create(ASnapshot: TSnapshot);
begin
  inherited Create;
  FUsed := ASnapshot.Used;
  ReservedPct := ASnapshot.ReservedPct;
end;

procedure TSnapshot.Init;
begin
  FUsed := 0;
  FReservedPct := 5;
end;

function TSnapshot.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TSnapshot.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TSnapshot.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('used', TJSONNUmber.Create(FUsed));
  Result.AddPair('reservedPercent', TJSONNUmber.Create(FReservedPct));
end;

procedure TSnapshot.FromJsonObject(AJSONObject: TJSONObject);
begin
  Init;
  if nil <> AJsonObject.Values['used'] then
    FUsed := StrToUInt64Def(AJsonObject.Values['used'].Value, 0);
  if nil <> AJsonObject.Values['reservedPercent'] then
    FReservedPct := StrToIntDef(AJsonObject.Values['reservedPercent'].Value, 5);
end;
{$ENDREGION}

end.
