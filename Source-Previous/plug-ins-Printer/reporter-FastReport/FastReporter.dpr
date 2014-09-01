library FastReporter;

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
  uFastReporter in 'uFastReporter.pas',
  ufrmFastReport in 'ufrmFastReport.pas' {frmFastReport},
  uFMPreView in 'uFMPreView.pas' {FMPreView: TFrame},
  uPreviewObjectWrapper in 'uPreviewObjectWrapper.pas',
  StdInterface in '..\..\Service\StdInterface.pas',
  uIBarTenderData in '..\..\Service\uIBarTenderData.pas',
  uIFileAccess in '..\..\Service\uIFileAccess.pas',
  uIReporter in '..\..\Service\uIReporter.pas',
  uIUIReporter in '..\..\Service\uIUIReporter.pas',
  uIIntfList in '..\..\Utils\uIIntfList.pas',
  uCore in '..\..\Utils\uCore.pas',
  uDBIntf in '..\..\Service\uDBIntf.pas',
  superobject in '..\..\Utils\superobject.pas',
  uIControlLayout in '..\..\Service\uIControlLayout.pas',
  uCRCTools in '..\..\Utils\uCRCTools.pas',
  uFileTools in '..\..\Utils\uFileTools.pas';

{$R *.res}
procedure registerReporter(const pvReporterFactory: IReporterFactory);
    stdcall;
begin
  pvReporterFactory.registerReporter('FR', 'FR±¨±í', createRepoter);
end;



exports
  registerReporter;

begin
end.
