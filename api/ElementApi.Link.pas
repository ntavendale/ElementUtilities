{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit ElementApi.Link;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections;

type
  TLinkPair = record
    LinkType : String;
    LinkValue: String;
  end;

  TLinks = class
  protected
    FList: TList<TLinkPair>;
    function GetCount: Integer;
    function GetListItem(AIndex: Integer): TLinkPair; overload;
    procedure SetListItem(AIndex: Integer; AValue: TLinkPair); overload;
    function GetListItem(ALinkType: String): String; overload;
    procedure SetListItem(ALinkType: String; AValue: String); overload;
    function ToJson: String;
    procedure FromJson(AValue: String);
  public
    constructor Create; overload; virtual;
    constructor Create(ALinks: TLinks); overload; virtual;
    destructor Destroy; override;
    function ToJsonObject: TJSONObject;
    procedure FromJsonObject(AJSONObject: TJSONObject);
    procedure Add(ALinkPair: TLinkPair); overload;
    procedure Add(ALinkType, ALinkValue: String); overload;
    procedure Delete(AIndex: Integer);
    procedure Clear;
    property Count: Integer read GetCount;
    property Link[AIndex: Integer]: TLinkPair read GetListItem write SetListItem; default;
    property LinkValues[ALinkType: String]: String read GetListItem write SetListItem;
    property AsJson: String read ToJson write FromJson;
  end;

implementation

{$REGION 'TLinks'}
constructor TLinks.Create;
begin
  inherited Create;
  FList := TList<TLinkPair>.Create;
end;

constructor TLinks.Create(ALinks: TLinks);
begin
  inherited Create;
  FList := TList<TLinkPair>.Create;
  for var i := 0 to (ALinks.Count - 1) do
    FList.Add(Alinks[i]);
end;

destructor TLinks.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TLinks.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TLinks.GetListItem(AIndex: Integer): TLinkPair;
begin
  Result := FList[AIndex];
end;

procedure TLinks.SetListItem(AIndex: Integer; AValue: TLinkPair);
begin
  FList[AIndex] := AValue;
end;

function TLinks.GetListItem(ALinkType: String): String;
begin
  for var i := 0 to (Flist.Count - 1) do
  begin
    if ALinkType = Flist[i].LinkType then
    begin
      Result := Flist[i].LinkValue;
      EXIT;
    end;
  end;
  raise Exception.Create(String.Format('List Item %s not found', [ALInkType]));
end;

procedure TLinks.SetListItem(ALinkType: String; AValue: String);
begin
  for var i := 0 to (Flist.Count - 1) do
  begin
    if ALinkType = Flist[i].LinkType then
    begin
      var LLink: TLinkPair;
      LLink.LinkType := ALinkType;
      LLink.LinkValue := AValue;
      Flist[i] := LLink;
      EXIT;
    end;
  end;
  raise Exception.Create(String.Format('List Item %s not found', [ALInkType]));
end;

function TLinks.ToJson: String;
begin
  var LObj := Self.ToJSONObject;
  try
    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

procedure TLinks.FromJson(AValue: String);
begin
  var LObj := TJSONObject.ParseJSONValue(AValue) as TJSONObject;
  try
    FromJSONObject(LObj);
  finally
    LObj.Free;
  end;
end;

function TLinks.ToJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;
  for var i := 0 to (FList.Count - 1) do
  begin
    var LLinkObj := TJSONObject.Create;
    LLinkObj.AddPair('href', FList[i].LinkValue);
    Result.AddPair(FList[i].LinkType, LLinkObj);
  end;
end;

procedure TLinks.FromJsonObject(AJSONObject: TJSONObject);
begin
  FList.Clear;
  for var LPair in AJSONObject do
  begin
    var LLInkPair: TLinkPair;
    LLInkPair.LinkType := LPair.JsonString.Value;
    LLInkPair.LinkValue := (LPair.JsonValue as TJsonObject).Values['href'].Value;
    FList.Add(LLInkPair);
  end;
end;

procedure TLinks.Add(ALinkPair: TLinkPair);
begin
  FList.Add(ALinkPair);
end;

procedure TLinks.Add(ALinkType, ALinkValue: String);
begin
  var LLinkPair: TLinkPair;
  LLinkPair.LinkType := ALinkType;
  LLinkPair.LinkValue := AlinkValue;
  FList.Add(LLinkPair);
end;

procedure TLinks.Delete(AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

procedure TLinks.Clear;
begin
  FList.Clear;
end;

{$ENDREGION}
end.
