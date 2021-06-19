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
    procedure DriveInfoListTest1;
    [Test]
    procedure DriveInfoListTest2;
    [Test]
    procedure DriveInfoListTest3;
  end;

implementation

procedure TDriveInfoTest.DriveNodeInfoTest1;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"name":"NHCITJJ1718","uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TDriveNodeInfo.Create;
  try
    LObj.Links.Add('self', '/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d');
    LObj.NodeID := 1;
    LObj.Name := 'NHCITJJ1718';
    Lobj.UUID := 'e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d';
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveNodeInfoTest2;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"name":"NHCITJJ1718","uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TDriveNodeInfo.Create;
  try
    LObj.AsJson := TEST_JSON;
    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', Lobj.UUID);
    Assert.AreEqual('NHCITJJ1718', LObj.Name);
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveNodeInfoTest3;
const
  TEST_JSON = '{"_links":{"self":{"href":"\/api\/cluster\/nodes\/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,"name":"NHCITJJ1718","uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}';
begin
  var LObj := TDriveNodeInfo.Create(TEST_JSON);
  try
    Assert.AreEqual('/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', LObj.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj.NodeID);
    Assert.AreEqual('e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d', Lobj.UUID);
    Assert.AreEqual('NHCITJJ1718', LObj.Name);
    Assert.AreEqual(TEST_JSON, LObj.AsJson);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveInfoListTest1;
const
  TEST_JSON = '[{"_links":{"self":{"href":"\/api\/cluster\/drives\/340e2e41-48ef-5394-ba97-1ec3731fd711"}},'+

               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M305640",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme0n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M305640"},"inUse":false,"state":"Available","uuid":"340e2e41-48ef-5394-ba97-1ec3731fd711"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/18aef12a-75c2-5cc3-b178-09c6004bade7"}},'+

               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M305464",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme10n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M305464"},"inUse":false,"state":"Available","uuid":"18aef12a-75c2-5cc3-b178-09c6004bade7"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/8cbfcc7b-129d-5fd4-a915-9d03150db94b"}},'+

               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M301672",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme11n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M301672"},"inUse":false,"state":"Available","uuid":"8cbfcc7b-129d-5fd4-a915-9d03150db94b"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7168df77-f716-55fc-83b3-629f76e30841"}},'+

               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M303955",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme1n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M303955"},"inUse":false,"state":"Available","uuid":"7168df77-f716-55fc-83b3-629f76e30841"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c"}},'+

               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M305694",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme2n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M305694"},"inUse":false,"state":"Available","uuid":"7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/1e2e82d2-dd07-5c16-bf56-321731a8b3e4"}},'+

               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M302436",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme3n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M302436"},"inUse":false,"state":"Available","uuid":"1e2e82d2-dd07-5c16-bf56-321731a8b3e4"}]';
