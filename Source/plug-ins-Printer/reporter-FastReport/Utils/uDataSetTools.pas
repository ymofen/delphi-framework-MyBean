unit uDataSetTools;

interface

uses
  DB, Classes, SysUtils, Variants, superobject, Controls;

type
  TDataSetTools = class(TObject)
  private
    class function CombineStrings(const strs: array of string; ifEmptyThenAllEmpty:
      Boolean = true): string;
  public

    class procedure FillRequireFieldData(pvDataSet:TDataSet);


    //判断字段是否为空值
    class function CheckFieldIsEmpty(pvDataSet:TDataSet; pvField:string): Boolean;
        overload;

    class function checkFieldIsEmpty(pvField:TField): Boolean; overload;

    //查找字段
    class function FindField(pvDataSet: TDataSet; const fields: array of string): TField;
    class function ExtractCaption(pvDataSet: TDataSet): string;

    //获取字段的值
    class function ExtractField(pvDataSet: TDataSet; pvField: string = '';
        pvSpliter: String = ','; pvLeft: String = ''; pvRight: String = '';
        pvIgnoreEmpty: Boolean = true; pvDisableControls: Boolean = true): string;

    class function BlobAsString(lvField: TField): string;

    class procedure BlobFieldSetString(lvField: TField; pvData: string);

    

    class procedure DataSetPost(pvDataSet: TDataSet);
    class procedure DataSetEdit(pvDataSet: TDataSet);


    class function DisableControlsAndGetBookMark(pvDataSet: TDataSet): Pointer;
    class procedure EnableControlsAndFreeBookMark(pvDataSet: TDataSet; pvBookMark:
      Pointer);

    /// <summary>
    ///   删除数据集的所有记录
    /// </summary>
    /// <param name="pvDataSet"> (TDataSet) </param>
    class procedure DeleteAllRecord(pvDataSet: TDataSet; pvDisableControls: Boolean
      = true);

    //1 合计一个字段的值
    class function Total(pvDataSet:TDataSet; pvFieldName:string; pvDisableControls:
        Boolean = true): Double;

    /// <summary>
    ///   统计一个最大的值
    /// </summary>
    /// <returns> Variant
    /// </returns>
    /// <param name="pvDataSet"> (TDataSet) </param>
    /// <param name="pvFieldName"> (string) </param>
    /// <param name="pvDisableControls"> (Boolean) </param>
    class function CalcuMaxFloat(pvDataSet:TDataSet; pvFieldName:string;
        pvDisableControls: Boolean = true): Double;

  public
    /// <summary>将SourceDataSet中的当前记录数据Copy到pvDestination中
    /// </summary>
    /// <param name="pvSourceDataSet"> (TDataSet) </param>
    /// <param name="pvDestination"> (TDataSet) </param>
    /// <param name="pvCopyFields">用逗号(,)或者分号(;)分开 </param>
    /// <param name="pvIgnoreFields">用逗号(,)或者分号(;)分开 </param>
    /// <param name="pvIfSourceFieldIsEmptyThenIgnore">如果源字段为空是否进行忽略赋值 </param>
    class procedure CopyDataSetRecord(pvSourceDataSet, pvDestination: TDataSet;
        pvIfSourceFieldIsEmptyThenIgnore: Boolean = false);


    procedure ExtractDataSetFields(pvDataSet: TDataSet; pvStrings: TStrings);






    /// <summary>TDataSetTools.GetLocateValueFromJSonData
    /// </summary>
    /// <returns> Variant
    /// </returns>
    /// <param name="pvData">
    /// 提供的原始数据
    /// {
    ///    "field":"value",
    ///    "field2":{"value":12},
    /// }
    /// </param>
    /// <param name="pvKeyFields">
    /// 要定位的字段列表
    /// 值从pvData中获取
    /// </param>
    class function GetLocateValueFromJSonData(pvData: ISuperObject; const
        pvKeyFields: string): Variant;


    /// <summary>
    ///   循环设置设置字段的值
    /// </summary>
    /// <param name="pvFieldName"> 字段名 </param>
    /// <param name="pvValue"> 字段值 </param>
    class procedure setDataSetFieldValue(pvDataSet: TDataSet; pvFieldName: String;
        pvValue: Variant; pvDisableControl: Boolean = true);
    class procedure setDataSource(AControl: TControl; ADataSource: TDataSource);
  end;

