{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit ElementApi.Job;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  ElementApi.Link;

const
  API_JOB_PATH = 'api/cluster/jobs';

type
  TJobInfo = class
  protected
    FLinks: TLinks;
    FDescription: String;
		FEndTime: String;
		FMessage: String;
		FStartTime: String;
		FState: String;
		FUUID: String;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(AJobInfo: TJobInfo); overload; virtual;
    destructor Destroy; override;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property Links: TLinks read FLinks;
    property Description: String read FDescription write FDescription;
		property EndTime: String read FEndTime write FEndTime;
		property JobMessage: String read FMessage write FMessage;
		property StartTime: String read FStartTime write FStartTime;
		property State: String read FState write FState;
		property UUID: String read FUUID write FUUID;
    property AsJson: String read ToJson write FromJson;
  end;

  TJobInfoList = class
  protected
    FList: TObjectList<TJobInfo>;
    function GetCount: Integer;
    function GetListItem(AIndex: Integer): TJobInfo;
    procedure SetListItem(AIndex: Integer; AValue: TJobInfo);
    function EncodeToJSONArrayString: String;
    procedure DecodeFromJSONArrayString(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(AJobInfoList: TJobInfoList); overload; virtual;
    destructor Destroy; override;
    function ToJSONArray: TJSONArray;
    procedure FromJSONArray(AJsonArray: TJSONArray);
    procedure Add(AJobInfo: TJobInfo);
    procedure Delete(AIndex: Integer);
    procedure Clear;
    property Count: Integer read GetCount;
    property Jobs[AIndex: Integer]: TJobInfo read GetListitem write SetListItem; default;
    property AsJSONArray: String read EncodeToJSONArrayString write DecodeFromJSONArrayString;
  end;

implementation

{$REGION 'TJobInfo'}
constructor TJobInfo.Create;
begin
  inherited Create;
  FLinks := TLinks.Create;
  FDescription := String.Empty;
  FEndTime := String.Empty;
	FMessage := String.Empty;
	FStartTime := String.Empty;
	FState := String.Empty;
	FUUID := String.Empty;
end;

constructor TJobInfo.Create(AJSON: String);
begin
  inherited Create;
  FLinks := TLinks.Create;
  FDescription := String.Empty;
  FEndTime := String.Empty;
	FMessage := String.Empty;
	FStartTime := String.Empty;
	FState := String.Empty;
	FUUID := String.Empty;
  FromJson(AJSON);
end;

constructor TJobInfo.Create(AJobInfo: TJobInfo);
begin
  inherited Create;
  FDescription := String.Empty;
  FEndTime := String.Empty;
	FMessage := String.Empty;
	FStartTime := String.Empty;
	FState := String.Empty;
	FUUID := String.Empty;
  if nil <> AJobInfo then
  begin
    FLinks := TLinks.Create(AJobInfo.Links);
    FDescription := AJobInfo.Description;
    FEndTime := AJobInfo.EndTime;
	  FMessage := AJobInfo.JobMessage;
	  FStartTime := AJobInfo.StartTime;
	  FState := AJobInfo.State;
	  FUUID := AJobInfo.UUID;
  end else
    FLinks := TLinks.Create;
end;

destructor TJobInfo.Destroy;
begin
  FLinks.Free;
  inherited Destroy;
end;

function TJobInfo.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TJobInfo.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

function TJobInfo.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('_links', FLinks.ToJsonObject);
  Result.AddPair('description', FDescription);
  Result.AddPair('end_time', FEndTime);
  Result.AddPair('message', FMessage);
  Result.AddPair('start_time', FStartTime);
  Result.AddPair('state', FState);
  Result.AddPair('uuid', FUUID);
end;

procedure TJobInfo.FromJsonObject(AJSONObject: TJSONObject);
begin
  FLinks.Clear;
  if nil <> AJSONObject.Values['_links'] then
    FLinks.FromJsonObject(AJSONObject.Values['_links'] as TJSONObject);
  if nil <> AJSONObject.Values['description'] then
    FDescription := AJSONObject.Values['description'].Value;
  if nil <> AJSONObject.Values['end_time'] then
    FEndTime := AJSONObject.Values['end_time'].Value;
  if nil <> AJSONObject.Values['message'] then
    FMessage := AJSONObject.Values['message'].Value;
  if nil <> AJSONObject.Values['start_time'] then
    FStartTime := AJSONObject.Values['start_time'].Value;
  if nil <> AJSONObject.Values['state'] then
    FState := AJSONObject.Values['state'].Value;
  if nil <> AJSONObject.Values['uuid'] then
    FUUID := AJSONObject.Values['uuid'].Value;
end;
{$ENDREGION}

{$REGION 'TJobInfoList'}
constructor TJobInfoList.Create;
begin
  inherited Create;
  FList := TObjectList<TJobInfo>.Create(TRUE);
end;

constructor TJobInfoList.Create(AJSON: String);
begin
  inherited Create;
  FList := TObjectList<TJobInfo>.Create(TRUE);
  DecodeFromJSONArrayString(AJSON);
end;

constructor TJobInfoList.Create(AJobInfoList: TJobInfoList);
begin
  inherited Create;
  FList := TObjectList<TJobInfo>.Create(TRUE);
  for var i := 0 to (AJobInfoList.Count - 1) do
    FList.Add(TJobInfo.Create(AJobInfoList[i]))
end;

destructor TJobInfoList.Destroy;
begin
  Flist.Free;
  inherited Destroy;
end;

function TJobInfoList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TJobInfoList.GetListItem(AIndex: Integer): TJobInfo;
begin
  Result := FList[AIndex];
end;

procedure TJobInfoList.SetListItem(AIndex: Integer; AValue: TJobInfo);
begin
  FList[AIndex] := AValue;
end;

function TJobInfoList.EncodeToJSONArrayString: String;
begin
  var LArray := Self.ToJSONArray;
  try
    Result := LArray.ToJSON;
  finally
    LArray.Free;
  end;
end;

procedure TJobInfoList.DecodeFromJSONArrayString(AValue: String);
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

function TJobInfoList.ToJSONArray: TJSONArray;
begin
  Result := TJSONArray.Create;
  for var i := 0 to (FList.Count - 1) do
    Result.Add(FList[i].ToJSONObject);
end;

procedure TJobInfoList.FromJSONArray(AJsonArray: TJSONArray);
begin
  FList.Clear;
  for var LArrayValue in AJsonArray do
    FList.Add(TJobInfo.Create((LArrayValue As TJSONObject).ToJSON));
end;

procedure TJobInfoList.Add(AJobInfo: TJobInfo);
begin
  FList.Add(AJobInfo);
end;

procedure TJobInfoList.Delete(AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

procedure TJobInfoList.Clear;
begin
  FList.Clear;
end;

{$ENDREGION}

end.
