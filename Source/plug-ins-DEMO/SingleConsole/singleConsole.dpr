program singleConsole;

uses
  Forms,
  ufrmMain in 'ufrmMain.pas' {Form2},
  mybean.console.loader.dll in '..\..\frame-core\mybean.console.loader.dll.pas',
  mybean.console.loader in '..\..\frame-core\mybean.console.loader.pas',
  mybean.console in '..\..\frame-core\mybean.console.pas',
  mybean.core.intf in '..\..\frame-core\mybean.core.intf.pas',
  uIPluginForm in '..\..\frame-common\uIPluginForm.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
