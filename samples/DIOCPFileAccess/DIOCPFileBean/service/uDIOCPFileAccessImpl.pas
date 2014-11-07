unit uDIOCPFileAccessImpl;

interface

uses
  uIRemoteFileAccess,
  uDTcpClientCoderImpl,
  uStreamCoderSocket,
  uZipTools,
  SimpleMsgPack,
  Classes,
  SysUtils,
  DTcpClient, uICoderSocket;

type
  TDIOCPFileAccessImpl = class(TInterfacedObject, IRemoteFileAccess)
  private
    FTcpClient: TDTcpClient;
    FCoderSocket: ICoderSocket;
    FMsgPack:TSimpleMsgPack;
    FSendStream:TMemoryStream;
    FRecvStream:TMemoryStream;
  protected

    /// <summary>
    ///   上传文件
    /// </summary>
    /// <param name="pvRFileName"> 远程文件名 </param>
    /// <param name="pvLocalFileName"> 本地文件名 </param>
    /// <param name="pvType"> 类型 </param>
    procedure UploadFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar);

    /// <summary>
    ///   删除文件
    /// </summary>
    /// <param name="pvRFileName"> 远程文件名 </param>
    procedure DeleteFile(pvRFileName, pvType: PAnsiChar);

    /// <summary>
    ///   下载文件
    /// </summary>
    /// <returns>
    ///   下载成功返回True
    /// </returns>
    /// <param name="pvRFileName"> 远程文件名 </param>
    /// <param name="pvLocalFileName"> 本地文件名 </param>
    function DownFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar): Boolean;


    /// <summary>
    ///   获取远程文件大小
    /// </summary>
    function FileSize(pvRFileName: PAnsiChar): Int64;
  public
    constructor Create;
    procedure setHost(pvHost: string);
    procedure setPort(pvPort:Integer);
    procedure open;
    destructor Destroy; override;
  end;

implementation

constructor TDIOCPFileAccessImpl.Create;
begin
  inherited Create;
  FTcpClient := TDTcpClient.Create(nil);
  FCoderSocket := TDTcpClientCoderImpl.Create(FTcpClient);
  
  FMsgPack := TSimpleMsgPack.Create;
  FRecvStream := TMemoryStream.Create;
  FSendStream := TMemoryStream.Create;
end;

procedure TDIOCPFileAccessImpl.DeleteFile(pvRFileName, pvType: PAnsiChar);
begin
  
end;

destructor TDIOCPFileAccessImpl.Destroy;
begin
  FCoderSocket := nil;
  FTcpClient.Disconnect;
  FTcpClient.Free;
  FMsgPack.Free;
  FRecvStream.Free;
  FSendStream.Free;
  inherited Destroy;
end;

function TDIOCPFileAccessImpl.DownFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar): Boolean;
begin

end;

function TDIOCPFileAccessImpl.FileSize(pvRFileName: PAnsiChar): Int64;
begin

end;

procedure TDIOCPFileAccessImpl.open;
begin
  FTcpClient.Disconnect;
  FTcpClient.Connect;
end;

procedure TDIOCPFileAccessImpl.setHost(pvHost: string);
begin
  FTcpClient.Host := pvHost;
end;

procedure TDIOCPFileAccessImpl.setPort(pvPort: Integer);
begin
  FTcpClient.Port := pvPort;  
end;

procedure TDIOCPFileAccessImpl.UploadFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar);
begin

end;

end.
