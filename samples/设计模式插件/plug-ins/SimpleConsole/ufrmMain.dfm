object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'frmMain'
  ClientHeight = 376
  ClientWidth = 901
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    901
    376)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 88
    Width = 885
    Height = 280
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      #20027#31243#24207#38656#35201#22312#21152#36733#23436#25152#26377'DLL'#21518', '#25191#34892'StartLibraryService('#19968#33324'DLL'#21487#20197#22312#27492#22788#36827#34892#35746#38405')'
      ''
      
        #26412#31383#20307#23454#29616#20102'ISubscribeListener'#25509#21475', '#20390#21548#20102'[tester]'#30340#35746#38405#28040#24687#65292#22914#26524#26377#23545'[tester]'#36827#34892#35746#38405#21644#21462#28040 +
        #35746#38405#12290#35813#31383#20307#37117#20250#25910#21040#28040#24687
      #21487#20197#23545'[tester]'#30340#25152#26377#35746#38405#32773#21457#24067#28040#24687#12290)
    TabOrder = 0
    ExplicitWidth = 640
    ExplicitHeight = 213
  end
  object edtMsg: TEdit
    Left = 8
    Top = 8
    Width = 169
    Height = 21
    TabOrder = 1
    Text = #20998#21457#28040#24687
  end
  object btnDispatchMsg: TButton
    Left = 200
    Top = 6
    Width = 113
    Height = 25
    Caption = 'btnDispatchMsg'
    TabOrder = 2
    OnClick = btnDispatchMsgClick
  end
  object btnSubscribe: TButton
    Left = 592
    Top = 8
    Width = 145
    Height = 25
    Caption = #26412#31383#20307#21521#35746#38405#32773#35746#38405
    TabOrder = 3
    OnClick = btnSubscribeClick
  end
  object btnRemoveSubscribe: TButton
    Left = 592
    Top = 57
    Width = 145
    Height = 25
    Caption = #21462#28040#26412#31383#20307#30340#35746#38405
    TabOrder = 4
    OnClick = btnRemoveSubscribeClick
  end
end
