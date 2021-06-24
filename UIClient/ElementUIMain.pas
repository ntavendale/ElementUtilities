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
  Vcl.Forms, Vcl.Dialogs, System.IOUtils, dxSkinsCore, dxSkinBasic, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans,
  dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
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
  ElementApi.Cluster, ElementApi.Node, ElementApi.Drive, ElementApi.Job, ElementApi.QosPolicy;

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

  TDataRefreshThread = class(TThread)
  private
    FFinishEvent: THandle;
    FRefreshSeconds: Integer;
    FFormHandle: THandle;
  protected
    procedure TerminatedSet; override;
    procedure Execute; override;
  public
    constructor Create; reintroduce; overload; virtual;
    constructor Create(CreateSuspended: Boolean; ARefreshSeconds: Integer; AFormHandle: THandle); reintroduce; overload; virtual;
    destructor Destroy; override;
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

  TQosPolicyListDataSource = class(TcxCustomDataSource)
  private
    FList: TQosPolicyList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(AJSON: String);
    destructor Destroy; override;
    property QosPolicies: TQosPolicyList read FList;
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
    btnRefresh: TdxBarLargeButton;
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
    colDrivePath: TcxGridColumn;
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
    gbJobs: TRzGroupBox;
    gJobs: TcxGrid;
    tvJobs: TcxGridTableView;
    colJobDescription: TcxGridColumn;
    colJobStartTime: TcxGridColumn;
    colJobEndTime: TcxGridColumn;
    colJobMessage: TcxGridColumn;
    colJobState: TcxGridColumn;
    colJobUUID: TcxGridColumn;
    lvJobs: TcxGridLevel;
    gbJobError: TRzGroupBox;
    vgJobError: TcxVerticalGrid;
    colNodesName: TcxGridColumn;
    volPendingNodeName: TcxGridColumn;
    tsQosPolicy: TRzTabSheet;
    gbQosPOlicies: TRzGroupBox;
    btnQosPolicies: TdxBarLargeButton;
    pnCosts: TPanel;
    vgCurve: TcxVerticalGrid;
    crCosts: TcxCategoryRow;
    pnQosGrid: TPanel;
    gQosPolicies: TcxGrid;
    tvQosPolicies: TcxGridTableView;
    colQosDescription: TcxGridColumn;
    colQosBurstIOPS: TcxGridColumn;
    colQosBurstTime: TcxGridColumn;
    colQosMaxIOPS: TcxGridColumn;
    colQosMinIOPS: TcxGridColumn;
    colQosPoliciesUUID: TcxGridColumn;
    lvQosPolicies: TcxGridLevel;
    colReachable: TcxGridColumn;
    colState: TcxGridColumn;
    colPendingNodeState: TcxGridColumn;
    colPendingNodeReachable: TcxGridColumn;
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
    procedure tvJobsFocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure btnQosPoliciesClick(Sender: TObject);
    procedure tvQosPoliciesFocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure btnRefreshClick(Sender: TObject);
  private
    { Private declarations }
    FLanguageID: Integer;
    FLogReceptionThread: TLogReceptionThread;
    FRefreshThread: TDataRefreshThread;
    FHostAddress: String;
    FHostPort: WORD;
    procedure WriteLog(AValue: String);
    function GetClusterInfo: TClusterInfo;
    function GetNodes: TNodeInfoList;
    function GetPendingNodes: TNodeInfoList;
    function GetDrives(AUnassigned: Boolean = FALSE): TDriveInfoList;
    function GetJobs: TJobInfoList;
    function GetQosPolicies: TQosPolicyList;
    procedure AddPendingNode(ANodeUUID: String);
    procedure DeleteNode(ANodeUUID: String);
    procedure AddAvailableDrives(ADriveInfoList: TDriveInfoList);
    procedure DeleteDrive(ADriveUUID: String);
    procedure DisplayClusterInfo(AClusterInfo: TClusterInfo);
    procedure DisplayCosts(ACostList: TCostList);
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
    procedure LoadQosPoliciesGrid(AJSON: String);
    procedure ClearQosPoliciesGrid;
    procedure DisplayJobError(AErrorCode, AErrorMessage: String);
  protected
    procedure LoadClusterAndNodes;
    procedure LoadDrives;
    procedure LoadJobs;
    procedure LoadQosPolicies;
    procedure StartRefreshThread;
    procedure StopRefreshThread;
    procedure OnRefreshRequest(var Msg: TMessage); message WM_REFRESH_MSG;
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

