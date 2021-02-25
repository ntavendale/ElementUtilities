{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2021 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit BaseURLSelect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseModalForm, RzButton,
  RzPanel, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, RzEdit, Utilities, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxTextEdit, dxSkinTheBezier,
  dxSkinOffice2019Colorful, dxSkinBasic, dxSkinOffice2019Black,
  dxSkinOffice2019DarkGray, dxSkinOffice2019White;

type
  TfmBaseURLSelect = class(TfmBaseModalForm)
    ebBaseURL: TcxTextEdit;
    procedure ebBaseURLKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FBaseURL: String;
    procedure GetSettings;
    procedure SaveSettings;
  protected
    { Protected declarations }
    function AllOK: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    class function GetBaseURL: String;
    property BaseURL: String read FBaseURL;
  end;

implementation

{$R *.dfm}

constructor TfmBaseURLSelect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBaseURL := '';
  GetSettings;
end;

procedure TfmBaseURLSelect.ebBaseURLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LIndex: Integer;
begin
  inherited;
  if ebBaseURL.Properties.LookupItems.Count = 0 then
    EXIT;

  if VK_DOWN = Key then
  begin
    if ('' = Trim(ebBaseURL.Text)) or (-1 = ebBaseURL.Properties.LookupItems.IndexOf(Trim(ebBaseURL.Text))) then
      ebBaseURL.Text := ebBaseURL.Properties.LookupItems[0]
    else
    begin
      LIndex := ebBaseURL.Properties.LookupItems.IndexOf(Trim(ebBaseURL.Text));
      if LIndex < (ebBaseURL.Properties.LookupItems.Count - 1) then
        ebBaseURL.Text := ebBaseURL.Properties.LookupItems[LIndex + 1]
      else
        ebBaseURL.Text := ebBaseURL.Properties.LookupItems[0];
    end;
  end
  else if VK_UP = Key then
  begin
    if ('' = Trim(ebBaseURL.Text)) or (-1 = ebBaseURL.Properties.LookupItems.IndexOf(Trim(ebBaseURL.Text))) then
      ebBaseURL.Text := ebBaseURL.Properties.LookupItems[ebBaseURL.Properties.LookupItems.Count - 1]
    else
    begin
      LIndex := ebBaseURL.Properties.LookupItems.IndexOf(Trim(ebBaseURL.Text));
      if LIndex > 0 then
        ebBaseURL.Text := ebBaseURL.Properties.LookupItems[LIndex - 1]
      else
        ebBaseURL.Text := ebBaseURL.Properties.LookupItems[ebBaseURL.Properties.LookupItems.Count - 1];
    end;
  end;

end;

procedure TfmBaseURLSelect.GetSettings;
begin
  ebBaseURL.Properties.LookupItems.Text := TUtilities.GetFormKey('BaseURLSelect', 'BaseURL');
  ebBaseURL.Text := TUtilities.GetFormKey('BaseURLSelect', 'LastSelectedBaseURL');
  if String.IsNullOrWhitespace(Trim(ebBaseURL.Text)) then
    ebBaseURL.Text := 'http://127.0.0.1:6200';
end;

procedure TfmBaseURLSelect.SaveSettings;
var
  i: Integer;
begin
  if -1 = ebBaseURL.Properties.LookupItems.IndexOf(Trim(ebBaseURL.Text)) then
    ebBaseURL.Properties.LookupItems.Insert(0, Trim(ebBaseURL.Text));
  if ebBaseURL.Properties.LookupItems.Count > 10 then
  begin
    for i := (ebBaseURL.Properties.LookupItems.Count - 1) downto 9 do
      ebBaseURL.Properties.LookupItems.Delete(i);
  end;

  TUtilities.SetFormKey('BaseURLSelect', 'BaseURL', ebBaseURL.Properties.LookupItems.Text);
  TUtilities.SetFormKey('BaseURLSelect', 'LastSelectedBaseURL', Trim(ebBaseURL.Text));
end;

function TfmBaseURLSelect.AllOK: Boolean;
begin
  FBaseURL := ebBaseURL.Text;
  SaveSettings;
  Result := TRUE;
end;

class function TfmBaseURLSelect.GetBaseURL: String;
begin
  Result := String.Empty;
  var fm := TfmBaseURLSelect.Create(nil);
  try
    if mrOK = fm.ShowModal then
      Result := fm.BaseURL;
  finally
    fm.Free;
  end;
end;

end.
