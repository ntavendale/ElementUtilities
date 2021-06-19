{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
program ElementUI;

{$IFDEF RELEASE}
{$R 'Version.res' 'Version.rc'}
{$ENDIF}

uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  EDebugExports,
  EDebugJCL,
  EFixSafeCallException,
  EMapWin32,
  EAppVCL,
  EDialogWinAPIMSClassic,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  ExceptionLog7,
  {$ENDIF EurekaLog}
  System.SysUtils,
  Vcl.Forms,
  System.UITypes,
  Vcl.Dialogs,
  ElementUIMain in 'ElementUIMain.pas' {fmMain},
  EndPointClient in '..\Common\EndPoint\EndPointClient.pas',
  FileLogger in '..\Common\Shared\FileLogger.pas',
  SignalledQueue in '..\Common\Shared\SignalledQueue.pas',
  CustomThread in '..\Common\Threading\CustomThread.pas',
  LockableObject in '..\Common\Threading\LockableObject.pas',
  oamSlimReadWriteLock in '..\Common\Threading\oamSlimReadWriteLock.pas',
  BuildVersion in '..\Common\Utilities\BuildVersion.pas',
  CryptoAPI in '..\Common\Utilities\CryptoAPI.pas',
  StopWatch in '..\Common\Utilities\StopWatch.pas',
  Utilities in '..\Common\Utilities\Utilities.pas',
  Wcrypt2 in '..\Common\Utilities\Wcrypt2.pas',
  ElementApi.Cluster in '..\api\ElementApi.Cluster.pas',
  ElementApi.Drive in '..\api\ElementApi.Drive.pas',
  ElementApi.Link in '..\api\ElementApi.Link.pas',
  ElementApi.Node in '..\api\ElementApi.Node.pas',
  BaseModalForm in '..\Common\Forms\BaseModalForm.pas' {fmBaseModalForm},
  BaseURLSelect in 'BaseURLSelect.pas' {fmBaseURLSelect},
  ClusterDetail in 'ClusterDetail.pas' {fmClusterDetail},
  ElementApi.Job in '..\api\ElementApi.Job.pas',
  ElementApi.Error in '..\api\ElementApi.Error.pas',
  ElementApi.QosPolicy in '..\api\ElementApi.QosPolicy.pas';

{$R *.res}

begin
  var LBaseURL := TfmBaseURLSelect.GetBaseURL;

  if not String.IsNullOrWhiteSpace(LBaseURL) then
  begin
    var LURL: String;
    var LPort: WORD;
    try
      LURL := TUtilities.GetURLFromURLString(LBaseURL);
      LPort := TUtilities.GetPortFromURLString(LBaseURL);
    except
      on E:Exception do
      begin
        MessageDlg(String.Format('Error Parsing Base URL %s: %s', [LBaseURL, E.Message]), mtError, [mbOK], 0);
        EXIT;
      end;
    end;
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfmMain, fmMain);
  fmMain.SetBaseURL(LURL, LPort);
    Application.Run;
  end;
end.