{$REGION 'TDataRefreshThread'}
constructor TDataRefreshThread.Create;
begin
  Create(TRUE);
end;

constructor TDataRefreshThread.Create(CreateSuspended: Boolean; ARefreshSeconds: Integer; AFormHandle: THandle);
begin
  inherited Create(CreateSuspended);
  FFinishEvent := CreateEvent(nil, TRUE, FALSE, nil);
  FRefreshSeconds := ARefreshSeconds;
  FFormHandle := AFormHandle;
end;

destructor TDataRefreshThread.Destroy;
begin
  CloseHandle(FFinishEvent);
  inherited Destroy;
end;

procedure TDataRefreshThread.TerminatedSet;
begin
  SetEvent( FFinishEvent );
end;

procedure TDataRefreshThread.Execute;
begin
  while not Terminated do
  begin
    case WaitForSingleObject(FFinishEvent, FRefreshSeconds * 1000) of
    WAIT_TIMEOUT:SendMessage(FFormHandle, WM_REFRESH_MSG, 0, 0);
    WAIT_OBJECT_0: BREAK;
    WAIT_FAILED: begin
        var LErr := GetLastError;
        LogError('WaitForSingleObject Falied. Error Code %d: %s', [LErr, SysErrorMessage(LErr)]);
      end;
    WAIT_ABANDONED: LogError('WaitForSingleObject Abandoned. The progreammer fucked up!'); //Shoudn't happen.
    end;
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
    1: Result := LRec.Name;
    2: Result := LRec.NodeInfoDetail.ClusterIP;
    3: Result := LRec.NodeInfoDetail.ManagementIP;
    4: Result := LRec.NodeInfoDetail.StorageIP;
    5: Result := LRec.UUID;
    6: Result := LRec.NodeInfoDetail.Role;
    7: Result := LRec.NodeInfoDetail.Version;
    8: Result := LRec.NodeInfoDetail.Status.Reachable;
    9: Result := LRec.NodeInfoDetail.Status.State;
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
    1: Result := LRec.State;
    2: Result := LRec.DriveDetail.Model;
    3: Result := LRec.DriveDetail.Node.NodeID;
    4: Result := LRec.DriveDetail.Path;
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

{$REGION 'TQosPolicyListDataSource'}
constructor TQosPolicyListDataSource.Create(AJSON: String);
begin
  FList := TQosPolicyList.Create(AJSON);
end;

destructor TQosPolicyListDataSource.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TQosPolicyListDataSource.GetRecordCount: Integer;
begin
  Result := FList.Count;
end;

function TQosPolicyListDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
begin
  Result := NULL;
  var LRecordIndex := Integer(ARecordHandle);
  var LRec := FList[LRecordIndex];
  if nil = LRec then
    EXIT;

  var LCloumnIndex := Integer(AItemHandle);

  case LCloumnIndex of
    0: Result := LRec.Description;
    1: Result := LRec.BurstIOPS;
    2: Result := LRec.BurstTime;
    3: Result := LRec.MaxIOPS;
    4: Result := LRec.MinIOPS;
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

  barHelp.Visible := TRUE;
  tsClusterInfo.TabVisible := FALSE;
  tsDrives.TabVisible := FALSE;
  tsJobs.TabVisible := FALSE;
  tsQosPolicy.TabVisible := FALSE;
end;

destructor TfmMain.Destroy;
begin
  StopRefreshThread;
  FLogReceptionThread.Terminate;
  FLogReceptionThread.Free;
  inherited Destroy;
end;


procedure TfmMain.WriteLog(AValue: String);
begin
  memLog.Lines.Add(AValue);
  if memLog.Lines.Count >= 5000 then
  begin
    var LFile := IncludeTrailingPathDelimiter(TUtilities.MyDocumentsDir) + 'ElementUI.log';
    try
      TFile.AppendAllText(LFile, memLog.Lines.Text);
      memLog.Lines.Clear;
      memLog.Lines.Add(String.Format('Log purged to file: %s', [LFile]));
    except
      on E:Exception do
      begin
        memLog.Lines.Clear;
        memLog.Lines.Add(String.Format('Error purging to file: %s. %s', [LFile, E.Message]));
      end;
    end;
  end;
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
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
      LogInfo(String.Format('GET %s. Response: %s', [LEndPoint.FullURL, LResponseText]));
      LogDebug('GET Returned %s', [LGetResponse]);
    except
      on E:Exception do
      begin
        LogError('Exeption attempting GET %s: %s', [LEndPoint.FullURL, E.Message]);
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

  try
    Result := TClusterInfo.Create(LGetResponse);
  except
    on E:Exception do
    begin
      LogError('Exeption: %s: %s', [E.Message]);
      Result := nil;
    end;
  end;
