unit uJSonTools;

interface

uses
  DB, superobject, SysUtils, Classes,
  Variants;

type
  TJSonTools = class(TObject)
  public            
    //给字段赋值
    class procedure AssignFieldValueFormJSon(lvField: TField; pvValue:
        ISuperObject);
    class function BlobAsString(lvField: TField): string;
    class procedure BlobFieldSetString(lvField: TField; pvData: string);
    /// <summary>TJSonTools.CopyDataRecordFromJsonData
    /// </summary>
    /// <param name="pvDestination"> (TDataSet) </param>
    /// <param name="pvSourceData">
    //   {
    //       fkey:"xxxx",
    //       fcode:"xxxx",
    //       fname:"xxxx",
    //       fskind:{value:1},
    //   }
    /// </param>
    /// <param name="pvCopyFields"> (string) </param>
    /// <param name="pvIgnoreFields"> (string) </param>
    class procedure CopyDataRecordFromJsonData(pvDestination: TDataSet;
        pvSourceData: ISuperObject; pvCopyFields: string = ''; pvIgnoreFields:
        string = '');
    class function CopyRecord2JSon(pvDataSet: TDataSet; vJSon: ISuperObject;
        pvIgnoreBinaryField: Boolean = false): ISuperObject;

    //DataSet打包成JSon
    //Blob和Bytes字段没有进行打包
    class function DataSetPack(pvDataSet: TDataSet): ISuperObject;


    //将数据还原到Dataset中
    class procedure DataSetUnPack(pvDataSet: TDataSet; pvPackData: ISuperObject;
      pvEmptyDataSet: Boolean = true);
    /// <summary>
    ///   删除数据集的所有记录
    /// </summary>
    /// <param name="pvDataSet"> (TDataSet) </param>
    class procedure DeleteAllRecord(pvDataSet: TDataSet; pvDisableControls: Boolean
        = true);
    /// </returns>
    /// <param name="pvDataSet"> (TDataSet) </param>
    /// <param name="vData"> 写入,覆盖
    /// {
    ///    "field":
    ///      {
    ///         "name":xx,
    ///         "caption":"pvPreName.xxx",
    ///         "value":"xxxx"
    ///      },
    /// }
    ///  </param>
    /// <param name="pvOverlay"> 写入时是否进行覆盖 </param>
    /// <param name="pvDictionaryINfo"> {"key":"caption"} </param>
    class function extractRecordsData(pvDataSet: TDataSet; vData: ISuperObject;
        pvOverlay: Boolean = true; pvDictionaryINfo: ISuperObject = nil; pvPreName:
        String = ''): ISuperObject;
    class function JsnParseFromFile(pvFile: string; pvEncrypKey: string = ''):
        ISuperObject;
    //存储文件使用该方式进行
    class function JsnSaveToFile(pvJsn: ISuperObject; pvFile: string; pvEncrypKey:
        string = ''): Boolean;






  end;

implementation

var
  __passString:String;

class procedure TJSonTools.AssignFieldValueFormJSon(lvField: TField; pvValue:
    ISuperObject);
begin
  if pvValue = nil then exit;

  if pvValue.IsType(stBoolean) then
    lvField.AsBoolean := pvValue.AsBoolean
  else if pvValue.IsType(stDouble) then
    lvField.AsFloat := pvValue.AsDouble
  else if pvValue.IsType(stInt) then
    lvField.AsInteger := pvValue.AsInteger
  else if pvValue.IsType(stNull) then
    lvField.Clear
  else
    lvField.AsString := pvValue.AsString;

end;

class function TJSonTools.BlobAsString(lvField: TField): string;
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

class procedure TJSonTools.BlobFieldSetString(lvField: TField; pvData: string);
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

class procedure TJSonTools.CopyDataRecordFromJsonData(pvDestination: TDataSet;
    pvSourceData: ISuperObject; pvCopyFields: string = ''; pvIgnoreFields:
    string = '');
var
  lvDField: TField;
  lvField:TSuperAvlEntry;
  lvValue:ISuperObject;
  i: Integer;
  lvIgnoreFields, lvCopyFields: TStrings;
