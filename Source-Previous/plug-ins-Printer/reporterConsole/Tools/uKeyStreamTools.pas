unit uKeyStreamTools;

interface

uses
  KeyStream, Classes, SysUtils;

type
  TKeyStreamTools =class(TObject)
  public
    class function ansiString2Utf8Bytes(v:AnsiString): TBytes;
    class function Utf8Bytes2AnsiString(pvData:TBytes): AnsiString;
    
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

class function TKeyStreamTools.ansiString2Utf8Bytes(v:AnsiString): TBytes;
var
  lvTemp:AnsiString;
begin
  lvTemp := AnsiToUtf8(v);
  SetLength(Result, Length(lvTemp));
  Move(lvTemp[1], Result[0],  Length(lvTemp));
end;

class function TKeyStreamTools.DecodeStringFromStream(pvStream:TStream): string;
var
  lvByte:TBytes;
begin
  pvStream.Position := 0;
  SetLength(lvByte, pvStream.Size);
  pvStream.Read(lvByte[0], pvStream.Size);
  Result := Utf8Bytes2AnsiString(lvByte);
end;

class function TKeyStreamTools.encodeString2Stream(pvString:string):
    TMemoryStream;
var
  lvBytes:TBytes;
begin
  Result := TMemoryStream.Create;
  try
    lvBytes := ansiString2Utf8Bytes(pvString);
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

class function TKeyStreamTools.Utf8Bytes2AnsiString(pvData:TBytes): AnsiString;
var
  lvTemp:AnsiString;
begin
  SetLength(lvTemp, Length(pvData));
  Move(pvData[0], lvTemp[1],  Length(pvData));
  Result := Utf8ToAnsi(lvTemp);
end;

end.
