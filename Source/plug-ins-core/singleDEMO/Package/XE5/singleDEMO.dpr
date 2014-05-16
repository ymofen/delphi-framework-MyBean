program singleDEMO;

uses
  FastMM4,
  FastMM4Messages,
  Forms,
  uBeanFactory,
  ufrmMain in '..\..\ufrmMain.pas' {frmMain},
  ufrmTester in '..\..\Child\ufrmTester.pas' {frmTester},
  uIUIForm in '..\..\Interface\uIUIForm.pas',
  ufrmSingleton in '..\..\Child\ufrmSingleton.pas' {frmSingleton},
  uIShow in '..\..\Interface\uIShow.pas',
  uAppPluginContext in '..\..\..\..\frameCommon\core\uAppPluginContext.pas',
  uIErrorINfo in '..\..\..\..\frameCommon\core\uIErrorINfo.pas',
  uErrorINfoTools in '..\..\..\..\frameCommon\core\uErrorINfoTools.pas';

{R *.res}

begin
  Application.Initialize;
  applicationContextIntialize(False);
  try
    registerFactoryObject(beanFactory, 'default');
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSingleton, frmSingleton);
  Application.Run;
  finally
    applicationContextFinalize;
  end;
end.
