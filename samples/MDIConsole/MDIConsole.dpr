program MDIConsole;

uses
  FastMM4,
  FastMM4Messages,
  mybean.console,
  ActiveX,
  Forms,
  ufrmMain in 'mainForm\ufrmMain.pas' {frmMain},
  PluginTabControl in 'mainForm\PluginTabControl.pas',
  uPluginObject in 'mainForm\uPluginObject.pas',
  uMainFormTools in 'mainForm\uMainFormTools.pas',
  uIMainForm in 'Interface\uIMainForm.pas',
  uICaption in 'Interface\uICaption.pas',
  uIFormShow in 'Interface\uIFormShow.pas',
  uIPluginForm in 'Interface\uIPluginForm.pas',
  mybean.strConsts in '..\..\Source\mybean.strConsts.pas';

{R *.res}

begin
  Application.Initialize;
  // mybean≥ı ºªØ
  applicationContextInitialize;
  //executeLoadLibFiles('*.dll');

  CoInitialize(nil);

  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
