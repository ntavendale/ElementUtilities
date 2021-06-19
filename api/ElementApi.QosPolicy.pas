{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit ElementApi.QosPolicy;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  ElementApi.Link, ElementApi.Error;

const
  API_QOS_POLICY_PATH = 'api/cluster/qos-policies';

type
  TCost = class
  private
    FCost: String;
    FIOSize: String;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(ACost: TCost); overload; virtual;
    procedure Init;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Cost: String read FCost write FCost;
    property IOSize: String read FIOSize write FIOSize;
    property AsJson: String read ToJson write FromJson;
  end;

  TCostList = class
  private
    FList: TObjectList<TCost>;
    function GetCount: Integer;
    function GetListItem(AIndex: Integer): TCost;
    procedure SetListItem(AIndex: Integer; AValue: TCost);
    function EncodeToJSONArrayString: String;
    procedure DecodeFromJSONArrayString(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(ACostList: TCostList); overload; virtual;
    destructor Destroy; override;
    function ToJSONArray: TJSONArray;
    procedure FromJSONArray(AJsonArray: TJSONArray);
    procedure Add(AValue: TCost);
    procedure Delete(AIndex: Integer);
    procedure Clear;
    property Count: Integer read GetCount;
    property Costs[AIndex: Integer]: TCost read GetListitem write SetListItem; default;
    property AsJSONArray: String read EncodeToJSONArrayString write DecodeFromJSONArrayString;
  end;

  TCurve = class
  private
    FCosts: TCostList;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(ACurve: TCurve); overload; virtual;
    destructor Destroy; override;
    procedure Init;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Costs: TCostList read FCosts;
    property AsJson: String read ToJson write FromJson;
  end;

  TQosPolicy = class
  private
    FLinks: TLinks;
    FBurstIOPS: Integer;
    FBurstTime: Integer;
    FCurve: TCurve;
    FDescription: String;
    FMaxIOPS: Integer;
    FMinIOPS: Integer;
    FUUID: String;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJson: String); overload; virtual;
    constructor Create(AQosPolicy: TQosPolicy); overload; virtual;
    destructor Destroy; override;
    procedure Init;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Links: TLinks read FLinks write FLinks;
    property BurstIOPS: Integer read FBurstIOPS write FBurstIOPS;
    property BurstTime: Integer read FBurstTime write FBurstTime;
    property Curve: TCurve read FCurve write FCurve;
    property Description: String read FDescription write FDescription;
    property MaxIOPS: Integer read FMaxIOPS write FMaxIOPS;
    property MinIOPS: Integer read FMinIOPS write FMinIOPS;
    property UUID: String read FUUID write FUUID;
    property AsJson: String read ToJson write FromJson;
  end;

  TQosPolicyList = class
  private
    FList: TObjectList<TQosPolicy>;
    function GetCount: Integer;
    function GetListItem(AIndex: Integer): TQosPolicy;
    procedure SetListItem(AIndex: Integer; AValue: TQosPolicy);
    function EncodeToJSONArrayString: String;
    procedure DecodeFromJSONArrayString(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(AQosPolicyList: TQosPolicyList); overload; virtual;
    destructor Destroy; override;
    function ToJSONArray: TJSONArray;
    procedure FromJSONArray(AJsonArray: TJSONArray);
    procedure Add(AValue: TQosPolicy);
    procedure Delete(AIndex: Integer);
    procedure Clear;
    property Count: Integer read GetCount;
    property QosPolicys[AIndex: Integer]: TQosPolicy read GetListitem write SetListItem; default;
    property AsJSONArray: String read EncodeToJSONArrayString write DecodeFromJSONArrayString;
  end;


implementation

{$REGION 'TCost'}
constructor TCost.Create;
begin
  Init;
end;

constructor TCost.Create(AJSON: String);
begin
  FromJson(AJSON);
end;

constructor TCost.Create(ACost: TCost);
begin
  Init;
  FCost := ACost.Cost;
  FIOSize := ACost.IOSize;
end;

function TCost.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TCost.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

procedure TCost.Init;
begin
  FCost := String.Empty;
  FIOSize := String.Empty;
end;

function TCost.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('cost', FCost);
  Result.AddPair('iosize', FIOSize);
end;

procedure TCost.FromJsonObject(AJSONObject: TJSONObject);
begin
  Init;
  if nil <> AJSONObject.Values['cost'] then
    FCost := AJSONObject.Values['cost'].Value;
  if nil <> AJSONObject.Values['iosize'] then
    FIOSize := AJSONObject.Values['iosize'].Value;
end;
{$ENDREGION}

{$REGION 'TCostList'}
constructor TCostList.Create;
begin
  inherited Create;
  FList := TObjectList<TCost>.Create(TRUE);
end;

constructor TCostList.Create(AJSON: String);
begin
  inherited Create;
  FList := TObjectList<TCost>.Create(TRUE);
  DecodeFromJSONArrayString(AJSON);
end;

constructor TCostList.Create(ACostList: TCostList);
begin
  inherited Create;
  FList := TObjectList<TCost>.Create(TRUE);
  for var i := 0 to (ACostList.Count - 1) do
    FList.Add(TCost.Create(ACostList[i]))
end;

destructor TCostList.Destroy;
begin
  Flist.Free;
  inherited Destroy;
end;

function TCostList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TCostList.GetListItem(AIndex: Integer): TCost;
begin
  Result := FList[AIndex];
end;

procedure TCostList.SetListItem(AIndex: Integer; AValue: TCost);
begin
  FList[AIndex] := AValue;
end;

function TCostList.EncodeToJSONArrayString: String;
begin
  var LArray := Self.ToJSONArray;
  try
    Result := LArray.ToJSON;
  finally
    LArray.Free;
  end;
end;

procedure TCostList.DecodeFromJSONArrayString(AValue: String);
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

function TCostList.ToJSONArray: TJSONArray;
begin
  Result := TJSONArray.Create;
  for var i := 0 to (FList.Count - 1) do
    Result.Add(FList[i].ToJSONObject);
end;

procedure TCostList.FromJSONArray(AJsonArray: TJSONArray);
begin
  FList.Clear;
  for var LArrayValue in AJsonArray do
    FList.Add(TCost.Create((LArrayValue As TJSONObject).ToJSON));
end;

procedure TCostList.Add(AValue: TCost);
begin
  FList.Add(AValue);
end;

procedure TCostList.Delete(AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

procedure TCostList.Clear;
begin
  FList.Clear;
end;
{$ENDREGION}

{$REGION 'TCurve'}
constructor TCurve.Create;
begin
  FCosts := TCostList.Create;
end;

constructor TCurve.Create(AJSON: String);
begin
  FCosts := TCostList.Create;
  Init;
  FromJson(AJSON);
end;

constructor TCurve.Create(ACurve: TCurve);
begin
  FCosts := TCostList.Create(ACurve.Costs);
end;

destructor TCurve.Destroy;
begin
  FCosts.Free;
  inherited Destroy;
end;

procedure TCurve.Init;
begin
  FCosts.Clear;
end;

function TCurve.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TCurve.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TCurve.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('costs', FCosts.ToJSONArray);
end;

procedure TCurve.FromJsonObject(AJSONObject: TJSONObject);
begin
  Init;
  if nil <> AJSONObject.Values['costs'] then
    FCosts.FromJsonArray(AJSONObject.Values['costs'] as TJSONArray);
end;
{$ENDREGION}

{$REGION 'TQosPolicy'}
constructor TQosPolicy.Create;
begin
  FLinks := TLinks.Create;
  FCurve := TCurve.Create;
  Init;
end;

constructor TQosPolicy.Create(AJson: String);
begin
  FLinks := TLinks.Create;
  FCurve := TCurve.Create;
  Init;
  FromJson(AJson);
end;

constructor TQosPolicy.Create(AQosPolicy: TQosPolicy);
begin
  FLinks := TLinks.Create(AQosPolicy.Links);
  FCurve := TCurve.Create(AQosPolicy.Curve);
  FBurstIOPS := AQosPolicy.BurstIOPS;
  FBurstTime := AQosPolicy.BurstTime;
  FDescription := AQosPolicy.Description;
  FMaxIOPS := AQosPolicy.MaxIOPS;
  FMinIOPS := AQosPolicy.MinIOPS;
  FUUID := AQosPolicy.UUID;
end;

destructor TQosPolicy.Destroy;
begin
  FLinks.Free;
  FCurve.Free;
  inherited Destroy;
end;

function TQosPolicy.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TQosPolicy.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

procedure TQosPolicy.Init;
begin
  FLinks.Clear;
  FBurstIOPS := Default(Integer);
  FBurstTime := Default(Integer);
  FCurve.Init;
  FDescription := String.Empty;
  FMaxIOPS := Default(Integer);
  FMinIOPS := Default(Integer);
  FUUID := String.Empty;
end;

function TQosPolicy.ToJsonObject: TJSONObject;
begin
  Result := TJsonObject.Create;
  Result.AddPair('_links', FLinks.ToJsonObject);
  Result.AddPair('burstIOPS', TJsonNumber.Create(FBurstIOPS));
  Result.AddPair('burstTime', TJsonNumber.Create(FBurstTime));
  Result.AddPair('curve', FCurve.ToJsonObject);
  Result.AddPair('description', FDescription);
  Result.AddPair('maxIOPS', TJsonNumber.Create(FMaxIOPS));
  Result.AddPair('minIOPS', TJsonNumber.Create(FMinIOPS));
  Result.AddPair('uuid', FUUID);
end;

procedure TQosPolicy.FromJsonObject(AJSONObject: TJSONObject);
begin
  Init;
  if nil <> AJSONObject.Values['_links'] then
    FLinks.FromJsonObject(AJSONObject.Values['_links'] as TJSONObject);
  if nil <> AJSONObject.Values['burstIOPS'] then
    FBurstIOPS := StrToIntDef(AJSONObject.Values['burstIOPS'].Value, Default(Integer));
  if nil <> AJSONObject.Values['burstTime'] then
    FBurstTime := StrToIntDef(AJSONObject.Values['burstTime'].Value, Default(Integer));
  if nil <> AJSONObject.Values['curve'] then
    FCurve.FromJsonObject(AJSONObject.Values['curve'] as TJsonObject);
  if nil <> AJSONObject.Values['description'] then
    FDescription := AJSONObject.Values['description'].Value;
  if nil <> AJSONObject.Values['maxIOPS'] then
    FMaxIOPS := StrToIntDef(AJSONObject.Values['maxIOPS'].Value, Default(Integer));
  if nil <> AJSONObject.Values['minIOPS'] then
    FMinIOPS := StrToIntDef(AJSONObject.Values['minIOPS'].Value, Default(Integer));
  if nil <> AJSONObject.Values['uuid'] then
    FUUID := AJSONObject.Values['uuid'].Value;
end;
{$ENDREGION}

{$REGION 'TQosPolicyList'}
constructor TQosPolicyList.Create;
begin
  inherited Create;
  FList := TObjectList<TQosPolicy>.Create(TRUE);
end;

constructor TQosPolicyList.Create(AJSON: String);
begin
  inherited Create;
  FList := TObjectList<TQosPolicy>.Create(TRUE);
  DecodeFromJSONArrayString(AJSON);
end;

constructor TQosPolicyList.Create(AQosPolicyList: TQosPolicyList);
begin
  inherited Create;
  FList := TObjectList<TQosPolicy>.Create(TRUE);
  for var i := 0 to (AQosPolicyList.Count - 1) do
    FList.Add(TQosPolicy.Create(AQosPolicyList[i]))
end;

destructor TQosPolicyList.Destroy;
begin
  Flist.Free;
  inherited Destroy;
end;

function TQosPolicyList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TQosPolicyList.GetListItem(AIndex: Integer): TQosPolicy;
begin
  Result := FList[AIndex];
end;

procedure TQosPolicyList.SetListItem(AIndex: Integer; AValue: TQosPolicy);
begin
  FList[AIndex] := AValue;
end;

function TQosPolicyList.EncodeToJSONArrayString: String;
begin
  var LArray := Self.ToJSONArray;
  try
    Result := LArray.ToJSON;
  finally
    LArray.Free;
  end;
end;

procedure TQosPolicyList.DecodeFromJSONArrayString(AValue: String);
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

function TQosPolicyList.ToJSONArray: TJSONArray;
begin
  Result := TJSONArray.Create;
  for var i := 0 to (FList.Count - 1) do
    Result.Add(FList[i].ToJSONObject);
end;

procedure TQosPolicyList.FromJSONArray(AJsonArray: TJSONArray);
begin
  FList.Clear;
  for var LArrayValue in AJsonArray do
    FList.Add(TQosPolicy.Create((LArrayValue As TJSONObject).ToJSON));
end;

procedure TQosPolicyList.Add(AValue: TQosPolicy);
begin
  FList.Add(AValue);
end;

procedure TQosPolicyList.Delete(AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

procedure TQosPolicyList.Clear;
begin
  FList.Clear;
end;
{$ENDREGION}

end.
