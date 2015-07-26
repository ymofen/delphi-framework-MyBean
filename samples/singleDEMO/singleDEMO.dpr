program singleDEMO;

uses
  Forms,
  mybean.core.beanFactory,
  mybean.console,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ufrmTester in 'Child\ufrmTester.pas' {frmTester},
  uIUIForm in 'Interface\uIUIForm.pas',
  ufrmSingleton in 'Child\ufrmSingleton.pas' {frmSingleton},
  uIShow in 'Interface\uIShow.pas',
  uIFormShow in 'Interface\uIFormShow.pas',
  mybean.tools.beanFactory;

{R *.res}

begin
  Application.Initialize;
  applicationContextInitialize;
  beanFactory.RegisterMainFormBean('main', TfrmMain);
  registerFactoryObject(beanFactory, 'default');
  Application.MainFormOnTaskbar := True;

  TMyBeanFactoryTools.GetBean('main');
  try
    Application.Run;
  finally
    Application.MainForm.Free;
    ApplicationContextFinalize;
  end;                         
end.
