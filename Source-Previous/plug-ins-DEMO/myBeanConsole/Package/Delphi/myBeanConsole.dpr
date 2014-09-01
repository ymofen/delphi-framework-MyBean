program myBeanConsole;

uses
  FastMM4,
  FastMM4Messages,
  mybean.console,
  Forms,
  ufrmMain in '..\..\mainForm\ufrmMain.pas' {frmMain},
  PluginTabControl in '..\..\mainForm\PluginTabControl.pas',
  uPluginObject in '..\..\mainForm\uPluginObject.pas',
  uMainFormTools in '..\..\mainForm\uMainFormTools.pas';

{R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
