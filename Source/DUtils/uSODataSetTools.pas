unit uSODataSetTools;

interface

uses
  superobject, SysUtils, Variants, DB;

type
  TSODataSetTools = class(TObject)
  protected
  public
    /// <summary>
    ///  得到一个Hash值
    /// </summary>
    class function Hash(const pvString: AnsiString): Cardinal;

    /// <summary>
    ///   制作一个JSonKey
    /// </summary>
    class function makeMapKey(pvStringData: AnsiString): AnsiString;


    /// <summary>
    ///   将superObject写入字段的值
    /// </summary>
    class procedure superObjectWrite2Field(pvField:TField; pvValue:ISuperObject);


  public

    /// <summary>
    ///   打包当前记录到一个新的JSon包
    /// </summary>
    class function Record2SuperObjectPack(pvDataSet: TDataSet): ISuperObject;

    /// <summary>
    ///   将数据集的所有记录写入到一个superobject 数组中区
    /// </summary>
    class function DataSet2SuperObjectPack(pvDataSet:TDataSet): ISuperObject;

    /// <summary>
    ///   将JSon记录写入到当前记录
    /// </summary>
    class procedure superObjectPack2Record(pvDataSet: TDataSet; pvSuperObjectPack:
        ISuperObject);
  end;

implementation

uses
  uSOConvertTools;

class function TSODataSetTools.DataSet2SuperObjectPack(pvDataSet:TDataSet):
    ISuperObject;
begin
  Result := SO('[]');
  pvDataSet.DisableControls;
  try
    pvDataSet.First;
    try
      while not pvDataSet.Eof do
      begin
        Result.AsArray.Add(Record2SuperObjectPack(pvDataSet));
        pvDataSet.Next;
      end;
    finally
      pvDataSet.Next;
    end;
  finally
    pvDataSet.EnableControls;
  end;
end;

class function TSODataSetTools.Hash(const pvString: AnsiString): Cardinal;
var
  h: cardinal;
  i: Integer;
begin
  h := 0;
  for i := 1 to Length(pvString) do
    h := h*129 + ord(pvString[i]) + $9e370001;
  Result := h;
end;

class procedure TSODataSetTools.superObjectPack2Record(pvDataSet: TDataSet;
    pvSuperObjectPack: ISuperObject);
var
  lvField:TField;
  i:Integer;
  lvData, lvFieldData:ISuperObject;
begin
  if not (pvDataSet.State in dsEditModes) then
  begin
    if pvDataSet.IsEmpty then
    begin
      pvDataSet.Append;
    end else
    begin
      pvDataSet.Edit;
    end;
  end;

  for i := 0 to pvDataSet.FieldCount - 1 do
  begin
    lvField := pvDataSet.Fields[i];
    lvData := pvSuperObjectPack.O[makeMapKey(lvField.FieldName)];
    if lvData <> nil then
    begin
      superObjectWrite2Field(lvField, lvData);
    end;
  end;
end;

class function TSODataSetTools.makeMapKey(pvStringData: AnsiString): AnsiString;
var
  lvCheckCanKey:Boolean;
  lvMapKey:AnsiString;
  i:Integer;
begin
  Result := '';
  lvMapKey := Trim(LowerCase(pvStringData));
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
    Result := '_' + IntToStr(TSuperAvlEntry.Hash(pvStringData));
  end;
end;

class function TSODataSetTools.Record2SuperObjectPack(pvDataSet: TDataSet):
    ISuperObject;
var
  lvField:TField;
  i:Integer;
  lvData, lvFieldData:ISuperObject;
  lvTempStr:String;
begin
  lvData := SO();
  for i := 0 to pvDataSet.FieldCount - 1 do
  begin
    lvField := pvDataSet.Fields[i];
    lvTempStr := makeMapKey(lvField.FieldName);
    lvData.O[lvTempStr] := TSOConvertTools.var2SuperObject(lvField.Value);
  end;
  Result := lvData;
end;

class procedure TSODataSetTools.superObjectWrite2Field(pvField: TField;
  pvValue: ISuperObject);
begin
  if pvField.DataType = ftBoolean then
  begin
    pvField.AsBoolean := TSOConvertTools.superObjectAsBoolean(pvValue);
  end else if pvValue.IsType(stDouble) then
    pvField.AsFloat := pvValue.AsDouble
  else if pvValue.IsType(stInt) then
    pvField.AsInteger := pvValue.AsInteger
  else if pvValue.IsType(stNull) then
    pvField.Clear
  else
    pvField.AsString := pvValue.AsString;
end;

end.