begin
  var LObj := TDriveInfoList.Create;
  try
    var LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/340e2e41-48ef-5394-ba97-1ec3731fd711');

    LInfo.DriveDetail.Capacity := 960197124096;

    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'CXV8202Q';
    LInfo.DriveDetail.Model := 'MZQLW960HMJP-00005';
    LInfo.DriveDetail.Name := 'nvme-sn-S3T1NX0M305640';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.Name := 'NHCITJJ1718';
    LInfo.DriveDetail.Node.UUID := '09a5e748-b83f-5394-8891-bf152e9859f9';

    LInfo.DriveDetail.Path := '/dev/nvme0n1';
    LInfo.DriveDetail.SerialNumber := 'nvme-sn-S3T1NX0M305640';
    LInfo.State := 'Available';
    LInfo.UUID := '340e2e41-48ef-5394-ba97-1ec3731fd711';
    LObj.Add(LInfo);

    LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/18aef12a-75c2-5cc3-b178-09c6004bade7');

    LInfo.DriveDetail.Capacity := 960197124096;
    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'CXV8202Q';
    LInfo.DriveDetail.Model := 'MZQLW960HMJP-00005';
    LInfo.DriveDetail.Name := 'nvme-sn-S3T1NX0M305464';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.Name := 'NHCITJJ1718';
    LInfo.DriveDetail.Node.UUID := '09a5e748-b83f-5394-8891-bf152e9859f9';

    LInfo.DriveDetail.Path := '/dev/nvme10n1';
    LInfo.DriveDetail.SerialNumber := 'nvme-sn-S3T1NX0M305464';
    LInfo.State := 'Available';
    LInfo.UUID := '18aef12a-75c2-5cc3-b178-09c6004bade7';
    LObj.Add(LInfo);

    LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/8cbfcc7b-129d-5fd4-a915-9d03150db94b');

    LInfo.DriveDetail.Capacity := 960197124096;
    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'CXV8202Q';
    LInfo.DriveDetail.Model := 'MZQLW960HMJP-00005';
    LInfo.DriveDetail.Name := 'nvme-sn-S3T1NX0M301672';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.Name := 'NHCITJJ1718';
    LInfo.DriveDetail.Node.UUID := '09a5e748-b83f-5394-8891-bf152e9859f9';

    LInfo.DriveDetail.Path := '/dev/nvme11n1';
    LInfo.DriveDetail.SerialNumber := 'nvme-sn-S3T1NX0M301672';
    LInfo.State := 'Available';
    LInfo.UUID := '8cbfcc7b-129d-5fd4-a915-9d03150db94b';
    LObj.Add(LInfo);

    LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/7168df77-f716-55fc-83b3-629f76e30841');

    LInfo.DriveDetail.Capacity := 960197124096;
    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'CXV8202Q';
    LInfo.DriveDetail.Model := 'MZQLW960HMJP-00005';
    LInfo.DriveDetail.Name := 'nvme-sn-S3T1NX0M303955';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.Name := 'NHCITJJ1718';
    LInfo.DriveDetail.Node.UUID := '09a5e748-b83f-5394-8891-bf152e9859f9';

    LInfo.DriveDetail.Path := '/dev/nvme1n1';
    LInfo.DriveDetail.SerialNumber := 'nvme-sn-S3T1NX0M303955';
    LInfo.State := 'Available';
    LInfo.UUID := '7168df77-f716-55fc-83b3-629f76e30841';
    LObj.Add(LInfo);

    LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c');

    LInfo.DriveDetail.Capacity := 960197124096;
    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'CXV8202Q';
    LInfo.DriveDetail.Model := 'MZQLW960HMJP-00005';
    LInfo.DriveDetail.Name := 'nvme-sn-S3T1NX0M305694';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.Name := 'NHCITJJ1718';
    LInfo.DriveDetail.Node.UUID := '09a5e748-b83f-5394-8891-bf152e9859f9';

    LInfo.DriveDetail.Path := '/dev/nvme2n1';
    LInfo.DriveDetail.SerialNumber := 'nvme-sn-S3T1NX0M305694';
    LInfo.State := 'Available';
    LInfo.UUID := '7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c';
    LObj.Add(LInfo);

    LInfo := TDriveInfo.Create;
    LInfo.Links.Add('self', '/api/cluster/drives/1e2e82d2-dd07-5c16-bf56-321731a8b3e4');

    LInfo.DriveDetail.Capacity := 960197124096;
    LInfo.DriveDetail.DriveFailureDetail := 'None';
    LInfo.DriveDetail.EncryptionCapable := TRUE;
    LInfo.DriveDetail.FirmwareVersion := 'CXV8202Q';
    LInfo.DriveDetail.Model := 'MZQLW960HMJP-00005';
    LInfo.DriveDetail.Name := 'nvme-sn-S3T1NX0M302436';

    LInfo.DriveDetail.Node.Links.Add('self', '/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9');
    LInfo.DriveDetail.Node.NodeID := 1;
    LInfo.DriveDetail.Node.Name := 'NHCITJJ1718';
    LInfo.DriveDetail.Node.UUID := '09a5e748-b83f-5394-8891-bf152e9859f9';

    LInfo.DriveDetail.Path := '/dev/nvme3n1';
    LInfo.DriveDetail.SerialNumber := 'nvme-sn-S3T1NX0M302436';
    LInfo.State := 'Available';
    LInfo.UUID := '1e2e82d2-dd07-5c16-bf56-321731a8b3e4';
    LObj.Add(LInfo);

    Assert.AreEqual(6, LObj.Count);
    Assert.AreEqual(TEST_JSON, LObj.AsJSONArray);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveInfoListTest2;
