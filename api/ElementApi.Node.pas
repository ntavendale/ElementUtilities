{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit ElementApi.Node;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  ElementApi.Link;

const
  API_NODE_PATH = 'api/cluster/nodes';

type
  TNodeDriveInfo = class
  protected
    FLinks: TLinks;
    FState: String;
    FUUID: String;
    FNodeUUID: String;
    procedure Init;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSONString: String); overload; virtual;
    constructor Create(ANodeDriveInfo: TNodeDriveInfo); overload; virtual;
    destructor Destroy; override;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Links: TLinks read FLinks;
    property State: String read FState write FState;
    property UUID: String read FUUID write FUUID;
    property NodeUUID: String read FNodeUUID write FNodeUUID; //Not part of JSON
    property AsJson: String read ToJson write FromJson;
  end;

  TMaintenceModeInfo = class
  protected
    FMaintenceModeState: String;
    FMaintenceModeVariant: String;
    procedure Init;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSONString: String); overload; virtual;
    constructor Create(AMaintenceModeInfo: TMaintenceModeInfo); overload; virtual;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property MaintenceModeState: String read FMaintenceModeState write FMaintenceModeState;
    property MaintenceModeVariant: String read FMaintenceModeVariant write FMaintenceModeVariant;
    property AsJson: String read ToJson write FromJson;
  end;

  TNodeStatus = class
  protected
    FReachable: Boolean;
    FState: String;
    procedure Init;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSONString: String); overload; virtual;
    constructor Create(ANodeStatus: TNodeStatus); overload; virtual;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Reachable: Boolean read FReachable write FReachable;
    property State: String read FState write FState;
    property AsJson: String read ToJson write FromJson;
  end;

  TNodeDriveInfoList = class
  protected
    { Protected declarations }
    FList: TObjectList<TNodeDriveInfo>;
    function GetCount: Integer;
    function GetListItem(AIndex: Integer): TNodeDriveInfo;
    procedure SetListItem(AIndex: Integer; AValue: TNodeDriveInfo);
    function EncodeToJSONArrayString: String;
    procedure DecodeFromJSONArrayString(AValue: String);
  public
    { Pulblic declarations }
    constructor Create; overload; virtual;
    constructor Create(AJSONString: String); overload; virtual;
    constructor Create(ANodeDriveInfoList: TNodeDriveInfoList); overload; virtual;
    destructor Destroy; override;
    function ToJSONArray: TJSONArray;
    procedure FromJSONArray(AJsonArray: TJSONArray);
    procedure Add(ANodeDriveInfo: TNodeDriveInfo);
    procedure Delete(AIndex: Integer);
    procedure AppendFromList(AList: TNodeDriveInfoList);
    procedure Clear;
    property Count: Integer read GetCount;
    property Drives[AIndex: Integer]: TNodeDriveInfo read GetListitem write SetListItem; default;
    property AsJSONArray: String read EncodeToJSONArrayString write DecodeFromJSONArrayString;
  end;

  TNodeInfoDetail = class
  protected
    FClusterIP: String;
    FDrives: TNodeDriveInfoList;
    FMaintenceModeInfo: TMaintenceModeInfo;
    FNodeStatus: TNodeStatus;
    FManagementIP: String;
    FStorageIP: String;
    FRole: String;
    FVersion: String;
    procedure Init;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSONString: String); overload; virtual;
    constructor Create(ANodeInfoDetail: TNodeInfoDetail); overload; virtual;
    destructor Destroy; override;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property ClusterIP: String read FClusterIP write FClusterIP;
    property Drives: TNodeDriveInfoList read FDrives;
    property MaintenceModeInfo: TMaintenceModeInfo read FMaintenceModeInfo;
    property Status: TNodeStatus read FNodeStatus;
    property ManagementIP: String read FManagementIP write FManagementIP;
    property Role: String read FRole write FRole;
    property StorageIP: String read FStorageIP write FStorageIP;
    property Version: String read FVersion write FVersion;
    property AsJson: String read ToJson write FromJson;
  end;

  TNodeInfo = class
  protected
    FLinks: TLinks;
    FNodeInfoDetail: TNodeInfoDetail;
    FNodeID: Integer;
    FName: String;
    FUUID: String;
    procedure Init;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSONString: String); overload; virtual;
    constructor Create(ANodeInfo: TNodeInfo); overload; virtual;
    destructor Destroy; override;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Links: TLinks read FLinks;
    property NodeInfoDetail: TNodeInfoDetail read FNodeInfoDetail;
    property NodeID: Integer read FNodeID write FNodeID;
    property Name: String read FName write FName;
    property UUID: String read FUUID write FUUID;
    property AsJson: String read ToJson write FromJson;
  end;

  TNodeInfoList = class
  protected
    { Protected declarations }
    FList: TObjectList<TNodeInfo>;
    function GetCount: Integer;
    function GetListItem(AIndex: Integer): TNodeInfo;
    procedure SetListItem(AIndex: Integer; AValue: TNodeInfo);
    function EncodeToJSONArrayString: String;
    procedure DecodeFromJSONArrayString(AValue: String);
  public
    { Pulblic declarations }
    constructor Create; overload; virtual;
    constructor Create(AJSONString: String); overload; virtual;
    constructor Create(ANodeInfoList: TNodeInfoList); overload; virtual;
    destructor Destroy; override;
    function ToJSONArray: TJSONArray;
    procedure FromJSONArray(AJsonArray: TJSONArray);
    procedure Add(ANodeInfo: TNodeInfo);
    procedure Delete(AIndex: Integer);
    procedure Clear;
    property Count: Integer read GetCount;
    property Nodes[AIndex: Integer]: TNodeInfo read GetListitem write SetListItem; default;
    property AsJSONArray: String read EncodeToJSONArrayString write DecodeFromJSONArrayString;
  end;

