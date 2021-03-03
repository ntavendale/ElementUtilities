{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit ElementUIMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.SyncObjs, System.Generics.Collections, System.JSON, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinOffice2019Black, dxSkinOffice2019Colorful,
  dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime,
  dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxCheckBox, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxRibbonSkins, cxDataStorage,
  dxRibbonCustomizationForm, dxRibbon, dxBar, cxBarEditItem, cxClasses,
  System.ImageList, Vcl.ImgList, cxImageList, Vcl.StdCtrls, RzEdit, RzTabs,
  Vcl.ExtCtrls, RzPanel, RzSplit, IdSSLOpenSSLHeaders, cxStyles, dxScrollbarAnnotations,
  cxEdit, cxInplaceContainer, cxVGrid, cxCustomData, cxFilter, cxData, cxNavigator,
  dxDateRanges, cxGridCustomTableView, cxGridTableView, cxGridCustomView,
  cxGridLevel, cxGrid, Vcl.Menus, System.UITypes, FileLogger, Utilities, EndPointClient,
  ElementApi.Cluster, ElementApi.Node, ElementApi.Drive, ElementApi.Job;

type
  TLogWriteProc = procedure(AValue: String) of Object;
  TLogReceptionThread = class(TThread)
  private
    FFinishEvent: THandle;
    FLogEvent: Thandle;
    FCrticalSection: TCriticalSection;
    FCurrentLogMessage: String;
    FList: TList<String>;
    FLogWriteProc: TLogWriteProc;
    procedure PushLogToMainThread;
    procedure WriteLogs;
  protected
    procedure TerminatedSet; override;
    procedure Execute; override;
  public
    constructor Create; reintroduce; overload; virtual;
    constructor Create(CreateSuspended: Boolean); reintroduce; overload; virtual;
    destructor Destroy; override;
    procedure AddLog(AValue: String);
    property LogWriteProc: TLogWriteProc read FLogWriteProc write FLogWriteProc;
  end;

  TNodeListDataSource = class(TcxCustomDataSource)
  private
    FNodes: TNodeInfoList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(AJSON: String);
    destructor Destroy; override;
    property Nodes: TNodeInfoList read FNodes;
  end;

  TNodeDrivesListDataSource = class(TcxCustomDataSource)
  private
    FDataSource: TNodeListDataSource; //Master
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(ADataSource: TNodeListDataSource); overload;
    destructor Destroy; override;
    function GetMasterRecordIndex: Integer;
    property MasterDataSource: TNodeListDataSource read FDataSource;
  end;

  TDriveListDataSource = class(TcxCustomDataSource)
  private
    FDrives: TDriveInfoList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(AJSON: String);
    destructor Destroy; override;
    property Drives: TDriveInfoList read FDrives;
  end;

  TJobListDataSource = class(TcxCustomDataSource)
  private
    FList: TJobInfoList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(AJSON: String);
    destructor Destroy; override;
    property Jobs: TJobInfoList read FList;
  end;

  TfmMain = class(TForm)
    ilBarLarge: TcxImageList;
    ilBarSmall: TcxImageList;
    BarManagerMain: TdxBarManager;
    BarCluster: TdxBar;
    BarLog: TdxBar;
    barHelp: TdxBar;
    cxBarEditItem1: TcxBarEditItem;
    btnClusterHealthDetail: TdxBarLargeButton;
    btnSaveLog: TdxBarLargeButton;
    btnClusterInfo: TdxBarLargeButton;
    dxBarLargeButton1: TdxBarLargeButton;
    btnHelpGuide: TdxBarLargeButton;
    btnSetEnglish: TdxBarLargeButton;
    btnSetGerman: TdxBarLargeButton;
    btnSetFrench: TdxBarLargeButton;
    btnSetItalian: TdxBarLargeButton;
    btnSetDutch: TdxBarLargeButton;
    RibbonMain: TdxRibbon;
    RibbonTabCluster: TdxRibbonTab;
    splMain: TRzSplitter;
    pcBottom: TRzPageControl;
    tsLog: TRzTabSheet;
    memLog: TRzMemo;
    pcCluster: TRzPageControl;
    tsClusterInfo: TRzTabSheet;
    btnDrives: TdxBarLargeButton;
    RzGroupBox2: TRzGroupBox;
    vgClusterInfo: TcxVerticalGrid;
    tsDrives: TRzTabSheet;
    ppmNodes: TPopupMenu;
    ppmiDeleteNode: TMenuItem;
    ppmiDeleteNodeDrives: TMenuItem;
    sdLog: TSaveDialog;
    ppmPendingNodes: TPopupMenu;
    ppmiAddNodeToCluster: TMenuItem;
    tsJobs: TRzTabSheet;
    gJobs: TcxGrid;
    tvJobs: TcxGridTableView;
    colJobDescription: TcxGridColumn;
    colJobStartTime: TcxGridColumn;
    colJobEndTime: TcxGridColumn;
    colJobMessage: TcxGridColumn;
    colJobState: TcxGridColumn;
    colJobUUID: TcxGridColumn;
    lvJobs: TcxGridLevel;
    btnJobs: TdxBarLargeButton;
    splNodes: TRzSplitter;
    gbNodes: TRzGroupBox;
    gNodes: TcxGrid;
    tvNodes: TcxGridTableView;
    colNodeID: TcxGridColumn;
    coNodeClusterlP: TcxGridColumn;
    colNodeManangementIP: TcxGridColumn;
    colNodeStorageIP: TcxGridColumn;
    coNodelUUID: TcxGridColumn;
    colNodeRole: TcxGridColumn;
    colNodeVersion: TcxGridColumn;
    tvNodeDrives: TcxGridTableView;
    colNodeDriveUUID: TcxGridColumn;
    tcNodeDriveState: TcxGridColumn;
    lvNodeDrives: TcxGridLevel;
    lvNodeDerives: TcxGridLevel;
    gbPendingNodes: TRzGroupBox;
    gPendingNodes: TcxGrid;
    tvPendingNodes: TcxGridTableView;
    colPendingNodeID: TcxGridColumn;
    colPendingNodeClusterIP: TcxGridColumn;
    colPendingNodeManagementIP: TcxGridColumn;
    colPendingNodeStorageIP: TcxGridColumn;
    colPendingNodeUUID: TcxGridColumn;
    colPendingNodeRole: TcxGridColumn;
    colPendingNodeVersion: TcxGridColumn;
    lvPendingNodes: TcxGridLevel;
    splDrives: TRzSplitter;
    gbDrives: TRzGroupBox;
    gDrives: TcxGrid;
    tvDrives: TcxGridTableView;
    colDriveName: TcxGridColumn;
    colDriveState: TcxGridColumn;
    colDriveModel: TcxGridColumn;
    colDriveNodeID: TcxGridColumn;
    colDriveSlot: TcxGridColumn;
    colDriveFirmwareVersion: TcxGridColumn;
    colDriveEncryptionCapable: TcxGridColumn;
    colDriveUUID: TcxGridColumn;
    lvDrives: TcxGridLevel;
    gbAvailableDrives: TRzGroupBox;
    gUnassignedDrives: TcxGrid;
    tvUnassignedDrives: TcxGridTableView;
    colUnassignedDrivesName: TcxGridColumn;
    colUnassignedDrivesState: TcxGridColumn;
    colUnassignedDrivesModel: TcxGridColumn;
    colUnassignedDrivesNodeID: TcxGridColumn;
    colUnassignedDrivesSlot: TcxGridColumn;
    colUnassignedDrivesFirmwareVersion: TcxGridColumn;
    colUnassignedDrivesEcryptionCapable: TcxGridColumn;
    colUnassignedDrivesUUID: TcxGridColumn;
    lvUnassignedDrives: TcxGridLevel;
    ilMenu: TImageList;
    ppmDrives: TPopupMenu;
    ppmiDeleteDrives: TMenuItem;
    ppmUnassingedDrives: TPopupMenu;
    ppmiAddSelectedDrives: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnClusterInfoClick(Sender: TObject);
    procedure btnDrivesClick(Sender: TObject);
    procedure ppmiDeleteNodeDrivesClick(Sender: TObject);
    procedure btnSaveLogClick(Sender: TObject);
    procedure ppmiDeleteNodeClick(Sender: TObject);
    procedure ppmiAddNodeToClusterClick(Sender: TObject);
    procedure btnJobsClick(Sender: TObject);
    procedure ppmiAddSelectedDrivesClick(Sender: TObject);
    procedure ppmiDeleteDrivesClick(Sender: TObject);
  private
    { Private declarations }
    FLanguageID: Integer;
    FLogReceptionThread: TLogReceptionThread;
    FHostAddress: String;
    FHostPort: WORD;
    procedure WriteLog(AValue: String);
    function GetClusterInfo: TClusterInfo;
    function GetNodes: TNodeInfoList;
    function GetPendingNodes: TNodeInfoList;
    function GetDrives(AUnassigned: Boolean = FALSE): TDriveInfoList;
    function GetJobs: TJobInfoList;
    procedure AddPendingNode(ANodeUUID: String);
    procedure DeleteNode(ANodeUUID: String);
    procedure AddAvailableDrives(ADriveInfoList: TDriveInfoList);
    procedure DeleteDrive(ADriveUUID: String);
    procedure DisplayClusterInfo(AClusterInfo: TClusterInfo);
    procedure LoadNodeGrid(AJSON: String);
    procedure ClearNodeGrid;
    procedure LoadPendingNodeGrid(AJSON: String);
    procedure ClearPendingNodeGrid;
    procedure LoadDrivesGrid(AJSON: String);
    procedure ClearDrivesGrid;
    procedure LoadUnassignedDrivesGrid(AJSON: String);
    procedure ClearUnassignedDrivesGrid;
    procedure LoadJobsGrid(AJSON: String);
    procedure ClearJobsGrid;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBaseURL(AAddress: String; APOrt: WORD);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

{$REGION 'TLogReceptionThread'}
constructor TLogReceptionThread.Create;
begin
  Create(TRUE);
end;

constructor TLogReceptionThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FCrticalSection := TCriticalSection.Create;
  FFinishEvent := CreateEvent(nil, TRUE, FALSE, nil);
  FLogEvent := CreateEvent(nil, TRUE, FALSE, nil);
  FList := TList<String>.Create;
end;

destructor TLogReceptionThread.Destroy;
begin
  FList.Free;
  CloseHandle(FFinishEvent);
  CloseHandle(FLogEvent);
  FCrticalSection.Release;
  FCrticalSection.Free;
  inherited Destroy;
end;

procedure TLogReceptionThread.TerminatedSet;
begin
  SetEvent( FFinishEvent );
end;

procedure TLogReceptionThread.Execute;
var
  LWaitObject: Cardinal;
  LEvents: array[0..1] of THandle;
begin
  LEvents[0] := FFinishEvent;
  LEvents[1] := FLogEvent;
  while not Terminated do
  begin
    LWaitObject := WaitForMultipleObjects(2, @LEvents, FALSE, INFINITE);
    case (LWaitObject - WAIT_OBJECT_0) of
    0:begin
       BREAK;
      end;
    1:begin
       ResetEvent(FLogEvent);
       WriteLogs;
     end;
    end;
  end;
end;

procedure TLogReceptionThread.PushLogToMainThread;
begin
  FLogWriteProc(FCurrentLogMessage);
end;

procedure TLogReceptionThread.WriteLogs;
var
  LNewList, LTempList: TList<String>;
  i: Integer;
begin
  LNewList := TList<String>.Create;
  FCrticalSection.Acquire;
  try
    LTempList := FList;
    FList := LNewList;
  finally
    FCrticalSection.Release;
  end;
  for i := 0 to (LTempList.Count - 1) do
  begin
    if Assigned(FLogWriteProc) then
    begin
      FCurrentLogMessage := LTempList[i];
      Synchronize(PushLogToMainThread);
    end;
  end;
  LTempList.Free;
end;

procedure TLogReceptionThread.AddLog(AValue: String);
begin
  FCrticalSection.Acquire;
  try
    FList.Add(AValue);
    SetEvent(FLogEvent);
  finally
    FCrticalSection.Release;
  end;
end;
{$ENDREGION}

{$REGION 'TNodeListDataSource'}
constructor TNodeListDataSource.Create(AJSON: String);
begin
  FNodes := TNodeInfoList.Create(AJSON);
end;

destructor TNodeListDataSource.Destroy;
begin
  FNodes.Free;
  inherited Destroy;
end;

function TNodeListDataSource.GetRecordCount: Integer;
begin
  Result := FNodes.Count;
end;

function TNodeListDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  LRec: TNodeInfo;
  LCloumnIndex: Integer;
  LRecordIndex: Integer;
begin
  Result := NULL;
  LRecordIndex := Integer(ARecordHandle);
  LRec := FNodes[LRecordIndex];
  if nil = LRec then
    EXIT;

  LCloumnIndex := Integer(AItemHandle);

  case LCloumnIndex of
    0: Result := LRec.NodeID;
    1: Result := LRec.NodeInfoDetail.ClusterIP;
    2: Result := LRec.NodeInfoDetail.ManagementIP;
    3: Result := LRec.NodeInfoDetail.StorageIP;
    4: Result := LRec.UUID;
    5: Result := LRec.NodeInfoDetail.Role;
    6: Result := LRec.NodeInfoDetail.Version;
    6: Result := LRec.NodeInfoDetail.;
  end;
end;
{$ENDREGION}

{$REGION 'TNodeDrivesListDataSource'}
constructor TNodeDrivesListDataSource.Create(ADataSource: TNodeListDataSource);
begin
  FDataSource := ADataSource;
end;

destructor TNodeDrivesListDataSource.Destroy;
begin
  inherited Destroy;
end;

function TNodeDrivesListDataSource.GetRecordCount: Integer;
var
  LMasterRecordIndex: Integer;
begin
  Result := 0;
  LMasterRecordIndex := GetMasterRecordIndex;
  if LMasterRecordIndex >= 0 then
    Result := TNodeListDataSource(MasterDataSource).Nodes[LMasterRecordIndex].NodeInfoDetail.Drives.Count;
end;

function TNodeDrivesListDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  LRec: TNodeDriveInfo;
  LMasterIndx : TNodeInfo;
  LCloumnIndex: Integer;
  LRecordIndex: Integer;
  LMasterRecordIndex: Integer;
begin
  LMasterRecordIndex := GetMasterRecordIndex;
  LCloumnIndex := GetDefaultItemID(Integer(AItemHandle));
  LRecordIndex := Integer(ARecordHandle);
  Result := NULL;

  LMasterIndx := TNodeListDataSource(MasterDataSource).Nodes[LMasterRecordIndex];
  LRec := LMasterIndx.NodeInfoDetail.Drives[LRecordIndex];

  if (nil <> LRec) then
  begin
    case LCloumnIndex of
      0: Result := LRec.UUID;
      1: Result := LRec.State;
    end;
  end;
end;

function TNodeDrivesListDataSource.GetMasterRecordIndex: Integer;
begin
  Result := DataController.GetMasterRecordIndex;
end;
{$ENDREGION'}

{$REGION 'TDriveListDataSource'}
constructor TDriveListDataSource.Create(AJSON: String);
begin
  FDrives := TDriveInfoList.Create(AJSON);
end;

destructor TDriveListDataSource.Destroy;
begin
  FDrives.Free;
  inherited Destroy;
end;

function TDriveListDataSource.GetRecordCount: Integer;
begin
  Result := FDrives.Count;
end;

function TDriveListDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  LRec: TDriveInfo;
  LCloumnIndex: Integer;
  LRecordIndex: Integer;
begin
  Result := NULL;
  LRecordIndex := Integer(ARecordHandle);
  LRec := FDrives[LRecordIndex];
  if nil = LRec then
    EXIT;

  LCloumnIndex := Integer(AItemHandle);

  case LCloumnIndex of
    0: Result := LRec.DriveDetail.Name;
    1: Result := LRec.DriveDetail.State;
    2: Result := LRec.DriveDetail.Model;
    3: Result := LRec.DriveDetail.Node.NodeID;
    4: Result := LRec.DriveDetail.Slot;
    5: Result := LRec.DriveDetail.FirmwareVersion;
    6: Result := LRec.DriveDetail.EncryptionCapable;
    7: Result := LRec.UUID;
  end;
end;
{$ENDREGION}

{$REGION 'TJobListDataSource'}
constructor TJobListDataSource.Create(AJSON: String);
begin
  FList := TJobInfoList.Create(AJSON);
end;

destructor TJobListDataSource.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TJobListDataSource.GetRecordCount: Integer;
begin
  Result := FList.Count;
end;

function TJobListDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  LRec: TJobInfo;
  LCloumnIndex: Integer;
  LRecordIndex: Integer;
begin
  Result := NULL;
  LRecordIndex := Integer(ARecordHandle);
  LRec := FList[LRecordIndex];
  if nil = LRec then
    EXIT;

  LCloumnIndex := Integer(AItemHandle);

  case LCloumnIndex of
    0: Result := LRec.Description;
    1: Result := LRec.StartTime;
    2: Result := LRec.EndTime;
    3: Result := LRec.JobMessage;
    4: Result := LRec.State;
    5: Result := LRec.UUID;
  end;
end;
{$ENDREGION}

{===============================================================================
  Custom Methods
===============================================================================}
constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLogReceptionThread := TLogReceptionThread.Create(TRUE);
  FLogReceptionThread.LogWriteProc := WriteLog;
  FLogReceptionThread.FreeOnTerminate := FALSE;
  TFileLogger.SetFileLogLevel(LOG_DEBUG, FLogReceptionThread.AddLog);
  FLogReceptionThread.Suspended := FALSE;

  LogInfo('Atomic batteries to power. Turbines to speed.');

  var LPath := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  var LeayLib := String.Format('%s\libeay32.dll', [LPath]);
  var LsslLib := String.Format('%s\ssleay32.dll', [LPath]);
  if FileExists( LeayLib ) and FileExists( LsslLib ) then
  begin
    IdOpenSSLSetLibPath(LPath);
    LogInfo(String.Format('OpenSSL Path set to %s', [LPath]));
  end;

  barHelp.Visible := FALSE;
  tsClusterInfo.TabVisible := FALSE;
  tsDrives.TabVisible := FALSE;
  tsJobs.TabVisible := FALSE;
end;

destructor TfmMain.Destroy;
begin
  FLogReceptionThread.Terminate;
  FLogReceptionThread.Free;
  inherited Destroy;
end;


procedure TfmMain.WriteLog(AValue: String);
begin
  memLog.Lines.Add(AValue);
end;

function TfmMain.GetClusterInfo: TClusterInfo;
begin
  {$IFDEF DEBUG}
  Result := TClusterInfo.Create('{"encryptionAtRestEnabled":true,"licenseSerialNumber":"123456789","managementVirtualIP":"10.117.67.45","masterNode":{"_links":{"self":{"href":"/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"id":1,' + '"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"},"name":"ff91e0c2-7207-11eb-89a1-02429e1a0002","svip":"10.117.81.95","uuid":"fdc3a79b-4d99-4c15-9c93-7873cc15aaf9"}');
  EXIT;
  {$ELSE}
  Result := nil;
  {$ENDIF}
  var LGetResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', String.Format('%s', [API_CLUSTER_PATH]));
  try
    try
      LogInfo(String.Format('GET %s', [LEndPoint.FullURL]));
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LogDebug('GET Returned %s', [LGetResponse]);
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
    except
      on E:Exception do
      begin
        LogError('Exeption: %s: %s', [E.Message]);
        EXIT;
      end;
    end;
  finally
    LEndPoint.Free;
  end;

  if not TEndpointClient.IsReponseCodeSuccess(LResponseCode) then
  begin
    LogError('%s: %s', [LResponseText, LGetResponse]);
    EXIT;
  end;

  Result := TClusterInfo.Create(LGetResponse);
end;

function TfmMain.GetNodes: TNodeInfoList;
begin
  {$IFDEF DEBUG}
  Result := TNodeInfoList.Create('[{"_links":{"self":{"href":"/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},' +
                                 '"detail":{"cluster_ip":{"address":"10.117.80.157"},"drives":[{"_links":{"self":' +
                                 '{"href":"/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"},{"_links":{"self":{"href":"/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67"}}' +
                                 ',"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"},{"_links":{"self":{"href":"/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/a6eec0e6-6e43-578c-aaec-e404a6a62f0d"}},'+'"state":"Active","uuid":"a6eec0e6-6e43-578c-aaec-e404a6a62f0d"},{"_links":{"self":{"href":"/api/cluster/drives/895c2810-4ed6-5906-8ecd-d9a8f2cb560a"}},' +
                                 '"state":"Active","uuid":"895c2810-4ed6-5906-8ecd-d9a8f2cb560a"},{"_links":{"self":{"href":"/api/cluster/drives/b9bf9d47-8a39-5491-8afc-83385c5a9761"}},"state":"Active","uuid":"b9bf9d47-8a39-5491-8afc-83385c5a9761"}],'+'"management_ip":{"address":"10.117.64.253"},"role":"Storage","storage_ip":{"address":"10.117.80.157"},"version":"12.75.0.5931100"},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}]');
  EXIT;
  {$ELSE}
  Result := nil;
  {$ENDIF}
  var LGetResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', 'api/cluster/nodes');
  try
    try
      LogInfo('GET %s', [LEndPoint.FullURL]);
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LogDebug('GET Returned %s', [LGetResponse]);
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
    except
      on E:Exception do
      begin
        LogError('Exeption: %s: %s', [E.Message]);
        EXIT;
      end;
    end;
  finally
    LEndPoint.Free;
  end;

  if not TEndpointClient.IsReponseCodeSuccess(LResponseCode) then
  begin
    LogError('%s: %s', [LResponseText, LGetResponse]);
    EXIT;
  end;

  Result := TNodeInfoList.Create;

  var LObj := TJSONObject.ParseJSONValue(LGetResponse) as TJSONObject;
  try
    try
      Result.FromJSONArray(LObj.Values['records'] as TJSONArray);
    except
      LogError(String.Format('Could Not parse JSON %s', [LGetResponse]));
    end;
  finally
    LObj.Free;
  end;
end;

function TfmMain.GetPendingNodes: TNodeInfoList;
begin
  {$IFDEF DEBUG}
  Result := TNodeInfoList.Create('[{"_links":{"self":{"href":"/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},' +
                                 '"detail":{"cluster_ip":{"address":"10.117.80.157"},"drives":[{"_links":{"self":' +
                                 '{"href":"/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"},{"_links":{"self":{"href":"/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67"}}' +
                                 ',"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"},{"_links":{"self":{"href":"/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/a6eec0e6-6e43-578c-aaec-e404a6a62f0d"}},'+'"state":"Active","uuid":"a6eec0e6-6e43-578c-aaec-e404a6a62f0d"},{"_links":{"self":{"href":"/api/cluster/drives/895c2810-4ed6-5906-8ecd-d9a8f2cb560a"}},' +
                                 '"state":"Active","uuid":"895c2810-4ed6-5906-8ecd-d9a8f2cb560a"},{"_links":{"self":{"href":"/api/cluster/drives/b9bf9d47-8a39-5491-8afc-83385c5a9761"}},"state":"Active","uuid":"b9bf9d47-8a39-5491-8afc-83385c5a9761"}],'+'"management_ip":{"address":"10.117.64.253"},"role":"Storage","storage_ip":{"address":"10.117.80.157"},"version":"12.75.0.5931100"},"id":1,"uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}]');
  EXIT;
  {$ELSE}
  Result := nil;
  {$ENDIF}
  var LGetResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', String.Format('%s?status=unassigned', [API_NODE_PATH]));
  try
    try
      LogInfo('GET %s', [LEndPoint.FullURL]);
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LogDebug('GET Returned %s', [LGetResponse]);
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
    except
      on E:Exception do
      begin
        LogError('Exeption: %s: %s', [E.Message]);
        EXIT;
      end;
    end;
  finally
    LEndPoint.Free;
  end;

  if not TEndpointClient.IsReponseCodeSuccess(LResponseCode) then
  begin
    LogError('%s: %s', [LResponseText, LGetResponse]);
    EXIT;
  end;

  Result := TNodeInfoList.Create;

  var LObj := TJSONObject.ParseJSONValue(LGetResponse) as TJSONObject;
  try
    try
      Result.FromJSONArray(LObj.Values['records'] as TJSONArray);
    except
      LogError('Could Not parse JSON %s', [LGetResponse]);
    end;
  finally
    LObj.Free;
  end;
end;

function TfmMain.GetDrives(AUnassigned: Boolean = FALSE): TDriveInfoList;
begin
  {$IFDEF DEBUG}
  Result := TDriveInfoList.Create('[{"_links":{"self":{"href":"\/api\/cluster\/drives\/5aa562ba-7257-5757-a6d3-24f7971c643f"}},' +
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
               '"serialNumber":"scsi-SATA_SAMSUNG_MZ7LM48S2UJNX0K700621","slot":-2,"state":"Active"},"uuid":"b9bf9d47-8a39-5491-8afc-83385c5a9761"}]');
  EXIT;
  {$ELSE}
  Result := nil;
  {$ENDIF}
  var LGetResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LResource: String := String.Format('%s', [API_DRIVE_PATH]);
  if AUnassigned then
    LResource := LResource + '?status=unassigned';
  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', LResource);
  try
    try
      LogInfo('GET %s', [LEndPoint.FullURL]);
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LogDebug('GET Returned %s', [LGetResponse]);
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
    except
      on E:Exception do
      begin
        LogError('Exeption: %s: %s', [E.Message]);
        EXIT;
      end;
    end;
  finally
    LEndPoint.Free;
  end;

  if not TEndpointClient.IsReponseCodeSuccess(LResponseCode) then
  begin
    LogError('%s: %s', [LResponseText, LGetResponse]);
    EXIT;
  end;

  Result := TDriveInfoList.Create;

  var LObj := TJSONObject.ParseJSONValue(LGetResponse) as TJSONObject;
  try
    try
      Result.FromJSONArray(LObj.Values['records'] as TJSONArray);
    except
      LogError(String.Format('Could Not parse JSON %s', [LGetResponse]));
    end;
  finally
    LObj.Free;
  end;
end;

function TfmMain.GetJobs: TJobInfoList;
begin
  {$IFDEF DEBUG}
  Result := TJobInfoList.Create('[{"_links":{"related":{"href":"/api/cluster/"},"self":{"href":"/api/cluster/jobs/dacfd35d-0413-5343-aa92-368b078f8d48"}},' +
		          '"description":"","end_time":"2021-02-22T17:49:15Z","message":"Create Cluster","start_time":"2021-02-22T17:47:18Z","state":"success","uuid":"dacfd35d-0413-5343-aa92-368b078f8d48"},' +

              '{"_links":{"related":{"href":""},"self":{"href":"/api/cluster/jobs/160e7a9e-30db-5284-9af4-5de7c2888403"}},' +
		          '"description":"","end_time":"2021-02-22T17:48:29Z","message":"","start_time":"2021-02-22T17:47:55Z","state":"success","uuid":"160e7a9e-30db-5284-9af4-5de7c2888403"},' +

              '{"_links":{"related":{"href":"/api/volumes/00678dd0-5f28-4880-93b0-7f131992234f"},"self":{"href":"/api/cluster/jobs/3d54b012-aad2-5fc4-baee-ce29f645c19d"}},' +
		          '"description":"Flexvol Creation Job","end_time":"2021-02-22T17:48:59Z","message":"Volume creation complete","start_time":"2021-02-22T17:48:55Z","state":"success","uuid":"3d54b012-aad2-5fc4-baee-ce29f645c19d"},' +

              '{"_links":{"related":{"href":""},"self":{"href":"/api/cluster/jobs/0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3"}},' +
              '"description":"","end_time":"2021-02-23T00:20:52Z","message":"","start_time":"2021-02-23T00:18:52Z","state":"success","uuid":"0a8cf06d-c5e9-50f9-9f6f-0b68a296c5c3"}]');
  EXIT;
  {$ELSE}
  Result := nil;
  {$ENDIF}
  var LGetResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', String.Format('%s', [API_JOB_PATH]));
  try
    try
      LogInfo('GET %s', [LEndPoint.FullURL]);
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LogDebug('GET Returned %s', [LGetResponse]);
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
    except
      on E:Exception do
      begin
        LogError('Exeption: %s: %s', [E.Message]);
        EXIT;
      end;
    end;
  finally
    LEndPoint.Free;
  end;

  if not TEndpointClient.IsReponseCodeSuccess(LResponseCode) then
  begin
    LogError('%s: %s', [LResponseText, LGetResponse]);
    EXIT;
  end;

  Result := TJobInfoList.Create;

  var LObj := TJSONObject.ParseJSONValue(LGetResponse) as TJSONObject;
  try
    try
      Result.FromJSONArray(LObj.Values['records'] as TJSONArray);
    except
      LogError(String.Format('Could Not parse JSON %s', [LGetResponse]));
    end;
  finally
    LObj.Free;
  end;
end;

procedure TfmMain.AddPendingNode(ANodeUUID: String);
begin
  var LPostContents: String;
  var LObj := TJSONObject.Create;
  try
    LObj.AddPair('uuid', ANodeUUID);
    LPostContents := LObj.ToJSON;
  finally
    LObj.Free;
  end;

  var LResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', String.Format('%s', [API_NODE_PATH]));
  try
    try
      LogInfo('POST %s to %s', [LPostContents, LEndPoint.FullURL]);
      Screen.Cursor := crHourglass;
      try
        LResponse := LEndPoint.Post(LPostContents);
      finally
        Screen.Cursor := crDefault;
      end;
      LogDebug('POST Returned %s', [LResponse]);
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
    except
      on E:Exception do
      begin
        LogError('Exeption: %s: %s', [E.Message]);
        EXIT;
      end;
    end;
  finally
    LEndPoint.Free;
  end;

  if not TEndpointClient.IsReponseCodeSuccess(LResponseCode) then
    LogError('%s: %s', [LResponseText, LResponse]);
end;

procedure TfmMain.DeleteNode(ANodeUUID: String);
begin
  var LResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', String.Format('%s/%s', [API_NODE_PATH, ANodeUUID]));
  try
    try
      LogInfo('DELETE %s', [LEndPoint.FullURL]);
      Screen.Cursor := crHourglass;
      try
        LResponse := LEndPoint.Delete;
      finally
        Screen.Cursor := crDefault;
      end;
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
      if TEndpointClient.IsReponseCodeSuccess(LEndPoint.ResponseCode) then
        LogDebug('DELETE Returned %s', [LResponse])
      else
        LogDebug('DELETE Returned %s', [LResponseText])
    except
      on E:Exception do
      begin
        LogError('Exeption: %s: %s', [E.Message]);
        EXIT;
      end;
    end;
  finally
    LEndPoint.Free;
  end;

  if not TEndpointClient.IsReponseCodeSuccess(LResponseCode) then
    LogError('%s: %s', [LResponseText, LResponse]);
end;

procedure TfmMain.AddAvailableDrives(ADriveInfoList: TDriveInfoList);
begin
  if 0 = ADriveInfoList.Count then
    EXIT;

  var LPostContents: String;
  var LPostObject := TJSONObject.Create;
  try
    var LDriveArray := TJSONArray.Create;
    for var i := 0 to (ADriveInfoList.Count - 1) do
    begin
      var LDriveUUID := TJSONObject.Create;
      LDriveUUID.AddPair('uuid', ADriveInfoList[i].UUID);
      LDriveArray.Add(LDriveUUID);
    end;
    LPostObject.AddPair('records', LDriveArray);
    LPostContents := LPostObject.ToJSON;
  finally
    LPostObject.Free;
  end;

  var LResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', String.Format('%s', [API_DRIVE_PATH]));
  try
    try
      LogInfo('POST %s to %s', [LPostContents, LEndPoint.FullURL]);
      Screen.Cursor := crHourglass;
      try
        LResponse := LEndPoint.Post(LPostContents);
      finally
        Screen.Cursor := crDefault;
      end;
      LogDebug('POST Returned %s', [LResponse]);
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
    except
      on E:Exception do
      begin
        LogError('Exeption: %s: %s', [E.Message]);
        EXIT;
      end;
    end;
  finally
    LEndPoint.Free;
  end;

  if not TEndpointClient.IsReponseCodeSuccess(LResponseCode) then
    LogError('%s: %s', [LResponseText, LResponse]);
end;

procedure TfmMain.DeleteDrive(ADriveUUID: String);
begin
  var LResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', String.Format('%s/%s', [API_DRIVE_PATH, ADriveUUID]));
  try
    try
      LogInfo('DELETE %s', [LEndPoint.FullURL]);
      Screen.Cursor := crHourglass;
      try
        LResponse := LEndPoint.Delete;
      finally
        Screen.Cursor := crDefault;
      end;
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
      if TEndpointClient.IsReponseCodeSuccess(LEndPoint.ResponseCode) then
        LogDebug('DELETE Returned %s', [LResponse])
      else
        LogDebug('DELETE Returned %s', [LResponseText]);
    except
      on E:Exception do
      begin
        LogError('Exeption: %s: %s', [E.Message]);
        EXIT;
      end;
    end;
  finally
    LEndPoint.Free;
  end;

  if not TEndpointClient.IsReponseCodeSuccess(LResponseCode) then
    LogError('%s: %s', [LResponseText, LResponse]);
end;

procedure TfmMain.DisplayClusterInfo(AClusterInfo: TClusterInfo);
var
  myCat : TcxCategoryRow;
  myRow : TcxEditorRow;
begin
  vgClusterInfo.BeginUpdate;
  try
    vgClusterInfo.ClearRows;

    myCat := vgClusterInfo.Add( TcxCategoryRow ) As TcxCategoryRow;
    myCat.Properties.Caption := AClusterInfo.Name;

    myRow := vgClusterInfo.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'Encryption At Rest';
    myRow.Properties.DataBinding.ValueTypeClass := TcxBooleanValueType;
    myRow.Properties.Value := AClusterInfo.EncryptionAtRestEnabled;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgClusterInfo.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'Master Node ID';
    myRow.Properties.DataBinding.ValueTypeClass := TcxIntegerValueType;
    myRow.Properties.Value := AClusterInfo.MasterNode.NodeID;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgClusterInfo.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'MVIP';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    myRow.Properties.Value := AClusterInfo.ManagementVirtualIP;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgClusterInfo.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'SVIP';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    myRow.Properties.Value := AClusterInfo.SVIP;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgClusterInfo.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'License Serial #';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    myRow.Properties.Value := AClusterInfo.LicenseSerialNumber;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgClusterInfo.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'UUID';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    myRow.Properties.Value := AClusterInfo.UUID;
    myRow.Properties.Options.Editing := FALSE;
  finally
    vgClusterInfo.EndUpdate;
  end;
end;

procedure TfmMain.LoadNodeGrid(AJSON: String);
var
  LNodes: TNodeListDataSource;
  LDrives: TNodeDrivesListDataSource;
begin
  ClearNodeGrid;
  tvNodes.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvNodes.DataController.CustomDataSource) then
      TNodeListDataSource(tvNodes.DataController.CustomDataSource).Free;

    tvNodes.DataController.BeginFullUpdate;
    try
      LNodes := TNodeListDataSource.Create(AJSON);
      tvNodes.DataController.CustomDataSource := LNodes;
    finally
      tvNodes.DataController.EndFullUpdate;
    end;
  finally
    tvNodes.EndUpdate;
    Screen.Cursor := crDefault;
  end;

  Screen.Cursor := crHourglass;
  tvNodeDrives.BeginUpdate(lsimImmediate);
  try
    tvNodeDrives.DataController.BeginFullUpdate;
    try
      LDrives := TNodeDrivesListDataSource.Create(LNodes);
      tvNodeDrives.DataController.CustomDataSource := LDrives;
    finally
     tvNodeDrives.DataController.EndFullUpdate;
    end;
  finally
    tvNodeDrives.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.ClearNodeGrid;
begin
  Screen.Cursor := crHourglass;
  tvNodeDrives.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvNodeDrives.DataController.CustomDataSource) then
      TNodeDrivesListDataSource(tvNodeDrives.DataController.CustomDataSource).Free;
  finally
    tvNodeDrives.EndUpdate;
    Screen.Cursor := crDefault;
  end;

  tvNodes.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvNodes.DataController.CustomDataSource) then
    begin
      TNodeListDataSource(tvNodes.DataController.CustomDataSource).Free;
      tvNodes.DataController.CustomDataSource := nil;
    end;
  finally
    tvNodes.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.LoadPendingNodeGrid(AJSON: String);
