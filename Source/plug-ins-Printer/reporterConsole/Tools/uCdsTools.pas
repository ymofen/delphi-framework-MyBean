unit uCdsTools;

interface

uses
  DB, DBClient, DSIntf, superobject;

type
  TCdsTools = class(TObject)
  public
    class procedure ApplyFilter(DataSet: TDataSet; pvValue: string);

    /// <summary>
    ///   排序CDS数据集
    /// </summary>
    /// <param name="DataSet"> (TDataSet) </param>
    /// <param name="pvSortFields"> 要排序的字段列表已分号隔开 </param>
    /// <param name="pvSortDescFields"> 要(倒)排序的字段列表已分号隔开  </param>
    class procedure ApplySorting(DataSet: TDataSet; pvSortFields: string;
      pvSortDescFields: string = '');
    class function CdsIsChanged(const pvCds: TCustomClientDataSet;
        pvIfInsertAndEditPost: Boolean = true): Boolean;
    class function GetDeltaXMLData(const pvCds: TCustomClientDataSet): String;

    class procedure RefreshCurrentRecord(const pvCds: TCustomClientDataSet;
        pvRecordData:OleVariant);


    class function CDSMarkInfo(pvCDS:TClientDataSet): ISuperObject;
    class procedure CDSRestoreINfo(pvCDS:TClientDataSet; pvMarkINfo:ISuperObject);

  end;

implementation

type
  TCustomClientDataSetCrack = class(TClientDataSet);

class procedure TCdsTools.ApplyFilter(DataSet: TDataSet; pvValue: string);
var
  DS: TDataSet;
begin
  DataSet.Filter := pvValue;
  if pvValue = '' then
  begin
    DataSet.Filtered := false;
  end else
  begin
    DataSet.Filtered := true;
  end;
end;

class procedure TCdsTools.ApplySorting(DataSet: TDataSet; pvSortFields: string;
  pvSortDescFields: string = '');
var
  DS: TDataSet;
  CDS: TCustomClientDataSetCrack;
  i: Integer;
  IndexFields, IndexDescFields: string;
begin
  IndexFields := pvSortFields;
  IndexDescFields := pvSortDescFields;
  if (DataSet is TClientDataSet) then
  begin
    CDS := TCustomClientDataSetCrack(DataSet);
    CDS.IndexDefs.Update;
    if CDS.IndexDefs.IndexOf('__SortIndex') >= 0 then
      CDS.DeleteIndex('__SortIndex');
    if (IndexFields > '') or (IndexDescFields <> '') then
    begin
      CDS.AddIndex('__SortIndex', IndexFields, [], IndexDescFields);
      CDS.IndexDefs.Update;
      CDS.IndexName := '__SortIndex';
    end else
      CDS.IndexName := '';
  end;
end;

class function TCdsTools.CdsIsChanged(const pvCds: TCustomClientDataSet;
    pvIfInsertAndEditPost: Boolean = true): Boolean;
begin
  if pvIfInsertAndEditPost then
    if pvCds.State in dsEditModes then pvCds.Post;
  Result := (pvCds.State in [dsEdit, dsInsert]) or (pvCds.ChangeCount > 0);
end;

class function TCdsTools.CDSMarkInfo(pvCDS:TClientDataSet): ISuperObject;
var
 lvPointer:Pointer;
begin
  if pvCDS = nil then exit;
  Result := SO();
  Result.B['readOnly'] := pvCDS.ReadOnly;
  Result.S['filter'] := pvCDS.Filter;
  Result.B['filtered'] := pvCDs.Filtered;
  lvPointer :=pvCDS.GetBookmark;
  if lvPointer <> nil then
  begin
    Result.I['bookmark'] := Integer(lvPointer);
  end;
  pvCDS.DisableControls;
end;

class procedure TCdsTools.CDSRestoreINfo(pvCDS:TClientDataSet;
    pvMarkINfo:ISuperObject);
var
  lvBookMark:Pointer;
begin
  if pvCDS = nil then exit;
  if pvMarkINfo = nil then exit;
  try

    if pvMarkINfo.O['readOnly'] <> nil then
    begin
      //现在设置
      if pvMarkINfo.B['readOnly'] = false then  pvCDS.ReadOnly :=pvMarkINfo.B['readOnly'];
    end;

    if pvMarkINfo.O['filter'] <> nil then
      pvCDS.Filter :=pvMarkINfo.S['filter'];
    if pvMarkINfo.O['filtered'] <> nil then
      pvCDS.Filtered :=pvMarkINfo.B['filtered'];
    if pvMarkINfo.O['bookmark'] <> nil then
    begin
      lvBookMark := Pointer(pvMarkINfo.I['bookmark']);

      if lvBookMark <> nil then
      begin
        if pvCDS.BookmarkValid(lvBookMark) then
          pvCDS.GotoBookmark(lvBookMark);

        pvCDS.FreeBookmark(lvBookMark);
      end;
    end;

    if pvMarkINfo.O['readOnly'] <> nil then
    begin
      //最后设置
      if pvMarkINfo.B['readOnly'] = true then  pvCDS.ReadOnly :=pvMarkINfo.B['readOnly'];
    end;

  finally
    pvCDS.EnableControls;
  end;

end;

class function TCdsTools.GetDeltaXMLData(const pvCds: TCustomClientDataSet):
    String;
var
  FDeltaDS          : IDSBase;
  DataPacket        : TDataPacket;
  VarPacket         : OleVariant;
begin
  pvCds.CheckBrowseMode;
  TCustomClientDataSetCrack(pvCds).Check(
    TCustomClientDataSetCrack(pvCds).DSBase.GetDelta(FDeltaDS));
  FDeltaDS.SetProp(dspropXML_STREAMMODE, xmlON);
  TCustomClientDataSetCrack(pvCds).Check(FDeltaDS.StreamDS(DataPacket));
  DataPacketToVariant(DataPacket, VarPacket);
  Result := VariantArrayToString(VarPacket);
end;

class procedure TCdsTools.RefreshCurrentRecord(const pvCds:
    TCustomClientDataSet; pvRecordData:OleVariant);
var
  lvCrackCDS:TCustomClientDataSetCrack;
begin
  //pvRecordData必须和pvCDS中的数据结构一致
  lvCrackCDS := TCustomClientDataSetCrack(pvCds);
  
  if pvCds.RecordCount = 0 then exit;

  if not Assigned(lvCrackCDS.DSCursor) then lvCrackCDS.CheckActive;
  lvCrackCDS.UpdateCursorPos;
  lvCrackCDS.Check(lvCrackCDS.DSCursor.RefreshRecord(VarToDataPacket(pvRecordData)));
  if not lvCrackCDS.Active then Exit;
  //DSCursor.GetCurrentRecord(ActiveBuffer);
  lvCrackCDS.Resync([]);
end;

end.

