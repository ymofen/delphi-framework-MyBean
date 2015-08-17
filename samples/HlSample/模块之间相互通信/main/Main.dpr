program Main;

uses
  mybean.console,
  Vcl.Forms,
  Unit_Main in 'Unit_Main.pas' {Form1},
  UIShowAsNormal in '..\interface\UIShowAsNormal.pas';

{$R *.res}

begin
  Application.Initialize;
  ApplicationContextInitialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