begin
  ClearPendingNodeGrid;
  tvPendingNodes.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvPendingNodes.DataController.CustomDataSource) then
      TNodeListDataSource(tvPendingNodes.DataController.CustomDataSource).Free;

    tvPendingNodes.DataController.BeginFullUpdate;
    try
      tvPendingNodes.DataController.CustomDataSource := TNodeListDataSource.Create(AJSON);
    finally
      tvPendingNodes.DataController.EndFullUpdate;
    end;
  finally
    tvPendingNodes.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.ClearPendingNodeGrid;
begin
  Screen.Cursor := crHourglass;
  tvPendingNodes.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvPendingNodes.DataController.CustomDataSource) then
    begin
      TNodeListDataSource(tvPendingNodes.DataController.CustomDataSource).Free;
      tvPendingNodes.DataController.CustomDataSource := nil;
    end;
  finally
    tvPendingNodes.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.LoadDrivesGrid(AJSON: String);
begin
  ClearDrivesGrid;
  tvDrives.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvDrives.DataController.CustomDataSource) then
      TDriveListDataSource(tvDrives.DataController.CustomDataSource).Free;

    tvDrives.DataController.BeginFullUpdate;
    try
      tvDrives.DataController.CustomDataSource := TDriveListDataSource.Create(AJSON);
    finally
      tvDrives.DataController.EndFullUpdate;
    end;
  finally
    tvDrives.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.ClearDrivesGrid;
