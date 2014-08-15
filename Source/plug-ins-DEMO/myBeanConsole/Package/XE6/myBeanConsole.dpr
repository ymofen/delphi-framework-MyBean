program myBeanConsole;

uses
  FastMM4,
  FastMM4Messages,
  Vcl.Forms,
  uAppPluginContext,
  PluginTabControl in '..\..\mainForm\PluginTabControl.pas',
  ufrmMain in '..\..\mainForm\ufrmMain.pas' {frmMain},
  uMainFormTools in '..\..\mainForm\uMainFormTools.pas',
  uPluginObject in '..\..\mainForm\uPluginObject.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  applicationContextIntialize();
  try
    Application.MainFormOnTaskbar := True;
    //TStyleManager.TrySetStyle('Cyan Dusk');
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  finally
    //必须提前释放，等清理了DLL资源再进行释放, 如果主窗体中含有DLL中的资源，可能会引发AV异常
    frmMain.Free;
    frmMain := nil;
    applicationContextFinalize;
  end;
end.
