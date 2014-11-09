library DIOCPFileBean;

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
  uIRemoteFileAccess in '..\interface\uIRemoteFileAccess.pas',
  uDIOCPFileAccessImpl in 'service\uDIOCPFileAccessImpl.pas',
  SimpleMsgPack in 'service\SimpleMsgPack.pas',
  uFileOperaObject in 'service\uFileOperaObject.pas',
  ufrmMain in 'Tester\ufrmMain.pas' {frmMain},
  uIFormShow in 'Tester\uIFormShow.pas',
  uDIOCPFileAccessTools in 'Tester\uDIOCPFileAccessTools.pas';

{$R *.res}

begin
  /// <summary>
  ///   diocpÔ¶³ÌÎÄ¼þ´æ´¢
  /// </summary>
  beanFactory.RegisterBean('diocpRemoteFile', TDIOCPFileAccessImpl);

  beanFactory.RegisterBean('diocpRemoteFileDEMO', TfrmMain);
end.