begin
  tvDrives.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvDrives.DataController.CustomDataSource) then
    begin
      TDriveListDataSource(tvDrives.DataController.CustomDataSource).Free;
      tvDrives.DataController.CustomDataSource := nil;
    end;
  finally
    tvDrives.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.LoadUnassignedDrivesGrid(AJSON: String);
begin
  ClearUnassignedDrivesGrid;
  tvUnassignedDrives.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvUnassignedDrives.DataController.CustomDataSource) then
      TDriveListDataSource(tvUnassignedDrives.DataController.CustomDataSource).Free;

    tvUnassignedDrives.DataController.BeginFullUpdate;
    try
      tvUnassignedDrives.DataController.CustomDataSource := TDriveListDataSource.Create(AJSON);
    finally
      tvUnassignedDrives.DataController.EndFullUpdate;
    end;
  finally
    tvUnassignedDrives.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.ClearUnassignedDrivesGrid;
begin
  tvUnassignedDrives.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvUnassignedDrives.DataController.CustomDataSource) then
    begin
      TDriveListDataSource(tvUnassignedDrives.DataController.CustomDataSource).Free;
      tvUnassignedDrives.DataController.CustomDataSource := nil;
    end;
  finally
    tvUnassignedDrives.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.LoadJobsGrid(AJSON: String);
