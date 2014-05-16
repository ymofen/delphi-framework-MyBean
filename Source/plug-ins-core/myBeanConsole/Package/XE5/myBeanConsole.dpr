program myBeanConsole;

uses
  FastMM4,
  FastMM4Messages,
  Forms,
  uAppPluginContext in '..\..\..\..\frameCommon\Service\uAppPluginContext.pas',
  ufrmMain in '..\..\mainForm\ufrmMain.pas' {Form1};

{R *.res}

begin
  Application.Initialize;
  applicationContextIntialize(False);
  try
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TForm1, Form1);
  Application.Run;
  finally
    applicationContextFinalize;
  end;
end.