implementation

{$REGION 'TNodeDriveInfo'}
constructor TNodeDriveInfo.Create;
begin
  inherited Create;
  FLinks := TLinks.Create;
  Init;
end;

constructor TNodeDriveInfo.Create(AJSONString: String);
begin
  inherited Create;
  FLinks := TLinks.Create;
  FromJson(AJSONString);
end;

constructor TNodeDriveInfo.Create(ANodeDriveInfo: TNodeDriveInfo);
begin
  inherited Create;
  FLinks := TLinks.Create(ANodeDriveInfo.Links);
  FState := ANodeDriveInfo.State;
  FUUID := ANodeDriveInfo.UUID;
  FNodeUUID := ANodeDriveInfo.NodeUUID;
end;

destructor TNodeDriveInfo.Destroy;
begin
  FLinks.Free;
  inherited Create;
end;

procedure TNodeDriveInfo.Init;
begin
  FLinks.Clear;
  FState := String.Empty;
  FUUID := String.Empty;
end;

function TNodeDriveInfo.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TNodeDriveInfo.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TNodeDriveInfo.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('_links', FLinks.ToJsonObject);
  Result.AddPair('state', FState);
  Result.AddPair('uuid', FUUID);
end;

procedure TNodeDriveInfo.FromJsonObject(AJSONObject: TJSONObject);
begin
  Init;

  if nil <> AJSONObject.Values['_links'] then
    FLinks.FromJsonObject(AJSONObject.Values['_links'] as TJSONObject);

  if nil <> AJsonObject.Values['state'] then
    FState := AJsonObject.Values['state'].Value;
  if nil <> AJsonObject.Values['uuid'] then
    FUUID := AJsonObject.Values['uuid'].Value;
end;
{$ENDREGION}

{$REGION 'TNodeDriveInfoList'}
constructor TNodeDriveInfoList.Create;
begin
  inherited Create;
  FList := TObjectList<TNodeDriveInfo>.Create(TRUE);
end;

constructor TNodeDriveInfoList.Create(AJSONString: String);
begin
  inherited Create;
  FList := TObjectList<TNodeDriveInfo>.Create(TRUE);
  DecodeFromJSONArrayString(AJSONString);
end;

constructor TNodeDriveInfoList.Create(ANodeDriveInfoList: TNodeDriveInfoList);
begin
  inherited Create;
  FList := TObjectList<TNodeDriveInfo>.Create(TRUE);
  for var i := 0 to (ANodeDriveInfoList.Count - 1) do
    FList.Add(TNodeDriveInfo.Create(ANodeDriveInfoList[i]));
end;

destructor TNodeDriveInfoList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TNodeDriveInfoList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TNodeDriveInfoList.GetListItem(AIndex: Integer): TNodeDriveInfo;
begin
  Result := FList[AIndex];
end;

