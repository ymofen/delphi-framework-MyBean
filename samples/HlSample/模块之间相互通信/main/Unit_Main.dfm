object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 256
  ClientWidth = 529
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
  object Button1: TButton
    Left = 24
    Top = 24
    Width = 75
    Height = 25
    Caption = #26174#31034#27169#22359'1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 24
    Top = 64
    Width = 75
    Height = 25
    Caption = #26174#31034#27169#22359'2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 288
    Top = 8
    Width = 217
    Height = 153
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object Button3: TButton
    Left = 24
    Top = 200
    Width = 75
    Height = 25
    Caption = 'send'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 120
    Top = 202
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'Edit1'
  end
end
