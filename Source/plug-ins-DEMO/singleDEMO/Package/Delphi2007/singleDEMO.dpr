program singleDEMO;

uses
  FastMM4,
  FastMM4Messages,
  Forms,
  uBeanFactory,
  ufrmMain in '..\..\ufrmMain.pas' {frmMain},
  ufrmTester in '..\..\Child\ufrmTester.pas' {frmTester},
  uIUIForm in '..\..\Interface\uIUIForm.pas',
  uAppPluginContext in '..\..\..\..\frameCommon\Service\uAppPluginContext.pas';

{$R *.res}

begin
  Application.Initialize;
  appPluginContext.checkInitialize(true);
  try
    registerFactoryObject(beanFactory, 'default');
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  finally
    appPluginContext.checkFinalize;
    appContextCleanup;
  end;
end.