const
  TEST_JSON = '[{"_links":{"self":{"href":"\/api\/cluster\/drives\/340e2e41-48ef-5394-ba97-1ec3731fd711"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M305640",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme0n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M305640"},"inUse":false,"state":"Available","uuid":"340e2e41-48ef-5394-ba97-1ec3731fd711"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/18aef12a-75c2-5cc3-b178-09c6004bade7"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M305464",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme10n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M305464"},"inUse":false,"state":"Available","uuid":"18aef12a-75c2-5cc3-b178-09c6004bade7"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/8cbfcc7b-129d-5fd4-a915-9d03150db94b"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M301672",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme11n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M301672"},"inUse":false,"state":"Available","uuid":"8cbfcc7b-129d-5fd4-a915-9d03150db94b"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7168df77-f716-55fc-83b3-629f76e30841"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M303955",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme1n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M303955"},"inUse":false,"state":"Available","uuid":"7168df77-f716-55fc-83b3-629f76e30841"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M305694",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme2n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M305694"},"inUse":false,"state":"Available","uuid":"7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/1e2e82d2-dd07-5c16-bf56-321731a8b3e4"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M302436",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme3n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M302436"},"inUse":false,"state":"Available","uuid":"1e2e82d2-dd07-5c16-bf56-321731a8b3e4"}]';
