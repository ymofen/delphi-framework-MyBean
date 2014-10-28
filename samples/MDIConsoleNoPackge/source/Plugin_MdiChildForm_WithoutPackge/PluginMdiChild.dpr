library PluginMdiChild;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  Windows,
  mybean.core.beanFactory,
  mybean.tools.beanFactory,
  Forms,
  ufrmPluginForm in 'Forms\ufrmPluginForm.pas' {frmPluginForm},
  uBasePluginFormNoPackge in '..\common\uBasePluginFormNoPackge.pas',
  uIMainApplication in '..\Interface\uIMainApplication.pas',
  uICaption in '..\Interface\uICaption.pas',
  uIFormShow in '..\Interface\uIFormShow.pas',
  uIMainForm in '..\Interface\uIMainForm.pas',
  uIPluginForm in '..\Interface\uIPluginForm.pas',
  mBeanMainFormTools in '..\Interface\mBeanMainFormTools.pas';

{$R *.res}

var
  DLLApp :TApplication;



procedure DoInitializeFactory();
var
  lvApp:TApplication;
begin
  lvApp := (TMyBeanFactoryTools.getObject('MainApplication') as IMainApplication).GetMainApplication;
  Application := lvApp;
end;

procedure DoFinalizeFactory();
begin
  Application := DLLApp;
end;

begin
  OnIntializeLibFactory := @DoInitializeFactory;
  OnFinalizeLibFactory := @DoFinalizeFactory;
  DLLApp:=Application;                      //±£¡ÙApplication

  beanFactory.RegisterBean('demoPluginMdiForm', TfrmPluginForm);
end.