begin
  ClearJobsGrid;
  tvJobs.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvJobs.DataController.CustomDataSource) then
      TJobListDataSource(tvJobs.DataController.CustomDataSource).Free;

    tvJobs.DataController.BeginFullUpdate;
    try
      tvJobs.DataController.CustomDataSource := TJobListDataSource.Create(AJSON);
    finally
      tvJobs.DataController.EndFullUpdate;
    end;
  finally
    tvJobs.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.ClearJobsGrid;
begin
  tvJobs.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvJobs.DataController.CustomDataSource) then
    begin
      TJobListDataSource(tvJobs.DataController.CustomDataSource).Free;
      tvJobs.DataController.CustomDataSource := nil;
    end;
  finally
    tvJobs.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.SetBaseURL(AAddress: String; APort: WORD);
begin
  FHostAddress := AAddress;
  FHostPort := APort;
  Self.Caption := String.Format('Element UI %s:%d', [FHostAddress, FHostPort]);
  LogDebug('Host set to %s:%d', [FHostAddress, FHostPort]);
end;
{===============================================================================
  End Of Custom Methods
===============================================================================}
procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := TRUE;
  TUtilities.SetFormKey('Main', 'Language', IntToStr(FLanguageID));
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  btnClusterInfo.Click;
end;

