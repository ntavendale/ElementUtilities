{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit Api.Node.Test;

interface

uses
  DUnitX.TestFramework, ElementApi.Node;

type
  [TestFixture]
  TNodeInfoTest = class
  public
    [Test]
    procedure NodeDriveInfoTest1;
    [Test]
    procedure NodeDriveInfoTest2;
    [Test]
    procedure NodeDriveInfoTest3;
    [Test]
    procedure NodeDriveInfoListTest1;
    [Test]
    procedure NodeDriveInfoListTest2;
    [Test]
    procedure NodeDriveInfoListTest3;
    [Test]
    procedure NodeInfoDetailTest1;
    [Test]
    procedure NodeInfoDetailTest2;
    [Test]
    procedure NodeInfoDetailTest3;
    [Test]
    procedure NodeInfoTest1;
    [Test]
    procedure NodeInfoTest2;
    [Test]
    procedure NodeInfoTest3;
  end;

implementation

procedure TNodeInfoTest.NodeDriveInfoTest1;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
begin
  var LObj := TNodeDriveInfo.Create;
  try
    LObj.Links.Add('self', '/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f');
    LObj.State := 'Active';
    Lobj.UUID := '5aa562ba-7257-5757-a6d3-24f7971c643f';
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeDriveInfoTest2;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
begin
  var LObj := TNodeDriveInfo.Create;
  try
    LObj.AsJson := TEST_JSON;
    Assert.AreEqual('/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.State);
    Assert.AreEqual('5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.UUID);
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeDriveInfoTest3;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
begin
  var LObj := TNodeDriveInfo.Create(TEST_JSON);
  try
    Assert.AreEqual('/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.State);
    Assert.AreEqual('5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.UUID);
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeDriveInfoListTest1;
const
  TEST_NODE_DRIVE_JSON_01 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
  TEST_NODE_DRIVE_JSON_02 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"}';
  TEST_NODE_DRIVE_JSON_03 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}';
  TEST_JSON = '[' + TEST_NODE_DRIVE_JSON_01 + ',' + TEST_NODE_DRIVE_JSON_02 + ',' + TEST_NODE_DRIVE_JSON_03 + ']';
begin
  var LObj := TNodeDriveInfoList.Create;
  try
    LObj.Add(TNodeDriveInfo.Create(TEST_NODE_DRIVE_JSON_01));
    LObj.Add(TNodeDriveInfo.Create(TEST_NODE_DRIVE_JSON_02));
    LObj.Add(TNodeDriveInfo.Create(TEST_NODE_DRIVE_JSON_03));
    Assert.AreEqual(3, LObj.Count);
    Assert.AreEqual(TEST_JSON, LObj.AsJSONArray);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeDriveInfoListTest2;
const
  TEST_NODE_DRIVE_JSON_01 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
  TEST_NODE_DRIVE_JSON_02 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"}';
  TEST_NODE_DRIVE_JSON_03 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}';
  TEST_JSON = '[' + TEST_NODE_DRIVE_JSON_01 + ',' + TEST_NODE_DRIVE_JSON_02 + ',' + TEST_NODE_DRIVE_JSON_03 + ']';
begin
  var LObj := TNodeDriveInfoList.Create;
  try
    LObj.AsJSONArray := TEST_JSON;
    Assert.AreEqual(3, LObj.Count);

    Assert.AreEqual('/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f', LObj[0].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj[0].State);
    Assert.AreEqual('5aa562ba-7257-5757-a6d3-24f7971c643f', LObj[0].UUID);

    Assert.AreEqual('/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67', LObj[1].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj[1].State);
    Assert.AreEqual('7116ca99-c93d-5551-885c-8625785f9c67', LObj[1].UUID);

    Assert.AreEqual('/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj[2].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj[2].State);
    Assert.AreEqual('3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj[2].UUID);

    Assert.AreEqual(TEST_JSON, LObj.AsJSONArray);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeDriveInfoListTest3;
const
  TEST_NODE_DRIVE_JSON_01 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
  TEST_NODE_DRIVE_JSON_02 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"}';
  TEST_NODE_DRIVE_JSON_03 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}';
  TEST_JSON = '[' + TEST_NODE_DRIVE_JSON_01 + ',' + TEST_NODE_DRIVE_JSON_02 + ',' + TEST_NODE_DRIVE_JSON_03 + ']';
begin
  var LObj := TNodeDriveInfoList.Create(TEST_JSON);
  try
    Assert.AreEqual(3, LObj.Count);

    Assert.AreEqual('/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f', LObj[0].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj[0].State);
    Assert.AreEqual('5aa562ba-7257-5757-a6d3-24f7971c643f', LObj[0].UUID);

    Assert.AreEqual('/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67', LObj[1].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj[1].State);
    Assert.AreEqual('7116ca99-c93d-5551-885c-8625785f9c67', LObj[1].UUID);

    Assert.AreEqual('/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj[2].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj[2].State);
    Assert.AreEqual('3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj[2].UUID);

    Assert.AreEqual(TEST_JSON, LObj.AsJSONArray);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeInfoDetailTest1;
const
  TEST_NODE_DRIVE_JSON_01 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
  TEST_NODE_DRIVE_JSON_02 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"}';
  TEST_NODE_DRIVE_JSON_03 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}';
  TEST_JSON = '{"cluster_ip":{"address":"10.117.80.157"},"drives":[' + TEST_NODE_DRIVE_JSON_01 + ',' + TEST_NODE_DRIVE_JSON_02 + ',' + TEST_NODE_DRIVE_JSON_03 + '],"maintenance_mode":{"state":"Disabled","variant":"None"},' + '"management_ip":{"address":"10.117.64.253"},"role":"Storage","storage_ip":{"address":"10.117.80.157"},"version":"12.75.0.5931100"}';
begin
  var LObj := TNodeInfoDetail.Create;
  try
    LObj.ClusterIP := '10.117.80.157';
    LObj.Drives.Add(TNodeDriveInfo.Create(TEST_NODE_DRIVE_JSON_01));
    LObj.Drives.Add(TNodeDriveInfo.Create(TEST_NODE_DRIVE_JSON_02));
    LObj.Drives.Add(TNodeDriveInfo.Create(TEST_NODE_DRIVE_JSON_03));

    LObj.MaintenceModeInfo.MaintenceModeState := 'Disabled';
    LObj.MaintenceModeInfo.MaintenceModeVariant := 'None';
    LObj.ManagementIP := '10.117.64.253';
    LObj.Role := 'Storage';
    LObj.StorageIP := '10.117.80.157';
    LObj.Version := '12.75.0.5931100';
    Assert.AreEqual(3, LObj.Drives.Count);
    Assert.AreEqual(TEST_JSON, LObj.AsJSON);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeInfoDetailTest2;
const
  TEST_NODE_DRIVE_JSON_01 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
  TEST_NODE_DRIVE_JSON_02 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"}';
  TEST_NODE_DRIVE_JSON_03 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}';
  TEST_JSON = '{"cluster_ip":{"address":"10.117.80.157"},"drives":[' + TEST_NODE_DRIVE_JSON_01 + ',' + TEST_NODE_DRIVE_JSON_02 + ',' + TEST_NODE_DRIVE_JSON_03 + '],"maintenance_mode":{"state":"Disabled","variant":"None"},' + '"management_ip":{"address":"10.117.64.253"},"role":"Storage","storage_ip":{"address":"10.117.80.157"},"version":"12.75.0.5931100"}';
begin
  var LObj := TNodeInfoDetail.Create;
  try
    LObj.AsJSON := TEST_JSON;
    Assert.AreEqual(3, LObj.Drives.Count);

    Assert.AreEqual('10.117.80.157', LObj.ClusterIP);

    Assert.AreEqual('/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.Drives[0].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.Drives[0].State);
    Assert.AreEqual('5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.Drives[0].UUID);

    Assert.AreEqual('/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67', LObj.Drives[1].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.Drives[1].State);
    Assert.AreEqual('7116ca99-c93d-5551-885c-8625785f9c67', LObj.Drives[1].UUID);

    Assert.AreEqual('/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj.Drives[2].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.Drives[2].State);
    Assert.AreEqual('3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj.Drives[2].UUID);

    Assert.AreEqual('3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj.Drives[2].UUID);

    Assert.AreEqual('Disabled', LObj.MaintenceModeInfo.MaintenceModeState);
    Assert.AreEqual('None', LObj.MaintenceModeInfo.MaintenceModeVariant);
    Assert.AreEqual('10.117.64.253', LObj.ManagementIP);
    Assert.AreEqual('Storage', LObj.Role);
    Assert.AreEqual('10.117.80.157', LObj.StorageIP);
    Assert.AreEqual('12.75.0.5931100', LObj.Version);
    Assert.AreEqual(TEST_JSON, LObj.AsJSON);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeInfoDetailTest3;
const
  TEST_NODE_DRIVE_JSON_01 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
  TEST_NODE_DRIVE_JSON_02 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"}';
  TEST_NODE_DRIVE_JSON_03 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}';
  TEST_JSON = '{"cluster_ip":{"address":"10.117.80.157"},"drives":[' + TEST_NODE_DRIVE_JSON_01 + ',' + TEST_NODE_DRIVE_JSON_02 + ',' + TEST_NODE_DRIVE_JSON_03 + '],"maintenance_mode":{"state":"Disabled","variant":"None"},' + '"management_ip":{"address":"10.117.64.253"},"role":"Storage","storage_ip":{"address":"10.117.80.157"},"version":"12.75.0.5931100"}';
begin
  var LObj := TNodeInfoDetail.Create(TEST_JSON);
  try
    Assert.AreEqual(3, LObj.Drives.Count);

    Assert.AreEqual('10.117.80.157', LObj.ClusterIP);

    Assert.AreEqual('/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.Drives[0].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.Drives[0].State);
    Assert.AreEqual('5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.Drives[0].UUID);

    Assert.AreEqual('/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67', LObj.Drives[1].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.Drives[1].State);
    Assert.AreEqual('7116ca99-c93d-5551-885c-8625785f9c67', LObj.Drives[1].UUID);

    Assert.AreEqual('/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj.Drives[2].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.Drives[2].State);
    Assert.AreEqual('3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj.Drives[2].UUID);

    Assert.AreEqual('3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj.Drives[2].UUID);

    Assert.AreEqual('Disabled', LObj.MaintenceModeInfo.MaintenceModeState);
    Assert.AreEqual('None', LObj.MaintenceModeInfo.MaintenceModeVariant);
    Assert.AreEqual('10.117.64.253', LObj.ManagementIP);
    Assert.AreEqual('Storage', LObj.Role);
    Assert.AreEqual('10.117.80.157', LObj.StorageIP);
    Assert.AreEqual('12.75.0.5931100', LObj.Version);
    Assert.AreEqual(TEST_JSON, LObj.AsJSON);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeInfoTest1;
const
  TEST_NODE_DRIVE_JSON_01 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
  TEST_NODE_DRIVE_JSON_02 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"}';
  TEST_NODE_DRIVE_JSON_03 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}';
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"detail":{"cluster_ip":{"address":"10.117.80.157"},"drives":[' + TEST_NODE_DRIVE_JSON_01 + ',' + TEST_NODE_DRIVE_JSON_02 + ',' + TEST_NODE_DRIVE_JSON_03 + '],"maintenance_mode":{"state":"Disabled","variant":"None"},' + '"management_ip":{"address":"10.117.64.253"},"role":"Storage","storage_ip":{"address":"10.117.80.157"},"version":"12.75.0.5931100"},"id":1,"name":"NHCITJJ1525","uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TNodeInfo.Create;
  try
    LObj.Links.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LObj.NodeInfoDetail.ClusterIP := '10.117.80.157';
    LObj.NodeInfoDetail.Drives.Add(TNodeDriveInfo.Create(TEST_NODE_DRIVE_JSON_01));
    LObj.NodeInfoDetail.Drives.Add(TNodeDriveInfo.Create(TEST_NODE_DRIVE_JSON_02));
    LObj.NodeInfoDetail.Drives.Add(TNodeDriveInfo.Create(TEST_NODE_DRIVE_JSON_03));
    LObj.NodeInfoDetail.MaintenceModeInfo.MaintenceModeState := 'Disabled';
    LObj.NodeInfoDetail.MaintenceModeInfo.MaintenceModeVariant := 'None';
    LObj.NodeInfoDetail.ManagementIP := '10.117.64.253';
    LObj.NodeInfoDetail.Role := 'Storage';
    LObj.NodeInfoDetail.StorageIP := '10.117.80.157';
    LObj.NodeInfoDetail.Version := '12.75.0.5931100';
    LObj.NodeID := 1;
    LObj.Name := 'NHCITJJ1525';
    LObj.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';
    Assert.AreEqual(3, LObj.NodeInfoDetail.Drives.Count);
    Assert.AreEqual(TEST_JSON, LObj.AsJSON);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeInfoTest2;
const
  TEST_NODE_DRIVE_JSON_01 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
  TEST_NODE_DRIVE_JSON_02 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"}';
  TEST_NODE_DRIVE_JSON_03 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}';
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"detail":{"cluster_ip":{"address":"10.117.80.157"},"drives":[' + TEST_NODE_DRIVE_JSON_01 + ',' + TEST_NODE_DRIVE_JSON_02 + ',' + TEST_NODE_DRIVE_JSON_03 + '],"maintenance_mode":{"state":"Disabled","variant":"None"},' + '"management_ip":{"address":"10.117.64.253"},"role":"Storage","storage_ip":{"address":"10.117.80.157"},"version":"12.75.0.5931100"},"id":1,"name":"NHCITJJ1525","uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TNodeInfo.Create;
  try
    LObj.AsJson := TEST_JSON;
    Assert.AreEqual(3, LObj.NodeInfoDetail.Drives.Count);

    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.Links.LinkValues['self']);

    Assert.AreEqual('10.117.80.157', LObj.NodeInfoDetail.ClusterIP);

    Assert.AreEqual('/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.NodeInfoDetail.Drives[0].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.NodeInfoDetail.Drives[0].State);
    Assert.AreEqual('5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.NodeInfoDetail.Drives[0].UUID);

    Assert.AreEqual('/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67', LObj.NodeInfoDetail.Drives[1].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.NodeInfoDetail.Drives[1].State);
    Assert.AreEqual('7116ca99-c93d-5551-885c-8625785f9c67', LObj.NodeInfoDetail.Drives[1].UUID);

    Assert.AreEqual('/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj.NodeInfoDetail.Drives[2].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.NodeInfoDetail.Drives[2].State);
    Assert.AreEqual('3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj.NodeInfoDetail.Drives[2].UUID);

    Assert.AreEqual('Disabled', LObj.NodeInfoDetail.MaintenceModeInfo.MaintenceModeState);
    Assert.AreEqual('None', LObj.NodeInfoDetail.MaintenceModeInfo.MaintenceModeVariant);

    Assert.AreEqual('10.117.64.253', LObj.NodeInfoDetail.ManagementIP);
    Assert.AreEqual('Storage', LObj.NodeInfoDetail.Role);
    Assert.AreEqual('10.117.80.157', LObj.NodeInfoDetail.StorageIP);
    Assert.AreEqual('12.75.0.5931100', LObj.NodeInfoDetail.Version);
    Assert.AreEqual(1, LObj.NodeID);
    Assert.AreEqual('NHCITJJ1525', LObj.Name);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.UUID);
    Assert.AreEqual(TEST_JSON, LObj.AsJSON);
  finally
    LObj.Free;
  end;
end;

procedure TNodeInfoTest.NodeInfoTest3;
const
  TEST_NODE_DRIVE_JSON_01 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"}';
  TEST_NODE_DRIVE_JSON_02 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"}';
  TEST_NODE_DRIVE_JSON_03 = '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}';
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"detail":{"cluster_ip":{"address":"10.117.80.157"},"drives":[' + TEST_NODE_DRIVE_JSON_01 + ',' + TEST_NODE_DRIVE_JSON_02 + ',' + TEST_NODE_DRIVE_JSON_03 + '],"maintenance_mode":{"state":"Disabled","variant":"None"},' + '"management_ip":{"address":"10.117.64.253"},"role":"Storage","storage_ip":{"address":"10.117.80.157"},"version":"12.75.0.5931100"},"id":1,"name":"NHCITJJ1525","uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TNodeInfo.Create(TEST_JSON);
  try
    Assert.AreEqual(3, LObj.NodeInfoDetail.Drives.Count);

    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.Links.LinkValues['self']);

    Assert.AreEqual('10.117.80.157', LObj.NodeInfoDetail.ClusterIP);

    Assert.AreEqual('/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.NodeInfoDetail.Drives[0].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.NodeInfoDetail.Drives[0].State);
    Assert.AreEqual('5aa562ba-7257-5757-a6d3-24f7971c643f', LObj.NodeInfoDetail.Drives[0].UUID);

    Assert.AreEqual('/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67', LObj.NodeInfoDetail.Drives[1].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.NodeInfoDetail.Drives[1].State);
    Assert.AreEqual('7116ca99-c93d-5551-885c-8625785f9c67', LObj.NodeInfoDetail.Drives[1].UUID);

    Assert.AreEqual('/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj.NodeInfoDetail.Drives[2].Links.LinkValues['self']);
    Assert.AreEqual('Active', LObj.NodeInfoDetail.Drives[2].State);
    Assert.AreEqual('3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj.NodeInfoDetail.Drives[2].UUID);

    Assert.AreEqual('Disabled', LObj.NodeInfoDetail.MaintenceModeInfo.MaintenceModeState);
    Assert.AreEqual('None', LObj.NodeInfoDetail.MaintenceModeInfo.MaintenceModeVariant);

    Assert.AreEqual('10.117.64.253', LObj.NodeInfoDetail.ManagementIP);
    Assert.AreEqual('Storage', LObj.NodeInfoDetail.Role);
    Assert.AreEqual('10.117.80.157', LObj.NodeInfoDetail.StorageIP);
    Assert.AreEqual('12.75.0.5931100', LObj.NodeInfoDetail.Version);
    Assert.AreEqual(1, LObj.NodeID);
    Assert.AreEqual('NHCITJJ1525', LObj.Name);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.UUID);
    Assert.AreEqual(TEST_JSON, LObj.AsJSON);
  finally
    LObj.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TNodeInfoTest);

end.
