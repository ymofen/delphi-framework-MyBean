unit uSOTools;

interface

uses
  superobject, SysUtils, Classes, Variants;

type
  TSOTools = class(TObject)
  public
    /// <summary>
    ///   产生一个Hash值
    ///    QDAC群主的Hash函数
    /// </summary>
    class function hashOf(const p:Pointer;l:Integer): Integer;overload;


    /// <summary>
    ///   产生一个Hash值
    /// </summary>
    class function hashOf(const vStrData:String): Integer; overload;
    
    /// <summary>
    ///   从文件中解析
    /// </summary>
    class function JsnParseFromFile(pvFile: string): ISuperObject;

    /// <summary>
    ///   将pvData数据保存到文件中
    /// </summary>
    class function JsnSaveToFile(pvData: ISuperObject; pvFile: string): Boolean;

    /// <summary>
    ///   制作一个JSonKey
    /// </summary>
    class function makeMapKey(pvStringData: string): String;
  end;

implementation

class function TSOTools.hashOf(const vStrData:String): Integer;
var
  lvStr:AnsiString;
begin
  lvStr := AnsiString(vStrData);
  Result := hashOf(PAnsiChar(lvStr), Length(lvStr));
end;

class function TSOTools.hashOf(const p:Pointer;l:Integer): Integer;
var
  ps:PInteger;
  lr:Integer;
begin
  Result:=0;
  if l>0 then
  begin
    ps:=p;
    lr:=(l and $03);//检查长度是否为4的整数倍
    l:=(l and $FFFFFFFC);//整数长度
    while l>0 do
    begin
      Result:=((Result shl 5) or (Result shr 27)) xor ps^;
      Inc(ps);
      Dec(l,4);
    end;
    if lr<>0 then
    begin
      l:=0;
      Move(ps^,l,lr);
      Result:=((Result shl 5) or (Result shr 27)) xor l;
    end;
  end;
end;



class function TSOTools.JsnParseFromFile(pvFile: string): ISuperObject;
var
  lvStream: TMemoryStream;
  lvStr: AnsiString;
begin
  Result := nil;
  if FileExists(pvFile) then
  begin
    lvStream := TMemoryStream.Create;
    try
      lvStream.LoadFromFile(pvFile);
      lvStream.Position := 0;
      SetLength(lvStr, lvStream.Size);
      lvStream.ReadBuffer(lvStr[1], lvStream.Size);
      Result := SO(lvStr);
    finally
      lvStream.Free;
    end;
  end;
  if Result <> nil then
    if not (Result.DataType in [stArray, stObject]) then
      Result := nil;
end;

class function TSOTools.JsnSaveToFile(pvData: ISuperObject; pvFile: string):
    Boolean;
var
  lvStrings: TStrings;
  lvStream: TMemoryStream;

  lvStr: AnsiString;
begin
  Result := false;
  if pvData = nil then exit;
  lvStream := TMemoryStream.Create;
  try
    lvStr := pvData.AsJSon(True, False);
    if lvStr <> '' then
      lvStream.WriteBuffer(lvStr[1], Length(lvStr));
    lvStream.SaveToFile(pvFile);
    Result := true;
  finally
    lvStream.Free;
  end;
end;

class function TSOTools.makeMapKey(pvStringData: string): String;
var
  lvCheckCanKey:Boolean;
  lvMapKey:AnsiString;
  i:Integer;
begin
  Result := '';
  lvMapKey := Trim(LowerCase(AnsiString(pvStringData)));
  if lvMapKey = '' then exit;

  lvCheckCanKey := True;

  //判断是否可以做JSON主键
  for I := 1 to Length(lvMapKey) do
  begin
    if not (lvMapKey[i] in ['a'..'z','0'..'9', '_']) then
    begin
      lvCheckCanKey := false;
      Break;
    end;
  end;

  if lvCheckCanKey then
  begin
    Result := lvMapKey;
  end else
  begin
    //使用hash值
    Result := '_' + IntToStr(hashOf(pvStringData));
    //Result := '_' + IntToStr(TSuperAvlEntry.Hash(pvStringData));
  end;
end;


end.

