{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit Api.Cluster.Test;

interface

uses
  DUnitX.TestFramework, ElementApi.Cluster;

type
  [TestFixture]
  TClusterInfoTest = class
  public
    [Test]
    procedure MasterNodeInfoTest1;
    [Test]
    procedure MasterNodeInfoTest2;
    [Test]
    procedure MasterNodeInfoTest3;
    [Test]
    procedure ClusterMasterInfoTest1;
    [Test]
    procedure ClusterMasterInfoTest2;
    [Test]
    procedure ClusterMasterInfoTest3;
  end;

implementation

procedure TClusterInfoTest.MasterNodeInfoTest1;
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

procedure TClusterInfoTest.MasterNodeInfoTest2;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TMasterNodeInfo.Create;
  try
    LObj.AsJson := TEST_JSON;
    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.Links.LinkValues['self'], 'href error');
    Assert.AreEqual(1, LObj.NodeID, 'NodeID error');
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.UUID, 'uuid error');
  finally
    LObj.Free;
  end;
end;

procedure TClusterInfoTest.MasterNodeInfoTest3;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TMasterNodeInfo.Create(TEST_JSON);
  try
    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.Links.LinkValues['self'], 'href error');
    Assert.AreEqual(1, LObj.NodeID, 'NodeID error');
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.UUID, 'uuid error');
  finally
    LObj.Free;
  end;
end;

procedure TClusterInfoTest.ClusterMasterInfoTest1;
const
  TEST_JSON = '{"encryptionAtRestEnabled":true,"licenseSerialNumber":"123456789","managementVirtualIP":"10.117.67.45",' + '"masterNode":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}' + ',"name":"ff91e0c2-7207-11eb-89a1-02429e1a0002","svip":"10.117.81.95","uuid":"fdc3a79b-4d99-4c15-9c93-7873cc15aaf9"}';
begin
  var LObj := TClusterInfo.Create;
  try
    LObj.EncryptionAtRestEnabled := TRUE;
    LObj.LicenseSerialNumber := '123456789';
    LObj.ManagementVirtualIP := '10.117.67.45';
    LObj.MasterNode.Links.Add('self','/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LObj.MasterNode.NodeID := 1;
    LObj.MasterNode.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';
    LObj.Name := 'ff91e0c2-7207-11eb-89a1-02429e1a0002';
    LObj.SVIP := '10.117.81.95';
    LObj.UUID := 'fdc3a79b-4d99-4c15-9c93-7873cc15aaf9';
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TClusterInfoTest.ClusterMasterInfoTest2;
const
  TEST_JSON = '{"encryptionAtRestEnabled":true,"licenseSerialNumber":"123456789","managementVirtualIP":"10.117.67.45",' + '"masterNode":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}' + ',"name":"ff91e0c2-7207-11eb-89a1-02429e1a0002","svip":"10.117.81.95","uuid":"fdc3a79b-4d99-4c15-9c93-7873cc15aaf9"}';
begin
  var LObj := TClusterInfo.Create;
  try
    LObj.AsJson := TEST_JSON;
    Assert.IsTrue(LObj.EncryptionAtRestEnabled);
    Assert.AreEqual('123456789', LObj.LicenseSerialNumber);
    Assert.AreEqual('10.117.67.45', LObj.ManagementVirtualIP);
    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.MasterNode.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj.MasterNode.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.MasterNode.UUID);
    Assert.AreEqual('ff91e0c2-7207-11eb-89a1-02429e1a0002', LObj.Name);
    Assert.AreEqual('10.117.81.95', LObj.SVIP);
    Assert.AreEqual('fdc3a79b-4d99-4c15-9c93-7873cc15aaf9', LObj.UUID);
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TClusterInfoTest.ClusterMasterInfoTest3;
const
  TEST_JSON = '{"encryptionAtRestEnabled":true,"licenseSerialNumber":"123456789","managementVirtualIP":"10.117.67.45",' + '"masterNode":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}' + ',"name":"ff91e0c2-7207-11eb-89a1-02429e1a0002","svip":"10.117.81.95","uuid":"fdc3a79b-4d99-4c15-9c93-7873cc15aaf9"}';
begin
  var LObj := TClusterInfo.Create(TEST_JSON);
  try
    Assert.IsTrue(LObj.EncryptionAtRestEnabled);
    Assert.AreEqual('123456789', LObj.LicenseSerialNumber);
    Assert.AreEqual('10.117.67.45', LObj.ManagementVirtualIP);
    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.MasterNode.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj.MasterNode.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.MasterNode.UUID);
    Assert.AreEqual('ff91e0c2-7207-11eb-89a1-02429e1a0002', LObj.Name);
    Assert.AreEqual('10.117.81.95', LObj.SVIP);
    Assert.AreEqual('fdc3a79b-4d99-4c15-9c93-7873cc15aaf9', LObj.UUID);
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TClusterInfoTest);

end.
