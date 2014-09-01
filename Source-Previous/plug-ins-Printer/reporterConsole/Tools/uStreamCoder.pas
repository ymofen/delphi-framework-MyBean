unit uStreamCoder;

interface

uses
  Classes;

type
  TStreamCoder = class(TObject)
  public
    //把Stream转换成字符串
    class function DecodeStringFromStream(pvStream:TStream): string;

    //打包成整个Stream
    class function EncodeString2Stream(pvString:string): TMemoryStream;
  end;

implementation

class function TStreamCoder.DecodeStringFromStream(pvStream:TStream): string;
begin
  Result := '';
  pvStream.Position := 0;
  SetLength(Result, pvStream.Size);
  pvStream.Read(Result[1], pvStream.Size);
end;

class function TStreamCoder.EncodeString2Stream(pvString:string): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  try
    Result.WriteBuffer(pvString[1], Length(pvString));
  except
    Result.Free;
    raise;
  end;
end;

end.