end;

function TfmMain.GetNodes: TNodeInfoList;
begin
  {$IFDEF DEBUG}
  Result := TNodeInfoList.Create('[{"_links":{"self":{"href":"/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"detail":{"cluster_ip":{"address":"10.117.80.157"},' +
                                 '"drives":[{"_links":{"self":{"href":"/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/a6eec0e6-6e43-578c-aaec-e404a6a62f0d"}},"state":"Active","uuid":"a6eec0e6-6e43-578c-aaec-e404a6a62f0d"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/895c2810-4ed6-5906-8ecd-d9a8f2cb560a"}},"state":"Active","uuid":"895c2810-4ed6-5906-8ecd-d9a8f2cb560a"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/b9bf9d47-8a39-5491-8afc-83385c5a9761"}},"state":"Active","uuid":"b9bf9d47-8a39-5491-8afc-83385c5a9761"}],' +
                                 '"maintenance_mode":{"state":"Disabled","variant":"None"},"management_ip":{"address":"10.117.64.253"},"role":"Storage","status":{"reachable":true,"state":"Added"},"storage_ip":{"address":"10.117.80.157"},"version":"12.75.0.5931100"},' +
                                 '"id":1,"name":"NHCITJJ1525","uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}]');
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
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
      LogInfo(String.Format('GET %s. Response: %s', [LEndPoint.FullURL, LResponseText]));
      LogDebug('GET Returned %s', [LGetResponse]);
    except
      on E:Exception do
      begin
        LogError('Exeption in GET %s: %s', [LEndPoint.FullURL, E.Message]);
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
  if nil <> LObj then
  begin
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
end;

function TfmMain.GetPendingNodes: TNodeInfoList;
begin
  {$IFDEF DEBUG}
  Result := TNodeInfoList.Create('[{"_links":{"self":{"href":"/api/cluster/nodes/e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}},"detail":{"cluster_ip":{"address":"10.117.80.157"},' +
                                 '"drives":[{"_links":{"self":{"href":"/api/cluster/drives/5aa562ba-7257-5757-a6d3-24f7971c643f"}},"state":"Active","uuid":"5aa562ba-7257-5757-a6d3-24f7971c643f"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/7116ca99-c93d-5551-885c-8625785f9c67"}},"state":"Active","uuid":"7116ca99-c93d-5551-885c-8625785f9c67"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"}},"state":"Active","uuid":"3a1e3680-0c8b-5e23-8c2e-2d42acf96ea4"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/a6eec0e6-6e43-578c-aaec-e404a6a62f0d"}},"state":"Active","uuid":"a6eec0e6-6e43-578c-aaec-e404a6a62f0d"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/895c2810-4ed6-5906-8ecd-d9a8f2cb560a"}},"state":"Active","uuid":"895c2810-4ed6-5906-8ecd-d9a8f2cb560a"},' +
                                 '{"_links":{"self":{"href":"/api/cluster/drives/b9bf9d47-8a39-5491-8afc-83385c5a9761"}},"state":"Active","uuid":"b9bf9d47-8a39-5491-8afc-83385c5a9761"}],' +
                                 '"maintenance_mode":{"state":"Disabled","variant":"None"},"management_ip":{"address":"10.117.64.253"},"role":"Storage","status":{"reachable":true,"state":"Pending"},"storage_ip":{"address":"10.117.80.157"},"version":"12.75.0.5931100"},' +
                                 '"id":1,"name":"NHCITJJ1525","uuid":"e6c62f86-3bb4-5b9d-822f-ca60a4b64d3d"}]');
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
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
      LogInfo(String.Format('GET %s. Response: %s', [LEndPoint.FullURL, LResponseText]));
      LogDebug('GET Returned %s', [LGetResponse]);
    except
      on E:Exception do
      begin
        LogError('Exeption in GET %s: %s', [LEndPoint.FullURL, E.Message]);
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
  if nil <> LObj then
  begin
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
end;

