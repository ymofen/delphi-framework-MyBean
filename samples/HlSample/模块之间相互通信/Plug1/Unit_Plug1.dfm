object frmPlug1: TfrmPlug1
  Left = 0
  Top = 0
  Caption = 'frmPlug1'
  ClientHeight = 202
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 8
    Width = 132
    Height = 33
    Caption = #36825#26159'plug1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 112
    Top = 56
    Width = 185
    Height = 89
    TabOrder = 0
  end
  object Button1: TButton
    Left = 15
    Top = 47
    Width = 75
    Height = 25
    Caption = 'memo1To2'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 15
    Top = 169
    Width = 75
    Height = 25
    Caption = 'sendtoMain'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 112
    Top = 173
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit1'
  end
  object Memo2: TMemo
    Left = 304
    Top = 56
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo2')
    TabOrder = 4
  end
end