procedure TfmMain.btnClusterInfoClick(Sender: TObject);
begin
  var LInfo := GetClusterInfo;
  try
    DisplayClusterInfo(LInfo);
  finally
    LInfo.Free;
  end;

  var LNodeList := GetNodes;
  try
    LoadNodeGrid(LNodeList.AsJSONArray);
  finally
    LNodeList.Free;
  end;

  LNodeList := GetPendingNodes;
  try
    LoadPendingNodeGrid(LNodeList.AsJSONArray);
  finally
    LNodeList.Free;
  end;

  pcCluster.ActivePageIndex := 0;
end;

procedure TfmMain.btnDrivesClick(Sender: TObject);
begin
  var LDriveList := GetDrives;
  try
    LoadDrivesGrid(LDriveList.AsJSONArray);
  finally
    LDriveList.Free;
  end;

  LDriveList := GetDrives(TRUE);
  try
    LoadUnassignedDrivesGrid(LDriveList.AsJSONArray);
  finally
    LDriveList.Free;
  end;
  pcCluster.ActivePageIndex := 1;
end;

procedure TfmMain.ppmiDeleteNodeClick(Sender: TObject);
begin
  var LIndex := tvNodes.DataController.FocusedRecordIndex;
  if LIndex < 0 then
  begin
    MessageDlg('You must select a node.', mtError, [mbOK], 0);
    EXIT;
  end;

  var LNode :=  TNodeListDataSource(tvNodes.DataController.CustomDataSource).Nodes[LIndex];

  DeleteNode(LNode.UUID);
