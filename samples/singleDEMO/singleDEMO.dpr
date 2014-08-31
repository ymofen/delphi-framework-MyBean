program singleDEMO;

uses
  Forms,
  mybean.core.beanFactory,
  mybean.console,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  ufrmTester in 'Child\ufrmTester.pas' {frmTester},
  uIUIForm in 'Interface\uIUIForm.pas',
  ufrmSingleton in 'Child\ufrmSingleton.pas' {frmSingleton};

{R *.res}

begin
  Application.Initialize;
  registerFactoryObject(beanFactory, 'default');
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
