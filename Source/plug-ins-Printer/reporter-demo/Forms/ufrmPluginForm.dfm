object frmPluginForm: TfrmPluginForm
  Left = 0
  Top = 0
  Caption = 'frmPluginForm'
  ClientHeight = 374
  ClientWidth = 851
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlOperator: TPanel
    Left = 0
    Top = 0
    Width = 851
    Height = 49
    Align = alTop
    TabOrder = 0
    ExplicitTop = -6
    object Label1: TLabel
      Left = 368
      Top = 13
      Width = 52
      Height = 13
      Caption = #24403#21069#29992#25143':'
    end
    object btnPreView: TButton
      Left = 89
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btnPreView'
      TabOrder = 0
    end
    object btnDesign: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btnDesign'
      TabOrder = 1
      OnClick = btnDesignClick
    end
    object btnPrint: TButton
      Left = 170
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btnPrint'
      TabOrder = 2
    end
    object cbbUser: TComboBox
      Left = 440
      Top = 10
      Width = 145
      Height = 21
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = #24352#19977
      Items.Strings = (
        #24352#19977
        #26446#22235)
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 49
    Width = 851
    Height = 325
    Align = alClient
    DataSource = dsMain
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'FKey'
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FCode'
        Width = 182
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FName'
        Width = 144
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FUpbuildTime'
        Visible = True
      end>
  end
  object cdsMain: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 168
    Data = {
      7C0000009619E0BD0100000018000000040000000000030000007C0004464B65
      7901004900000001000557494454480200020032000546436F64650100490000
      00010005574944544802000200320005464E616D650100490000000100055749
      4454480200020032000C4655706275696C6454696D6508000800000000000000}
    object cdsMainFKey: TStringField
      FieldName = 'FKey'
      Size = 50
    end
    object cdsMainFCode: TStringField
      DisplayLabel = #32534#21495
      FieldName = 'FCode'
      Size = 50
    end
    object cdsMainFName: TStringField
      DisplayLabel = #21517#31216
      FieldName = 'FName'
      Size = 50
    end
    object cdsMainFUpbuildTime: TDateTimeField
      DisplayLabel = #24314#26723#26102#38388
      FieldName = 'FUpbuildTime'
    end
  end
  object dsMain: TDataSource
    DataSet = cdsMain
    Left = 16
    Top = 168
  end
end
