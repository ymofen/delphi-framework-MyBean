program singleConsole;

uses
  FastMM4,
  FastMM4Messages,
  Forms,
  ufrmMain in 'ufrmMain.pas' {Form2},
  mybean.console,
  uIPluginForm in '..\..\frame-common\uIPluginForm.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
