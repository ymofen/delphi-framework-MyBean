library reporterConsole;

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
  MidasLib,
  SysUtils,
  Classes,
  ufrmReportEditor in '..\..\ufrmReportEditor.pas' {frmReportEditor},
  ufrmReportList in '..\..\ufrmReportList.pas' {frmReportList},
  uReporterDefaultOperator in '..\..\uReporterDefaultOperator.pas',
  uReportConsoleObject in '..\..\uReportConsoleObject.pas',
  uIReporter in '..\..\interface\uIReporter.pas',
  uCdsTools in '..\..\Tools\uCdsTools.pas',
  uIFileAccess in '..\..\interface\uIFileAccess.pas',
  uBeanFactory,
  superobject in '..\..\Tools\superobject.pas',
  uDBTools in '..\..\Tools\uDBTools.pas',
  SOWrapper in '..\..\Tools\SOWrapper.pas',
  ObjRecycle in '..\..\Tools\ObjRecycle.pas',
  uSNTools in '..\..\Tools\uSNTools.pas',
  uFileTools in '..\..\Tools\uFileTools.pas',
  uKeyStreamCoder in '..\..\Tools\uKeyStreamCoder.pas',
  uKeyStreamFileCoder in '..\..\Tools\uKeyStreamFileCoder.pas',
  uKeyStreamTools in '..\..\Tools\uKeyStreamTools.pas',
  uMsgTools in '..\..\Tools\uMsgTools.pas',
  uStreamCoder in '..\..\Tools\uStreamCoder.pas',
  uJSonTools in '..\..\Tools\uJSonTools.pas';

{$R *.res}

function createReportConsole(pvApplicationHandle: THandle): IReportConsole;
    stdcall;
begin
  Result := TfrmReportList.Create(nil);      //TReportConsoleObject.Create;//
end;


function createReporterIM(pvApplicationHandle: THandle): IReporterIM;
    stdcall;
begin
  Result := TfrmReportList.Create(pvApplicationHandle);
end;

function createReporterDefaultOperator(const pvUserID: PAnsiChar; pvFileAccess:
    IFileAccess): IReporterDefaultOperator; stdcall;
begin
  Result := TReporterDefaultOperator.Create(pvUserID, pvFileAccess);
end;


exports
  createReportConsole,
  createReporterIM,
  createReporterDefaultOperator;

begin
  //报表控制台
  beanFactory.RegisterBean('reporterConsole', TfrmReportList);
end.
