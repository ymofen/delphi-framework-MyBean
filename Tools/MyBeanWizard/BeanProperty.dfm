object beanPropertyDlg: TbeanPropertyDlg
  Left = 0
  Top = 0
  ActiveControl = btnOK
  BorderStyle = bsDialog
  Caption = #23646#24615
  ClientHeight = 240
  ClientWidth = 464
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 200
    Top = 192
    Width = 75
    Height = 25
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 296
    Top = 192
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 1
  end
  object lbEditBeanName: TLabeledEdit
    Left = 154
    Top = 48
    Width = 231
    Height = 21
    EditLabel.Width = 36
    EditLabel.Height = 13
    EditLabel.Caption = #21517#31216#65306
    LabelPosition = lpLeft
    TabOrder = 2
  end
end
