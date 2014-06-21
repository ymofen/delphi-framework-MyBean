unit uDBTools;

interface

uses
  DB, SysUtils, Windows, Classes, Variants, Controls;

type
  TDBTools = class(TObject)
  public
    class function BinaryField2HexString(lvField: TField): AnsiString;
    class function BlobField2HexString(lvField: TField): AnsiString;
    class function BlobVar2HexString(const V: Variant): AnsiString;
    class procedure DataSetEdit(pvDataSet: TDataSet);
    class procedure DataSetPost(pvDataSet: TDataSet);
    class function DisableControlsAndGetBookMark(pvDataSet: TDataSet): Pointer;
    class procedure EnableControlsAndFreeBookMark(pvDataSet: TDataSet; pvBookMark:
        Pointer);
    class procedure setDataSource(AControl: TControl; ADataSource: TDataSource);
    class function setDataSetValue(pvDataSet: TDataSet; pvFieldName, pvValue:
        string; pvSkipIfEmpty: Boolean = false): Boolean; overload;
    class function setDataSetValue(pvDataSet:TDataSet; pvFieldName:string; pvValue:Boolean):Boolean;overload;
    class function setDataSetValue(pvDataSet: TDataSet; pvFieldName: string;
        pvValue: Integer; pvSkipIfValueIsZero: Boolean = false): Boolean; overload;
    class function setDataSetValue(pvDataSet:TDataSet; pvFieldName:string; pvValue:Double):Boolean;overload;
  end;

function ReadVarBinaryField(vbField: TField): string;

implementation

function ReadVarBinaryField(vbField: TField): string;
var
  Len: Integer;
  Data: Variant;
  PData: Pointer;
begin
  Data := vbField.Value;
  if VarIsNull(Data) then
    Result := ''
  else
  begin
    Len := VarArrayHighBound(Data, 1) + 1;
    PData := VarArrayLock(Data);
    try
      SetLength(Result, Len);
      Move(PData^, Pointer(Result)^, Len);
    finally
      VarArrayUnlock(Data);
    end;
  end;
end;

class function TDBTools.BinaryField2HexString(lvField: TField): AnsiString;
var
  V: Variant;
  l, i:Integer;
begin
  Result := '';
  V := lvField.AsVariant;
  if not VarIsArray(V) then raise Exception.Create('²»ÊÇBinary×Ö¶Î(BinaryField2HexString)');

  for i := VarArrayLowBound(V, 1) to VarArrayHighBound(V, 1)  do
  begin
    Result := Result  + IntToHex(V[i], 2);
  end;
end;

class function TDBTools.BlobField2HexString(lvField: TField): AnsiString;
begin
  Result := BlobVar2HexString(lvField.AsVariant);
end;

class function TDBTools.BlobVar2HexString(const V: Variant): AnsiString;
var
  HexStr: PAnsiChar;
  len: Integer;
begin
  Result := '';

  len := Length(V);
  
{$IFDEF UNICODE}
  HexStr := AnsiStrAlloc(len * 2 + 1);
{$ELSE}
  HexStr := StrAlloc(len * 2 + 1);
{$ENDIF}

  BinToHex(PAnsiChar(TVarData(V).VPointer), HexStr, len);
  HexStr[len * 2] := #0;
  Result := '0x' + StrPas(HexStr);
  StrDispose(HexStr);
end;

class procedure TDBTools.DataSetEdit(pvDataSet: TDataSet);
begin
  if not (pvDataSet.State in [dsInsert, dsEdit]) then pvDataSet.Edit;
end;

class procedure TDBTools.DataSetPost(pvDataSet: TDataSet);
begin
  if pvDataSet.State in [dsInsert, dsEdit] then pvDataSet.Post;
end;

class function TDBTools.DisableControlsAndGetBookMark(pvDataSet: TDataSet):
    Pointer;
begin
  pvDataSet.DisableControls;
  Result := pvDataSet.GetBookmark;
end;

class procedure TDBTools.EnableControlsAndFreeBookMark(pvDataSet: TDataSet;
    pvBookMark: Pointer);
begin
  try
    if (pvBookMark <> nil) and pvDataSet.BookmarkValid(pvBookMark) then
    begin
      pvDataSet.GotoBookmark(pvBookMark);
      pvDataSet.FreeBookmark(pvBookMark);
    end;
  finally
    pvDataSet.EnableControls;
  end;
end;

class function TDBTools.setDataSetValue(pvDataSet: TDataSet;
  pvFieldName: string; pvValue: Boolean): Boolean;
var
  lvField:TField;
begin
  Result := false;
  lvField := pvDataSet.FindField(pvFieldName);
  if lvField <> nil then
  begin
    if lvField.AsBoolean <> pvValue then
    begin
      if not (pvDataSet.State in [dsEdit, dsInsert]) then pvDataSet.Edit;
      lvField.AsBoolean := pvValue;
      Result := true;
    end;
  end;

end;

class function TDBTools.setDataSetValue(pvDataSet: TDataSet; pvFieldName,
    pvValue: string; pvSkipIfEmpty: Boolean = false): Boolean;
var
  lvField:TField;
begin
  Result := false;
  if (pvValue = '') and (pvSkipIfEmpty) then exit;
  lvField := pvDataSet.FindField(pvFieldName);
  if lvField <> nil then
  begin
    if lvField.AsString <> pvValue then
    begin
      if not (pvDataSet.State in [dsEdit, dsInsert]) then pvDataSet.Edit;
      lvField.AsString := pvValue;
      Result := true;
    end;
  end;
end;

class function TDBTools.setDataSetValue(pvDataSet: TDataSet;
  pvFieldName: string; pvValue: Double): Boolean;
var
  lvField:TField;
begin
  Result := false;
  lvField := pvDataSet.FindField(pvFieldName);
  if lvField <> nil then
  begin
    if lvField.AsFloat <> pvValue then
    begin
      if not (pvDataSet.State in [dsEdit, dsInsert]) then pvDataSet.Edit;
      lvField.AsFloat := pvValue;
      Result := true;
    end;
  end;
end;

class function TDBTools.setDataSetValue(pvDataSet: TDataSet; pvFieldName:
    string; pvValue: Integer; pvSkipIfValueIsZero: Boolean = false): Boolean;
var
  lvField:TField;
begin
  Result := false;
  if (pvValue = 0) and (pvSkipIfValueIsZero) then exit;
  lvField := pvDataSet.FindField(pvFieldName);
  if lvField <> nil then
  begin
    if lvField.AsInteger <> pvValue then
    begin
      if not (pvDataSet.State in [dsEdit, dsInsert]) then pvDataSet.Edit;
      lvField.AsInteger := pvValue;
      Result := true;
    end;
  end;
end;

class procedure TDBTools.setDataSource(AControl: TControl; ADataSource:
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

end.
