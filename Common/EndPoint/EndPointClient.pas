{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit EndPointClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdSSL, IdSSLOpenSSL,
  IdSSLOpenSSLHeaders, IdIOHandler,  IdIOHandlerSocket, IdIOHandlerStack, IdAuthentication,
  Utilities, FileLogger;

type
  TEndpointClient = class
    protected
      { Protected declarations }
      FEndpointURL: String;
      FHttp: TIdHTTP;
      FResponseCode: Integer;
      FResponseText: String;
      FFullURL: String;
      FHandler: TIdSSLIOHandlerSocketOpenSSL;
      function IsPlainHttp(ARUL: String): Boolean;
      procedure Init(AAuthToken, AUserName, APassword: String; ASecure: Boolean);
    public
      { Public declarations }
      constructor Create(AEndpoint: String; APort: WORD; AuthToken: String; AResource: String); overload; virtual;
      constructor Create(AEndpoint: String; AuthToken: String; AResource: String); overload; virtual;
      constructor Create(AEndpoint: String; APort: WORD; AUserName, APassword: String; AResource: String); overload; virtual;
      constructor Create(AEndpoint: String; AUserName, APassword: String; AResource: String); overload; virtual;
      destructor Destroy; override;
      function Head: Integer; overload;
      function Head(AResource: String): Integer; overload;
      function Get: String; overload;
      function Get(AResource: String): String; overload;
      procedure Put(AContents: String); overload;
      procedure Put(AContents, AAccept, AContentType: String); overload;
      procedure Put(AResource: String; AContents: String); overload;
      procedure Put(AResource, AContents, AAccept, AContentType: String); overload;
      function Post(AContents: String): String; overload;
      function Post(AContents, AAccept, AContentType: String): String; overload;
      function Post(AResource: String; AContents: String): String; overload;
      function Post(AResource: String; AContents: String; AAccept: String; AContentType: String): String; overload;
      function Delete: String; overload;
      function Delete(AResource: String): String; overload;
      class function IsReponseCodeSuccess(AResponseCode: Integer): Boolean;
      property ResponseCode: Integer read FResponseCode;
      property ResponseText: String read FResponseText;
      property StatusCode: Integer read FResponseCode;
      property StatusText: String read FResponseText;
      property FullURL: String read FFullURl;
  end;

implementation

constructor TEndpointClient.Create(AEndpoint: String; APort: WORD; AuthToken: String; AResource: String);
begin
  Init(AuthToken, String.Empty, String.Empty, not IsPlainHttp(AEndpoint));
  FEndpointURL := String.Format('%s:%d', [AEndpoint, APort]);
  FFullURL := String.Format('%s/%s', [FEndpointURL, AResource]);
end;

constructor TEndpointClient.Create(AEndpoint: String; AuthToken: String; AResource: String);
begin
  Init(AuthToken, String.Empty, String.Empty, not IsPlainHttp(AEndpoint));
  FEndpointURL := AEndpoint;
  FFullURL := String.Format('%s/%s', [FEndpointURL, AResource]);
end;

constructor TEndpointClient.Create(AEndpoint: String; APort: WORD; AUserName, APassword: String; AResource: String);
begin
  Init(String.Empty, AUserName, APassword, not IsPlainHttp(AEndpoint));
  FEndpointURL := String.Format('%s:%d', [AEndpoint, APort]);
  FFullURL := String.Format('%s/%s', [FEndpointURL, AResource]);
end;

constructor TEndpointClient.Create(AEndpoint: String; AUserName, APassword: String; AResource: String);
begin
  Init(String.Empty, AUserName, APassword, not IsPlainHttp(AEndpoint) );
  FEndpointURL := AEndpoint;
  FFullURL := String.Format('%s/%s', [FEndpointURL, AResource]);
end;

destructor TEndpointClient.Destroy;
begin
  if nil <> FHttp then
    FHttp.Free;
  if Assigned(FHandler) then
    FHandler.Free;
  inherited Destroy;
end;

function TEndpointClient.IsPlainHttp(ARUL: String): Boolean;
begin
  Result := ('http://' = ARUL.Substring(0, 7).ToLower);
end;

procedure TEndpointClient.Init(AAuthToken, AUserName, APassword: String; ASecure: Boolean);
begin
  FHandler := nil;
  FHttp := TIdHTTP.Create(nil);
  if not String.IsNullOrWhiteSpace(AAuthToken) then
     FHttp.Request.CustomHeaders.Add(String.Format('Authorization:Bearer %s', [AAuthToken]))
  else
  begin
    FHttp.Request.BasicAuthentication := True;
    FHttp.Request.Username := AUserName;
    FHttp.Request.Password := APassword;
  end;

  if ASecure then
  begin
    FHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    FHttp.IOHandler := FHandler;
    FHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    FHandler.SSLOptions.Method := sslvTLSv1_2;
  end;
end;

function TEndpointClient.Head: Integer;
begin
  FResponseText := String.Empty;
  try
    FHttp.Head(FFullURL);
  except
  end;
  FResponseCode := FHttp.ResponseCode;
  Result := FResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Head(AResource: String): Integer;
begin
  FResponseText := String.Empty;
  try
    FHttp.Head( String.Format('%s/%s', [FEndpointURL, AResource]) );
  except
  end;
  FResponseCode := FHttp.ResponseCode;
  Result := FResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Get: String;
begin
  FResponseText := String.Empty;
  try
    Result := FHttp.Get(FFullURL);
  except
    on E:Exception do
    begin
      Result := String.Format('%s', [E.Message]);
    end;
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Get(AResource: String): String;
begin
  FResponseText := String.Empty;
  try
    Result := FHttp.Get(String.Format('%s/%s', [FEndpointURL, AResource]));
  except
    on E:Exception do
    begin
      Result := String.Format('%s', [E.Message]);
    end;
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

procedure TEndpointClient.Put(AContents: String);
var
  LStream: TStringStream;
begin
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      FHttp.Put(FFullURL, LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

procedure TEndpointClient.Put(AContents, AAccept, AContentType: String);
var
  LStream: TStringStream;
begin
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      FHttp.Request.Accept := AAccept;
      FHttp.Request.ContentType := AContentType;
      FHttp.Put(FFullURL, LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

procedure TEndpointClient.Put(AResource: String; AContents: String);
var
  LStream: TStringStream;
begin
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      FHttp.Put(String.Format('%s/%s', [FEndpointURL, AResource]), LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

procedure TEndpointClient.Put(AResource, AContents, AAccept, AContentType: String);
var
  LStream: TStringStream;
begin
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      FHttp.Request.Accept := AAccept;
      FHttp.Request.ContentType := AContentType;
      FHttp.Put(String.Format('%s/%s', [FEndpointURL, AResource]), LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Post(AContents: String): String;
var
  LStream: TStringStream;
begin
  Result := String.Empty;
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      Result := FHttp.Post(FFullURL, LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Post(AContents, AAccept, AContentType: String): String;
var
  LStream: TStringStream;
begin
  Result := String.Empty;
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      FHttp.Request.Accept := AAccept;
      FHttp.Request.ContentType := AContentType;
      Result := FHttp.Post(FFullURL, LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Post(AResource: String; AContents: String): String;
var
  LStream: TStringStream;
begin
  Result := String.Empty;
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      Result := FHttp.Post(String.Format('%s/%s', [FEndpointURL, AResource]), LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Post(AResource: String; AContents: String; AAccept: String; AContentType: String): String;
var
  LStream: TStringStream;
begin
  Result := String.Empty;
  FResponseText := String.Empty;
  try
    LStream := TStringStream.Create(AContents);
    try
      FHttp.Request.Accept := AAccept;
      FHttp.Request.ContentType := AContentType;
      Result := FHttp.Post(String.Format('%s/%s', [FEndpointURL, AResource]), LStream);
    finally
      LStream.Free;
    end;
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Delete: String;
begin
  FResponseText := String.Empty;
  try
    Result := FHttp.Delete(FFullURL);
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

function TEndpointClient.Delete(AResource: String): String;
begin
  FResponseText := String.Empty;
  try
    Result := FHttp.Delete(String.Format('%s/%s', [FEndpointURL, AResource]));
  except
    //Do not throw
  end;
  FResponseCode := FHttp.ResponseCode;
  FResponseText := FHttp.ResponseText;
end;

class function TEndpointClient.IsReponseCodeSuccess(AResponseCode: Integer): Boolean;
begin
  Result := ((200 <= AResponseCode) and (AResponseCode < 300));
end;

end.
