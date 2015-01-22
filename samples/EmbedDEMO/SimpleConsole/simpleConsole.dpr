program simpleConsole;

uses
  mybean.console,
  Forms,
  mybean.tools.bridgeConsole,  
  ufrmMain in 'ufrmMain.pas' {frmMain};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;

  /// <summary>
  ///   先加载配置文件，读取Bean信息
  ///     让DLL或者BPL按需加载
  ///   执行后，EXE的其他地方可以通过引用
  ///   TMyBeanFactoryTools(mybean.tools.beanFactory.pas)中的GetBean调用插件
  /// </summary>
  ExecuteLoadBeanFromConfigFiles('ConfigPlugins\*.plug-ins');

  /// 直接加载DLL
  ExecuteLoadLibFiles('corePlugins\*.dll');
  
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
