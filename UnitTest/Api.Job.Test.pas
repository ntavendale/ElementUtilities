{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit Api.Job.Test;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Classes, ElementApi.Job;

type
  [TestFixture]
  TJobInfoTest = class
  public
    [Test]
    procedure JobInfoTest1;
    [Test]
    procedure JobInfoTest2;
    [Test]
    procedure JobInfoTest3;
    [Test]
    procedure JobInfoListTest1;
    [Test]
    procedure JobInfoListTest2;
    [Test]
    procedure JobInfoListTest3;
  end;

implementation

procedure TJobInfoTest.JobInfoTest1;
const
  TEST_JSON = '{"_links":{"related":{"href":"\/api\/cluster\/"},"self":{"href":"\/api\/cluster\/jobs\/dacfd35d-0413-5343-aa92-368b078f8d48"}},' +
		          '"description":"","end_time":"2021-02-22T17:49:15Z","message":"Create Cluster","start_time":"2021-02-22T17:47:18Z","state":"success","uuid":"dacfd35d-0413-5343-aa92-368b078f8d48"}';
begin
  var LActual := TJobInfo.Create;
  try
    LActual.Links.Add('related', '/api/cluster/');
    LActual.Links.Add('self', '/api/cluster/jobs/dacfd35d-0413-5343-aa92-368b078f8d48');
    LActual.Description := String.Empty;
    LActual.EndTime := '2021-02-22T17:49:15Z';
    LActual.JobMessage := 'Create Cluster';
    LActual.StartTime := '2021-02-22T17:47:18Z';
    LActual.State := 'success';
    LActual.UUID := 'dacfd35d-0413-5343-aa92-368b078f8d48';
    Assert.AreEqual(TEST_JSON, LActual.AsJson);
  finally
    LActual.Free;
  end;
end;

procedure TJobInfoTest.JobInfoTest2;
const
  TEST_JSON = '{"_links":{"related":{"href":""},"self":{"href":"/api/cluster/jobs/160e7a9e-30db-5284-9af4-5de7c2888403"}},' +
		          '"description":"","end_time":"2021-02-22T17:48:29Z","message":"","start_time":"2021-02-22T17:47:55Z","state":"success","uuid":"160e7a9e-30db-5284-9af4-5de7c2888403"}';
begin
  var LActual := TJobInfo.Create(TEST_JSON);
  try
    Assert.AreEqual(String.Empty, LActual.Links.LinkValues['related']);
    Assert.AreEqual('/api/cluster/jobs/160e7a9e-30db-5284-9af4-5de7c2888403', LActual.Links.LinkValues['self']);
    Assert.AreEqual(String.Empty, LActual.Description);
    Assert.AreEqual('2021-02-22T17:48:29Z', LActual.EndTime);
    Assert.AreEqual(String.Empty, LActual.JobMessage);
    Assert.AreEqual('2021-02-22T17:47:55Z', LActual.StartTime);
    Assert.AreEqual('success', LActual.State);
    Assert.AreEqual('160e7a9e-30db-5284-9af4-5de7c2888403', LActual.UUID);
  finally
    LActual.Free;
  end;
end;

procedure TJobInfoTest.JobInfoTest3;
const
  TEST_JSON = '{"_links":{"related":{"href":"/api/volumes/00678dd0-5f28-4880-93b0-7f131992234f"},"self":{"href":"/api/cluster/jobs/3d54b012-aad2-5fc4-baee-ce29f645c19d"}},' +
		          '"description":"Flexvol Creation Job","end_time":"2021-02-22T17:48:59Z","message":"Volume creation complete","start_time":"2021-02-22T17:48:55Z","state":"success","uuid":"3d54b012-aad2-5fc4-baee-ce29f645c19d"}';
begin
  var LObj := TJobInfo.Create(TEST_JSON);
  try
    var LActual := TJobInfo.Create(LObj);
    try
      Assert.AreEqual('/api/volumes/00678dd0-5f28-4880-93b0-7f131992234f', LActual.Links.LinkValues['related']);
      Assert.AreEqual('/api/cluster/jobs/3d54b012-aad2-5fc4-baee-ce29f645c19d', LActual.Links.LinkValues['self']);
      Assert.AreEqual('Flexvol Creation Job', LActual.Description);
      Assert.AreEqual('2021-02-22T17:48:59Z', LActual.EndTime);
      Assert.AreEqual('Volume creation complete', LActual.JobMessage);
      Assert.AreEqual('2021-02-22T17:48:55Z', LActual.StartTime);
      Assert.AreEqual('success', LActual.State);
      Assert.AreEqual('3d54b012-aad2-5fc4-baee-ce29f645c19d', LActual.UUID);
    finally
      LActual.Free;
    end;
  finally
    LObj.Free;
  end;
end;

procedure TJobInfoTest.JobInfoListTest1;
const
  TEST_JSON = '[{"_links":{"related":{"href":"\/api\/cluster\/"},"self":{"href":"\/api\/cluster\/jobs\/dacfd35d-0413-5343-aa92-368b078f8d48"}},' +
		          '"description":"","end_time":"2021-02-22T17:49:15Z","message":"Create Cluster","start_time":"2021-02-22T17:47:18Z","state":"success","uuid":"dacfd35d-0413-5343-aa92-368b078f8d48"},' +
              '{"_links":{"related":{"href":""},"self":{"href":"\/api\/cluster\/jobs\/160e7a9e-30db-5284-9af4-5de7c2888403"}},' +
		          '"description":"","end_time":"2021-02-22T17:48:29Z","message":"","start_time":"2021-02-22T17:47:55Z","state":"success","uuid":"160e7a9e-30db-5284-9af4-5de7c2888403"},' +
              '{"_links":{"related":{"href":"\/api\/volumes\/00678dd0-5f28-4880-93b0-7f131992234f"},"self":{"href":"\/api\/cluster\/jobs\/3d54b012-aad2-5fc4-baee-ce29f645c19d"}},' +
		          '"description":"Flexvol Creation Job","end_time":"2021-02-22T17:48:59Z","message":"Volume creation complete","start_time":"2021-02-22T17:48:55Z","state":"success","uuid":"3d54b012-aad2-5fc4-baee-ce29f645c19d"},' +
              '{"_links":{"related":{"href":""},"self":{"href":"\/api\/cluster\/jobs\/0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3"}},' +
              '"description":"","end_time":"2021-02-23T00:20:52Z","message":"","start_time":"2021-02-23T00:18:52Z","state":"success","uuid":"0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3"}]';
begin
  var LActual := TJobInfoList.Create;
  try
    var LJobInfo := TJobInfo.Create;
    LJobInfo.Links.Add('related', '/api/cluster/');
    LJobInfo.Links.Add('self', '/api/cluster/jobs/dacfd35d-0413-5343-aa92-368b078f8d48');
    LJobInfo.Description := String.Empty;
    LJobInfo.EndTime := '2021-02-22T17:49:15Z';
    LJobInfo.JobMessage := 'Create Cluster';
    LJobInfo.StartTime := '2021-02-22T17:47:18Z';
    LJobInfo.State := 'success';
    LJobInfo.UUID := 'dacfd35d-0413-5343-aa92-368b078f8d48';
    LActual.Add(LJobInfo);
    //

    LJobInfo := TJobInfo.Create;
    LJobInfo.Links.Add('related', String.Empty);
    LJobInfo.Links.Add('self', '/api/cluster/jobs/160e7a9e-30db-5284-9af4-5de7c2888403');
    LJobInfo.Description := String.Empty;
    LJobInfo.EndTime := '2021-02-22T17:48:29Z';
    LJobInfo.JobMessage := String.Empty;;
    LJobInfo.StartTime := '2021-02-22T17:47:55Z';
    LJobInfo.State := 'success';
    LJobInfo.UUID := '160e7a9e-30db-5284-9af4-5de7c2888403';
    LActual.Add(LJobInfo);
    //

    LJobInfo := TJobInfo.Create;
    LJobInfo.Links.Add('related', '/api/volumes/00678dd0-5f28-4880-93b0-7f131992234f');
    LJobInfo.Links.Add('self', '/api/cluster/jobs/3d54b012-aad2-5fc4-baee-ce29f645c19d');
    LJobInfo.Description := 'Flexvol Creation Job';
    LJobInfo.EndTime := '2021-02-22T17:48:59Z';
    LJobInfo.JobMessage := 'Volume creation complete';
    LJobInfo.StartTime := '2021-02-22T17:48:55Z';
    LJobInfo.State := 'success';
    LJobInfo.UUID := '3d54b012-aad2-5fc4-baee-ce29f645c19d';
    LActual.Add(LJobInfo);
    //

    LJobInfo := TJobInfo.Create;
    LJobInfo.Links.Add('related', String.Empty);
    LJobInfo.Links.Add('self', '/api/cluster/jobs/0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3');
    LJobInfo.Description := String.Empty;
    LJobInfo.EndTime := '2021-02-23T00:20:52Z';
    LJobInfo.JobMessage := String.Empty;
    LJobInfo.StartTime := '2021-02-23T00:18:52Z';
    LJobInfo.State := 'success';
    LJobInfo.UUID := '0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3';
    LActual.Add(LJobInfo);

    Assert.AreEqual(TEST_JSON, LActual.AsJSONArray);
  finally
    LActual.Free;
  end;
end;

procedure TJobInfoTest.JobInfoListTest2;
const
  TEST_JSON = '[{"_links":{"related":{"href":"/api/cluster/"},"self":{"href":"/api/cluster/jobs/dacfd35d-0413-5343-aa92-368b078f8d48"}},' +
		          '"description":"","end_time":"2021-02-22T17:49:15Z","message":"Create Cluster","start_time":"2021-02-22T17:47:18Z","state":"success","uuid":"dacfd35d-0413-5343-aa92-368b078f8d48"},' +
              '{"_links":{"related":{"href":""},"self":{"href":"/api/cluster/jobs/160e7a9e-30db-5284-9af4-5de7c2888403"}},' +
		          '"description":"","end_time":"2021-02-22T17:48:29Z","message":"","start_time":"2021-02-22T17:47:55Z","state":"success","uuid":"160e7a9e-30db-5284-9af4-5de7c2888403"},' +
              '{"_links":{"related":{"href":"/api/volumes/00678dd0-5f28-4880-93b0-7f131992234f"},"self":{"href":"/api/cluster/jobs/3d54b012-aad2-5fc4-baee-ce29f645c19d"}},' +
		          '"description":"Flexvol Creation Job","end_time":"2021-02-22T17:48:59Z","message":"Volume creation complete","start_time":"2021-02-22T17:48:55Z","state":"success","uuid":"3d54b012-aad2-5fc4-baee-ce29f645c19d"},' +
              '{"_links":{"related":{"href":""},"self":{"href":"/api/cluster/jobs/0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3"}},' +
              '"description":"","end_time":"2021-02-23T00:20:52Z","message":"","start_time":"2021-02-23T00:18:52Z","state":"success","uuid":"0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3"}]';
begin
  var LActual := TJobInfoList.Create(TEST_JSON);
  try
    Assert.AreEqual(4, LActual.Count);
    Assert.AreEqual('/api/cluster/', LActual[0].Links.LinkValues['related']);
    Assert.AreEqual('/api/cluster/jobs/dacfd35d-0413-5343-aa92-368b078f8d48', LActual[0].Links.LinkValues['self']);
    Assert.AreEqual(String.Empty, LActual[0].Description);
    Assert.AreEqual('2021-02-22T17:49:15Z', LActual[0].EndTime);
    Assert.AreEqual('Create Cluster', LActual[0].JobMessage);
    Assert.AreEqual('2021-02-22T17:47:18Z', LActual[0].StartTime);
    Assert.AreEqual('success', LActual[0].State);
    Assert.AreEqual('dacfd35d-0413-5343-aa92-368b078f8d48', LActual[0].UUID);

    Assert.AreEqual(String.Empty, LActual[1].Links.LinkValues['related']);
    Assert.AreEqual('/api/cluster/jobs/160e7a9e-30db-5284-9af4-5de7c2888403', LActual[1].Links.LinkValues['self']);
    Assert.AreEqual(String.Empty, LActual[1].Description);
    Assert.AreEqual('2021-02-22T17:48:29Z', LActual[1].EndTime);
    Assert.AreEqual(String.Empty, LActual[1].JobMessage);
    Assert.AreEqual('2021-02-22T17:47:55Z', LActual[1].StartTime);
    Assert.AreEqual('success', LActual[1].State);
    Assert.AreEqual('160e7a9e-30db-5284-9af4-5de7c2888403', LActual[1].UUID);

    Assert.AreEqual('/api/volumes/00678dd0-5f28-4880-93b0-7f131992234f', LActual[2].Links.LinkValues['related']);
    Assert.AreEqual('/api/cluster/jobs/3d54b012-aad2-5fc4-baee-ce29f645c19d', LActual[2].Links.LinkValues['self']);
    Assert.AreEqual('Flexvol Creation Job', LActual[2].Description);
    Assert.AreEqual('2021-02-22T17:48:59Z', LActual[2].EndTime);
    Assert.AreEqual('Volume creation complete', LActual[2].JobMessage);
    Assert.AreEqual('2021-02-22T17:48:55Z', LActual[2].StartTime);
    Assert.AreEqual('success', LActual[2].State);
    Assert.AreEqual('3d54b012-aad2-5fc4-baee-ce29f645c19d', LActual[2].UUID);

    Assert.AreEqual(String.Empty, LActual[3].Links.LinkValues['related']);
    Assert.AreEqual('/api/cluster/jobs/0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3', LActual[3].Links.LinkValues['self']);
    Assert.AreEqual(String.Empty, LActual[3].Description);
    Assert.AreEqual('2021-02-23T00:20:52Z', LActual[3].EndTime);
    Assert.AreEqual(String.Empty, LActual[3].JobMessage);
    Assert.AreEqual('2021-02-23T00:18:52Z', LActual[3].StartTime);
    Assert.AreEqual('success', LActual[3].State);
    Assert.AreEqual('0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3', LActual[3].UUID);
  finally
    LActual.Free;
  end;
end;

procedure TJobInfoTest.JobInfoListTest3;
const
  TEST_JSON = '[{"_links":{"related":{"href":"/api/cluster/"},"self":{"href":"/api/cluster/jobs/dacfd35d-0413-5343-aa92-368b078f8d48"}},' +
		          '"description":"","end_time":"2021-02-22T17:49:15Z","message":"Create Cluster","start_time":"2021-02-22T17:47:18Z","state":"success","uuid":"dacfd35d-0413-5343-aa92-368b078f8d48"},' +
              '{"_links":{"related":{"href":""},"self":{"href":"/api/cluster/jobs/160e7a9e-30db-5284-9af4-5de7c2888403"}},' +
		          '"description":"","end_time":"2021-02-22T17:48:29Z","message":"","start_time":"2021-02-22T17:47:55Z","state":"success","uuid":"160e7a9e-30db-5284-9af4-5de7c2888403"},' +
              '{"_links":{"related":{"href":"/api/volumes/00678dd0-5f28-4880-93b0-7f131992234f"},"self":{"href":"/api/cluster/jobs/3d54b012-aad2-5fc4-baee-ce29f645c19d"}},' +
		          '"description":"Flexvol Creation Job","end_time":"2021-02-22T17:48:59Z","message":"Volume creation complete","start_time":"2021-02-22T17:48:55Z","state":"success","uuid":"3d54b012-aad2-5fc4-baee-ce29f645c19d"},' +
              '{"_links":{"related":{"href":""},"self":{"href":"/api/cluster/jobs/0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3"}},' +
              '"description":"","end_time":"2021-02-23T00:20:52Z","message":"","start_time":"2021-02-23T00:18:52Z","state":"success","uuid":"0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3"}]';
begin
  var LObj := TJobInfoList.Create(TEST_JSON);
  try
    var LActual := TJobInfoList.Create(LObj);
    try
      Assert.AreEqual(4, LActual.Count);
      Assert.AreEqual('/api/cluster/', LActual[0].Links.LinkValues['related']);
      Assert.AreEqual('/api/cluster/jobs/dacfd35d-0413-5343-aa92-368b078f8d48', LActual[0].Links.LinkValues['self']);
      Assert.AreEqual(String.Empty, LActual[0].Description);
      Assert.AreEqual('2021-02-22T17:49:15Z', LActual[0].EndTime);
      Assert.AreEqual('Create Cluster', LActual[0].JobMessage);
      Assert.AreEqual('2021-02-22T17:47:18Z', LActual[0].StartTime);
      Assert.AreEqual('success', LActual[0].State);
      Assert.AreEqual('dacfd35d-0413-5343-aa92-368b078f8d48', LActual[0].UUID);

      Assert.AreEqual(String.Empty, LActual[1].Links.LinkValues['related']);
      Assert.AreEqual('/api/cluster/jobs/160e7a9e-30db-5284-9af4-5de7c2888403', LActual[1].Links.LinkValues['self']);
      Assert.AreEqual(String.Empty, LActual[1].Description);
      Assert.AreEqual('2021-02-22T17:48:29Z', LActual[1].EndTime);
      Assert.AreEqual(String.Empty, LActual[1].JobMessage);
      Assert.AreEqual('2021-02-22T17:47:55Z', LActual[1].StartTime);
      Assert.AreEqual('success', LActual[1].State);
      Assert.AreEqual('160e7a9e-30db-5284-9af4-5de7c2888403', LActual[1].UUID);

      Assert.AreEqual('/api/volumes/00678dd0-5f28-4880-93b0-7f131992234f', LActual[2].Links.LinkValues['related']);
      Assert.AreEqual('/api/cluster/jobs/3d54b012-aad2-5fc4-baee-ce29f645c19d', LActual[2].Links.LinkValues['self']);
      Assert.AreEqual('Flexvol Creation Job', LActual[2].Description);
      Assert.AreEqual('2021-02-22T17:48:59Z', LActual[2].EndTime);
      Assert.AreEqual('Volume creation complete', LActual[2].JobMessage);
      Assert.AreEqual('2021-02-22T17:48:55Z', LActual[2].StartTime);
      Assert.AreEqual('success', LActual[2].State);
      Assert.AreEqual('3d54b012-aad2-5fc4-baee-ce29f645c19d', LActual[2].UUID);

      Assert.AreEqual(String.Empty, LActual[3].Links.LinkValues['related']);
      Assert.AreEqual('/api/cluster/jobs/0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3', LActual[3].Links.LinkValues['self']);
      Assert.AreEqual(String.Empty, LActual[3].Description);
      Assert.AreEqual('2021-02-23T00:20:52Z', LActual[3].EndTime);
      Assert.AreEqual(String.Empty, LActual[3].JobMessage);
      Assert.AreEqual('2021-02-23T00:18:52Z', LActual[3].StartTime);
      Assert.AreEqual('success', LActual[3].State);
      Assert.AreEqual('0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3', LActual[3].UUID);
    finally
      LActual.Free;
    end;
  finally
    Lobj.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TJobInfoTest);

end.
