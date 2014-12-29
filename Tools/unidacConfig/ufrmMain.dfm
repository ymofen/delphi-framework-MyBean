object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'unidac'#37197#32622#24037#20855
  ClientHeight = 144
  ClientWidth = 425
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
  object lblDataSourceID: TLabel
    Left = 56
    Top = 64
    Width = 47
    Height = 13
    Caption = #25968#25454#28304'ID'
  end
  object btnConfig: TButton
    Left = 256
    Top = 55
    Width = 73
    Height = 33
    Action = actConfig
    TabOrder = 0
  end
  object cbbSection: TComboBox
    Left = 109
    Top = 61
    Width = 113
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'cbbSection'
  end
  object UniConnection1: TUniConnection
    ConnectDialog = UniConnectDialog1
    Left = 104
    Top = 24
  end
  object UniConnectDialog1: TUniConnectDialog
    DatabaseLabel = #25968#25454#24211
    PortLabel = #31471#21475
    ProviderLabel = #39537#21160
    SavePassword = True
    Caption = #36830#25509#37197#32622
    UsernameLabel = #29992#25143#21517
    PasswordLabel = #23494#30721
    ServerLabel = #26381#21153#22120
    ConnectButton = #36830#25509
    CancelButton = #21462#28040
    LabelSet = lsCustom
    Left = 144
    Top = 24
  end
  object MySQLUniProvider1: TMySQLUniProvider
    Left = 336
    Top = 24
  end
  object AccessUniProvider1: TAccessUniProvider
    Left = 232
    Top = 24
  end
  object OracleUniProvider1: TOracleUniProvider
    Left = 272
    Top = 24
  end
  object SQLServerUniProvider1: TSQLServerUniProvider
    Left = 376
    Top = 24
  end
  object SQLiteUniProvider1: TSQLiteUniProvider
    Left = 304
    Top = 24
  end
  object actlstMain: TActionList
    Left = 184
    Top = 24
    object actConfig: TAction
      Caption = #37197#32622
      OnExecute = actConfigExecute
    end
  end
end