function TfmMain.GetDrives(AUnassigned: Boolean = FALSE): TDriveInfoList;
begin
  {$IFDEF DEBUG}
  Result := TDriveInfoList.Create('[{"_links":{"self":{"href":"\/api\/cluster\/drives\/340e2e41-48ef-5394-ba97-1ec3731fd711"}},'+
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
               '"serialNumber":"nvme-sn-S3T1NX0M302436"},"inUse":false,"state":"Available","uuid":"1e2e82d2-dd07-5c16-bf56-321731a8b3e4"}]');
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
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
      LogInfo(String.Format('GET %s. Response: %s', [LEndPoint.FullURL, LResponseText]));
      LogDebug('GET Returned %s', [LGetResponse]);
    except
      on E:Exception do
      begin
        LogError('Exeption in GET %s: %s', [LEndPoint.FullURL, E.Message]);
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
  if nil <> LObj then
  begin
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
end;

function TfmMain.GetJobs: TJobInfoList;
begin
  {$IFDEF DEBUG}
  Result := TJobInfoList.Create('[{"_links":{"related":{"href":"/api/cluster/"},"self":{"href":"/api/cluster/jobs/fbfb4c24-ae8d-50de-bac2-1445141019b1"}},"description":"","end_time":"2021-03-10T17:59:54Z",' + '"message":"Create Cluster","start_time":"2021-03-10T17:57:58Z","state":"success","uuid":"fbfb4c24-ae8d-50de-bac2-1445141019b1"},' +
    '{"_links":{"related":{"href":"/api/cluster/"},"self":{"href":"/api/cluster/jobs/56ab3449-8e23-56a0-ab23-d3967bff0dbf"}},"description":"","end_time":"2021-03-11T15:45:07Z","error":{"code":"xTooFewDrives",' + '"message":"Could not remove drives - Cannot fully replicate all volumes {1}"},"message":"Remove Nodes nodesToRemove={4}","start_time":"2021-03-11T15:44:59Z","state":"failure","uuid":"56ab3449-8e23-56a0-ab23-d3967bff0dbf"},' +
    '{"_links":{"related":{"href":"/api/cluster/"},"self":{"href":"/api/cluster/jobs/31afe827-4df6-5d41-b161-0b17efcaf43e"}},"description":"","end_time":"2021-03-11T15:51:02Z","error":{"code":"xTooFewDrives",' + '"message":"Could not remove drives - Cannot fully replicate all volumes {1}"},"message":"Remove Nodes nodesToRemove={4}","start_time":"2021-03-11T15:50:54Z","state":"failure","uuid":"31afe827-4df6-5d41-b161-0b17efcaf43e"},' +
    '{"_links":{"related":{"href":"/api/cluster/"},"self":{"href":"/api/cluster/jobs/858fe514-f9f0-5e38-8e22-92578d9a00b7"}},"description":"","end_time":"2021-03-11T15:51:28Z","error":{"code":"xTooFewDrives",' + '"message":"Could not remove drives - Cannot fully replicate all volumes {1}"},"message":"Remove Nodes nodesToRemove={4}","start_time":"2021-03-11T15:51:20Z","state":"failure","uuid":"858fe514-f9f0-5e38-8e22-92578d9a00b7"},' +
    '{"_links":{"related":{"href":"/api/cluster/"},"self":{"href":"/api/cluster/jobs/3db799ec-67a0-5803-83b8-d7165e2a4acb"}},"description":"RemoveNodes","end_time":"2021-03-11T17:04:04Z",' + '"error":{"code":"xTooFewDrives",' +
    '"message":"Could not remove drives - Cannot proceed with space calculations, no block drives responded: servicesToKill: {(14,=0x0)} latestBServices: {{ServiceInfo(type=block, ID=14, fireStormID=9, maxUsableCapacity=8412635357184, firstTimeStartup=false, ' +
    'ServiceFormat=Firetap){nodeID=4 masterID=1 fireflyID=2 name=NHCITGG2715 mip=10.117.66.75 mipi=team0 cip=10.117.82.75 cipi=team1 sip=10.117.82.75 sipi=team1 uuid=d7797fce-06e2-11e9-aa11-d8c497e969bc nodeSlot= ' +
    'chassisName=QTFCR291400F0 ' + 'chassisNameOverride= customProtectionDomainName=__default__ softwareVersion=12.75.0.5950081 platform={\"chassisType\":\"SFc100\",\"containerized\":true,\"cpuModel\":\"Intel(R) Xeon(R) Gold 5120 CPU ' +
    '@ 2.20GHz\",\"nodeMemoryGB\":257,\"nodeType\":\"SFc100\",\"platformConfigVersion\":\"0.0.0.0\"} role=Storage fibreChannelTargetPortGroup=None virtualNetworks={} unreachableKeyServers={}}{}},' +
    '{ServiceInfo(type=block, ID=26, fireStormID=21, maxUsableCapacity=16834210066432, firstTimeStartup=false, ServiceFormat=Firetap)' +
    '{nodeID=1 masterID=7 fireflyID=8 name=NHCITGG2712 mip=10.117.66.72 mipi=team0 cip=10.117.82.72 cipi=team1 sip=10.117.82.72 ' +
    'sipi=team1 uuid=3577d5ce-fc68-11e8-bb66-d8c497e80c45 nodeSlot= chassisName=QTFCR291202C5 chassisNameOverride= customProtectionDomainName=__' +
    'default__ softwareVersion=12.75.0.5950081 platform={\"chassisType\":\"SFc100\",\"containerized\":true,\"cpuModel\":\"Intel(R) Xeon(R) Gold 5120 ' +
    'CPU @ 2.20GHz\",\"nodeMemoryGB\":515,\"nodeType\":\"SFc100\",\"platformConfigVersion\":\"0.0.0.0\"} role=Storage fibreChannelTargetPortGroup' +
    '=None virtualNetworks={} unreachableKeyServers={}}{}},{ServiceInfo(type=block, ID=20, fireStormID=15, maxUsableCapacity=30615814729728, firstTimeStartup=' +
    'false, ServiceFormat=Firetap){nodeID=3 masterID=3 ' +
    'fireflyID=4 name=NHCITGG2713 mip=10.117.66.73 mipi=team0 cip=10.117.82.73 cipi=team1 sip=10.117.82.73 sipi=team1 ' +
    'uuid=b61e4988-e61f-11e8-a6ee-d8c497d01c74 nodeSlot= chassisName=QTFCR290802D5 chassisNameOverride= customProtectionDomainName=__default__ ' +
    'softwareVersion=12.75.0.5950081 platform={\"chassisType\":\"SFc100\",\"containerized\":true,\"cpuModel\":\"Intel(R) ' +
    'Xeon(R) Gold 5120 CPU @ 2.20GHz\",\"nodeMemoryGB\":707,\"nodeType\":\"SFc100\",\"platformConfigVersion\":\"0.0.0.0\"} role=Storage fibreChannelTargetPortGroup=None virtualNetworks={} ' +
    'unreachableKeyServers={}}{}},{ServiceInfo(type=block, ID=32, fireStormID=27, maxUsableCapacity=16834210066432, firstTimeStartup=false, ' +
    'ServiceFormat=Firetap){nodeID=2 masterID=5 fireflyID=6 name=NHCITGG2714 mip=10.117.66.74 mipi=team0 cip=10.117.82.74 ' +
    'cipi=team1 sip=10.117.82.74 sipi=team1 uuid=93997c06-f5bb-11e8-9058-d8c497d07e7d nodeSlot= chassisName=QTFCR2912013C chassisNameOverride= customProtectionDomainName=__default__ softwareVersion=12.75.0.5950081 ' +
    'platform={\"chassisType\":\"SFc100\",\"containerized\":true,\"cpuModel\":\"Intel(R) Xeon(R) Gold 5120 CPU @ 2.20GHz\",\"nodeMemoryGB\":515,' +
    '\"nodeType\":\"SFc100\",\"platformConfigVersion\":\"0.0.0.0\"} role=Storage fibreChannelTargetPortGroup=None virtualNetworks={} ' +
    'unreachableKeyServers={}}{}}} this: BlockServiceSpaceUsageInfo {  mAvailableServicesUsableCapacity={0,0} ' +
    'mKilledServicesUsableCapacity={8412635357184,0} mUnresponsiveServicesUsableCapacity={64284234862592,0} mKnownUsedSpace={0,0} ' +
    'mEstimatedTotalUsedSpace={0,0} mEffectiveHeadroomPercent=3 mMaxUsedSpaceRatio=0}"},"message":"Failed removal of node ex=xTooFewDrives","start_time":"2021-03-11T17:03:42Z","state":"failure","uuid":"3db799ec-67a0-5803-83b8-d7165e2a4acb"},' +
    '{"_links":{"related":{"href":""},"self":{"href":"/api/cluster/jobs/9d15ac07-cafe-519a-b29e-6bf14c8197d2"}},"description":"","end_time":"2021-03-10T17:59:01Z","message":"","start_time":"2021-03-10T17:58:23Z","state":"success",' +
    '"uuid":"9d15ac07-cafe-519a-b29e-6bf14c8197d2"},{"_links":{"related":{"href":"/api/volumes/72404c40-798a-5617-857d-61b57745bbf4"},' +
    '"self":{"href":"/api/cluster/jobs/3843349b-70cd-5c63-a20c-e547d56771b9"}},"description":"Volume Creation Job","end_time":"2021-03-10T17:59:39Z",' +
    '"message":"Volume creation complete","start_time":"2021-03-10T17:59:34Z","state":"success","uuid":"3843349b-70cd-5c63-a20c-e547d56771b9"}]');

  EXIT;
  {$ELSE}
  Result := nil;
  {$ENDIF}
  var LGetResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', String.Format('%s?show_nested=true', [API_JOB_PATH]));
  try
    try
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
      LogInfo(String.Format('GET %s. Response: %s', [LEndPoint.FullURL, LResponseText]));
      LogDebug('GET Returned %s', [LGetResponse]);
    except
      on E:Exception do
      begin
        LogError('Exeption in GET %s: %s', [LEndPoint.FullURL, E.Message]);
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
  if nil <> LObj then
  begin
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
end;

