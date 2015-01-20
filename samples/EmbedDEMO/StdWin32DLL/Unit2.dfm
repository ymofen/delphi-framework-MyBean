object Form2: TForm2
  Left = 194
  Top = 314
  Caption = 'Form2'
  ClientHeight = 525
  ClientWidth = 963
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 327
    Width = 108
    Height = 13
    Caption = 'MyBean'#31383#20307#25554#20214'ID'
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 649
    Height = 297
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    Lines.Strings = (
      #36825#26159#19968#20010#26631#20934#30340'Win32 DLL, '#20294#26159#21487#20197#22312#19979#38754#22312#36825#37324#35843#29992'MyBean'#30340#25554#20214#65292' '#36825
      #24847#21619#30528#20219#20309#30340#26694#26550#20013#37117#21487#20197#20351#29992'MyBean'#25554#20214)
    ParentFont = False
    TabOrder = 0
  end
  object edtBeanID: TEdit
    Left = 122
    Top = 324
    Width = 169
    Height = 21
    TabOrder = 1
    Text = 'mybeanForm'
  end
  object btnShowForm: TButton
    Left = 297
    Top = 322
    Width = 128
    Height = 25
    Caption = #26174#31034'MyBean'#31383#20307
    TabOrder = 2
    OnClick = btnShowFormClick
  end
end
