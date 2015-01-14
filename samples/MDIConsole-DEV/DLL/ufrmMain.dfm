object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 411
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 818
    Height = 113
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object btnCreateDataSet: TButton
      Left = 16
      Top = 72
      Width = 145
      Height = 25
      Caption = 'btnCreateDataSet'
      TabOrder = 0
      OnClick = btnCreateDataSetClick
    end
  end
  object pnlClient: TPanel
    Left = 0
    Top = 113
    Width = 818
    Height = 298
    Align = alClient
    Caption = 'pnlClient'
    TabOrder = 1
  end
  object cdsMain: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 25
    Top = 146
  end
end
