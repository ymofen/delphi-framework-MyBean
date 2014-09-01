unit uSNTools;
{
   序号工具
}

interface

uses
  DB, SysUtils, DBClient, Math, uDBTools, Classes;

type
  TSNTools = class(TObject)
  private
  public
    class procedure ReCreateSNIndex(pvDataSet: TDataSet; pvSNFieldName: string;
        pvKeyField: String = '');

    class procedure MoveUp(pvDataSet: TClientDataSet; pvSNFieldName: string);

    class procedure MoveDown(pvDataSet: TClientDataSet; pvSNFieldName: string);

    /// <summary>
    ///
    /// </summary>
    /// <returns>
    /// pvCurrent = -1 :获取最大的数+1
    ///   否则 获取最小大于Current的数(FCurrent的下一个序号)
    /// </returns>
    /// <param name="pvDataSet"> (TDataSet) </param>
    /// <param name="pvSNFieldName"> (string) </param>
    /// <param name="pvCurrent"> (Integer) </param>
    class function GetNextSNIndex(pvDataSet: TDataSet; pvSNFieldName: string;
      pvCurrent: Integer = -1; pvDisableControls: Boolean = true): Integer;

    class function GetPriorSNIndex(pvDataSet: TDataSet; pvSNFieldName: string;
        pvCurrent: Integer = -1; pvDisableControls: Boolean = true): Integer;
  end;

implementation

class function TSNTools.GetNextSNIndex(pvDataSet: TDataSet; pvSNFieldName:
  string; pvCurrent: Integer = -1; pvDisableControls: Boolean = true):
  Integer;
var
  lvField: TField;
  i: Integer;

  lvBookMark: TBookmark;
begin
  lvField := pvDataSet.FindField(pvSNFieldName);
  if lvField = nil then raise Exception.CreateFmt('找不到%s序号字段', [pvSNFieldName]);

  if pvDisableControls then lvBookMark := TDBTools.DisableControlsAndGetBookMark(pvDataSet);
  try
    pvDataSet.First;
    if pvCurrent = -1 then
      i := 0
    else
      i := pvCurrent;
    while not pvDataSet.Eof do
    begin
      if pvCurrent = -1 then //获取最大的数
      begin
        i := Max(lvField.AsInteger, i);
      end else if (lvField.AsInteger > pvCurrent) then
      begin //获取最小大于Current的数
        if i = pvCurrent then i := lvField.AsInteger
        else i := Min(lvField.AsInteger, i);
      end;
      pvDataSet.Next;
    end;

    if pvCurrent = -1 then inc(i);
    Result := i;
  finally
    if pvDisableControls then TDBTools.EnableControlsAndFreeBookMark(pvDataSet, lvBookMark);
  end;
end;

class function TSNTools.GetPriorSNIndex(pvDataSet: TDataSet; pvSNFieldName:
    string; pvCurrent: Integer = -1; pvDisableControls: Boolean = true):
    Integer;
var
  lvField: TField;
  i: Integer;

  lvBookMark: TBookmark;
begin
  lvField := pvDataSet.FindField(pvSNFieldName);
  if lvField = nil then raise Exception.CreateFmt('找不到%s序号字段', [pvSNFieldName]);

  if pvDisableControls then lvBookMark := TDBTools.DisableControlsAndGetBookMark(pvDataSet);
  try
    pvDataSet.First;
    if pvCurrent = -1 then
    begin
      i := lvField.AsInteger;
      pvDataSet.Next;
    end else
    begin
      i := pvCurrent;
    end;
    while not pvDataSet.Eof do
    begin
      if pvCurrent = -1 then //获取最小的数
      begin
        i := Min(lvField.AsInteger, i);
      end else if (lvField.AsInteger < pvCurrent) then
      begin //获取最大的小于Current的数
        if i = pvCurrent then i := lvField.AsInteger
        else i := Max(lvField.AsInteger, i);
      end;
      pvDataSet.Next;
    end;
    Result := i;
  finally
    if pvDisableControls then TDBTools.EnableControlsAndFreeBookMark(pvDataSet, lvBookMark);
  end;
end;