begin
  if pvSourceData = nil then exit;
  
  lvIgnoreFields := TStringList.Create;
  lvCopyFields := TStringList.Create;
  try
    if pvIgnoreFields <> '' then
    begin
      pvIgnoreFields := StringReplace(pvIgnoreFields, ';', sLineBreak, [rfReplaceAll]);
      pvIgnoreFields := StringReplace(pvIgnoreFields, ',', sLineBreak, [rfReplaceAll]);
      lvIgnoreFields.Text := pvIgnoreFields;
    end;

    if pvCopyFields <> '' then
    begin
      pvCopyFields := StringReplace(pvCopyFields, ';', sLineBreak, [rfReplaceAll]);
      pvCopyFields := StringReplace(pvCopyFields, ',', sLineBreak, [rfReplaceAll]);
      lvCopyFields.Text := pvCopyFields;
    end;

    pvDestination.Edit;
    if lvCopyFields.Count = 0 then
    begin
      for lvField in pvSourceData.AsObject do
      begin
        lvDField := pvDestination.FindField(lvField.Name);
        if (lvDField <> nil)
           and
           (lvIgnoreFields.IndexOf(lvDField.FieldName) = -1) then
        begin
          if (lvField.Value <> nil) and (lvField.Value.DataType = stObject) and (lvField.Value.O['value'] <> nil) then
          begin
            AssignFieldValueFormJSon(lvDField, lvField.Value.O['value']);
          end else
          begin
            AssignFieldValueFormJSon(lvDField, lvField.Value);
          end;
        end;
      end;
    end else
    begin
      for i := 0 to lvCopyFields.Count - 1 do
      begin
        lvValue := pvSourceData.O[lvCopyFields[i]];
        lvDField := pvDestination.FindField(lvCopyFields[i]);
        if (lvValue <> nil)
           and (lvDField <> nil)
           and (lvIgnoreFields.IndexOf(lvDField.FieldName) = -1) then
        begin
          if (lvValue <> nil) and (lvValue.DataType = stObject) and (lvValue.O['value'] <> nil) then
          begin
            TJSonTools.AssignFieldValueFormJSon(lvDField, lvValue.O['value']);
          end else
          begin
            TJSonTools.AssignFieldValueFormJSon(lvDField, lvValue);
          end;
        end;
      end;
    end;
  finally
    lvCopyFields.Free;
    lvIgnoreFields.Free;
  end;
  
end;

class function TJSonTools.CopyRecord2JSon(pvDataSet: TDataSet; vJSon:
    ISuperObject; pvIgnoreBinaryField: Boolean = false): ISuperObject;
var
  i: Integer;
  lvField: TField;
begin
  Result := vJSon;
  if Result = nil then Result := SO();

  for i := 0 to pvDataSet.FieldCount - 1 do
  begin
    lvField := pvDataSet.Fields[i];
    if lvField.DataType in [ftDate, ftDateTime, ftString, ftGuid, ftWideString] then
    begin
      Result.S[LowerCase(lvField.FieldName)] := lvField.AsString;
    end else if (lvField.DataType in [ftBoolean]) then
    begin
      Result.B[LowerCase(lvField.FieldName)] := lvField.AsBoolean;
    end else if (lvField.DataType in [ftBlob]) then
    begin
      if not pvIgnoreBinaryField then
        Result.S[LowerCase(lvField.FieldName)] := BlobAsString(lvField);
    end else if not (lvField.DataType in [ftDataSet]) then
    begin
      Result.O[LowerCase(lvField.FieldName)] := SO(lvField.AsVariant);
    end;
  end;
end;

class procedure TJSonTools.DataSetUnPack(pvDataSet: TDataSet; pvPackData:
  ISuperObject; pvEmptyDataSet: Boolean = true);
var
  lvBookmark: TBookmark;
  i: Integer;
  lvValue: string;
  lvItemEntry: TSuperAvlEntry;
  lvItem, lvRecords: ISuperObject;
  lvField: TField;
begin
  if pvPackData = nil then raise Exception.Create('DataSetUnPack, JSonData is nil!');
  pvDataSet.DisableControls;
  try
    if pvEmptyDataSet then DeleteAllRecord(pvDataSet, False);


    if pvPackData.DataType = stArray then lvRecords:= pvPackData
    else if pvPackData.O['records'] <> nil then lvRecords := pvPackData.O['records']
    else if pvPackData.O['list'] <> nil then lvRecords := pvPackData.O['list'];
    
    if lvRecords = nil then Exit;

    for lvItem in lvRecords do
    begin
      pvDataSet.Append;
      for lvItemEntry in lvItem.AsObject do
      begin
        lvField := pvDataSet.FindField(lvItemEntry.Name);
        if lvField <> nil then
        begin
          if lvField.DataType in [ftBlob] then
          begin
            BlobFieldSetString(lvField, lvItemEntry.Value.AsString);
          end else if lvField.DataType in [ftBoolean] then
          begin
            if (lvItem.O[lvField.FieldName] = nil) or (lvItem.S[lvField.FieldName] = '') then
              lvField.Clear
            else
              lvField.AsBoolean := lvItem.B[lvField.FieldName];
          end else
          begin
            lvField.AsString := lvItemEntry.Value.AsString;
          end;
        end;


      end;
      pvDataSet.Post;
    end;
    pvDataSet.First;
  finally
    pvDataSet.EnableControls;
  end;