begin
  var LCapacity: NativeUInt;
  var LUsable: NativeUInt;
  var LObj := TDriveInfoList.Create(TEST_JSON);
  try
    Assert.AreEqual(6, LObj.Count);
    Assert.AreEqual('/api/cluster/drives/340e2e41-48ef-5394-ba97-1ec3731fd711', LObj[0].Links.LinkValues['self']);
    LCapacity := 960197124096;
    Assert.AreEqual(LCapacity, LObj[0].DriveDetail.Capacity);

    Assert.AreEqual('None', LObj[0].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[0].DriveDetail.EncryptionCapable);
    Assert.AreEqual('CXV8202Q', LObj[0].DriveDetail.FirmwareVersion);
    Assert.AreEqual('MZQLW960HMJP-00005', LObj[0].DriveDetail.Model);
    Assert.AreEqual('nvme-sn-S3T1NX0M305640', LObj[0].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LObj[0].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[0].DriveDetail.Node.NodeID);
    Assert.AreEqual('NHCITJJ1718', LObj[0].DriveDetail.Node.Name);
    Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LObj[0].DriveDetail.Node.UUID);

    Assert.AreEqual('nvme-sn-S3T1NX0M305640', LObj[0].DriveDetail.SerialNumber);
    Assert.AreEqual('Available', LObj[0].State);
    Assert.AreEqual('340e2e41-48ef-5394-ba97-1ec3731fd711', LObj[0].UUID);
    //

    Assert.AreEqual('/api/cluster/drives/18aef12a-75c2-5cc3-b178-09c6004bade7', LObj[1].Links.LinkValues['self']);
    LCapacity := 960197124096;
    Assert.AreEqual(LCapacity, LObj[1].DriveDetail.Capacity);

    Assert.AreEqual('None', LObj[1].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[1].DriveDetail.EncryptionCapable);
    Assert.AreEqual('CXV8202Q', LObj[1].DriveDetail.FirmwareVersion);
    Assert.AreEqual('MZQLW960HMJP-00005', LObj[1].DriveDetail.Model);
    Assert.AreEqual('nvme-sn-S3T1NX0M305464', LObj[1].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LObj[1].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[1].DriveDetail.Node.NodeID);
    Assert.AreEqual('NHCITJJ1718', LObj[1].DriveDetail.Node.Name);
    Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LObj[1].DriveDetail.Node.UUID);

    Assert.AreEqual('nvme-sn-S3T1NX0M305464', LObj[1].DriveDetail.SerialNumber);
    Assert.AreEqual('Available', LObj[1].State);
    Assert.AreEqual('18aef12a-75c2-5cc3-b178-09c6004bade7', LObj[1].UUID);
    //

    Assert.AreEqual('/api/cluster/drives/8cbfcc7b-129d-5fd4-a915-9d03150db94b', LObj[2].Links.LinkValues['self']);
    LCapacity := 960197124096;
    Assert.AreEqual(LCapacity, LObj[2].DriveDetail.Capacity);

    Assert.AreEqual('None', LObj[2].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[2].DriveDetail.EncryptionCapable);
    Assert.AreEqual('CXV8202Q', LObj[2].DriveDetail.FirmwareVersion);
    Assert.AreEqual('MZQLW960HMJP-00005', LObj[2].DriveDetail.Model);
    Assert.AreEqual('nvme-sn-S3T1NX0M301672', LObj[2].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LObj[2].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[2].DriveDetail.Node.NodeID);
    Assert.AreEqual('NHCITJJ1718', LObj[2].DriveDetail.Node.Name);
    Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LObj[2].DriveDetail.Node.UUID);

    Assert.AreEqual('nvme-sn-S3T1NX0M301672', LObj[2].DriveDetail.SerialNumber);
    Assert.AreEqual('Available', LObj[2].State);
    Assert.AreEqual('8cbfcc7b-129d-5fd4-a915-9d03150db94b', LObj[2].UUID);
    //

    Assert.AreEqual('/api/cluster/drives/7168df77-f716-55fc-83b3-629f76e30841', LObj[3].Links.LinkValues['self']);
    LCapacity := 960197124096;
    Assert.AreEqual(LCapacity, LObj[3].DriveDetail.Capacity);

    Assert.AreEqual('None', LObj[3].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[3].DriveDetail.EncryptionCapable);
    Assert.AreEqual('CXV8202Q', LObj[3].DriveDetail.FirmwareVersion);
    Assert.AreEqual('MZQLW960HMJP-00005', LObj[3].DriveDetail.Model);
    Assert.AreEqual('nvme-sn-S3T1NX0M303955', LObj[3].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LObj[3].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[3].DriveDetail.Node.NodeID);
    Assert.AreEqual('NHCITJJ1718', LObj[3].DriveDetail.Node.Name);
    Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LObj[3].DriveDetail.Node.UUID);

    Assert.AreEqual('nvme-sn-S3T1NX0M303955', LObj[3].DriveDetail.SerialNumber);
    Assert.AreEqual('Available', LObj[3].State);
    Assert.AreEqual('7168df77-f716-55fc-83b3-629f76e30841', LObj[3].UUID);
    //

    Assert.AreEqual('/api/cluster/drives/7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c', LObj[4].Links.LinkValues['self']);
    LCapacity := 960197124096;
    Assert.AreEqual(LCapacity, LObj[4].DriveDetail.Capacity);

    Assert.AreEqual('None', LObj[4].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[4].DriveDetail.EncryptionCapable);
    Assert.AreEqual('CXV8202Q', LObj[4].DriveDetail.FirmwareVersion);
    Assert.AreEqual('MZQLW960HMJP-00005', LObj[4].DriveDetail.Model);
    Assert.AreEqual('nvme-sn-S3T1NX0M305694', LObj[4].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LObj[4].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[4].DriveDetail.Node.NodeID);
    Assert.AreEqual('NHCITJJ1718', LObj[4].DriveDetail.Node.Name);
    Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LObj[4].DriveDetail.Node.UUID);

    Assert.AreEqual('nvme-sn-S3T1NX0M305694', LObj[4].DriveDetail.SerialNumber);
    Assert.AreEqual('Available', LObj[4].State);
    Assert.AreEqual('7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c', LObj[4].UUID);
    //

    Assert.AreEqual('/api/cluster/drives/1e2e82d2-dd07-5c16-bf56-321731a8b3e4', LObj[5].Links.LinkValues['self']);
    LCapacity := 960197124096;
    Assert.AreEqual(LCapacity, LObj[5].DriveDetail.Capacity);

    Assert.AreEqual('None', LObj[5].DriveDetail.DriveFailureDetail);
    Assert.IsTrue(LObj[5].DriveDetail.EncryptionCapable);
    Assert.AreEqual('CXV8202Q', LObj[5].DriveDetail.FirmwareVersion);
    Assert.AreEqual('MZQLW960HMJP-00005', LObj[5].DriveDetail.Model);
    Assert.AreEqual('nvme-sn-S3T1NX0M302436', LObj[5].DriveDetail.Name);

    Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LObj[5].DriveDetail.Node.Links.LinkValues['self']);
    Assert.AreEqual(1, LObj[5].DriveDetail.Node.NodeID);
    Assert.AreEqual('NHCITJJ1718', LObj[5].DriveDetail.Node.Name);
    Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LObj[5].DriveDetail.Node.UUID);

    Assert.AreEqual('nvme-sn-S3T1NX0M302436', LObj[5].DriveDetail.SerialNumber);
    Assert.AreEqual('Available', LObj[5].State);
    Assert.AreEqual('1e2e82d2-dd07-5c16-bf56-321731a8b3e4', LObj[5].UUID);
    //
    Assert.AreEqual(TEST_JSON, LObj.AsJSONArray);
  finally
    LObj.Free;
  end;
