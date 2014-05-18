object frmPluginForm: TfrmPluginForm
  Left = 0
  Top = 0
  Caption = 'frmPluginForm'
  ClientHeight = 326
  ClientWidth = 630
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mmo1: TMemo
    Left = 8
    Top = 8
    Width = 449
    Height = 289
    Lines.Strings = (
      #25105#26159#19968#20010#24456#26222#36890#30340#31383#20307#65292#23454#29616#20102'IPluginForm'#65292#23601#26159#19968#20010#25554#20214#31383#20307)
    TabOrder = 0
  end
  object btnCreateAsModal: TButton
    Left = 480
    Top = 24
    Width = 142
    Height = 25
    Caption = 'CreateAsModal'
    TabOrder = 1
    OnClick = btnCreateAsModalClick
  end
end
