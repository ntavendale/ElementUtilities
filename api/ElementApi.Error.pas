{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit ElementApi.Error;

interface

uses
  System.SysUtils, System.Classes, System.JSON;

type
  TError = class
  protected
    FErrorCode: String;
    FErrorMessage: String;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(AJSON: String); overload; virtual;
    constructor Create(AError: TError); overload; virtual;
    procedure Clear;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    property ErrorCode: String read FErrorCode write FErrorCode;
    property ErrorMessage: String read FErrorMessage write FErrorMessage;
  end;

implementation

{$REGION 'TError'}
constructor TError.Create;
begin
  Clear;
end;
constructor TError.Create(AJSON: String);
begin
  Clear;
  FromJSon(AJSON);
end;

constructor TError.Create(AError: TError);
begin
  FErrorCode := AError.ErrorCode;
  FErrorMessage := AError.ErrorMessage;
end;

function TError.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TError.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj)
  finally
    LObj.Free;
  end;
end;

procedure TError.Clear;
begin
  FErrorCode := String.Empty;
  FErrorMessage := String.Empty
end;

function TError.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('code', FErrorCode);
  Result.AddPair('message', FErrorMessage);
end;

procedure TError.FromJsonObject(AJSONObject: TJSONObject);
begin
  if nil <> AJSONObject.Values['code'] then
    FErrorCode := AJSONObject.Values['code'].Value;
  if nil <> AJSONObject.Values['message'] then
    FErrorMessage := AJSONObject.Values['message'].Value;
end;
{$ENDREGION}
end.
