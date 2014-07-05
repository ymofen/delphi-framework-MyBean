unit uKeyStreamFileCoder;
{
   文件流编码和加码
}

interface

uses
  KeyStream, Classes, SysUtils, uStreamCoder;

type
  TKeyStreamFileCoder = class(TObject)
  public
    class procedure AddFile(const pvKeyStream: TKeyStream; pvKey, pvFileName:
        string);
    class procedure AddString(const pvKeyStream: TKeyStream; pvKey, pvData: string);
    class procedure Encode2Stream(const pvKeyStream: TKeyStream; pvStream: TStream);
    class procedure DecodeFromStream(const pvKeyStream: TKeyStream; pvStream: TStream);

    class procedure Encode2File(const pvKeyStream: TKeyStream; pvFile: string);
    class procedure DecodeFromFile(const pvKeyStream: TKeyStream; pvFile: string);
    class function ExtractString(const pvKeyStream: TKeyStream; pvKey: string):
        string;
  end;

implementation

class procedure TKeyStreamFileCoder.AddFile(const pvKeyStream: TKeyStream;
    pvKey, pvFileName: string);
var
  lvStream:TMemoryStream;
begin
  lvStream := TMemoryStream.Create;
  try
    lvStream.LoadFromFile(pvFileName);
    pvKeyStream.Add(pvKey, lvStream, True);
  except
    lvStream.Free;
    lvStream := nil;
    raise;
  end;
end;

class procedure TKeyStreamFileCoder.AddString(const pvKeyStream: TKeyStream;
    pvKey, pvData: string);
var
  lvStream:TMemoryStream;
begin
  lvStream := TStreamCoder.EncodeString2Stream(pvData);
  pvKeyStream.Add(pvKey, lvStream, True);
end;

class procedure TKeyStreamFileCoder.DecodeFromFile(const pvKeyStream:
    TKeyStream; pvFile: string);
var
  lvStream:TMemoryStream;
begin
  if not FileExists(pvFile) then raise Exception.Create('文件不存在' + pvFile);


  lvStream := TMemoryStream.Create;
  try
    lvStream.LoadFromFile(pvFile);
    lvStream.Position := 0;
    DecodeFromStream(pvKeyStream, lvStream);
  finally
    lvStream.Free;
  end;                                    
end;

class procedure TKeyStreamFileCoder.DecodeFromStream(const pvKeyStream: TKeyStream;
    pvStream: TStream);
var
  lvByte, lvKeyBytes:array of Byte;
  l, r:Integer;
  lvKey:String;
  lvItem:TKeyStreamItem;
  lvStream:TMemoryStream;
begin
  if pvStream.Size = 0 then exit;

  pvStream.Position := 0;

  while True do
  begin
    r := pvStream.Read(l, SizeOf(Integer));
    if r = 0 then
    begin
      Break;
    end;

    SetLength(lvKey, l);
    pvStream.Read(lvKey[1], l);

    //stream
    pvStream.Read(l, SizeOf(Integer));
    SetLength(lvByte, l);
    pvStream.Read(lvByte[0], l);

    
    lvStream := TMemoryStream.Create;
    try
      lvStream.WriteBuffer(lvByte[0], l);
    except
      lvStream.Free;
      raise;
    end;

    pvKeyStream.Add(lvKey, lvStream, True);
  end;  
end;

class procedure TKeyStreamFileCoder.Encode2File(const pvKeyStream: TKeyStream;
    pvFile: string);
var
  lvStream:TMemoryStream;
begin
  lvStream := TMemoryStream.Create;
  try
    Encode2Stream(pvKeyStream, lvStream);
    lvStream.SaveToFile(pvFile);
  finally
    lvStream.Free;
  end;
end;

class procedure TKeyStreamFileCoder.Encode2Stream(const pvKeyStream: TKeyStream;
    pvStream: TStream);
var
  lvBytes:array of Byte;
  i, lvKeyLength, lvStreamLength:Integer;
  lvItem:TKeyStreamItem;
  sData:String;
begin
  for i := 0 to pvKeyStream.Count - 1 do
  begin
    lvItem := pvKeyStream.getItemObject(i);
    sData := lvItem.Key;
    lvKeyLength := Length(sData);

    //Key长度
    pvStream.WriteBuffer(lvKeyLength, SizeOf(lvKeyLength));
    //Key字符
    pvStream.WriteBuffer(sData[1], lvKeyLength);


    lvStreamLength := lvItem.Stream.Size;
    
    pvStream.WriteBuffer(lvStreamLength, SizeOf(lvStreamLength));
    //Stream
    if lvStreamLength> 0 then
    begin
      SetLength(lvBytes, lvStreamLength);
      lvItem.Stream.Position := 0;
      lvItem.Stream.ReadBuffer(lvBytes[0], lvStreamLength);
      pvStream.WriteBuffer(lvBytes[0], Length(lvBytes));
    end;
  end;
end;

class function TKeyStreamFileCoder.ExtractString(const pvKeyStream: TKeyStream;
    pvKey: string): string;
var
  lvStream:TStream;
begin
  lvStream := pvKeyStream.getStream(pvKey);
  if lvStream <> nil then
  begin
    Result := TStreamCoder.DecodeStringFromStream(lvStream);
  end else
  begin
    Result := '';
  end;
end;

end.
