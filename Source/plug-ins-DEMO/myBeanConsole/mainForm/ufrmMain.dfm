object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 382
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = mmMain
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlExp: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 25
    Align = alTop
    TabOrder = 0
    object pnlTabs: TPanel
      Left = 376
      Top = 1
      Width = 307
      Height = 23
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
    end
  end
  object mmMain: TMainMenu
    Left = 408
    Top = 64
    object DEMO1: TMenuItem
      Action = actCreateDemoForm
    end
    object actAbout1: TMenuItem
      Action = actAbout
    end
  end
  object actlstMain: TActionList
    Left = 376
    Top = 64
    object actAbout: TAction
      Caption = #20851#20110
      OnExecute = actAboutExecute
    end
    object actCreateDemoForm: TAction
      Caption = #21019#24314#19968#20010'DEMO'#31383#20307
      OnExecute = actCreateDemoFormExecute
    end
  end
end
