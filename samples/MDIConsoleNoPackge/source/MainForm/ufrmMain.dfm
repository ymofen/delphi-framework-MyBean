object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 458
  ClientWidth = 841
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = mmMain
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlExp: TPanel
    Left = 0
    Top = 0
    Width = 841
    Height = 25
    Align = alTop
    TabOrder = 0
    object pnlTabs: TPanel
      Left = 392
      Top = 1
      Width = 448
      Height = 23
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
    end
    object edtPluginID: TEdit
      Left = 7
      Top = 3
      Width = 177
      Height = 21
      TabOrder = 1
      Text = 'demoPluginMdiForm'
    end
    object btnCreateAsMDI: TButton
      Left = 191
      Top = 2
      Width = 147
      Height = 23
      Action = actCreatePluginAsMDI
      TabOrder = 2
    end
  end
  object DockTabSet1: TDockTabSet
    Left = 191
    Top = 437
    Width = 554
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 225
    Height = 433
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 2
    object btnGetPerson: TButton
      Left = 7
      Top = 36
      Width = 209
      Height = 69
      Caption = #26174#31034#19981#24102#21253'MDI'#31383#20307
      TabOrder = 0
      OnClick = btnGetPersonClick
    end
  end
  object mmMain: TMainMenu
    Left = 288
    Top = 64
    object F1: TMenuItem
      Caption = #25991#20214'(&F)'
      object N1: TMenuItem
        Action = actOpenDatabase
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N2: TMenuItem
        Action = actCreateDataBase
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object N3: TMenuItem
        Action = actCloseDatabase
      end
    end
    object DEMO2: TMenuItem
      Caption = 'DEMO('#28436#31034')'
      object DEMO1: TMenuItem
        Action = actCreateDemoForm
      end
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
    object actCreatePluginAsMDI: TAction
      Caption = #20197'MDI'#26041#24335#21019#24314#25554#20214
      OnExecute = actCreatePluginAsMDIExecute
    end
    object actCreateDataBase: TAction
      Category = 'File'
      Caption = #26032#24314#23478#35889#25968#25454#24211'..'
    end
    object actOpenDatabase: TAction
      Category = 'File'
      Caption = #25171#24320#23478#35889#25968#25454#24211'...'
    end
    object actCloseDatabase: TAction
      Category = 'File'
      Caption = #20851#38381#25968#25454#24211
    end
    object actAddPerson: TAction
      Caption = #28155#21152#20154#21592
    end
  end
  object dlgOpen1: TOpenDialog
    Left = 288
    Top = 176
  end
  object dlgOpen2: TOpenDialog
    Left = 344
    Top = 184
  end
end
