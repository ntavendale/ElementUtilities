{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit Api.Link.Test;

interface

uses
  DUnitX.TestFramework, ElementApi.Link;

type
  [TestFixture]
  TLinksTest = class
  public
    [Test]
    procedure Test1;
    [Test]
    procedure Test2;
  end;

implementation

procedure TLinksTest.Test1;
const
  TEST_JSON = '{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}}';
begin
  var LObj := TLinks.Create;
  try
    LObj.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TLinksTest.Test2;
const
  TEST_JSON = '{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}}';
begin
  var LObj := TLinks.Create;
  try
    LObj.AsJson := TEST_JSON;
    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.LinkValues['self']);
  finally
    LObj.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLinksTest);

end.
