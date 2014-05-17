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
  Menu = mmMain
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TabSet1: TTabSet
    Left = 0
    Top = 0
    Width = 684
    Height = 21
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object mmMain: TMainMenu
    Left = 408
    Top = 64
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
  end
end
