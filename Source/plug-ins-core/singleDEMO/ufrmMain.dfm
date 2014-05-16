object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 243
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 32
    Top = 43
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtThreadCounter: TEdit
    Left = 136
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '100'
  end
  object btnStart: TButton
    Left = 136
    Top = 43
    Width = 75
    Height = 25
    Caption = 'btnStart'
    TabOrder = 2
    OnClick = btnStartClick
  end
  object btnSingletonForm: TButton
    Left = 26
    Top = 144
    Width = 185
    Height = 25
    Caption = 'btnSingletonForm'
    TabOrder = 3
    OnClick = btnSingletonFormClick
  end
end