implementation

uses
  Math;

class function TDataSetTools.BlobAsString(lvField: TField): string;
var
  lvStream: TMemoryStream;
begin
  Result := '';
  lvStream := TMemoryStream.Create;
  try
    TBlobField(lvField).SaveToStream(lvStream);
    if lvStream.Size > 0 then
    begin
      lvStream.Position := 0;
      SetLength(Result, lvStream.Size);
      lvStream.ReadBuffer(Result[1], lvStream.Size);
    end;
  finally
    lvStream.Free;
  end;
end;

class procedure TDataSetTools.BlobFieldSetString(lvField: TField; pvData: string);
var
  lvStream: TMemoryStream;
begin
  lvStream := TMemoryStream.Create;
  try
    lvStream.WriteBuffer(pvData[1], Length(pvData));
    lvStream.Position := 0;
    TBlobField(lvField).LoadFromStream(lvStream);
  finally
    lvStream.Free;
  end;
end;

class function TDataSetTools.CheckFieldIsEmpty(pvDataSet:TDataSet;
    pvField:string): Boolean;
var
  lvField:TField;
begin
  lvField := pvDataSet.FindField(pvField);
  if lvField = nil then
  begin
    Result := True;
  end else
  begin
    Result := checkFieldIsEmpty(lvField);
  end;

end;

class function TDataSetTools.checkFieldIsEmpty(pvField:TField): Boolean;
begin
  if (pvField.IsNull) then
  begin
    Result := True;
  end else if (not pvField.IsBlob) and (pvField.AsString = '') then
  begin
    Result := True;
  end else
  begin
    Result := False;
  end;
end;

class function TDataSetTools.CombineStrings(const strs: array of string;
  ifEmptyThenAllEmpty: Boolean = true): string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(strs) to High(strs) do
  begin
    if (Length(strs[i]) = 0) and (ifEmptyThenAllEmpty) then
    begin
      Result := '';
      Break;
    end;

    Result := Result + strs[i];
  end;
end;

class procedure TDataSetTools.CopyDataSetRecord(pvSourceDataSet, pvDestination:
    TDataSet; pvIfSourceFieldIsEmptyThenIgnore: Boolean = false);
var
  lvField, lvDField: TField;
  i: Integer;
begin
    pvDestination.Edit;

  for i := 0 to pvSourceDataSet.FieldCount - 1 do
  begin
    lvField := pvSourceDataSet.Fields[i];
    lvDField := pvDestination.FindField(lvField.FieldName);
    if (lvDField <> nil)  then
    begin
      if (not pvIfSourceFieldIsEmptyThenIgnore)  //空值不忽略
          or
         (not TDataSetTools.CheckFieldIsEmpty(lvField))  //字段不为空
      then
      begin
        lvDField.AsVariant := lvField.AsVariant;
      end;
    end;
  end;

end;

class procedure TDataSetTools.DataSetEdit(pvDataSet: TDataSet);
begin
  if not (pvDataSet.State in [dsInsert, dsEdit]) then pvDataSet.Edit;
end;

class procedure TDataSetTools.DataSetPost(pvDataSet: TDataSet);
begin
  if pvDataSet.State in [dsInsert, dsEdit] then pvDataSet.Post;
end;

class procedure TDataSetTools.DeleteAllRecord(pvDataSet: TDataSet;
  pvDisableControls: Boolean = true);
begin
  if not pvDataSet.Active then exit;

  if pvDisableControls then pvDataSet.DisableControls;
  try
    while pvDataSet.RecordCount > 0 do pvDataSet.Delete;
  finally
    if pvDisableControls then pvDataSet.EnableControls;
  end;
end;

class function TDataSetTools.DisableControlsAndGetBookMark(pvDataSet:
  TDataSet): Pointer;
begin
  pvDataSet.DisableControls;
  Result := pvDataSet.GetBookmark;
end;

class procedure TDataSetTools.EnableControlsAndFreeBookMark(pvDataSet:
  TDataSet; pvBookMark: Pointer);
begin
  try
    if (pvBookMark <> nil) then
    begin
      try
      if pvDataSet.BookmarkValid(pvBookMark) then pvDataSet.GotoBookmark(pvBookMark);
      except
      end; 
      //需要进行内存释放,否则会内存泄漏
      pvDataSet.FreeBookmark(pvBookMark);
    end;
  except
  end;
  pvDataSet.EnableControls;
