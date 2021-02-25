inherited fmBaseURLSelect: TfmBaseURLSelect
  Left = 830
  Top = 465
  Caption = 'Select BaseURL'
  ClientHeight = 90
  ClientWidth = 698
  ExplicitWidth = 704
  ExplicitHeight = 119
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzPanel1: TRzPanel
    Width = 698
    Height = 63
    ExplicitWidth = 698
    ExplicitHeight = 63
    inherited gbModal: TRzGroupBox
      Width = 698
      Height = 63
      Caption = 'Base URL'
      ExplicitWidth = 698
      ExplicitHeight = 63
      object ebBaseURL: TcxTextEdit
        Left = 8
        Top = 23
        TabOrder = 0
        OnKeyDown = ebBaseURLKeyDown
        Width = 681
      end
    end
  end
  inherited pnBottom: TRzPanel
    Top = 63
    Width = 698
    ExplicitTop = 63
    ExplicitWidth = 698
    inherited pnOKCancel: TRzPanel
      Left = 468
      ExplicitLeft = 468
    end
  end
end