end;

procedure TDriveInfoTest.DriveInfoListTest3;
const
  TEST_JSON = '[{"_links":{"self":{"href":"\/api\/cluster\/drives\/340e2e41-48ef-5394-ba97-1ec3731fd711"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M305640",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme0n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M305640"},"inUse":false,"state":"Available","uuid":"340e2e41-48ef-5394-ba97-1ec3731fd711"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/18aef12a-75c2-5cc3-b178-09c6004bade7"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M305464",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme10n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M305464"},"inUse":false,"state":"Available","uuid":"18aef12a-75c2-5cc3-b178-09c6004bade7"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/8cbfcc7b-129d-5fd4-a915-9d03150db94b"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M301672",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme11n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M301672"},"inUse":false,"state":"Available","uuid":"8cbfcc7b-129d-5fd4-a915-9d03150db94b"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7168df77-f716-55fc-83b3-629f76e30841"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M303955",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme1n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M303955"},"inUse":false,"state":"Available","uuid":"7168df77-f716-55fc-83b3-629f76e30841"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M305694",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme2n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M305694"},"inUse":false,"state":"Available","uuid":"7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c"},'+

               '{"_links":{"self":{"href":"\/api\/cluster\/drives\/1e2e82d2-dd07-5c16-bf56-321731a8b3e4"}},'+
               '"detail":{"capacity":960197124096,"driveFailureDetail":"None","encryptionCapable":true,'+
               '"fwVersion":"CXV8202Q","model":"MZQLW960HMJP-00005","name":"nvme-sn-S3T1NX0M302436",'+
               '"node":{"_links":{"self":{"href":"\/api\/cluster\/nodes\/09a5e748-b83f-5394-8891-bf152e9859f9"}},"id":1,"name":"NHCITJJ1718","uuid":"09a5e748-b83f-5394-8891-bf152e9859f9"},"path":"\/dev\/nvme3n1",'+
               '"serialNumber":"nvme-sn-S3T1NX0M302436"},"inUse":false,"state":"Available","uuid":"1e2e82d2-dd07-5c16-bf56-321731a8b3e4"}]';
