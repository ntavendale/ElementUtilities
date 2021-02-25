{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit Api.Drive.Test;

interface

uses
  DUnitX.TestFramework, ElementApi.Drive, ElementApi.Link;

type
  [TestFixture]
  TDriveInfoTest = class
  public
    [Test]
    procedure DriveNodeInfoTest1;
    [Test]
    procedure DriveNodeInfoTest2;
    [Test]
    procedure DriveNodeInfoTest3;
    [Test]
    procedure DriveCapacityTest1;
    [Test]
    procedure DriveCapacityTest2;
    [Test]
    procedure DriveCapacityTest3;
    [Test]
    procedure DriveInfoListTest1;
    [Test]
    procedure DriveInfoListTest2;
    [Test]
    procedure DriveInfoListTest3;
  end;

implementation

procedure TDriveInfoTest.DriveNodeInfoTest1;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TDriveNodeInfo.Create;
  try
    LObj.Links.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LObj.NodeID := 1;
    Lobj.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveNodeInfoTest2;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TDriveNodeInfo.Create;
  try
    LObj.AsJson := TEST_JSON;
    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', Lobj.UUID);
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveNodeInfoTest3;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TDriveNodeInfo.Create(TEST_JSON);
  try
    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', Lobj.UUID);
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveCapacityTest1;
const
  TEST_JSON = '{"raw":480103981056,"usable":480038092800}';
begin
  var LObj := TDriveCapacity.Create;
  try
    LObj.Raw := 480103981056;
    Lobj.Usable := 480038092800;
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveCapacityTest2;
const
  TEST_JSON = '{"raw":480103981056,"usable":480038092800}';
begin
  var LObj := TDriveCapacity.Create;
  try
    LObj.AsJson := TEST_JSON;
    var LExpectedRaw: NativeUInt := 480103981056;
    var LExpectedUsable: NativeUInt := 480038092800;
    Assert.AreEqual(LExpectedRaw, LObj.Raw);
    Assert.AreEqual(LExpectedUsable, Lobj.Usable);
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveCapacityTest3;
const
  TEST_JSON = '{"raw":480103981056,"usable":480038092800}';
begin
  var LObj := TDriveCapacity.Create(TEST_JSON);
  try
    var LExpectedRaw: NativeUInt := 480103981056;
    var LExpectedUsable: NativeUInt := 480038092800;
    Assert.AreEqual(LExpectedRaw, LObj.Raw);
    Assert.AreEqual(LExpectedUsable, Lobj.Usable);
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveInfoListTest1;
const
  TEST_JSON = '[{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742","slot":-2,"state":"Active"},"uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596","slot":-2,"state":"Active"},"uuid":"7116ca99-c93d-5551-885c-8625785f9c67"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608","slot":-2,"state":"Active"},"uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/a6eec0e6-6e43-578c-aaec-e404a6a62f0d"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612","slot":-2,"state":"Active"},"uuid":"a6eec0e6-6e43-578c-aaec-e404a6a62f0d"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/895c2810-4ed6-5906-8ecd-d9a8f2cb560a"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620","slot":-2,"state":"Active"},"uuid":"895c2810-4ed6-5906-8ecd-d9a8f2cb560a"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/b9bf9d47-8a39-5491-8afc-83385c5a9761"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621","slot":-2,"state":"Active"},"uuid":"b9bf9d47-8a39-5491-8afc-83385c5a9761"}]';
begin
  var LObj := TDriveInfoList.Create;
  try
    var LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f');

    LInfo.DriveDetail.Capacity.Raw := 480103981056;
    LInfo.DriveDetail.Capacity.Usable := 480038092800;

    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'GXT5404Q';
    LInfo.DriveDetail.Model := 'SAMSUNG MZ7LM480HMHQ-00005';
    LInfo.DriveDetail.Name := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';

    LInfo.DriveDetail.SerialNumber := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742';
    LInfo.DriveDetail.Slot := -2;
    LInfo.DriveDetail.State := 'Active';
    LInfo.UUID := '5aa562ba-7257-5757-a6d3-24f7971c643f';
    LObj.Add(LInfo);

    LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67');

    LInfo.DriveDetail.Capacity.Raw := 480103981056;
    LInfo.DriveDetail.Capacity.Usable := 480038092800;

    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'GXT5404Q';
    LInfo.DriveDetail.Model := 'SAMSUNG MZ7LM480HMHQ-00005';
    LInfo.DriveDetail.Name := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';

    LInfo.DriveDetail.SerialNumber := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596';
    LInfo.DriveDetail.Slot := -2;
    LInfo.DriveDetail.State := 'Active';
    LInfo.UUID := '7116ca99-c93d-5551-885c-8625785f9c67';
    LObj.Add(LInfo);

    LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4');

    LInfo.DriveDetail.Capacity.Raw := 480103981056;
    LInfo.DriveDetail.Capacity.Usable := 480038092800;

    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'GXT5404Q';
    LInfo.DriveDetail.Model := 'SAMSUNG MZ7LM480HMHQ-00005';
    LInfo.DriveDetail.Name := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';

    LInfo.DriveDetail.SerialNumber := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608';
    LInfo.DriveDetail.Slot := -2;
    LInfo.DriveDetail.State := 'Active';
    LInfo.UUID := '3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4';
    LObj.Add(LInfo);

    LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/a6eec0e6-6e43-578c-aaec-e404a6a62f0d');

    LInfo.DriveDetail.Capacity.Raw := 480103981056;
    LInfo.DriveDetail.Capacity.Usable := 480038092800;

    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'GXT5404Q';
    LInfo.DriveDetail.Model := 'SAMSUNG MZ7LM480HMHQ-00005';
    LInfo.DriveDetail.Name := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';

    LInfo.DriveDetail.SerialNumber := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612';
    LInfo.DriveDetail.Slot := -2;
    LInfo.DriveDetail.State := 'Active';
    LInfo.UUID := 'a6eec0e6-6e43-578c-aaec-e404a6a62f0d';
    LObj.Add(LInfo);

    LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/895c2810-4ed6-5906-8ecd-d9a8f2cb560a');

    LInfo.DriveDetail.Capacity.Raw := 480103981056;
    LInfo.DriveDetail.Capacity.Usable := 480038092800;

    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'GXT5404Q';
    LInfo.DriveDetail.Model := 'SAMSUNG MZ7LM480HMHQ-00005';
    LInfo.DriveDetail.Name := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';

    LInfo.DriveDetail.SerialNumber := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620';
    LInfo.DriveDetail.Slot := -2;
    LInfo.DriveDetail.State := 'Active';
    LInfo.UUID := '895c2810-4ed6-5906-8ecd-d9a8f2cb560a';
    LObj.Add(LInfo);

    LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/b9bf9d47-8a39-5491-8afc-83385c5a9761');

    LInfo.DriveDetail.Capacity.Raw := 480103981056;
    LInfo.DriveDetail.Capacity.Usable := 480038092800;

    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'GXT5404Q';
    LInfo.DriveDetail.Model := 'SAMSUNG MZ7LM480HMHQ-00005';
    LInfo.DriveDetail.Name := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';

    LInfo.DriveDetail.SerialNumber := 'scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621';
    LInfo.DriveDetail.Slot := -2;
    LInfo.DriveDetail.State := 'Active';
    LInfo.UUID := 'b9bf9d47-8a39-5491-8afc-83385c5a9761';
    LObj.Add(LInfo);

    Assert.AreEqual(6, LObj.Count);
    Assert.AreEqual(TEST_JSON, LObj.AsJSONArray);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveInfoListTest2;
const
  TEST_JSON = '[{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742","slot":-2,"state":"Active"},"uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596","slot":-2,"state":"Active"},"uuid":"7116ca99-c93d-5551-885c-8625785f9c67"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608","slot":-2,"state":"Active"},"uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/a6eec0e6-6e43-578c-aaec-e404a6a62f0d"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612","slot":-2,"state":"Active"},"uuid":"a6eec0e6-6e43-578c-aaec-e404a6a62f0d"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/895c2810-4ed6-5906-8ecd-d9a8f2cb560a"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620","slot":-2,"state":"Active"},"uuid":"895c2810-4ed6-5906-8ecd-d9a8f2cb560a"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/b9bf9d47-8a39-5491-8afc-83385c5a9761"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621","slot":-2,"state":"Active"},"uuid":"b9bf9d47-8a39-5491-8afc-83385c5a9761"}]';
begin
  var LRaw: NativeUInt;
  var LUsable: NativeUInt;
  var LObj := TDriveInfoList.Create(TEST_JSON);
  try
    Assert.AreEqual(6, LObj.Count);
    Assert.AreEqual('/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f', LObj[0].Links.LinkValues['self']);
    LRaw := 480103981056;
    LUsable := 480038092800;
    Assert.AreEqual(LRaw, LObj[0].DriveDetail.Capacity.Raw);
    Assert.AreEqual(LUsable, LObj[0].DriveDetail.Capacity.Usable);

    Assert.AreEqual('None', LObj[0].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[0].DriveDetail.EncryptionCapable);
    Assert.AreEqual('GXT5404Q', LObj[0].DriveDetail.FirmwareVersion);
    Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LObj[0].DriveDetail.Model);
    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742', LObj[0].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[0].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[0].DriveDetail.Node.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[0].DriveDetail.Node.UUID);

    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742', LObj[0].DriveDetail.SerialNumber);
    Assert.AreEqual(-2, LObj[0].DriveDetail.Slot);
    Assert.AreEqual('Active', LObj[0].DriveDetail.State);
    Assert.AreEqual('5aa562ba-7257-5757-a6d3-24f7971c643f', LObj[0].UUID);
    //

    Assert.AreEqual('/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67', LObj[1].Links.LinkValues['self']);
    LRaw := 480103981056;
    LUsable := 480038092800;
    Assert.AreEqual(LRaw, LObj[1].DriveDetail.Capacity.Raw);
    Assert.AreEqual(LUsable, LObj[1].DriveDetail.Capacity.Usable);

    Assert.AreEqual('None', LObj[1].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[1].DriveDetail.EncryptionCapable);
    Assert.AreEqual('GXT5404Q', LObj[1].DriveDetail.FirmwareVersion);
    Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LObj[1].DriveDetail.Model);
    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596', LObj[1].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[1].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[1].DriveDetail.Node.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[1].DriveDetail.Node.UUID);

    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596', LObj[1].DriveDetail.SerialNumber);
    Assert.AreEqual(-2, LObj[1].DriveDetail.Slot);
    Assert.AreEqual('Active', LObj[1].DriveDetail.State);
    Assert.AreEqual('7116ca99-c93d-5551-885c-8625785f9c67', LObj[1].UUID);
    //

    Assert.AreEqual('/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj[2].Links.LinkValues['self']);
    LRaw := 480103981056;
    LUsable := 480038092800;
    Assert.AreEqual(LRaw, LObj[2].DriveDetail.Capacity.Raw);
    Assert.AreEqual(LUsable, LObj[2].DriveDetail.Capacity.Usable);

    Assert.AreEqual('None', LObj[2].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[2].DriveDetail.EncryptionCapable);
    Assert.AreEqual('GXT5404Q', LObj[2].DriveDetail.FirmwareVersion);
    Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LObj[2].DriveDetail.Model);
    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608', LObj[2].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[2].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[2].DriveDetail.Node.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[2].DriveDetail.Node.UUID);

    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608', LObj[2].DriveDetail.SerialNumber);
    Assert.AreEqual(-2, LObj[2].DriveDetail.Slot);
    Assert.AreEqual('Active', LObj[2].DriveDetail.State);
    Assert.AreEqual('3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LObj[2].UUID);
    //

    Assert.AreEqual('/api/cluster/drives/a6eec0e6-6e43-578c-aaec-e404a6a62f0d', LObj[3].Links.LinkValues['self']);
    LRaw := 480103981056;
    LUsable := 480038092800;
    Assert.AreEqual(LRaw, LObj[3].DriveDetail.Capacity.Raw);
    Assert.AreEqual(LUsable, LObj[3].DriveDetail.Capacity.Usable);

    Assert.AreEqual('None', LObj[3].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[3].DriveDetail.EncryptionCapable);
    Assert.AreEqual('GXT5404Q', LObj[3].DriveDetail.FirmwareVersion);
    Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LObj[3].DriveDetail.Model);
    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612', LObj[3].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[3].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[3].DriveDetail.Node.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[3].DriveDetail.Node.UUID);

    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612', LObj[3].DriveDetail.SerialNumber);
    Assert.AreEqual(-2, LObj[3].DriveDetail.Slot);
    Assert.AreEqual('Active', LObj[3].DriveDetail.State);
    Assert.AreEqual('a6eec0e6-6e43-578c-aaec-e404a6a62f0d', LObj[3].UUID);
    //

    Assert.AreEqual('/api/cluster/drives/895c2810-4ed6-5906-8ecd-d9a8f2cb560a', LObj[4].Links.LinkValues['self']);
    LRaw := 480103981056;
    LUsable := 480038092800;
    Assert.AreEqual(LRaw, LObj[4].DriveDetail.Capacity.Raw);
    Assert.AreEqual(LUsable, LObj[4].DriveDetail.Capacity.Usable);

    Assert.AreEqual('None', LObj[4].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[4].DriveDetail.EncryptionCapable);
    Assert.AreEqual('GXT5404Q', LObj[4].DriveDetail.FirmwareVersion);
    Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LObj[4].DriveDetail.Model);
    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620', LObj[4].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[4].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[4].DriveDetail.Node.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[4].DriveDetail.Node.UUID);

    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620', LObj[4].DriveDetail.SerialNumber);
    Assert.AreEqual(-2, LObj[4].DriveDetail.Slot);
    Assert.AreEqual('Active', LObj[4].DriveDetail.State);
    Assert.AreEqual('895c2810-4ed6-5906-8ecd-d9a8f2cb560a', LObj[4].UUID);
    //

    Assert.AreEqual('/api/cluster/drives/b9bf9d47-8a39-5491-8afc-83385c5a9761', LObj[5].Links.LinkValues['self']);
    LRaw := 480103981056;
    LUsable := 480038092800;
    Assert.AreEqual(LRaw, LObj[5].DriveDetail.Capacity.Raw);
    Assert.AreEqual(LUsable, LObj[5].DriveDetail.Capacity.Usable);

    Assert.AreEqual('None', LObj[5].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[5].DriveDetail.EncryptionCapable);
    Assert.AreEqual('GXT5404Q', LObj[5].DriveDetail.FirmwareVersion);
    Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LObj[5].DriveDetail.Model);
    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621', LObj[5].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[5].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[5].DriveDetail.Node.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj[5].DriveDetail.Node.UUID);

    Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621', LObj[5].DriveDetail.SerialNumber);
    Assert.AreEqual(-2, LObj[5].DriveDetail.Slot);
    Assert.AreEqual('Active', LObj[5].DriveDetail.State);
    Assert.AreEqual('b9bf9d47-8a39-5491-8afc-83385c5a9761', LObj[5].UUID);
    //
    Assert.AreEqual(TEST_JSON, LObj.AsJSONArray);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveInfoListTest3;