function TfmMain.GetQosPolicies: TQosPolicyList;
begin
  {$IFDEF DEBUG}
  Result := TQosPolicyList.Create('[{"_links":{"self":{"href":"\/api\/cluster\/qos-policies\/9b367c57-dc30-5655-86bd-3c8f5c460424"}},"burstIOPS":15000,"burstTime":60,"curve":{"costs":[{"cost":"100","iosize":"4096"},{"cost":"160","iosize":"8192"},{"cost":"270","iosize":"16384"},' + '{"cost":"500","iosize":"32768"},{"cost":"1000","iosize":"65536"},{"cost":"1950","iosize":"131072"},{"cost":"3900","iosize":"262144"},{"cost":"7600","iosize":"524288"},{"cost":"15000","iosize":"1048576"}]},' + '"description":"DefaultClusterPolicy","maxIOPS":15000,"minIOPS":50,"uuid":"9b367c57-dc30-5655-86bd-3c8f5c460424"}]');
  EXIT;
  {$ELSE}
  Result := nil;
  {$ENDIF}
  var LGetResponse: String;
  var LResponseCode: Integer;
  var LResponseText: String;

  var LEndPoint := TEndpointClient.Create(FHostAddress, FHostPort, '', '', API_QOS_POLICY_PATH);
  try
    try
      Screen.Cursor := crHourglass;
      try
        LGetResponse := LEndPoint.Get;
      finally
        Screen.Cursor := crDefault;
      end;
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
      LogInfo(String.Format('GET %s. Response: %s', [LEndPoint.FullURL, LResponseText]));
      LogDebug('GET Returned %s', [LGetResponse]);
    except
      on E:Exception do
      begin
        LogError('Exeption in GET %s: %s', [LEndPoint.FullURL, E.Message]);
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

  Result := TQosPolicyList.Create;

  var LObj := TJSONObject.ParseJSONValue(LGetResponse) as TJSONObject;
  if nil <> LObj then
  begin
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
      LResponseCode := LEndPoint.ResponseCode;
      LResponseText := LEndPoint.ResponseText;
      LogDebug('POST Response: %s', [LResponseText]);
      LogDebug('POST Returned %s', [LResponse]);
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
      LogDebug('DELETE Response: %s', [LResponseText]);
      LogDebug('DELETE Returned %s', [LResponse]);
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
  //No longer supported?
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
  //Not supported?
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
      LogDebug('DELETE Reponse %s', [LResponseText]);
      LogDebug('DELETE Returned %s', [LResponse]);
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
    if nil = AClusterInfo then
      EXIT;  //Finally will still run!

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