begin
  var LCapacity: NativeUInt;
  var LUsable: NativeUInt;
  var LObj := TDriveInfoList.Create(TEST_JSON);
  try
    var LActual := TDriveInfoList.Create(LObj);
    try
      Assert.AreEqual(6, LObj.Count);
      Assert.AreEqual('/api/cluster/drives/340e2e41-48ef-5394-ba97-1ec3731fd711', LActual[0].Links.LinkValues['self']);
      LCapacity := 960197124096;
      Assert.AreEqual(LCapacity, LActual[0].DriveDetail.Capacity);

      Assert.AreEqual('None', LActual[0].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[0].DriveDetail.EncryptionCapable);
      Assert.AreEqual('CXV8202Q', LActual[0].DriveDetail.FirmwareVersion);
      Assert.AreEqual('MZQLW960HMJP-00005', LActual[0].DriveDetail.Model);
      Assert.AreEqual('nvme-sn-S3T1NX0M305640', LActual[0].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LActual[0].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[0].DriveDetail.Node.NodeID);
      Assert.AreEqual('NHCITJJ1718', LActual[0].DriveDetail.Node.Name, 'Name 0');
      Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LActual[0].DriveDetail.Node.UUID);

      Assert.AreEqual('nvme-sn-S3T1NX0M305640', LActual[0].DriveDetail.SerialNumber);
      Assert.AreEqual('Available', LActual[0].State);
      Assert.AreEqual('340e2e41-48ef-5394-ba97-1ec3731fd711', LActual[0].UUID);
      //

      Assert.AreEqual('/api/cluster/drives/18aef12a-75c2-5cc3-b178-09c6004bade7', LActual[1].Links.LinkValues['self']);
      LCapacity := 960197124096;
      Assert.AreEqual(LCapacity, LActual[1].DriveDetail.Capacity);

      Assert.AreEqual('None', LActual[1].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[1].DriveDetail.EncryptionCapable);
      Assert.AreEqual('CXV8202Q', LActual[1].DriveDetail.FirmwareVersion);
      Assert.AreEqual('MZQLW960HMJP-00005', LActual[1].DriveDetail.Model);
      Assert.AreEqual('nvme-sn-S3T1NX0M305464', LActual[1].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LActual[1].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[1].DriveDetail.Node.NodeID);
      Assert.AreEqual('NHCITJJ1718', LActual[1].DriveDetail.Node.Name, 'Name 1');
      Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LActual[1].DriveDetail.Node.UUID);

      Assert.AreEqual('nvme-sn-S3T1NX0M305464', LActual[1].DriveDetail.SerialNumber);
      Assert.AreEqual('Available', LActual[1].State);
      Assert.AreEqual('18aef12a-75c2-5cc3-b178-09c6004bade7', LActual[1].UUID);
      //

      Assert.AreEqual('/api/cluster/drives/8cbfcc7b-129d-5fd4-a915-9d03150db94b', LActual[2].Links.LinkValues['self']);
      LCapacity := 960197124096;
      Assert.AreEqual(LCapacity, LActual[2].DriveDetail.Capacity);

      Assert.AreEqual('None', LActual[2].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[2].DriveDetail.EncryptionCapable);
      Assert.AreEqual('CXV8202Q', LActual[2].DriveDetail.FirmwareVersion);
      Assert.AreEqual('MZQLW960HMJP-00005', LActual[2].DriveDetail.Model);
      Assert.AreEqual('nvme-sn-S3T1NX0M301672', LActual[2].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LActual[2].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[2].DriveDetail.Node.NodeID);
      Assert.AreEqual('NHCITJJ1718', LActual[2].DriveDetail.Node.Name);
      Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LActual[2].DriveDetail.Node.UUID);

      Assert.AreEqual('nvme-sn-S3T1NX0M301672', LActual[2].DriveDetail.SerialNumber);
      Assert.AreEqual('Available', LActual[2].State);
      Assert.AreEqual('8cbfcc7b-129d-5fd4-a915-9d03150db94b', LActual[2].UUID);
      //

      Assert.AreEqual('/api/cluster/drives/7168df77-f716-55fc-83b3-629f76e30841', LActual[3].Links.LinkValues['self']);
      LCapacity := 960197124096;
      Assert.AreEqual(LCapacity, LActual[3].DriveDetail.Capacity);

      Assert.AreEqual('None', LActual[3].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[3].DriveDetail.EncryptionCapable);
      Assert.AreEqual('CXV8202Q', LActual[3].DriveDetail.FirmwareVersion);
      Assert.AreEqual('MZQLW960HMJP-00005', LActual[3].DriveDetail.Model);
      Assert.AreEqual('nvme-sn-S3T1NX0M303955', LActual[3].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LActual[3].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[3].DriveDetail.Node.NodeID);
      Assert.AreEqual('NHCITJJ1718', LActual[3].DriveDetail.Node.Name);
      Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LActual[3].DriveDetail.Node.UUID);

      Assert.AreEqual('nvme-sn-S3T1NX0M303955', LActual[3].DriveDetail.SerialNumber);
      Assert.AreEqual('Available', LActual[3].State);
      Assert.AreEqual('7168df77-f716-55fc-83b3-629f76e30841', LActual[3].UUID);
      //

      Assert.AreEqual('/api/cluster/drives/7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c', LActual[4].Links.LinkValues['self']);
      LCapacity := 960197124096;
      Assert.AreEqual(LCapacity, LActual[4].DriveDetail.Capacity);

      Assert.AreEqual('None', LActual[4].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[4].DriveDetail.EncryptionCapable);
      Assert.AreEqual('CXV8202Q', LActual[4].DriveDetail.FirmwareVersion);
      Assert.AreEqual('MZQLW960HMJP-00005', LActual[4].DriveDetail.Model);
      Assert.AreEqual('nvme-sn-S3T1NX0M305694', LActual[4].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LActual[4].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[4].DriveDetail.Node.NodeID);
      Assert.AreEqual('NHCITJJ1718', LActual[4].DriveDetail.Node.Name);
      Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LActual[4].DriveDetail.Node.UUID);

      Assert.AreEqual('nvme-sn-S3T1NX0M305694', LActual[4].DriveDetail.SerialNumber);
      Assert.AreEqual('Available', LActual[4].State);
      Assert.AreEqual('7cb7f7d0-6c66-5b45-87a8-feaef9c6b51c', LActual[4].UUID);
      //

      Assert.AreEqual('/api/cluster/drives/1e2e82d2-dd07-5c16-bf56-321731a8b3e4', LActual[5].Links.LinkValues['self']);
      LCapacity := 960197124096;
      Assert.AreEqual(LCapacity, LActual[5].DriveDetail.Capacity);

      Assert.AreEqual('None', LActual[5].DriveDetail.DriveFailureDetail);
      Assert.IsTrue(LActual[5].DriveDetail.EncryptionCapable);
      Assert.AreEqual('CXV8202Q', LActual[5].DriveDetail.FirmwareVersion);
      Assert.AreEqual('MZQLW960HMJP-00005', LActual[5].DriveDetail.Model);
      Assert.AreEqual('nvme-sn-S3T1NX0M302436', LActual[5].DriveDetail.Name);

      Assert.AreEqual('/api/cluster/nodes/09a5e748-b83f-5394-8891-bf152e9859f9', LActual[5].DriveDetail.Node.Links.LinkValues['self']);
      Assert.AreEqual(1, LActual[5].DriveDetail.Node.NodeID);
      Assert.AreEqual('NHCITJJ1718', LActual[5].DriveDetail.Node.Name);
      Assert.AreEqual('09a5e748-b83f-5394-8891-bf152e9859f9', LActual[5].DriveDetail.Node.UUID);

      Assert.AreEqual('nvme-sn-S3T1NX0M302436', LActual[5].DriveDetail.SerialNumber);
      Assert.AreEqual('Available', LActual[5].State);
      Assert.AreEqual('1e2e82d2-dd07-5c16-bf56-321731a8b3e4', LActual[5].UUID);
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
