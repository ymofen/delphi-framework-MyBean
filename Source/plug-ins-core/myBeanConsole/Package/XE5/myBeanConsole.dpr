program myBeanConsole;

uses
  FastMM4,
  FastMM4Messages,
  Forms,
  uAppPluginContext,
  ufrmMain in '..\..\mainForm\ufrmMain.pas' {frmMain};

{R *.res}

begin
  Application.Initialize;
  applicationContextIntialize();
  try
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  finally
    applicationContextFinalize;
  end;
end.