end;

class function TDataSetTools.ExtractCaption(pvDataSet: TDataSet): string;
var
  lvField: TField;
  lvName, lvCode: string;
begin
  lvField := FindField(pvDataSet, ['FName', 'FCaption']);
  if lvField <> nil then
    lvName := lvField.AsString;

  lvField := FindField(pvDataSet, ['FCode', 'FIndex']);
  if lvField <> nil then
    lvCode := lvField.AsString;

  Result := lvName + CombineStrings(['(', lvCode, ')']);
end;

procedure TDataSetTools.ExtractDataSetFields(pvDataSet: TDataSet; pvStrings:
    TStrings);
var
  i:Integer;
begin
  for i := 0 to pvDataSet.FieldCount - 1 do
  begin
    pvStrings.Add(pvDataSet.Fields[i].FieldName);
  end;
end;

class function TDataSetTools.ExtractField(pvDataSet: TDataSet; pvField: string
    = ''; pvSpliter: String = ','; pvLeft: String = ''; pvRight: String = '';
    pvIgnoreEmpty: Boolean = true; pvDisableControls: Boolean = true): string;
var
  lvField:TField;
  lvValue:String;
  lvBookmark:TBookmark;
begin
  if pvField = '' then
    lvField := pvDataSet.Fields[0]
  else
    lvField := pvDataSet.FieldByName(pvField);

  Result := '';

  if pvDisableControls then  
    lvBookmark := TDataSetTools.DisableControlsAndGetBookMark(pvDataSet);
  try
    pvDataSet.First;
    while not pvDataSet.Eof do
    begin
      lvValue := lvField.AsString;
      if (lvValue = '') and (pvIgnoreEmpty) then
      begin

      end else
      begin
        lvValue := pvLeft + lvValue + pvRight;
        Result := Result + lvValue + pvSpliter;
      end;
      pvDataSet.Next;
    end;
  finally
    if pvDisableControls then
      TDataSetTools.EnableControlsAndFreeBookMark(pvDataSet, lvBookmark);
  end;
  if Result <> '' then
  begin
    SetLength(Result, Length(Result)- Length(pvSpliter));
  end;
end;

class procedure TDataSetTools.FillRequireFieldData(pvDataSet:TDataSet);
var
  lvField:TField;
  i:Integer;
begin
  DataSetEdit(pvDataSet);
  for i := 0 to pvDataSet.FieldCount - 1 do
  begin
    lvField :=pvDataSet.Fields[i];
    if lvField.Required then
    begin
      if lvField.DataType in [ftGuid] then
      begin
        lvField.AsString := '{00000000-0000-0000-0000-000000000001}';
      end else if lvField.DataType in [ftInteger, ftFloat, ftWord, ftCurrency] then
      begin
        lvField.AsInteger :=0;
      end else if lvField.DataType in [ftDateTime, ftDate] then
      begin
        lvField.AsDateTime := Now();
      end else
      begin
        lvField.AsString := '';
      end;
    end;
  end;
end;

class function TDataSetTools.FindField(pvDataSet: TDataSet; const fields: array
  of string): TField;
var
  i: Integer;
begin
  Result := nil;
  for i := Low(fields) to High(fields) do
  begin
    Result := pvDataSet.FindField(fields[i]);
    if Result <> nil then
    begin
      Break;
    end;
  end;
end;

class function TDataSetTools.GetLocateValueFromJSonData(pvData: ISuperObject;
    const pvKeyFields: string): Variant;
var
  lvKeyName, lvData: string;
  lvLocateKeyValues: Variant;
  lvKeyFieldLst: TStrings;
  j: Integer;
