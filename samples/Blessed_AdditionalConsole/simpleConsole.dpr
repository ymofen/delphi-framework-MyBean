program simpleConsole;

uses
  FastMM4,
  FastMM4Messages,
  mybean.console,
  Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  applicationContextInitialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