const
  TEST_JSON = '[{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742","slot":-2,"state":"Active"},"uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7116ca99-c93d-5551-885c-8625785f9c67"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596","slot":-2,"state":"Active"},"uuid":"7116ca99-c93d-5551-885c-8625785f9c67"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608","slot":-2,"state":"Active"},"uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/a6eec0e6-6e43-578c-aaec-e404a6a62f0d"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612","slot":-2,"state":"Active"},"uuid":"a6eec0e6-6e43-578c-aaec-e404a6a62f0d"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/895c2810-4ed6-5906-8ecd-d9a8f2cb560a"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620","slot":-2,"state":"Active"},"uuid":"895c2810-4ed6-5906-8ecd-d9a8f2cb560a"},' +

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/b9bf9d47-8a39-5491-8afc-83385c5a9761"}},' +
               '"detail":{"capacity":{"raw":480103981056,"usable":480038092800},"driveFailureDetail":"None","encryptionCapable":true,' +
               '"fwVersion":"GXT5404Q","model":"SAMSUNG MZ7LM480HMHQ-00005","name":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621",' +
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},' +
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621","slot":-2,"state":"Active"},"uuid":"b9bf9d47-8a39-5491-8afc-83385c5a9761"}]';
begin
  var LRaw: NativeUInt;
  var LUsable: NativeUInt;
  var LObj := TDriveInfoList.Create(TEST_JSON);
  try
    var LActual := TDriveInfoList.Create(LObj);
    try
      Assert.AreEqual(6, LActual.Count);
      Assert.AreEqual('/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f', LActual[0].Links.LinkValues['self']);
      LRaw := 480103981056;
      LUsable := 480038092800;
      Assert.AreEqual(LRaw, LActual[0].DriveDetail.Capacity.Raw);
      Assert.AreEqual(LUsable, LActual[0].DriveDetail.Capacity.Usable);

      Assert.AreEqual('None', LActual[0].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[0].DriveDetail.EncryptionCapable);
      Assert.AreEqual('GXT5404Q', LActual[0].DriveDetail.FirmwareVersion);
      Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LActual[0].DriveDetail.Model);
      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742', LActual[0].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[0].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[0].DriveDetail.Node.NodeID);
      Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[0].DriveDetail.Node.UUID);

      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700742', LActual[0].DriveDetail.SerialNumber);
      Assert.AreEqual(-2, LActual[0].DriveDetail.Slot);
      Assert.AreEqual('Active', LActual[0].DriveDetail.State);
      Assert.AreEqual('5aa562ba-7257-5757-a6d3-24f7971c643f', LActual[0].UUID);
      //

      Assert.AreEqual('/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67', LActual[1].Links.LinkValues['self']);
      LRaw := 480103981056;
      LUsable := 480038092800;
      Assert.AreEqual(LRaw, LActual[1].DriveDetail.Capacity.Raw);
      Assert.AreEqual(LUsable, LActual[1].DriveDetail.Capacity.Usable);

      Assert.AreEqual('None', LActual[1].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[1].DriveDetail.EncryptionCapable);
      Assert.AreEqual('GXT5404Q', LActual[1].DriveDetail.FirmwareVersion);
      Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LActual[1].DriveDetail.Model);
      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596', LActual[1].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[1].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[1].DriveDetail.Node.NodeID);
      Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[1].DriveDetail.Node.UUID);

      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700596', LActual[1].DriveDetail.SerialNumber);
      Assert.AreEqual(-2, LActual[1].DriveDetail.Slot);
      Assert.AreEqual('Active', LActual[1].DriveDetail.State);
      Assert.AreEqual('7116ca99-c93d-5551-885c-8625785f9c67', LActual[1].UUID);
      //

      Assert.AreEqual('/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LActual[2].Links.LinkValues['self']);
      LRaw := 480103981056;
      LUsable := 480038092800;
      Assert.AreEqual(LRaw, LActual[2].DriveDetail.Capacity.Raw);
      Assert.AreEqual(LUsable, LActual[2].DriveDetail.Capacity.Usable);

      Assert.AreEqual('None', LActual[2].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[2].DriveDetail.EncryptionCapable);
      Assert.AreEqual('GXT5404Q', LActual[2].DriveDetail.FirmwareVersion);
      Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LActual[2].DriveDetail.Model);
      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608', LActual[2].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[2].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[2].DriveDetail.Node.NodeID);
      Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[2].DriveDetail.Node.UUID);

      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700608', LActual[2].DriveDetail.SerialNumber);
      Assert.AreEqual(-2, LActual[2].DriveDetail.Slot);
      Assert.AreEqual('Active', LActual[2].DriveDetail.State);
      Assert.AreEqual('3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4', LActual[2].UUID);
      //

      Assert.AreEqual('/api/cluster/drives/a6eec0e6-6e43-578c-aaec-e404a6a62f0d', LActual[3].Links.LinkValues['self']);
      LRaw := 480103981056;
      LUsable := 480038092800;
      Assert.AreEqual(LRaw, LActual[3].DriveDetail.Capacity.Raw);
      Assert.AreEqual(LUsable, LActual[3].DriveDetail.Capacity.Usable);

      Assert.AreEqual('None', LActual[3].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[3].DriveDetail.EncryptionCapable);
      Assert.AreEqual('GXT5404Q', LActual[3].DriveDetail.FirmwareVersion);
      Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LActual[3].DriveDetail.Model);
      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612', LActual[3].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[3].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[3].DriveDetail.Node.NodeID);
      Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[3].DriveDetail.Node.UUID);

      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700612', LActual[3].DriveDetail.SerialNumber);
      Assert.AreEqual(-2, LActual[3].DriveDetail.Slot);
      Assert.AreEqual('Active', LActual[3].DriveDetail.State);
      Assert.AreEqual('a6eec0e6-6e43-578c-aaec-e404a6a62f0d', LActual[3].UUID);
      //

      Assert.AreEqual('/api/cluster/drives/895c2810-4ed6-5906-8ecd-d9a8f2cb560a', LActual[4].Links.LinkValues['self']);
      LRaw := 480103981056;
      LUsable := 480038092800;
      Assert.AreEqual(LRaw, LActual[4].DriveDetail.Capacity.Raw);
      Assert.AreEqual(LUsable, LActual[4].DriveDetail.Capacity.Usable);

      Assert.AreEqual('None', LActual[4].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[4].DriveDetail.EncryptionCapable);
      Assert.AreEqual('GXT5404Q', LActual[4].DriveDetail.FirmwareVersion);
      Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LActual[4].DriveDetail.Model);
      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620', LActual[4].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[4].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[4].DriveDetail.Node.NodeID);
      Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[4].DriveDetail.Node.UUID);

      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700620', LActual[4].DriveDetail.SerialNumber);
      Assert.AreEqual(-2, LActual[4].DriveDetail.Slot);
      Assert.AreEqual('Active', LActual[4].DriveDetail.State);
      Assert.AreEqual('895c2810-4ed6-5906-8ecd-d9a8f2cb560a', LActual[4].UUID);
      //

      Assert.AreEqual('/api/cluster/drives/b9bf9d47-8a39-5491-8afc-83385c5a9761', LActual[5].Links.LinkValues['self']);
      LRaw := 480103981056;
      LUsable := 480038092800;
      Assert.AreEqual(LRaw, LActual[5].DriveDetail.Capacity.Raw);
      Assert.AreEqual(LUsable, LActual[5].DriveDetail.Capacity.Usable);

      Assert.AreEqual('None', LActual[5].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[5].DriveDetail.EncryptionCapable);
      Assert.AreEqual('GXT5404Q', LActual[5].DriveDetail.FirmwareVersion);
      Assert.AreEqual('SAMSUNG MZ7LM480HMHQ-00005', LActual[5].DriveDetail.Model);
      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621', LActual[5].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[5].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[5].DriveDetail.Node.NodeID);
      Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LActual[5].DriveDetail.Node.UUID);

      Assert.AreEqual('scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621', LActual[5].DriveDetail.SerialNumber);
      Assert.AreEqual(-2, LActual[5].DriveDetail.Slot);
      Assert.AreEqual('Active', LActual[5].DriveDetail.State);
      Assert.AreEqual('b9bf9d47-8a39-5491-8afc-83385c5a9761', LActual[5].UUID);
      //
      Assert.AreEqual(TEST_JSON, LActual.AsJSONArray);
    finally
      LActual.Free;
    end;
  finally
    LObj.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TDriveInfoTest);

end.
