object frmPluginForm: TfrmPluginForm
  Left = 0
  Top = 0
  Caption = 'frmPluginForm'
  ClientHeight = 378
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnPutObject: TButton
    Left = 16
    Top = 24
    Width = 121
    Height = 25
    Caption = 'btnPutObject'
    TabOrder = 0
    OnClick = btnPutObjectClick
  end
  object btnGetObject: TButton
    Left = 16
    Top = 88
    Width = 121
    Height = 25
    Caption = 'btnGetObject'
    TabOrder = 1
    OnClick = btnGetObjectClick
  end
end