procedure TfmMain.DisplayCosts(ACostList: TCostList);
begin
  vgCurve.BeginUpdate;
  try
    vgCurve.ClearRows;
    var myCat := vgCurve.Add( TcxCategoryRow ) As TcxCategoryRow;
    myCat.Properties.Caption := 'Costs';

    if (nil = ACostList) or (0 = ACostList.Count) then
      EXIT;  //Finally will still run!

    var myRow := vgCurve.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'Cost';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    myRow.Properties.Value := ACostList[0].Cost;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgCurve.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'I/O Size';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    myRow.Properties.Value := ACostList[0].IOSize;
    myRow.Properties.Options.Editing := FALSE;

    if 1 = ACostList.Count then
      EXIT;

    for var i := 1 to (ACostList.Count - 1) do
    begin
      myCat := vgCurve.Add( TcxCategoryRow ) As TcxCategoryRow;
      myCat.Properties.Caption := '';

      myRow := vgCurve.Add( TcxEditorRow ) as TcxEditorRow;
      myRow.Properties.Caption := 'Cost';
      myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
      myRow.Properties.Value := ACostList[i].Cost;
      myRow.Properties.Options.Editing := FALSE;

      myRow := vgCurve.Add( TcxEditorRow ) as TcxEditorRow;
      myRow.Properties.Caption := 'I/O Size';
      myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
      myRow.Properties.Value := ACostList[i].IOSize;
      myRow.Properties.Options.Editing := FALSE;
    end;
  finally
    vgCurve.EndUpdate;
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