class procedure TSNTools.MoveDown(pvDataSet: TClientDataSet; pvSNFieldName:
  string);
var
  lvField: TField;
  i, lvNext: Integer;

  lvBookMark: TBookmark;
begin
  lvField := pvDataSet.FindField(pvSNFieldName);
  if lvField = nil then raise Exception.CreateFmt('找不到%s序号字段', [pvSNFieldName]);

  i := lvField.AsInteger;

  lvBookMark := TDBTools.DisableControlsAndGetBookMark(pvDataSet);
  try 
    //下一个
    lvNext := GetNextSNIndex(pvDataSet, pvSNFieldName, i, False);

    if lvNext > i then //有下一个
    begin
      pvDataSet.First;
      while not pvDataSet.Eof do
      begin
        if lvField.AsInteger = lvNext then
        begin
          pvDataSet.Edit;
          lvField.AsInteger := i;
          pvDataSet.Post;
        end;
        pvDataSet.Next;
      end;
    end;
  finally
    TDBTools.EnableControlsAndFreeBookMark(pvDataSet, lvBookMark);
    pvDataSet.Edit;
    lvField.AsInteger := lvNext;
    pvDataSet.Post;
  end;
end;

class procedure TSNTools.MoveUp(pvDataSet: TClientDataSet;
  pvSNFieldName: string);
var
  lvField: TField;
  i, lvPrior: Integer;

  lvBookMark: TBookmark;
begin
  lvField := pvDataSet.FindField(pvSNFieldName);
  if lvField = nil then raise Exception.CreateFmt('找不到%s序号字段', [pvSNFieldName]);

  i := lvField.AsInteger;

  lvBookMark := TDBTools.DisableControlsAndGetBookMark(pvDataSet);
  try 
    //上一个
    lvPrior := GetPriorSNIndex(pvDataSet, pvSNFieldName, i, False);

    if lvPrior < i then //有上一个
    begin
      pvDataSet.First;
      while not pvDataSet.Eof do
      begin
        if lvField.AsInteger = lvPrior then
        begin
          pvDataSet.Edit;
          lvField.AsInteger := i;
          pvDataSet.Post;
        end;
        pvDataSet.Next;
      end;
    end;
  finally
    TDBTools.EnableControlsAndFreeBookMark(pvDataSet, lvBookMark);
    pvDataSet.Edit;
    lvField.AsInteger := lvPrior;
    pvDataSet.Post;
  end;
end;

class procedure TSNTools.ReCreateSNIndex(pvDataSet: TDataSet; pvSNFieldName:
    string; pvKeyField: String = '');
var
  lvField, lvKeyField: TField;
  i: Integer;
  lvBookMark: TBookmark;
  lvKeyList:TStrings;
begin
  lvField := pvDataSet.FindField(pvSNFieldName);
  if lvField = nil then raise Exception.CreateFmt('找不到%s序号字段', [pvSNFieldName]);

  lvBookMark := TDBTools.DisableControlsAndGetBookMark(pvDataSet);
  try

    if pvKeyField <> '' then
    begin               //利用主键定位更新
      lvKeyField := pvDataSet.FindField(pvKeyField);
      if lvKeyField = nil then raise Exception.CreateFmt('找不到指定的主键%s字段', [pvKeyField]);
      lvKeyList := TStringList.Create;
      try
        pvDataSet.First;
        while not pvDataSet.Eof do
        begin
          lvKeyList.Add(lvKeyField.AsString);
          pvDataSet.Next;
        end;


        for i := 0 to lvKeyList.Count - 1 do
        begin
         if pvDataSet.Locate(pvKeyField, lvKeyList[i], []) then
         begin
           pvDataSet.Edit;
           lvField.AsInteger := i + 1;
           pvDataSet.Post;
         end;
        end;
      finally
        lvKeyList.Free;
      end;             
    end else
    begin
      i := 1;
      while not pvDataSet.Eof do
      begin
        pvDataSet.Edit;
        lvField.AsInteger := i;
        pvDataSet.Post;
        inc(i);
        pvDataSet.Next;
      end;
    end;
  finally
    TDBTools.EnableControlsAndFreeBookMark(pvDataSet, lvBookMark);
  end;
end;

end.

