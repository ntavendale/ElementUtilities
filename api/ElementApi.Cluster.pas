{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit ElementApi.Cluster;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  ElementApi.Link;

const
  API_CLUSTER_PATH = 'api/cluster';

type
  TMasterNodeInfo = class
  protected
    FLinks: TLinks;
    FNodeID: Integer;
    FUUID: String;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSONString: String); overload; virtual;
    constructor Create(AMasterNodeInfo: TMasterNodeInfo); overload; virtual;
    destructor Destroy; override;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Links: TLinks read FLinks;
    property NodeID: Integer read FNodeID write FNodeID;
    property UUID: String read FUUID write FUUID;
    property AsJson: String read ToJson write FromJson;
  end;

  TClusterInfo = class
  protected
    FEncryptionAtRestEnabled: Boolean;
	  FLicenseSerialNumber: String;
	  FManagementVirtualIP: String;
	  FMasterNode: TMasterNodeInfo;
	  FName: String;
	  FSVIP: String;
	  FUUID: String;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSONString: String); overload; virtual;
    constructor Create(AClusterInfo: TClusterInfo); overload; virtual;
    destructor Destroy; override;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property EncryptionAtRestEnabled: Boolean read FEncryptionAtRestEnabled write FEncryptionAtRestEnabled;
	  property LicenseSerialNumber: String read FLicenseSerialNumber write FLicenseSerialNumber;
	  property ManagementVirtualIP: String read FManagementVirtualIP write FManagementVirtualIP;
	  property MasterNode: TMasterNodeInfo read FMasterNode;
	  property Name: String read FName write FName;
	  property SVIP: String read FSVIP write FSVIP;
	  property UUID: String read FUUID write FUUID;
    property AsJson: String read ToJson write FromJson;
  end;

implementation

{$REGION 'TMasterNodeInfo'}
constructor TMasterNodeInfo.Create;
begin
  inherited Create;
  FLinks := TLinks.Create;
end;

constructor TMasterNodeInfo.Create(AJSONString: String);
begin
  inherited Create;
  FLinks := TLinks.Create;
  FromJson(AJSONString);
end;

constructor TMasterNodeInfo.Create(AMasterNodeInfo: TMasterNodeInfo);
begin
  inherited Create;
  FLinks := TLinks.Create(AMasterNodeInfo.Links);
end;

destructor TMasterNodeInfo.Destroy;
begin
  FLinks.Free;
  inherited Create;
end;

function TMasterNodeInfo.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TMasterNodeInfo.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TMasterNodeInfo.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('_links', FLinks.ToJsonObject);
  Result.AddPair('id', TJsonNumber.Create(FNodeID));
  Result.AddPair('uuid', FUUID);
end;

procedure TMasterNodeInfo.FromJsonObject(AJSONObject: TJSONObject);
begin
  if nil <> AJSONObject.Values['_links'] then
    FLinks.FromJsonObject(AJSONObject.Values['_links'] as TJSONObject);
  if nil <> AJsonObject.Values['id'] then
    FNodeID := StrToIntDef(AJsonObject.Values['id'].Value, -1);
  if nil <> AJsonObject.Values['uuid'] then
    FUUID := AJsonObject.Values['uuid'].Value;
end;
{$ENDREGION}

{$REGION 'TClusterInfo'}
constructor TClusterInfo.Create;
begin
  inherited Create;
  FMasterNode := TMasterNodeInfo.Create;
end;

constructor TClusterInfo.Create(AJSONString: String);
begin
  inherited Create;
  FMasterNode := TMasterNodeInfo.Create;
  FromJson(AJSONString);
end;

constructor TClusterInfo.Create(AClusterInfo: TClusterInfo);
begin
  inherited Create;
  FEncryptionAtRestEnabled := AClusterInfo.EncryptionAtRestEnabled;
  FLicenseSerialNumber := AClusterInfo.LicenseSerialNumber;
  FManagementVirtualIP := AClusterInfo.ManagementVirtualIP;
  FMasterNode := TMasterNodeInfo.Create(AClusterInfo.MasterNode);
	FName := AClusterInfo.Name;
	FSVIP := AClusterInfo.SVIP;
	FUUID := AClusterInfo.UUID;
end;

destructor TClusterInfo.Destroy;
begin
  FMasterNode.Free;
  inherited Create;
end;

function TClusterInfo.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TClusterInfo.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TClusterInfo.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('encryptionAtRestEnabled', TJSONBool.Create(FEncryptionAtRestEnabled));
  Result.AddPair('licenseSerialNumber', FLicenseSerialNumber);
  Result.AddPair('managementVirtualIP', FManagementVirtualIP);
  Result.AddPair('masterNode', FMasterNode.ToJsonObject);
  Result.AddPair('name', FName);
  Result.AddPair('svip', FSVIP);
  Result.AddPair('uuid', FUUID);
end;

procedure TClusterInfo.FromJsonObject(AJSONObject: TJSONObject);
begin
  if nil <> AJSONObject.Values['encryptionAtRestEnabled'] then
    FEncryptionAtRestEnabled := ('TRUE' = AJSONObject.Values['encryptionAtRestEnabled'].Value.ToUpper);
  if nil <> AJsonObject.Values['licenseSerialNumber'] then
    FLicenseSerialNumber := AJsonObject.Values['licenseSerialNumber'].Value;
  if nil <> AJsonObject.Values['managementVirtualIP'] then
    FManagementVirtualIP := AJsonObject.Values['managementVirtualIP'].Value;
  if nil <> AJsonObject.Values['masterNode'] then
    FMasterNode.FromJsonObject(AJSONObject.Values['masterNode'] as TJSONObject);
  if nil <> AJsonObject.Values['name'] then
    FName := AJsonObject.Values['name'].Value;
  if nil <> AJsonObject.Values['svip'] then
    FSVIP := AJsonObject.Values['svip'].Value;
  if nil <> AJsonObject.Values['uuid'] then
    FUUID := AJsonObject.Values['uuid'].Value;
end;

{$ENDREGION}
end.
