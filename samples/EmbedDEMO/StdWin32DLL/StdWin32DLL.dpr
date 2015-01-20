library StdWin32DLL;

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
  forms,
  MyBeanBridgeLib,
  Unit2 in 'Unit2.pas' {Form2},
  uIFormShow in 'uIFormShow.pas',
  uIPluginForm in 'uIPluginForm.pas';

{$R *.res}
 procedure Load_frmTest(App: THandle);stdcall;
var
  sHandle: THandle;
begin
  sHandle := Application.Handle;
  //Application.Handle := App;
  Form2 := TForm2.Create (Application);
  try
    Form2.ShowModal;
  finally
    Form2.Free;
  end;
  Application.Handle := sHandle;
end;
 
exports
  Load_frmTest;

begin
end.
