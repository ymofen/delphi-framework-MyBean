object frmMain: TfrmMain
  Left = 140
  Top = 156
  Caption = 'Analyze Executable Files'
  ClientHeight = 501
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gpAnalyse: TPanel
    Left = 0
    Top = 45
    Width = 774
    Height = 456
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 480
      Top = 0
      Width = 294
      Height = 456
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 2
      object lblPath: TLabel
        Left = 3
        Top = 37
        Width = 288
        Height = 13
        Align = alTop
        Caption = 'Copy to Destination Path:'
        ExplicitWidth = 124
      end
      object lblCopyTo: TLabel
        Left = 3
        Top = 3
        Width = 288
        Height = 13
        Align = alTop
        Caption = 'DevExpress Library Path:'
        ExplicitWidth = 122
      end
      object edtTOPath: TEdit
        Left = 3
        Top = 50
        Width = 288
        Height = 21
        Align = alTop
        TabOrder = 0
        Text = 'H:\Hydra\DCU\'
      end
      object edtDEPath: TEdit
        Left = 3
        Top = 16
        Width = 288
        Height = 21
        Align = alTop
        TabOrder = 1
        Text = 'D:\DevExpress VCL\Library\RS11\'
      end
      object mmoDevUnits: TMemo
        Left = 3
        Top = 71
        Width = 288
        Height = 217
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 2
      end
      object mmoLog: TMemo
        Left = 3
        Top = 288
        Width = 288
        Height = 165
        Align = alBottom
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 3
      end
    end
    object pnlRequiredPackages: TPanel
      Left = 240
      Top = 0
      Width = 240
      Height = 456
      Align = alLeft
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 1
      object Label2: TLabel
        Left = 3
        Top = 3
        Width = 234
        Height = 13
        Align = alTop
        Caption = 'Required Packages:'
        ExplicitWidth = 95
      end
      object Label1: TLabel
        Left = 3
        Top = 168
        Width = 234
        Height = 13
        Align = alTop
        Caption = 'Contained Units:'
        ExplicitWidth = 80
      end
      object mmoRequirePackages: TMemo
        Left = 3
        Top = 16
        Width = 234
        Height = 152
        Align = alTop
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object mmoUnits: TMemo
        Left = 3
        Top = 181
        Width = 234
        Height = 272
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
      end
    end
    object pnlExeFiles: TPanel
      Left = 0
      Top = 0
      Width = 240
      Height = 456
      Align = alLeft
      BevelOuter = bvNone
      BorderWidth = 3
      TabOrder = 0
      object Label3: TLabel
        Left = 3
        Top = 3
        Width = 234
        Height = 13
        Align = alTop
        Caption = 'Files to Analyze:'
        ExplicitWidth = 79
      end
      object lstFiles: TListBox
        Left = 3
        Top = 16
        Width = 234
        Height = 437
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnClick = lstFilesClick
        OnKeyUp = lstFilesKeyUp
      end
    end
  end
  object pnlButton: TPanel
    Left = 0
    Top = 0
    Width = 774
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btnOpenFiles: TBitBtn
      Left = 12
      Top = 10
      Width = 85
      Height = 25
      Caption = #28155#21152#25991#20214
      TabOrder = 0
      OnClick = btnOpenFilesClick
    end
    object btnAnalyse: TBitBtn
      Left = 103
      Top = 10
      Width = 85
      Height = 25
      Caption = #20998#26512#25991#20214
      Enabled = False
      TabOrder = 1
      OnClick = btnAnalyseClick
    end
    object btnClearFiles: TBitBtn
      Left = 194
      Top = 10
      Width = 85
      Height = 25
      Caption = #28165#31354#25991#20214
      Enabled = False
      TabOrder = 2
      OnClick = btnClearFilesClick
    end
    object btnCopyUnits: TBitBtn
      Left = 285
      Top = 10
      Width = 85
      Height = 25
      Caption = #22797#21046#21333#20803
      TabOrder = 3
      OnClick = btnCopyUnitsClick
    end
  end
  object dlgOpen: TOpenDialog
    Filter = 
      'Executable files(*.exe;*.dll;*.bpl;*.xex;*.cpl)|*.exe;*.dll;*.bp' +
      'l;*.xex;*.cpl|All files(*.*)|*.*'
    InitialDir = 'H:\Hydra\BIN'
    Options = [ofAllowMultiSelect, ofEnableSizing]
    Title = 'Open Files'
    Left = 132
    Top = 260
  end
end
