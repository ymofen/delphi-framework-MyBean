program myBeanConsole;

uses
  FastMM4,
  FastMM4Messages,
  Forms,
  uAppPluginContext,
  ufrmMain in '..\..\mainForm\ufrmMain.pas' {frmMain},
  PluginTabControl in '..\..\mainForm\PluginTabControl.pas',
  uPluginObject in '..\..\mainForm\uPluginObject.pas',
  uMainFormTools in '..\..\mainForm\uMainFormTools.pas';

{R *.res}

begin
  Application.Initialize;
  applicationContextIntialize();
  try
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  finally
    //必须提前释放，等清理了DLL资源再进行释放, 如果主窗体中含有DLL中的资源，可能会引发AV异常
    frmMain.Free;
    frmMain := nil;
    applicationContextFinalize;
  end;
end.
