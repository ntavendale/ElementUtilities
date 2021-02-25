{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit ClusterDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseModalForm, RzButton, RzPanel,
  Vcl.ExtCtrls,
  ElementApi.Cluster;

type
  TfmClusterDetail = class(TfmBaseModalForm)
  private
    { Private declarations }
    FClusterInfo: TClusterInfo;
  public
    { Public declarations }
    constructor Create(AOWner: TComponent; AClusterInfo: TClusterInfo); reintroduce;
  end;

implementation

{$R *.dfm}

constructor TfmClusterDetail.Create(AOwner: TComponent; AClusterInfo: TClusterInfo);
begin
  inherited Create(AOwner);
  if nil = AClusterInfo then
    FClusterInfo := TClusterInfo.Create
  else
    FClusterInfo := TClusterInfo.Create(AClusterInfo);
end;

end.
