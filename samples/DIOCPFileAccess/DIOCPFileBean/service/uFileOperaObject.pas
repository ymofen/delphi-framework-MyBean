unit uFileOperaObject;

interface

uses
  IdTCPClient, SysUtils, SimpleMsgPack, Classes, Math, uCRCTools,
  uStreamCoderSocket, uZipTools, DTcpClient, uICoderSocket, uDTcpClientCoderImpl;


type
  TFileOperaObject = class(TObject)
  private
    FFileSize:Int64;
    FFileCheckSum:Cardinal;
    FCoderSocket:ICoderSocket;
    FTcpClient: TDTcpClient;

    FCMDStream: TMemoryStream;
    FCMDObj:TSimpleMsgPack;

    function ChecksumAFile(pvFile:string): Cardinal;
    procedure pressINfo(pvSendObject: TSimpleMsgPack; pvRFile, pvType: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure checkConnect;

    procedure setHost(pvHost: string);
    procedure setPort(pvPort:Integer);

    procedure open;
    procedure close;

    procedure readFileINfo(pvRFile, pvType: string; pvChecksum: Boolean = true);

    function uploadFile(pvRFile:String; pvLocalFile:string; pvType:string): Int64;

    procedure downFile(pvRFile:String; pvLocalFile:string; pvType:string);

    procedure copyAFile(pvRFile, pvRDestFile, pvType: String);

    procedure deleteFile(pvRFile:String; pvType: string);

    property FileCheckSum: Cardinal read FFileCheckSum;

    property FileSize: Int64 read FFileSize;

    
  end;

implementation


const
  SEC_SIZE = 1024 * 50;

procedure TFileOperaObject.checkConnect;
begin
  try
    if not FTcpClient.Active then FTcpClient.Connect;
  except
    on E:Exception do
    begin
      raise Exception.CreateFmt('连接服务器出错[%s:%d]' + sLineBreak + E.Message,
        [FTcpClient.Host, FTcpClient.Port]);
    end;
  end;
end;

procedure TFileOperaObject.close;
begin
  FTcpClient.Disconnect;
end;

procedure TFileOperaObject.copyAFile(pvRFile, pvRDestFile, pvType: String);
var
  lvFileStream:TFileStream;
  lvRecvObj, lvSendObj:TSimpleMsgPack;
  i, l, lvSize:Integer;
begin
  checkConnect;
  lvSendObj := TSimpleMsgPack.Create;
  lvRecvObj := TSimpleMsgPack.Create;
  try
    lvSendObj.Clear();
    lvSendObj.S['cmd.namespace'] := 'fileaccess';
    lvSendObj.I['cmd.index'] := 5;   //copy文件
    lvSendObj.S['fileName'] := pvRFile;
    lvSendObj.S['newFile'] := pvRDestFile;

    lvSendObj.S['catalog'] := pvType;


    TStreamCoderSocket.SendObject(FCoderSocket, lvSendObj);
    TStreamCoderSocket.RecvObject(FCoderSocket, lvRecvObj);
    if not lvRecvObj.B['__result.result'] then
    begin
      raise Exception.Create(lvRecvObj.S['__result.msg']);
    end;
  finally
    lvSendObj.Free;
    lvRecvObj.Free;
  end;    
end;

constructor TFileOperaObject.Create;
begin
  inherited Create;
  FTcpClient := TDTcpClient.Create(nil);
  FCoderSocket := TDTcpClientCoderImpl.Create(FTcpClient);
  FCMDStream := TMemoryStream.Create;
  FCMDObj := TSimpleMsgPack.Create;
end;

procedure TFileOperaObject.deleteFile(pvRFile, pvType: string);
var
  i, l, lvSize:Integer;
begin
  checkConnect;

  FCMDObj.Clear();
  FCMDObj.S['cmd.namespace'] := 'fileaccess';
  FCMDObj.I['cmd.index'] := 4;   //删除文件
  FCMDObj.S['fileName'] := pvRFile;
  FCMDObj.S['catalog'] := pvType;
  FCMDStream.Clear;
  FCMDObj.EncodeToStream(FCMDStream);

  TStreamCoderSocket.SendObject(FCoderSocket, FCMDStream);

  FCMDStream.Clear;
  TStreamCoderSocket.RecvObject(FCoderSocket, FCMDStream);
  FCMDStream.Position := 0;
  FCMDObj.DecodeFromStream(FCMDStream);

  if not FCMDObj.B['__result.result'] then
  begin
    raise Exception.Create(FCMDObj.S['__result.msg']);
  end;

end;

destructor TFileOperaObject.Destroy;
begin
  FCMDStream.Free;
  FCMDObj.Free;
  FCoderSocket := nil;
  FTcpClient.Free;
  inherited Destroy;
end;

procedure TFileOperaObject.downFile(pvRFile, pvLocalFile, pvType: string);
var
  lvRFileSize:Integer;
var
  lvFileStream:TFileStream;
  i, l, lvSize:Integer;
  lvFileName:String;
  lvCrc, lvChecksum, lvLocalCheckSum:Cardinal;
  lvBytes:TBytes;
begin
  checkConnect;
  
  //if FProgConsole <> nil then FProgConsole.SetHintText('正在获取远程文件大小');
  readFileINfo(pvRFile, pvType);

  lvRFileSize := FFileSize;

  if lvRFileSize = 0 then Exit;
//  if FProgConsole <> nil then
//  begin
//    FProgConsole.SetMax(lvRFileSize);
//    FProgConsole.SetPosition(0);
//  end;

//  lvCheckSum := FFileCheckSum;
//  if lvCheckSum = 0 then raise Exception.Create('服务端文件不存在!');

  lvLocalCheckSum := ChecksumAFile(pvLocalFile);
  if lvCheckSum = lvLocalCheckSum then
  begin
//    if FProgConsole <> nil then
//    begin
//      FProgConsole.SetHintText('秒传文件...');
//      FProgConsole.SetPosition(lvRFileSize);
//      Sleep(1000);
//    end;
    Exit;
  end;
        
  //将文件分段下载<每段固定大小>
  //循环发送
  //  {
  //     fileName:'xxxx',  //客户端请求文件
  //     start:0,          //客户端请求开始位置

  //     filesize:11111,   //文件总大小
  //     crc:xxxx,         //服务端返回
  //     blockSize:4096   //服务端返回
  //  }


  lvFileName := pvLocalFile;
  SysUtils.DeleteFile(lvFileName);

  lvFileStream := TFileStream.Create(lvFileName, fmCreate or fmShareDenyWrite);
  try
//    if FProgConsole <> nil then
//    begin
//      FProgConsole.SetHintText('下载文件中...');
//    end;
    while true do
    begin
//      if FProgConsole <> nil then
//      begin
//        if FProgConsole.IsBreaked then Break;
//      end;
        
      FCMDObj.Clear();
      pressINfo(FCMDObj, pvRFile, pvType);


      FCMDObj.I['cmd.index'] := 1;
      FCMDObj.I['start'] := lvFileStream.Position;

      FCMDStream.Clear;
      FCMDObj.EncodeToStream(FCMDStream);

      TStreamCoderSocket.SendObject(FCoderSocket, FCMDStream);

      FCMDStream.Clear;
      TStreamCoderSocket.RecvObject(FCoderSocket, FCMDStream);
      FCMDStream.Position := 0;
      FCMDObj.DecodeFromStream(FCMDStream);

      if not FCMDObj.B['__result.result'] then
      begin
        raise Exception.Create(FCMDObj.S['__result.msg']);
      end;

//      lvCrc := TCRCTools.crc32Stream(lvRecvObj.Stream);
//      if lvCrc <> lvRecvObj.I['crc'] then
//      begin
//        raise Exception.Create('crc校验失败!');
//      end;
      lvBytes := FCMDObj.ForcePathObject('data').AsBytes;
      lvFileStream.Write(lvBytes[0], Length(lvBytes));

//      if FProgConsole <> nil then
//      begin
//        FProgConsole.SetPosition(lvFileStream.Position);
//      end;
        
      //文件下载完成
      if lvFileStream.Size = FCMDObj.I['fileSize'] then
      begin
        Break;
      end;
    end;
  finally
    lvFileStream.Free;
  end; 
end;

function TFileOperaObject.ChecksumAFile(pvFile:string): Cardinal;
var
  lvFileStream:TFileStream;
  lvCrc:Cardinal;
begin
  result := 0;
  if FileExists(pvFile) then
  begin
    lvFileStream := TFileStream.Create(pvFile, fmOpenRead);
    try
      result := TZipTools.verifyStream(lvFileStream, 0);
    finally
      lvFileStream.Free;
    end;
  end;  
end;

procedure TFileOperaObject.open;
begin
  FTcpClient.Connect;
end;

procedure TFileOperaObject.pressINfo(pvSendObject: TSimpleMsgPack; pvRFile,
    pvType: String);
begin
  pvSendObject.S['cmd.namespace'] := 'fileaccess';
  pvSendObject.S['fileName'] := pvRFile;
  pvSendObject.S['catalog'] := pvType;
end;

procedure TFileOperaObject.readFileINfo(pvRFile, pvType: string; pvChecksum:
    Boolean = true);
var
  lvFileStream:TFileStream;
  i, l, lvSize:Integer;
begin
  checkConnect;

  FCMDObj.Clear();
  FCMDObj.S['cmd.namespace'] := 'fileaccess';
  FCMDObj.I['cmd.index'] := 3;   //文件信息
  FCMDObj.B['cmd.checksum'] := pvChecksum;   //获取checksum值
  FCMDObj.S['fileName'] := pvRFile;
  FCMDObj.S['catalog'] := pvType;

  FCMDStream.Clear;
  FCMDObj.EncodeToStream(FCMDStream);
  TStreamCoderSocket.SendObject(FCoderSocket, FCMDStream);

  FCMDStream.Clear;
  TStreamCoderSocket.RecvObject(FCoderSocket, FCMDStream);
  FCMDStream.Position := 0;
  FCMDObj.DecodeFromStream(FCMDStream);
  
  if not FCMDObj.B['__result.result'] then
  begin
    raise Exception.Create(FCMDObj.S['__result.msg']);
  end;
  FFileSize := FCMDObj.I['info.size'];
  FFileCheckSum := FCMDObj.I['info.checksum'];

end;

procedure TFileOperaObject.setHost(pvHost: string);
begin
  FTcpClient.Host := pvHost;
end;

procedure TFileOperaObject.setPort(pvPort: Integer);
begin
  FTcpClient.Port := pvPort;
end;

{ TFileOperaObject }


function TFileOperaObject.uploadFile(pvRFile:String; pvLocalFile:string;
    pvType:string): Int64;
var
  lvFileStream:TFileStream;

  lvPosition, i, l, lvSize:Int64;
  lvCheckSum, lvLocalCheckSum:Cardinal;
begin
  //将文件分段传递<每段固定大小> 4K
  //循环发送
  //  {
  //     fileName:'xxxx',
  //     crc:xxxx,
  //     start:0,   //开始位置
  //     eof:true,  //最后一个
  //  }

  checkConnect;
  
  //lvLocalCheckSum := ChecksumAFile(pvLocalFile);

  lvFileStream := TFileStream.Create(pvLocalFile, fmOpenRead);
  try
    //readFileINfo(pvRFile, pvType);

//    lvCheckSum := FFileCheckSum;
//
//
//    if lvCheckSum = lvLocalCheckSum then
//    begin
////      if FProgConsole <> nil then
////      begin
////        FProgConsole.SetHintText('秒传文件...');
////        FProgConsole.SetPosition(lvFileStream.Size);
////        Sleep(1000);
////      end;
//      Exit;
//    end;

    while true do
    begin
//      if FProgConsole <> nil then
//      begin
//        if FProgConsole.IsBreaked then Break;
//      end;
//
      FCMDObj.Clear();
      if pvRFile = '' then
      begin
        pressINfo(FCMDObj, ExtractFileName(pvLocalFile), pvType);
      end else
      begin
        pressINfo(FCMDObj, pvRFile, pvType);
      end;
      FCMDObj.S['cmd.namespace'] := 'fileaccess';
      FCMDObj.I['cmd.index'] := 2;   //上传文件

      lvPosition:=lvFileStream.Position;
      FCMDObj.I['start'] := lvPosition;
//      if lvFileStream.Position = 102400 then
//      begin
//        FCMDObj.I['start'] := lvFileStream.Position;
//      end;
//      if lvFileStream.Position = 0 then
//      begin
//        FCMDObj.I['start'] := 0;
//      end;

//     FCMDObj.S['startStr'] := IntToStr(lvFileStream.Position);
      
      lvSize := Min(SEC_SIZE, lvFileStream.Size-lvFileStream.Position);
      if lvSize = 0 then
      begin
        Break;
      end else
      begin
        FCMDObj.ForcePathObject('data').LoadBinaryFromStream(lvFileStream, lvSize);

        FCMDObj.I['size'] := lvSize;
        if (lvFileStream.Position = lvFileStream.Size) then
        begin
          FCMDObj.B['eof'] := true;
        end;

        FCMDStream.Clear;
        FCMDObj.EncodeToStream(FCMDStream);


        TStreamCoderSocket.SendObject(FCoderSocket, FCMDStream);

        FCMDStream.Clear;
        TStreamCoderSocket.RecvObject(FCoderSocket, FCMDStream);
        FCMDStream.Position := 0;
        FCMDObj.DecodeFromStream(FCMDStream);

        if not FCMDObj.B['__result.result'] then
        begin
          raise Exception.Create(FCMDObj.S['__result.msg']);
        end;

  //      if FProgConsole <> nil then
  //      begin
  //        FProgConsole.SetPosition(lvFileStream.Position);
  //      end;

        if (lvFileStream.Position = lvFileStream.Size) then
        begin
          Break;
        end;
      end;
    end;
    Result := lvFileStream.Size;
  finally
    lvFileStream.Free;
  end;
end;

end.
