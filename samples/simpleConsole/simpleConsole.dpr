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
  try
    // 直接加载plug-ins目录下的DLL插件
    ExecuteLoadLibFiles('plug-ins\*.dll');

    // 直接加载plug-ins目录下的BPL插件
    ExecuteLoadLibFiles('plug-ins\*.bpl');

    // 直接加载EXE当前目录下的DLL插件
    ExecuteLoadLibFiles('*.dll');

    // 加载configPlugins目录下的插件配置文件(按需加载)
    ExecuteLoadBeanFromConfigFiles('configPlugins\*.plug-ins');
    
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  finally
    // 释放主窗体
    Application.MainForm.Free;

    // 清理数据共享中心对象, 释放插件, 卸载DLL/BPl
    ApplicationContextFinalize;
  end;
end.
