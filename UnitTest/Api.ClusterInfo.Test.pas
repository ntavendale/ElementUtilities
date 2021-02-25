{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit Api.ClusterInfo.Test;

interface

uses
  DUnitX.TestFramework, ElementApi.Cluster;

type
  [TestFixture]
  TClusterInfoTest = class
  public
    [Test]
    procedure Test1;
  end;

implementation

procedure TClusterInfoTest.Test1;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TMasterNodeInfo.Create;
  try
    LObj.Links.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LObj.NodeID := 1;
    LObj.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TClusterInfoTest);

end.