procedure TfmMain.LoadQosPoliciesGrid(AJSON: String);
begin
  ClearJobsGrid;
  tvQosPolicies.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvQosPolicies.DataController.CustomDataSource) then
      TQosPolicyListDataSource(tvQosPolicies.DataController.CustomDataSource).Free;

    tvQosPolicies.DataController.BeginFullUpdate;
    try
      tvQosPolicies.DataController.CustomDataSource := TQosPolicyListDataSource.Create(AJSON);
    finally
      tvQosPolicies.DataController.EndFullUpdate;
    end;
  finally
    tvQosPolicies.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.ClearQosPoliciesGrid;
begin
  tvQosPolicies.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvQosPolicies.DataController.CustomDataSource) then
    begin
      TQosPolicyListDataSource(tvQosPolicies.DataController.CustomDataSource).Free;
      tvQosPolicies.DataController.CustomDataSource := nil;
    end;
  finally
    tvQosPolicies.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.DisplayJobError(AErrorCode, AErrorMessage: String);
var
  myRow : TcxEditorRow;
begin
  vgJobError.BeginUpdate;
  try
    vgJobError.ClearRows;
    myRow := vgJobError.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'Code';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    myRow.Properties.Value := AErrorCode;
    myRow.Properties.Options.Editing := FALSE;

    myRow := vgJobError.Add( TcxEditorRow ) as TcxEditorRow;
    myRow.Properties.Caption := 'Message';
    myRow.Properties.DataBinding.ValueTypeClass := TcxStringValueType;
    myRow.Properties.Value := AErrorMessage;
    myRow.Properties.Options.Editing := FALSE;
  finally
    vgJobError.EndUpdate;
  end;
end;

procedure TfmMain.LoadClusterAndNodes;
begin
  try
    var LInfo := GetClusterInfo;
    try
      DisplayClusterInfo(LInfo);
    finally
      LInfo.Free;
    end;
  except on E:Exception do
    LogError('Exception Loading Cluster: %s', [E.Message]);
  end;

  try
    var LNodeList := GetNodes;
    if nil = LNodeList then
    begin
      ClearNodeGrid;
    end else
    begin
      try
        LoadNodeGrid(LNodeList.AsJSONArray);
      finally
        LNodeList.Free;
      end;
    end;
  except on E:Exception do
    LogError('Exception Loading Nodes: %s', [E.Message]);
  end;

  try
    var LNodeList := GetPendingNodes;
    if nil = LNodeList then
    begin
      ClearPendingNodeGrid;
    end else
    begin
      try
        LoadPendingNodeGrid(LNodeList.AsJSONArray);
      finally
        LNodeList.Free;
      end;
    end;
  except on E:Exception do
    LogError('Exception Loading Pending Nodes: %s', [E.Message]);
  end;
