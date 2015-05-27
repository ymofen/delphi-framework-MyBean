library plugin_form_demo;

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
  mybean.core.beanFactory,
  ufrmAbout in 'Forms\ufrmAbout.pas' {frmAbout},
  ufrmPluginForm in 'Forms\ufrmPluginForm.pas' {frmPluginForm},
  uBasePluginForm in 'Service\uBasePluginForm.pas',
  uICaption in '..\Interface\uICaption.pas',
  uIFormShow in '..\Interface\uIFormShow.pas',
  uIMainForm in '..\Interface\uIMainForm.pas',
  uIPluginForm in '..\Interface\uIPluginForm.pas',
  mBeanMainFormTools in '..\Interface\mBeanMainFormTools.pas',
  mybean.vcl.BaseForm in '..\..\..\Source\mybean.vcl.BaseForm.pas',
  ufrmMyBeanPlugin in 'Forms\ufrmMyBeanPlugin.pas' {frmMyBeanPlugin};

{$R *.res}

begin
  beanFactory.RegisterBean('aboutForm', TfrmAbout);
  beanFactory.RegisterBean('demoPluginForm', TfrmPluginForm);
  beanFactory.RegisterBean('mybeanForm', TfrmMyBeanPlugin, true);
end.