end;

procedure TfmMain.ppmiDeleteNodeDrivesClick(Sender: TObject);
begin
  var LIndex := tvNodes.DataController.FocusedRecordIndex;
  if LIndex < 0 then
  begin
    MessageDlg('You must select a node.', mtError, [mbOK], 0);
    EXIT;
  end;

  var LNode :=  TNodeListDataSource(tvNodes.DataController.CustomDataSource).Nodes[LIndex];

  for var i := 0 to (LNode.NodeInfoDetail.Drives.Count - 1) do
    DeleteDrive(LNode.NodeInfoDetail.Drives[0].UUID);
end;

procedure TfmMain.btnSaveLogClick(Sender: TObject);
begin
  if not sdLog.Execute then
    EXIT;
  memLog.Lines.SaveToFile(sdLog.FileName);
end;

procedure TfmMain.ppmiAddNodeToClusterClick(Sender: TObject);
begin
  var LIndex := tvPendingNodes.DataController.FocusedRecordIndex;
  if LIndex < 0 then
  begin
    MessageDlg('You must select a node.', mtError, [mbOK], 0);
    EXIT;
  end;

  var LNode := TNodeListDataSource(tvPendingNodes.DataController.CustomDataSource).Nodes[LIndex];

  AddPendingNode(LNode.UUID);
