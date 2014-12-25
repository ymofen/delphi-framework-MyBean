unit DMQClient;

interface

uses
  Classes, DMQProtocol, DTcpClient, SysUtils, uByteTools;

type
  TDMQClient = class(TComponent)
  private
    FSendHeader: TDMQRequestRecord;
    FSendData: TMemoryStream;
    FRecvData: TMemoryStream;
    FTcpClient: TDTcpClient;
    function GetHost: string;
    function GetLogicID: Integer;
    function GetPort: Integer;
    procedure SetHost(const Value: string);
    procedure SetLogicID(const Value: Integer);
    procedure SetPort(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Post;
    procedure Recv;
    procedure Connect;
    procedure Disconnect;
    property Host: string read GetHost write SetHost;
    property LogicID: Integer read GetLogicID write SetLogicID;
    property Port: Integer read GetPort write SetPort;
    property RecvData: TMemoryStream read FRecvData;
    property SendData: TMemoryStream read FSendData;
    property TcpClient: TDTcpClient read FTcpClient;
  end;

implementation

procedure TDMQClient.Connect;
begin
  FTcpClient.Disconnect;
  FTcpClient.Connect;
end;

constructor TDMQClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSendHeader.flag := Header_Flag;
  FSendHeader.logicID := 0;
  FTcpClient := TDTcpClient.Create(Self);
  FSendData := TMemoryStream.Create();
  FRecvData := TMemoryStream.Create();
end;

destructor TDMQClient.Destroy;
begin
  FreeAndNil(FRecvData);
  FreeAndNil(FSendData);
  FTcpClient.Free;
  inherited Destroy;
end;

procedure TDMQClient.Disconnect;
begin
  FTcpClient.Disconnect;
end;

procedure TDMQClient.Post;
var
  lvSize:Integer;
  lvRet:Integer;
begin
  lvSize := FSendData.Size;
  FSendHeader.datalen := TByteTools.swap32(lvSize);
  lvRet := FTcpClient.sendBuffer(@FSendHeader, SizeOf(FSendHeader));
  if lvRet = -1 then RaiseLastOSError;

  if lvSize > 0 then
  begin
    lvRet := FTcpClient.sendBuffer(FSendData.Memory, lvSize);
    if lvRet = -1 then RaiseLastOSError;
  end;
end;

procedure TDMQClient.Recv;
var
  lvResponseHeader:TDMQResponseRecord;
begin
  FTcpClient.recv(@lvResponseHeader, SizeOf(lvResponseHeader));
  if lvResponseHeader.flag <> Header_Flag then
  begin
    FTcpClient.Disconnect;
    raise Exception.Create('错误的数据包格式!');
  end;
  lvResponseHeader.datalen := TByteTools.swap32(lvResponseHeader.datalen);
  FRecvData.SetSize(lvResponseHeader.datalen);
  FRecvData.Position := 0;
  FTcpClient.recv(FRecvData.Memory, lvResponseHeader.datalen);
  FRecvData.Position := 0;
end;

function TDMQClient.GetHost: string;
begin
  Result := FTcpClient.Host;
end;

function TDMQClient.GetLogicID: Integer;
begin
  Result := FSendHeader.logicID;
end;

function TDMQClient.GetPort: Integer;
begin
  Result := FTcpClient.Port;
end;

procedure TDMQClient.SetHost(const Value: string);
begin
  FTcpClient.Host := Value;
end;

procedure TDMQClient.SetLogicID(const Value: Integer);
begin
  FSendHeader.logicID := Value;
end;

procedure TDMQClient.SetPort(const Value: Integer);
begin
  FTcpClient.Port := Value;
end;

end.
