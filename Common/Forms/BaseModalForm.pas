{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit BaseModalForm;

interface

uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzPanel, RzButton;

type
  TfmBaseModalForm = class(TForm)
    RzPanel1: TRzPanel;
    pnBottom: TRzPanel;
    pnOKCancel: TRzPanel;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    gbModal: TRzGroupBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  protected
    { Protected declarations }
    FLanguageID: Integer;
    function AllOK: Boolean; virtual; abstract;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Utilities;

{$R *.dfm}

constructor TfmBaseModalForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLanguageID := 0;
end;

procedure TfmBaseModalForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmBaseModalForm.btnOKClick(Sender: TObject);
begin
  if AllOK then
    ModalResult := mrOK;
end;

procedure TfmBaseModalForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN: btnOK.Click;
    VK_ESCAPE: btnCancel.Click;
  end;
end;

end.
