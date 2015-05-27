library plugin01;

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
  System.SysUtils,
  System.Classes,
  mybean.core.beanFactory,
  ufrmMyBeanPlugin in '..\plug-ins-form-demo\Forms\ufrmMyBeanPlugin.pas' {frmMyBeanPlugin},
  ufrmAbout in '..\plug-ins-form-demo\Forms\ufrmAbout.pas' {frmAbout},
  uBasePluginForm in '..\plug-ins-form-demo\Service\uBasePluginForm.pas',
  mBeanMainFormTools in '..\Interface\mBeanMainFormTools.pas',
  uICaption in '..\Interface\uICaption.pas',
  uIFormShow in '..\Interface\uIFormShow.pas',
  uIMainForm in '..\Interface\uIMainForm.pas',
  uIPluginForm in '..\Interface\uIPluginForm.pas',
  ufrmPluginForm in '..\plug-ins-form-demo\Forms\ufrmPluginForm.pas' {frmPluginForm};

{$R *.res}

begin
  beanFactory.RegisterBean('aboutForm', TfrmAbout);
  beanFactory.RegisterBean('demoPluginForm', TfrmPluginForm);
  beanFactory.RegisterBean('mybeanForm', TfrmMyBeanPlugin, true);
end.