procedure TNodeDriveInfoList.SetListItem(AIndex: Integer; AValue: TNodeDriveInfo);
begin
  FList[AIndex] := AValue;
end;

function TNodeDriveInfoList.EncodeToJSONArrayString: String;
begin
  var LArray := Self.ToJSONArray;
  try
    Result := LArray.ToJSON;
  finally
    LArray.Free;
  end;
end;

procedure TNodeDriveInfoList.DecodeFromJSONArrayString(AValue: String);
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

function TNodeDriveInfoList.ToJSONArray: TJSONArray;
begin
  Result := TJSONArray.Create;
  for var i := 0 to (FList.Count - 1) do
    Result.Add(FList[i].ToJSONObject);
end;

procedure TNodeDriveInfoList.FromJSONArray(AJsonArray: TJSONArray);
begin
  FList.Clear;
  for var LArrayValue in AJsonArray do
    FList.Add(TNodeDriveInfo.Create((LArrayValue As TJSONObject).ToJSON));
end;

procedure TNodeDriveInfoList.Add(ANodeDriveInfo: TNodeDriveInfo);
begin
  FList.Add(ANodeDriveInfo);
end;

procedure TNodeDriveInfoList.Delete(AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

procedure TNodeDriveInfoList.AppendFromList(AList: TNodeDriveInfoList);
begin
  for var i := 0 to (AList.Count - 1) do
    FList.Add(TNodeDriveInfo.Create(AList[i]));
end;

procedure TNodeDriveInfoList.Clear;
begin
  FList.Clear;
end;
{$ENDREGION}

{$REGION 'TMaintenceModeInfo'}
constructor TMaintenceModeInfo.Create;
begin
  inherited Create;
  Init;
end;

constructor TMaintenceModeInfo.Create(AJSONString: String);
begin
  inherited Create;
  FromJson(AJSONString);
end;

constructor TMaintenceModeInfo.Create(AMaintenceModeInfo: TMaintenceModeInfo);
begin
  inherited Create;
  FMaintenceModeState := AMaintenceModeInfo.MaintenceModeState;
  FMaintenceModeVariant := AMaintenceModeInfo.FMaintenceModeVariant;
end;

procedure TMaintenceModeInfo.Init;
begin
  FMaintenceModeState := String.Empty;
  FMaintenceModeVariant := String.Empty;
end;

function TMaintenceModeInfo.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TMaintenceModeInfo.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TMaintenceModeInfo.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('state', FMaintenceModeState);
  Result.AddPair('variant', FMaintenceModeVariant);
end;

procedure TMaintenceModeInfo.FromJsonObject(AJSONObject: TJSONObject);
begin
  if (nil <> AJSONObject.Values['state']) then
    FMaintenceModeState := AJSONObject.Values['state'].Value;
  if (nil <> AJSONObject.Values['variant']) then
    FMaintenceModeVariant := AJSONObject.Values['variant'].Value;
end;
{$ENDREGION}

{$REGION 'TNodeStatus'}
constructor TNodeStatus.Create;
begin
  inherited Create;
  Init;
end;

constructor TNodeStatus.Create(AJSONString: String);
begin
  inherited Create;
  FromJson(AJSONString);
end;

constructor TNodeStatus.Create(ANodeStatus: TNodeStatus);
begin
  inherited Create;
  FReachable := ANodeStatus.Reachable;
  FState := ANodeStatus.State;
end;

procedure TNodeStatus.Init;
begin
  FReachable := FALSE;
  FState := String.Empty;
end;

function TNodeStatus.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TNodeStatus.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TNodeStatus.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('reachable', TJsonBool.Create(FReachable));
  Result.AddPair('state', FState);
end;

procedure TNodeStatus.FromJsonObject(AJSONObject: TJSONObject);
begin
  Init;
  if (nil <> AJSONObject.Values['state']) then
    FState := AJSONObject.Values['state'].Value;
  if (nil <> AJSONObject.Values['reachable']) then
    FReachable := ('TRUE' = AJSONObject.Values['reachable'].Value.ToUpper);
end;
{$ENDREGION}

{$REGION 'TNodeInfoDetail'}
constructor TNodeInfoDetail.Create;
begin
  inherited Create;
  FDrives := TNodeDriveInfoList.Create;
  FMaintenceModeInfo := TMaintenceModeInfo.Create;
  FNodeStatus := TNodeStatus.Create;
  Init;
end;

constructor TNodeInfoDetail.Create(AJSONString: String);
begin
  inherited Create;
  FDrives := TNodeDriveInfoList.Create;
  FMaintenceModeInfo := TMaintenceModeInfo.Create;
  FNodeStatus := TNodeStatus.Create;
  FromJson(AJSONString);
end;

constructor TNodeInfoDetail.Create(ANodeInfoDetail: TNodeInfoDetail);
begin
  inherited Create;
  FDrives := TNodeDriveInfoList.Create(ANodeInfoDetail.Drives) ;
  FMaintenceModeInfo := TMaintenceModeInfo.Create(ANodeInfoDetail.MaintenceModeInfo);
  FNodeStatus := TNodeStatus.Create(ANodeInfoDetail.Status);
end;

destructor TNodeInfoDetail.Destroy;
begin
  FNodeStatus.Free;
  FMaintenceModeInfo.Free;
  FDrives.Free;
  inherited Destroy;
end;

procedure TNodeInfoDetail.Init;
begin
  FClusterIP := String.Empty;
  FDrives.Clear;
  FMaintenceModeInfo.MaintenceModeState := String.Empty;
  FMaintenceModeInfo.MaintenceModeVariant := String.Empty;

  FManagementIP := String.Empty;
  FStorageIP := String.Empty;
  FRole := String.Empty;
  FVersion := String.Empty;

  FNodeStatus.State := String.Empty;
  FNodeStatus.Reachable := FALSE;
end;

function TNodeInfoDetail.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoDetail.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TNodeInfoDetail.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;

  var LIPObj := TJSONObject.Create;
  LIPObj.AddPair('address', FClusterIP);
  Result.AddPair('cluster_ip', LIPObj);

  Result.AddPair('drives', FDrives.ToJSONArray);

  Result.AddPair('maintenance_mode', FMaintenceModeInfo.ToJsonObject);

  LIPObj := TJSONObject.Create;
  LIPObj.AddPair('address', FManagementIP);
  Result.AddPair('management_ip', LIPObj);

  Result.AddPair('role', FRole);

  Result.AddPair('status', FNodeStatus.ToJsonObject);

  LIPObj := TJSONObject.Create;
  LIPObj.AddPair('address', FStorageIP);
  Result.AddPair('storage_ip', LIPObj);

  Result.AddPair('version', FVersion);
end;

procedure TNodeInfoDetail.FromJsonObject(AJSONObject: TJSONObject);
begin
  Init;
  if (nil <> AJSONObject.Values['cluster_ip']) and (nil <> (AJSONObject.Values['cluster_ip'] as TJSONObject).Values['address']) then
    FClusterIP := (AJSONObject.Values['cluster_ip'] as TJSONObject).Values['address'].Value;

  if nil <> AJSONObject.Values['drives'] then
    FDrives.FromJSONArray(AJSONObject.Values['drives'] as TJSONArray);

  if (nil <> AJSONObject.Values['maintenance_mode']) then
    FMaintenceModeInfo.FromJsonObject(AJSONObject.Values['maintenance_mode'] as TJSONObject);

  if (nil <> AJSONObject.Values['management_ip']) and (nil <> (AJSONObject.Values['management_ip'] as TJSONObject).Values['address']) then
    FManagementIP := (AJSONObject.Values['management_ip'] as TJSONObject).Values['address'].Value;

  if nil <> AJSONObject.Values['role'] then
    FRole := AJSONObject.Values['role'].Value;

  if (nil <> AJSONObject.Values['status']) then
    FNodeStatus.FromJsonObject(AJSONObject.Values['status'] as TJSONObject);

  if (nil <> AJSONObject.Values['storage_ip']) and (nil <> (AJSONObject.Values['storage_ip'] as TJSONObject).Values['address']) then
    FStorageIP := (AJSONObject.Values['storage_ip'] as TJSONObject).Values['address'].Value;

  if nil <> AJSONObject.Values['version'] then
    FVersion := AJSONObject.Values['version'].Value;
end;
{$ENDREGION}

{$REGION 'TNodeInfo'}
constructor TNodeInfo.Create;
begin
  inherited Create;
  FLinks := TLinks.Create;
  FNodeInfoDetail := TNodeInfoDetail.Create;
end;

constructor TNodeInfo.Create(AJSONString: String);
begin
  inherited Create;
  FLinks := TLinks.Create;
  FNodeInfoDetail := TNodeInfoDetail.Create;
  FromJson(AJSONString);
end;

constructor TNodeInfo.Create(ANodeInfo: TNodeInfo);
begin
  inherited Create;
  FLinks := TLinks.Create(ANodeInfo.Links);
  FNodeInfoDetail := TNodeInfoDetail.Create(ANodeInfo.NodeInfoDetail);
end;

destructor TNodeInfo.Destroy;
begin
  if nil <> FNodeInfoDetail then
    FNodeInfoDetail.Free;

  if nil <> FLinks then
    FLinks.Free;

  inherited Destroy;
end;

procedure TNodeInfo.Init;
begin
  FLinks.Clear;
  FNodeID := 0;
  FName := String.Empty;
  FUUID := String.Empty;
end;

function TNodeInfo.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfo.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TNodeInfo.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('_links', FLinks.ToJsonObject);
  Result.AddPair('detail', FNodeInfoDetail.ToJsonObject);
  Result.AddPair('id', TJsonNumber.Create(FNodeID));
  Result.AddPair('name', FName);
  Result.AddPair('uuid', FUUID);
end;

procedure TNodeInfo.FromJsonObject(AJSONObject: TJSONObject);
begin
  Init;
  if nil <> AJSONObject.Values['_links'] then
    FLinks.FromJsonObject(AJSONObject.Values['_links'] as TJSONObject);
  if nil <> AJSONObject.Values['detail'] then
    FNodeInfoDetail.FromJsonObject(AJSONObject.Values['detail'] as TJSONObject);
  if nil <> AJsonObject.Values['id'] then
    FNodeID := StrToIntDef(AJsonObject.Values['id'].Value, -1);
  if nil <> AJsonObject.Values['name'] then
    FName := AJsonObject.Values['name'].Value;
  if nil <> AJsonObject.Values['uuid'] then
    FUUID := AJsonObject.Values['uuid'].Value;

  for var i := 0 to (FNodeInfoDetail.Drives.Count - 1) do
    FNodeInfoDetail.Drives[i].NodeUUID := FUUID;
end;
{$ENDREGION}

{$REGION 'TNodeInfoList'}
constructor TNodeInfoList.Create;
begin
  inherited Create;
  FList := TObjectList<TNodeInfo>.Create(TRUE);
end;

constructor TNodeInfoList.Create(AJSONString: String);
begin
  inherited Create;
  FList := TObjectList<TNodeInfo>.Create(TRUE);
  DecodeFromJSONArrayString(AJSONString);
end;

constructor TNodeInfoList.Create(ANodeInfoList: TNodeInfoList);
begin
  FList := TObjectList<TNodeInfo>.Create(TRUE);
  for var i := 0 to (ANodeInfoList.Count - 1) do
    FList.Add(TNodeInfo.Create(ANodeInfoList[i]));
end;

destructor TNodeInfoList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TNodeInfoList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TNodeInfoList.GetListItem(AIndex: Integer): TNodeInfo;
begin
  Result := FList[AIndex];
end;

procedure TNodeInfoList.SetListItem(AIndex: Integer; AValue: TNodeInfo);
begin
  FList[AIndex] := AValue;
end;

function TNodeInfoList.EncodeToJSONArrayString: String;
begin
  var LArray := Self.ToJSONArray;
  try
    Result := LArray.ToJSON;
  finally
    LArray.Free;
  end;
end;

procedure TNodeInfoList.DecodeFromJSONArrayString(AValue: String);
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

function TNodeInfoList.ToJSONArray: TJSONArray;
begin
  Result := TJSONArray.Create;
  for var i := 0 to (FList.Count - 1) do
    Result.Add(FList[i].ToJSONObject);
end;

procedure TNodeInfoList.FromJSONArray(AJsonArray: TJSONArray);
begin
  FList.Clear;
  for var LArrayValue in AJsonArray do
    FList.Add(TNodeInfo.Create((LArrayValue As TJSONObject).ToJSON));
end;

procedure TNodeInfoList.Add(ANodeInfo: TNodeInfo);
begin
  FList.Add(ANodeInfo);
end;

procedure TNodeInfoList.Delete(AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

procedure TNodeInfoList.Clear;
begin
  FList.Clear;
end;
{$ENDREGION}

end.
