object frmReportEditor: TfrmReportEditor
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #25253#34920#32534#36753
  ClientHeight = 188
  ClientWidth = 422
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 31
    Width = 48
    Height = 13
    Caption = #25253#34920#21517#31216
  end
  object Label2: TLabel
    Left = 40
    Top = 66
    Width = 24
    Height = 13
    Caption = #31867#22411
  end
  object dbFName: TDBEdit
    Left = 96
    Top = 28
    Width = 193
    Height = 21
    DataField = 'FName'
    TabOrder = 0
  end
  object DBCheckBox1: TDBCheckBox
    Left = 96
    Top = 92
    Width = 150
    Height = 17
    Caption = #31169#26377#25253#34920'('#33258#24049#21487#35265')'
    DataField = 'FIsPrivate'
    TabOrder = 1
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object dbchkFIsEspecial: TDBCheckBox
    Left = 96
    Top = 115
    Width = 150
    Height = 17
    Caption = #25935#24863#25968#25454#25253#34920
    DataField = 'FIsEspecial'
    TabOrder = 2
    ValueChecked = 'True'
    ValueUnchecked = 'False'
  end
  object btnOK: TButton
    Left = 199
    Top = 144
    Width = 75
    Height = 25
    Caption = #30830#23450'(&O)'
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 302
    Top = 144
    Width = 75
    Height = 25
    Caption = #21462#28040'(&C)'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object cbbTypeID: TComboBox
    Left = 96
    Top = 63
    Width = 193
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
  end
end
