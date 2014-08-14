(*
  2014年7月21日 15:36:28
   添加superObject2Variant函数
*)
unit uSOConvertTools;

interface

{$if CompilerVersion>= 23}
  {$define HAVE_UINT_TYPE}
{$ifend}

uses
  superobject, Variants, SysUtils;

type
  TSOConvertTools = class(TObject)
  public

    /// <summary>
    ///   将json对象，转换成Variant值
    /// </summary>
    class function superObject2Var(const pvData: ISuperObject): Variant;

    /// <summary>
    ///   JSon值对象转换成SQL字符
    /// </summary>
    class function superObject2SQLString(pvData:ISuperObject): String;
    /// <summary>
    ///   将Var值转换成Boolean类型的值
    /// </summary>
    class function var2AsBoolean(pvValue:Variant): ISuperObject;

    /// <summary>
    ///   variant转换为superobject
    /// </summary>
    class function var2SuperObject(pvValue:Variant): ISuperObject;

    /// <summary>
    ///  将superObject中的值转成Boolean值
    /// </summary>
    class function superObjectAsBoolean(pvValue:ISuperObject):Boolean;
  end;


implementation

class function TSOConvertTools.superObject2Var(const pvData: ISuperObject):
    Variant;
begin
  if pvData = nil then
  begin
    Result := null;
  end else
  begin
    case pvData.DataType of
      stInt: Result := pvData.AsInteger;
      stDouble: Result := pvData.AsDouble;
      stBoolean: Result := pvData.AsBoolean;
      stNull: Result := null;
      stCurrency: Result := pvData.AsCurrency;
      stObject: Result := pvData.AsJSon(False);
    else
      Result := pvData.AsString;
    end;
  end;
end;

class function TSOConvertTools.superObject2SQLString(pvData:ISuperObject):
    String;
var
  lvType:TSuperType;
begin
  if pvData = nil then
  begin
    Result := 'null';
  end else
  begin
    lvType := pvData.DataType;
    if lvType = stNull then
    begin
      Result := 'null';
    end else if lvType = stBoolean then
    begin
      if pvData.AsBoolean then
      begin
        Result := '1';
      end else
      begin
        Result := '0';
      end;
    end else if lvType in [stDouble, stInt] then
    begin
      Result := pvData.AsString;
    end else
    begin
      Result := QuotedStr(pvData.AsString);
    end;
  end;
end;

class function TSOConvertTools.superObjectAsBoolean(
  pvValue: ISuperObject): Boolean;
var
  lvStr:String;
begin
  Result := false;
  if pvValue = nil then exit;
  if pvValue.DataType = stNull then Exit;
  if pvValue.DataType = stBoolean then
  begin
    Result := pvValue.AsBoolean;
  end else if pvValue.DataType = stString then
  begin
    lvStr := LowerCase(trim(pvValue.AsString));
    Result := (lvStr = '1') or (lvStr = 'true');
  end else if pvValue.DataType in [stInt] then
  begin
    Result := pvValue.AsInteger = 1;
  end;
end;

class function TSOConvertTools.var2AsBoolean(pvValue: Variant): ISuperObject;
var
  lvType:TVarType;
  lvTempStr:String;
begin
  lvType := TVarData(pvValue).VType;

  if lvType in [varEmpty, varNull] then
  begin
    Result := nil;
  end else if lvType in [varInteger, varSmallint,
     varInt64, varDouble, varSingle,
     varWord, varByte, varShortInt, varLongWord
     {$if defined(NEED_FORMATSETTINGS)}FormatSettings varUInt64{$ifend}


     ] then
  begin
    if pvValue = 1 then
    begin
      Result := SO(True);
    end else
    begin
      Result := SO(False);
    end;
  end else
  begin
    lvTempStr :=VarToStrDef(pvValue, '');
    lvTempStr := LowerCase(lvTempStr);
    if (lvTempStr = 'true')
      or (lvTempStr = '1')
      then
    begin
      Result := SO(True);
    end else
    begin
      Result := SO(False);
    end;
  end;
end;

class function TSOConvertTools.var2SuperObject(pvValue:Variant): ISuperObject;
var
  lvType:TVarType;
  lvTempStr:String;
begin
  lvType := TVarData(pvValue).VType;

  if lvType in [varEmpty, varNull] then
  begin
    Result := SO(pvValue);
  end else if lvType = varDate then
  begin
    lvTempStr :=FormatDateTime('yyyy-MM-dd hh:nn:ss.zzz', TVarData(pvValue).VDate);
    Result := TSuperObject.Create(SOString(lvTempStr));
  end else
  begin
    Result := SO(pvValue);
  end;

end;

end.