end;

class function TJSonTools.DataSetPack(pvDataSet: TDataSet): ISuperObject;
var
  lvBookmark: TBookmark;
  i: Integer;
  lvValue: string;
  lvItem: ISuperObject;
  lvField: TField;
begin
  Result := SO();
  pvDataSet.DisableControls;
  try
    pvDataSet.First;
    while not pvDataSet.Eof do
    begin
      lvItem := SO();
      for i := 0 to pvDataSet.FieldCount - 1 do
      begin
        lvField := pvDataSet.Fields[i];
        if lvField.DataType in [ftBlob] then
        begin
          lvItem.S[lvField.FieldName] := BlobAsString(lvField);
        end else if lvField.DataType in [ftBoolean] then
        begin
          if not lvField.IsNull then
          begin
            lvItem.B[lvField.FieldName] := lvField.AsBoolean;
          end;
        end else
        begin
          lvItem.S[lvField.FieldName] := lvField.AsString;
        end;
      end;
      Result['records[]'] := lvItem;
      pvDataSet.Next;
    end;
  finally
    pvDataSet.EnableControls;
  end;
end;

class procedure TJSonTools.DeleteAllRecord(pvDataSet: TDataSet;
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

class function TJSonTools.extractRecordsData(pvDataSet: TDataSet; vData:
    ISuperObject; pvOverlay: Boolean = true; pvDictionaryINfo: ISuperObject =
    nil; pvPreName: String = ''): ISuperObject;
var
  i:Integer;
  lvItem:ISuperObject;
  lvField:TField;
  lvCaption:String;
begin
  if vData = nil then exit;

  for I := 0 to pvDataSet.FieldCount - 1 do
  begin
    lvField := pvDataSet.Fields[i];
    lvItem := SO();
    lvItem.S['name'] := lvField.FieldName;
    lvItem.S['caption'] := lvField.DisplayLabel;
    lvItem.S['value'] := lvField.AsString;
    if pvDictionaryINfo <> nil then
    begin
      lvCaption :=pvDictionaryINfo.S[LowerCase(lvField.FieldName)];
      if lvCaption <> '' then
      begin
        lvItem.S['caption'] := lvCaption;
      end;
    end;
    if pvPreName <> '' then
    begin
      lvItem.S['caption'] := pvPreName + '.' + lvItem.S['caption'];
    end;
    if pvOverlay then
    begin
      vData.O[LowerCase(lvField.FieldName)] := lvItem;
    end else
    begin
      if vData.O[LowerCase(lvField.FieldName)] = nil then
        vData.O[LowerCase(lvField.FieldName)] := lvItem;
    end;
  end;
end;

class function TJSonTools.JsnParseFromFile(pvFile: string; pvEncrypKey: string
    = ''): ISuperObject;
var
  lvStream: TMemoryStream;
  lvStr: AnsiString;
begin
  if FileExists(pvFile) then
  begin
    lvStream := TMemoryStream.Create;
    try
      lvStream.LoadFromFile(pvFile);
      lvStream.Position := 0;
      SetLength(lvStr, lvStream.Size);
      lvStream.ReadBuffer(lvStr[1], lvStream.Size);
      if Length(trim(lvStr)) > 2 then 
        Result := SO(lvStr);
    finally
      lvStream.Free;
    end;
  end;
  if (Result = nil) or (not Result.IsType(stObject)) then Result := SO();
end;

class function TJSonTools.JsnSaveToFile(pvJsn: ISuperObject; pvFile: string;
    pvEncrypKey: string = ''): Boolean;
var
  lvStrings: TStrings;
  lvStream: TMemoryStream;

  lvStr: AnsiString;
begin
  Result := false;
  if pvJsn = nil then exit;
  lvStream := TMemoryStream.Create;
  try
    lvStr := pvJsn.AsJSon(True, False);
    if lvStr <> '' then
      lvStream.WriteBuffer(lvStr[1], Length(lvStr));
    lvStream.SaveToFile(pvFile);
    Result := true;
  finally
    lvStream.Free;
  end;
end;


end.

