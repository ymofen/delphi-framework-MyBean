object frmPluginForm: TfrmPluginForm
  Left = 0
  Top = 0
  Caption = #19981#24102#21253'DLL'#31383#20307
  ClientHeight = 525
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mmo1: TMemo
    Left = 0
    Top = 0
    Width = 405
    Height = 352
    Align = alClient
    Lines.Strings = (
      #25105#26159#19968#20010#19981#20351#29992#24102#21253#23601#33021#20316#20026'MDI'#23376#31383#20307#26174#31034#30340'DLL'#25554#20214#31383#20307#65292
      #38656#35201#20462#25913'DLL'#30340'Application'#23646#24615#12290
      ''
      ''
      'library PluginMdiChild;'
      ''
      
        '{ Important note about DLL memory management: ShareMem must be t' +
        'he'
      
        '  first unit in your library'#39's USES clause AND your project'#39's (s' +
        'elect'
      
        '  Project-View Source) USES clause if your DLL exports any proce' +
        'dures or'
      
        '  functions that pass strings as parameters or function results.' +
        ' This'
      
        '  applies to all strings passed to and from your DLL--even those' +
        ' that'
      
        '  are nested in records and classes. ShareMem is the interface u' +
        'nit to'
      
        '  the BORLNDMM.DLL shared memory manager, which must be deployed' +
        ' along'
      
        '  with your DLL. To avoid using BORLNDMM.DLL, pass string inform' +
        'ation'
      '  using PChar or ShortString parameters. }'
      ''
      'uses'
      '  SysUtils,'
      '  Classes,'
      '  Windows,'
      '  Forms,'
      '  mybean.core.beanFactory,'
      '  ufrmPluginForm in '#39'Forms\ufrmPluginForm.pas'#39' {frmPluginForm},'
      
        '  uBasePluginFormNoPackge in '#39'..\common\uBasePluginFormNoPackge.' +
        'pas'#39','
      '  uIMainApplication in '#39'..\Interface\uIMainApplication.pas '#39','
      '  uICaption in '#39'..\Interface\uICaption.pas'#39','
      '  uIFormShow in '#39'..\Interface\uIFormShow.pas'#39','
      '  uIMainForm in '#39'..\Interface\uIMainForm.pas'#39','
      '  uIPluginForm in '#39'..\Interface\uIPluginForm.pas'#39','
      '  mBeanMainFormTools in '#39'..\Interface\mBeanMainFormTools.pas'#39';'
      ''
      '{$R *.res}'
      ''
      'var'
      '  DLLApp :TApplication;'
      ''
      'procedure DLLUnloadProc(Reason: Integer); register;'
      'begin'
      
        ' if (Reason = DLL_PROCESS_DETACH) or (Reason = DLL_THREAD_DETACH' +
        ')'
      '     then Application := DLLApp;        //DLLApp'#26159#22312'DLL'#24037#31243#25991#26723#20013#23450#20041#30340#20840#23616
      'TApplication'#23545#35937
      '                                       //'#29992#26469#20445#23384'Application'#23545#35937
      'end;'
      ''
      'begin'
      ''
      '   DLLApp:=Application;                      //'#20445#30041'Application'
      '   DLLProc := @DLLUnloadProc;                //'#23558#37325#20889#21518#30340#20837#21475#20989#25968#22320#22336#20184#32473
      'DLLProc'
      ''
      
        '   beanFactory.RegisterBean('#39'demoPluginMdiForm'#39', TfrmPluginForm)' +
        ';'
      'end.')
    TabOrder = 0
  end
  object pnlOperator: TPanel
    Left = 405
    Top = 0
    Width = 185
    Height = 352
    Align = alRight
    TabOrder = 1
    object btnCreateAsModal: TButton
      Left = 27
      Top = 16
      Width = 142
      Height = 25
      Caption = 'CreateAsModal'
      TabOrder = 0
      OnClick = btnCreateAsModalClick
    end
    object btnCreateAsMDI: TButton
      Left = 32
      Top = 80
      Width = 113
      Height = 25
      Caption = 'btnCreateAsMDI'
      TabOrder = 1
      OnClick = btnCreateAsMDIClick
    end
  end
  object pnlConfig: TPanel
    Left = 0
    Top = 352
    Width = 590
    Height = 173
    Align = alBottom
    Caption = 'pnlConfig'
    TabOrder = 2
    object mmoConfig: TMemo
      Left = 1
      Top = 1
      Width = 588
      Height = 171
      Align = alClient
      TabOrder = 0
    end
  end
  object mm1: TMainMenu
    Left = 720
    Top = 256
    object N1: TMenuItem
      Caption = #23376#31383#20307#33756#21333
      GroupIndex = 1
      object N2: TMenuItem
        Caption = #23376#31383#20307#23376#33756#21333
        GroupIndex = 1
      end
    end
  end
end