end;

procedure TfmMain.btnJobsClick(Sender: TObject);
begin
  var LJobList := GetJobs;
  try
    LoadJobsGrid(LJobList.AsJSONArray);
  finally
    LJobList.Free;
  end;
  pcCluster.ActivePageIndex := 2;
end;

procedure TfmMain.ppmiAddSelectedDrivesClick(Sender: TObject);
begin
  var LDrives := TDriveInfoList.Create;
  try
    for var i := 0 to (tvUnassignedDrives.Controller.SelectedRecordCount - 1) do
    begin
      var LRecordIndex := tvUnassignedDrives.Controller.SelectedRecords[i].RecordIndex;
      LDrives.Add(TDriveInfo.Create(TDriveListDataSource(tvUnassignedDrives.DataController.CustomDataSource).Drives[LRecordIndex]));
    end;
    AddAvailableDrives(LDrives);
    LogInfo('Added %d drive(s)', [LDrives.Count]);
  finally
    LDrives.Free;
  end;
  btnDrives.Click;
end;

procedure TfmMain.ppmiDeleteDrivesClick(Sender: TObject);
begin
  for var i := 0 to (tvDrives.Controller.SelectedRecordCount - 1) do
  begin
    var LRecordIndex := tvDrives.Controller.SelectedRecords[i].RecordIndex;
    DeleteDrive(TDriveListDataSource(tvDrives.DataController.CustomDataSource).Drives[LRecordIndex].UUID);
  end;
  LogInfo('Deleted %d drive(s)', [tvDrives.Controller.SelectedRecordCount]);
  btnDrives.Click;
end;

end.