end;

procedure TfmMain.LoadDrives;
begin
  try
    var LDriveList := GetDrives;
    try
      LoadDrivesGrid(LDriveList.AsJSONArray);
    finally
      LDriveList.Free;
    end;
  except on E:Exception do
    LogError('Exception Loading Drives: %s', [E.Message]);
  end;

  try
    var LDriveList := GetDrives(TRUE);
    try
      LoadUnassignedDrivesGrid(LDriveList.AsJSONArray);
    finally
      LDriveList.Free;
    end;
  except on E:Exception do
    LogError('Exception Loading Unassigned Drives: %s', [E.Message]);
  end;
end;

procedure TfmMain.LoadJobs;
begin
  try
    var LJobList := GetJobs;
    try
      LoadJobsGrid(LJobList.AsJSONArray);
    finally
      LJobList.Free;
    end;
  except on E:Exception do
    LogError('Exception Loading Jobs: %s', [E.Message]);
  end;
end;

procedure TfmMain.LoadQosPolicies;
begin
  try
    var LQosPolicyList := GetQosPolicies;
    try
      LoadQosPoliciesGrid(LQosPolicyList.AsJSONArray);
    finally
      LQosPolicyList.Free;
    end;
  except on E:Exception do
    LogError('Exception Loading Qos Policies: %s', [E.Message]);
  end;
end;

procedure TfmMain.StartRefreshThread;
begin
  StopRefreshThread;
  FRefreshThread := TDataRefreshThread.Create(TRUE, 5, Self.Handle);
  FRefreshThread.Resume;
end;

procedure TfmMain.StopRefreshThread;
begin
  if nil <> FRefreshThread then
  begin
    try
      try
        FRefreshThread.Terminate;
        FRefreshThread.Free;
      except on E:Exception do
        LogWarn('Exception Terminating Refresh Thread: %s', [E.Message]);
      end;
    finally
      FRefreshThread := nil;
    end;
  end;
end;

procedure TfmMain.OnRefreshRequest(var Msg: TMessage);
begin
  Screen.Cursor := crHourglass;
  try
    case pcCluster.ActivePageIndex of
    0:LoadClusterAndNodes;
    1:LoadDrives;
    2:LoadJobs;
    3:LoadQosPolicies;
    end;
  finally
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
  Screen.Cursor := crHourglass;
  try
    LoadClusterAndNodes;
    pcCluster.ActivePageIndex := 0;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.btnDrivesClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  try
    LoadDrives;
    pcCluster.ActivePageIndex := 1;
  finally
    Screen.Cursor := crDefault;
  end;
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
  Screen.Cursor := crHourglass;
  try
    LoadJobs;
    pcCluster.ActivePageIndex := 2;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmMain.btnQosPoliciesClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  try
    LoadQosPolicies;
    pcCluster.ActivePageIndex := 3;
  finally
    Screen.Cursor := crDefault;
  end;

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

procedure TfmMain.tvJobsFocusedRecordChanged(Sender: TcxCustomGridTableView;
  APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if 0 = tvJobs.Controller.SelectedRecordCount then
  begin
    DisplayJobError(String.Empty, String.Empty);
    EXIT;
  end;

  var LRecordIndex := AFocusedRecord.RecordIndex;
  var LJob := TJobListDataSource(tvJobs.DataController.CustomDataSource).Jobs[LRecordIndex];
  DisplayJobError(LJob.ErrorInfo.ErrorCode, LJob.ErrorInfo.ErrorMessage);
end;

procedure TfmMain.tvQosPoliciesFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if 0 = tvQosPolicies.Controller.SelectedRecordCount then
  begin
    DisplayCosts(nil);
    EXIT;
  end;

  var LRecordIndex := AFocusedRecord.RecordIndex;
  var LQosPolicy := TQosPolicyListDataSource(tvQosPolicies.DataController.CustomDataSource).QosPolicies[LRecordIndex];
  DisplayCosts(LQosPolicy.Curve.Costs);
end;

procedure TfmMain.btnRefreshClick(Sender: TObject);
begin
  if not btnRefresh.Down then
  begin
    StopRefreshThread;
    btnRefresh.Caption := 'Auto Refresh Disabled';
  end
  else
  begin
    StartRefreshThread;
    btnRefresh.Caption := 'Auto Refresh Enabled';
  end;
end;

end.