begin
  Result := varNull;
  if pvKeyFields <> '' then
  begin
    lvKeyFieldLst := TStringList.Create;
    try
      lvData := StringReplace(pvKeyFields, ';', sLineBreak, [rfReplaceAll]);
      lvData := StringReplace(lvData, ',', sLineBreak, [rfReplaceAll]);
      lvKeyFieldLst.Text := lvData;

      if lvKeyFieldLst.Count = 1 then
      begin //只有一个主键
        lvKeyName := Trim(lvKeyFieldLst[0]);

        if pvData.O[lvKeyName] = nil then
          raise Exception.CreateFmt('设置的主键(%s)在JSon中未找到相应的值!'
            , [lvKeyName]);
        lvLocateKeyValues := pvData.S[lvKeyName]; //用在定位的时候
      end else
      begin
        lvLocateKeyValues := VarArrayCreate([0, lvKeyFieldLst.Count - 1], varVariant);

        for j := 0 to lvKeyFieldLst.Count - 1 do
        begin
          lvKeyName := Trim(lvKeyFieldLst[j]);
          if lvKeyName = '' then raise Exception.Create('设置的主键内有空的无效的值!');
          if pvData.O[lvKeyName] = nil then
             raise Exception.CreateFmt('设置的主键(%s)在JSon中未找到相应的值!'
               , [lvKeyName]);
          lvLocateKeyValues[j] := pvData.S[lvKeyName];
        end;
      end;
      Result := lvLocateKeyValues;
    finally
      lvKeyFieldLst.Free;
    end;
  end;
end;

class function TDataSetTools.CalcuMaxFloat(pvDataSet:TDataSet;
    pvFieldName:string; pvDisableControls: Boolean = true): Double;
var
  lvBookMark:Pointer;
  lvField:TField;
begin
  lvBookMark:=nil;
  Result:=0;
  if not pvDataSet.Active then exit;
  lvField := pvDataSet.FindField(pvFieldName);
  if lvField = nil then
    raise Exception.CreateFmt('(TDataSetTools.CalcuMaxFloat)找不到对应的字段(%s)', [pvFieldName]);

  if pvDisableControls then lvBookMark := DisableControlsAndGetBookMark(pvDataSet);
  try
    pvDataSet.First;
    Result := lvField.AsFloat;
    pvDataSet.Next;
    while (not pvDataSet.Eof) do
    begin
      if lvField.AsFloat > Result then
      begin
        Result := lvField.AsFloat;
      end;
      pvDataSet.Next;
    end;
  finally
    if pvDisableControls then EnableControlsAndFreeBookMark(pvDataSet, lvBookMark);
  end;

end;

class procedure TDataSetTools.setDataSetFieldValue(pvDataSet: TDataSet;
    pvFieldName: String; pvValue: Variant; pvDisableControl: Boolean = true);
var
  lvBookMark:TBookmark;
  lvField:TField;
begin
  if pvDisableControl then  lvBookMark := DisableControlsAndGetBookMark(pvDataSet);
  try
    pvDataSet.First;
    lvField := pvDataSet.FieldByName(pvFieldName);
    while not pvDataSet.Eof do
    begin
      pvDataSet.Edit;
      lvField.AsVariant := pvValue;
      pvDataSet.Post;
      pvDataSet.First;
    end;
  finally
    if pvDisableControl then EnableControlsAndFreeBookMark(pvDataSet, lvBookMark);
  end;               
end;

class procedure TDataSetTools.setDataSource(AControl: TControl; ADataSource:
    TDataSource);
var
  i: Integer;
  DataLink: TDataLink;
begin
  DataLink := TDataLink(AControl.Perform(CM_GETDATALINK, 0, 0));
  if DataLink <> nil then
  begin
    DataLink.DataSourceFixed := false;
    try
      DataLink.DataSource := ADataSource;
    finally
      DataLink.DataSourceFixed := true;
    end;
  end;
  if AControl is TWinControl then
    with TWinControl(AControl) do
      for i := 0 to ControlCount - 1 do
        if Controls[i].Tag = 0 then
          setDataSource(Controls[i], ADataSource);

end;

class function TDataSetTools.Total(pvDataSet:TDataSet; pvFieldName:string;
    pvDisableControls: Boolean = true): Double;
var
  lvBookMark:Pointer;
  lvField:TField;
begin
  lvBookMark:=nil;
  Result:=0;
  if not pvDataSet.Active then exit;
  lvField := pvDataSet.FindField(pvFieldName);
  if lvField = nil then
    raise Exception.CreateFmt('(TDataSetTools.Total)找不到对应的字段(%s)', [pvFieldName]);

  if pvDisableControls then lvBookMark := DisableControlsAndGetBookMark(pvDataSet);
  try
    Result := 0;
    pvDataSet.First;
    while (not pvDataSet.Eof) do
    begin
      Result :=Result + lvField.AsFloat;
      pvDataSet.Next;
    end;
  finally
    if pvDisableControls then EnableControlsAndFreeBookMark(pvDataSet, lvBookMark);
  end;
end;

end.

