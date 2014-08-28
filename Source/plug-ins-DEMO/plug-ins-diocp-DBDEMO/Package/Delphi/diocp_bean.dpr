library diocp_bean;

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
  uBeanFactory,
  uRemoteServerDIOCPImpl in '..\..\Service\uRemoteServerDIOCPImpl.pas',
  uICoderSocket in '..\..\Service\uICoderSocket.pas',
  uRawTcpClientCoderImpl in '..\..\Service\uRawTcpClientCoderImpl.pas',
  uStreamCoderSocket in '..\..\Service\uStreamCoderSocket.pas',
  uZipTools in '..\..\Service\uZipTools.pas',
  pcre in '..\..\qdac3-source\pcre.pas',
  PerlRegEx in '..\..\qdac3-source\PerlRegEx.pas',
  qmsgpack in '..\..\qdac3-source\qmsgpack.pas',
  qrbtree in '..\..\qdac3-source\qrbtree.pas',
  qstring in '..\..\qdac3-source\qstring.pas',
  BaseQueue in '..\..\diocp3\source\BaseQueue.pas',
  iocpEngine in '..\..\diocp3\source\iocpEngine.pas',
  RawTcpClient in '..\..\diocp3\source\RawTcpClient.pas',
  iocpRawSocket in '..\..\diocp3\source\iocpRawSocket.pas',
  iocpSocketUtils in '..\..\diocp3\source\iocpSocketUtils.pas',
  iocpWinsock2 in '..\..\diocp3\source\iocpWinsock2.pas',
  iocpQos in '..\..\diocp3\source\iocpQos.pas',
  uByteTools in '..\..\diocp3\source\uByteTools.pas',
  uIRemoteServer in '..\..\interface\uIRemoteServer.pas',
  iocpProtocol in '..\..\diocp3\source\iocpProtocol.pas',
  iocpLocker in '..\..\diocp3\source\iocpLocker.pas';

{$R *.res}

begin
  beanFactory.RegisterBean('diocpRemoteSvr', TRemoteServerDIOCPImpl);
end.
