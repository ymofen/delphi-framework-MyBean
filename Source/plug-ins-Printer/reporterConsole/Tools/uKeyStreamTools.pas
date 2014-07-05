unit uKeyStreamTools;

interface

uses
  KeyStream, Classes, IdGlobal;

type
  TKeyStreamTools =class(TObject)
  public
    class procedure AddString(const pvKeyStream: TKeyStream; pvKey, pvData: string);
    class procedure AddFile(const pvKeyStream: TKeyStream; pvKey, pvFileName: string);
    class function DecodeStringFromStream(pvStream:TStream): string;
    class function ExtractString(const pvKeyStream: TKeyStream; pvKey: string): string;
    class function encodeString2Stream(pvString:string): TMemoryStream;
    class procedure ExtractStream(const pvKeyStream: TKeyStream; pvKey: string;
        pvDATAStream:TStream);
  end;

implementation

class procedure TKeyStreamTools.AddFile(const pvKeyStream: TKeyStream; pvKey,
    pvFileName: string);
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

class procedure TKeyStreamTools.AddString(const pvKeyStream: TKeyStream; pvKey,
    pvData: string);
var
  lvStream:TMemoryStream;
begin
  lvStream := encodeString2Stream(pvData);
  pvKeyStream.Add(pvKey, lvStream, True);
end;

class function TKeyStreamTools.DecodeStringFromStream(pvStream:TStream): string;
var
  lvByte:TIdBytes;
begin
  pvStream.Position := 0;
  SetLength(lvByte, pvStream.Size);
  pvStream.Read(lvByte[0], pvStream.Size);
  Result := BytesToString(lvByte, TIdTextEncoding.UTF8, TIdTextEncoding.Default);
end;

class function TKeyStreamTools.encodeString2Stream(pvString:string):
    TMemoryStream;
var
  lvBytes:TIdBytes;
begin
  Result := TMemoryStream.Create;
  try
    lvBytes := ToBytes(pvString, TIdTextEncoding.UTF8);
    Result.WriteBuffer(lvBytes[0], Length(lvBytes));
  except
    Result.Free;
    raise;
  end;
end;

class procedure TKeyStreamTools.ExtractStream(const pvKeyStream: TKeyStream;
    pvKey: string; pvDATAStream:TStream);
var
  lvStream:TStream;
begin
  lvStream := pvKeyStream.getStream(pvKey);
  if lvStream <> nil then
  begin
    lvStream.Position :=0;
    pvDATAStream.CopyFrom(lvStream, lvStream.Size);
  end;
end;

class function TKeyStreamTools.ExtractString(const pvKeyStream: TKeyStream;
    pvKey: string): string;
var
  lvStream:TStream;
begin
  lvStream := pvKeyStream.getStream(pvKey);
  if lvStream <> nil then
  begin
    Result := DecodeStringFromStream(lvStream);
  end else
  begin
    Result := '';
  end;
end;

end.
