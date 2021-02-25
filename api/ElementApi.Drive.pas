{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit ElementApi.Drive;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  ElementApi.Link;

const
  API_DRIVE_PATH = 'api/cluster/drives';

type
  TDriveNodeInfo = class
  protected
    FLinks: TLinks;
    FNodeID: Integer;
    FUUID: String;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(ADriveNodeInfo: TDriveNodeInfo); overload; virtual;
    destructor Destroy; override;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Links: TLinks read FLinks;
    property NodeID: Integer read FNodeID write FNodeID;
    property UUID: String read FUUID write FUUID;
    property AsJson: String read ToJson write FromJson;
  end;

  TDriveCapacity = class
  protected
    FRaw: NativeUInt;
    FUsable: NativeUInt;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(ADriveCapacity: TDriveCapacity); overload; virtual;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Raw: NativeUInt read FRaw write FRaw;
    property Usable: NativeUInt read FUsable write FUsable;
    property AsJson: String read ToJson write FromJson;
  end;

  TDriveDetail = class
  protected
    FCapacity: TDriveCapacity;
    FDriveFailureDetail: String;
    FEncryptionCapable: Boolean;
    FFWVersion: String;
    FModel: String;
    FName: String;
    FNode: TDriveNodeInfo;
    FSerialNumber: String;
    FSlot: Integer;
    FState: String;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(ADriveDetail: TDriveDetail); overload; virtual;
    destructor Destroy; override;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Capacity: TDriveCapacity read FCapacity;
    property DriveFailureDetail: String read FDriveFailureDetail write FDriveFailureDetail;
    property EncryptionCapable: Boolean read FEncryptionCapable write FEncryptionCapable;
    property FirmwareVersion: String read FFWVersion write FFWVersion;
    property Model: String read FModel write FModel;
    property Name: String read FName write FName;
    property Node: TDriveNodeInfo read FNode;
    property SerialNumber: String read FSerialNumber write FSerialNumber;
    property Slot: Integer read FSlot write FSlot;
    property State: String read FState write FState;
    property AsJson: String read ToJson write FromJson;
  end;

  TDriveInfo = class
  protected
    FLInks: TLinks;
    FDetail: TDriveDetail;
    FUUID: String;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(ADriveInfo: TDriveInfo); overload; virtual;
    destructor Destroy; override;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Links: TLinks read FLinks;
    property DriveDetail: TDriveDetail read FDetail;
    property UUID: String read FUUID write FUUID;
    property AsJson: String read ToJson write FromJson;
  end;

  TDriveInfoList = class
  protected
    FLIst: TObjectList<TDriveInfo>;
    function GetCount: Integer;
    function GetListItem(AIndex: Integer): TDriveInfo;
    procedure SetListItem(AIndex: Integer; AValue: TDriveInfo);
    function EncodeToJSONArrayString: String;
    procedure DecodeFromJSONArrayString(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSONString: String); overload; virtual;
    constructor Create(ADriveInfoList: TDriveInfoList); overload; virtual;
    destructor Destroy; override;
    function ToJSONArray: TJSONArray;
    procedure FromJSONArray(AJsonArray: TJSONArray);
    procedure Add(AValue: TDriveInfo);
    procedure Delete(AIndex: Integer);
    procedure Clear;
    property Count: Integer read GetCount;
    property DriveInfo[AIndex: Integer]: TDriveInfo read GetListItem write SetListItem; default;
    property AsJSONArray: String read EncodeToJSONArrayString write DecodeFromJSONArrayString;
  end;

implementation

{$REGION 'TDriveNodeInfo'}
constructor TDriveNodeInfo.Create;
begin
  inherited Create;
  FLinks := TLinks.Create;
end;

constructor TDriveNodeInfo.Create(AJSON: String);
begin
  inherited Create;
  FLinks := TLinks.Create;
  FromJson(AJSON);
end;

constructor TDriveNodeInfo.Create(ADriveNodeInfo: TDriveNodeInfo);
begin
  inherited Create;
  FLinks := TLinks.Create(ADriveNodeInfo.Links);
  FNodeID := ADriveNodeInfo.NodeID;
  FUUID := ADriveNodeInfo.UUID;
end;

destructor TDriveNodeInfo.Destroy;
begin
  FLinks.Free;
  inherited Destroy;
end;

function TDriveNodeInfo.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TDriveNodeInfo.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TDriveNodeInfo.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('_links', FLinks.ToJsonObject);
  Result.AddPair('id', TJSONNumber.Create(FNodeID));
  Result.AddPair('uuid', FUUID);
end;

procedure TDriveNodeInfo.FromJsonObject(AJSONObject: TJSONObject);
begin
  FLinks.Clear;
  FNodeID := -1;
  FUUID := String.Empty;

  if nil <> AJSONObject.Values['_links'] then
    FLinks.FromJsonObject(AJSONObject.Values['_links'] as TJSONObject);
  if nil <> AJsonObject.Values['id'] then
    FNodeID := StrToIntDef(AJsonObject.Values['id'].Value, -1);
  if nil <> AJsonObject.Values['uuid'] then
    FUUID := AJsonObject.Values['uuid'].Value;
end;
{$ENDREGION}

{$REGION 'TDriveCapacity'}
constructor TDriveCapacity.Create;
begin
  inherited Create;
  FRaw := 0;
  FUsable := 0;
end;

constructor TDriveCapacity.Create(AJSON: String);
begin
  inherited Create;
  FRaw := 0;
  FUsable := 0;
  FromJson(AJSON);
end;

constructor TDriveCapacity.Create(ADriveCapacity: TDriveCapacity);
begin
  inherited Create;
  FRaw := ADriveCapacity.Raw;
  FUsable := ADriveCapacity.Usable;
end;

function TDriveCapacity.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TDriveCapacity.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TDriveCapacity.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('raw', TJSONNumber.Create(FRaw));
  Result.AddPair('usable', TJSONNumber.Create(FUsable));
end;

procedure TDriveCapacity.FromJsonObject(AJSONObject: TJSONObject);
begin
  FRaw := 0;
  FUsable := 0;

  if nil <> AJsonObject.Values['raw'] then
    FRaw := StrToUInt64Def(AJsonObject.Values['raw'].Value, 0);

  if nil <> AJsonObject.Values['usable'] then
    FUsable := StrToUInt64Def(AJsonObject.Values['usable'].Value, 0);
end;
{$ENDREGION}

{$REGION 'TDriveDetail'}
constructor TDriveDetail.Create;
begin
  inherited Create;
  FCapacity := TDriveCapacity.Create;
  FNode := TDriveNodeInfo.Create;
end;

constructor TDriveDetail.Create(AJSON: String);
begin
  inherited Create;
  FCapacity := TDriveCapacity.Create;
  FNode := TDriveNodeInfo.Create;
  FromJson(AJSON);
end;

constructor TDriveDetail.Create(ADriveDetail: TDriveDetail);
begin
  inherited Create;
  FCapacity := TDriveCapacity.Create(ADriveDetail.Capacity);
  FDriveFailureDetail := ADriveDetail.DriveFailureDetail;
  FEncryptionCapable := ADriveDetail.EncryptionCapable;
  FFWVersion := ADriveDetail.FirmwareVersion;
  FModel := ADriveDetail.Model;
  FName := ADriveDetail.Name;
  FNode := TDriveNodeInfo.Create(ADriveDetail.Node);
  FSerialNumber := ADriveDetail.SerialNumber;
  FSlot := ADriveDetail.Slot;
  FState := ADriveDetail.State;
end;

destructor TDriveDetail.Destroy;
begin
  FCapacity.Free;
  inherited Destroy;
end;

function TDriveDetail.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TDriveDetail.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TDriveDetail.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('capacity', FCapacity.ToJsonObject);
  Result.AddPair('driveFailureDetail', FDriveFailureDetail);
  Result.AddPair('encryptionCapable', TJSONBool.Create(FEncryptionCapable));
  Result.AddPair('fwVersion', FFWVersion);
  Result.AddPair('model', FModel);
  Result.AddPair('name', FName);
  Result.AddPair('node', FNode.ToJsonObject);
  Result.AddPair('serialNumber', FSerialNumber);
  Result.AddPair('slot', TJSONNUmber.Create(FSlot));
  Result.AddPair('state', FState);
end;

procedure TDriveDetail.FromJsonObject(AJSONObject: TJSONObject);
begin
  if nil <> AJSONObject.Values['capacity'] then
    FCapacity.FromJsonObject(AJSONObject.Values['capacity'] as TJSONObject);
  if nil <> AJSONObject.Values['driveFailureDetail'] then
    FDriveFailureDetail := AJSONObject.Values['driveFailureDetail'].Value;
  if nil <> AJSONObject.Values['encryptionCapable'] then
    FEncryptionCapable := ('TRUE' = AJSONObject.Values['encryptionCapable'].Value.ToUpper);
  if nil <> AJSONObject.Values['fwVersion'] then
    FFWVersion := AJSONObject.Values['fwVersion'].Value;
  if nil <> AJSONObject.Values['model'] then
    FModel := AJSONObject.Values['model'].Value;
  if nil <> AJSONObject.Values['name'] then
    FName := AJSONObject.Values['name'].Value;
  if nil <> AJSONObject.Values['node'] then
    FNode.FromJsonObject(AJSONObject.Values['node'] as TJSONObject);
  if nil <> AJSONObject.Values['serialNumber'] then
    FSerialNumber := AJSONObject.Values['serialNumber'].Value;
  if nil <> AJSONObject.Values['slot'] then
    FSlot := StrToIntDef(AJSONObject.Values['slot'].Value, 0);
  if nil <> AJSONObject.Values['state'] then
    FState := AJSONObject.Values['state'].Value;
end;
{$ENDREGION}

{$REGION 'TDriveInfo'}
constructor TDriveInfo.Create;
begin
  inherited Create;
  FLInks := TLinks.Create;
  FDetail := TDriveDetail.Create;
end;

constructor TDriveInfo.Create(AJSON: String);
begin
  inherited Create;
  FLInks := TLinks.Create;
  FDetail := TDriveDetail.Create;
  FromJson(AJSON);
end;

constructor TDriveInfo.Create(ADriveInfo: TDriveInfo);
begin
  inherited Create;
  FLInks := TLinks.Create(ADriveInfo.Links);
  FDetail := TDriveDetail.Create(ADriveInfo.DriveDetail);
  FUUID := ADriveInfo.UUID;
end;

destructor TDriveInfo.Destroy;
begin
  if nil <> FDetail then
    FDetail.Free;
  if nil <> FLinks then
    FLinks.Free;
  inherited Destroy;
end;


function TDriveInfo.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfo.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;


function TDriveInfo.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('_links', FLinks.ToJsonObject);
  Result.AddPair('detail', FDetail.ToJsonObject);
  Result.AddPair('uuid', FUUID);
end;

procedure TDriveInfo.FromJsonObject(AJSONObject: TJSONObject);
begin
  if nil <> AJSONObject.Values['_links'] then
    FLinks.FromJsonObject(AJSONObject.Values['_links'] as TJSONObject);
  if nil <> AJSONObject.Values['detail'] then
    FDetail.FromJsonObject(AJSONObject.Values['detail'] as TJSONObject);
  if nil <> AJSONObject.Values['uuid'] then
    FUUID := AJSONObject.Values['uuid'].Value;
end;
{$ENDREGION}

{$REGION 'TDriveInfoList'}
constructor TDriveInfoList.Create;
begin
  inherited Create;
  FLIst := TObjectList<TDriveInfo>.Create(TRUE);
end;

constructor TDriveInfoList.Create(AJSONString: String);
begin
  inherited Create;
  FLIst := TObjectList<TDriveInfo>.Create(TRUE);
  DecodeFromJSONArrayString(AJSONString);
end;

constructor TDriveInfoList.Create(ADriveInfoList: TDriveInfoList);
begin
  inherited Create;
  FLIst := TObjectList<TDriveInfo>.Create(TRUE);
  for var i := 0 to (ADriveInfoList.Count - 1) do
    FLIst.Add(TDriveInfo.Create(ADriveInfoList[i]));
end;

destructor TDriveInfoList.Destroy;
begin
  FLIst.Free;
  inherited Destroy;
end;

function TDriveInfoList.GetCount: Integer;
begin
  Result := FLIst.Count;
end;

function TDriveInfoList.GetListItem(AIndex: Integer): TDriveInfo;
begin
  Result := Flist[AIndex];
end;

procedure TDriveInfoList.SetListItem(AIndex: Integer; AValue: TDriveInfo);
begin
  Flist[AIndex] := AValue;
end;

function TDriveInfoList.EncodeToJSONArrayString: String;
begin
  var LArray := Self.ToJSONArray;
  try
    Result := LArray.ToJSON;
  finally
    LArray.Free;
  end;
end;

procedure TDriveInfoList.DecodeFromJSONArrayString(AValue: String);
begin
  if String.IsNullOrWhitespace(AValue) then
    EXIT;
  var LArray := TJSONObject.ParseJSONValue(AValue) as TJSONArray;
  try
    Self.FromJSONArray(LArray)
  finally
    LArray.Free;
  end;
end;

function TDriveInfoList.ToJSONArray: TJSONArray;
begin
  Result := TJSONArray.Create;
  for var i := 0 to (FList.Count - 1) do
    Result.Add(FList[i].ToJSONObject);
end;

procedure TDriveInfoList.FromJSONArray(AJsonArray: TJSONArray);
begin
  FList.Clear;
  for var LArrayValue in AJsonArray do
    FList.Add(TDriveInfo.Create((LArrayValue As TJSONObject).ToJSON));
end;

procedure TDriveInfoList.Add(AValue: TDriveInfo);
begin
  FList.Add(AValue);
end;

procedure TDriveInfoList.Delete(AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

procedure TDriveInfoList.Clear;
begin
  FList.Clear;
end;
{$ENDREGION}

end.
