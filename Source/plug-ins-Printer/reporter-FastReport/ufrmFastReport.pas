unit ufrmFastReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxClass, frxRich, frxDMPExport, frxCross, frxDesgn, frxBarcode,
  frxExportXLS, frxExportPDF, frxExportRTF, frxExportImage, frxChBox, frxChart,
  frxGradient, uIIntfList, uDBIntf, frxDBSet, StdInterface, superobject,
  uFMPreView;

type
  TfrmFastReport = class(TForm)
    frxGradientObject: TfrxGradientObject;
    frxChartObject: TfrxChartObject;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    frxJPEGExport1: TfrxJPEGExport;
    frxRTFExport1: TfrxRTFExport;
    frxPDFExport1: TfrxPDFExport;
    frxXLSExport: TfrxXLSExport;
    frxBarCodeObject: TfrxBarCodeObject;
    rtpReport: TfrxReport;
    frxDesigner: TfrxDesigner;
    frxCrossObject: TfrxCrossObject;
    frxCheckBoxObject: TfrxCheckBoxObject;
    frxDotMatrixExport1: TfrxDotMatrixExport;
    frxRichObject: TfrxRichObject;
    frxDBDataset1: TfrxDBDataset;
  private
    { Private declarations }
    procedure CreateDataItem(const pvIntf:IInterface);
    procedure CreateDataObject4InterfaceList(const pvDataList: IInterfaceList);
    procedure CreateDataObject4IntfList(const pvDataList: IIntfList);
  public
    procedure CreateDataObject(const pvDataList: IInterface);

    function CreatePreViewFM: TFMPreView;
  end;

var
  frmFastReport: TfrmFastReport;

implementation

{$R *.dfm}

procedure TfrmFastReport.CreateDataItem(const pvIntf:IInterface);
var
  lvDataSetGetter:IDataSetGetter;
  lvDataSet:TfrxDBDataSet;
  lvJSonConfigStringGetter:IJSonConfigStringGetter;
  lvJSonConfig:ISuperObject;
begin
  lvDataSetGetter := nil;
  if pvIntf.QueryInterface(IDataSetGetter,lvDataSetGetter) = S_OK then
  begin
    lvDataSet := TfrxDBDataSet.Create(Self);
    lvDataSet.DataSet := lvDataSetGetter.getDataSet;
    if lvDataSet.DataSet <> nil then
    begin
      if lvDataSet.DataSet.Name <> '' then
      begin
        lvDataSet.UserName :=lvDataSet.DataSet.Name;
      end;
    end;

    if pvIntf.QueryInterface(IJSonConfigStringGetter, lvJSonConfigStringGetter) = S_OK then
    begin
      lvJSonConfig := SO(lvJSonConfigStringGetter.getJSonConfigString);
      if lvJSonConfig <> nil then
      begin
        if lvJSonConfig.S['caption']<>'' then
        begin
          lvDataSet.UserName := lvJSonConfig.S['caption'];
        end;
      end;
    end;
  end;
end;

procedure TfrmFastReport.CreateDataObject(const pvDataList: IInterface);
var
  lvIntfList:IIntfList;
  lvList:IInterfaceList;
  lvCreated:Boolean;
begin
  lvCreated := false;
  pvDataList.QueryInterface(IIntfList, lvIntfList);
  if lvIntfList <> nil then
  begin
    CreateDataObject4IntfList(lvIntfList);
    lvCreated := true;
  end;

  if not lvCreated then
  begin
    pvDataList.QueryInterface(IInterfaceList, lvList);
    if lvList <> nil then
    begin
      CreateDataObject4InterfaceList(lvList);
      lvCreated := true;
    end;
  end;

  
//  for i := 0 to pvDataList.Count - 1 do
//  begin
//    lvIntf := pvDataList.Values[i];
//    lvDataSetGetter := nil;    
//    if lvIntf.QueryInterface(IDataSetGetter,lvDataSetGetter) = S_OK then
//    begin
//      lvDataSet := TfrxDBDataSet.Create(Self);
//      lvDataSet.DataSet := lvDataSetGetter.getDataSet;
//      if lvDataSet.DataSet <> nil then
//      begin
//        lvDataSet.UserName :=lvDataSet.DataSet.Name;
//      end;
//    end;
//  end;

end;

procedure TfrmFastReport.CreateDataObject4InterfaceList(const pvDataList:
    IInterfaceList);
var
  i:Integer;
begin
  if pvDataList = nil then exit;
  for i := 0 to pvDataList.Count - 1 do
  begin
    CreateDataItem(pvDataList[i]);
  end;
end;

procedure TfrmFastReport.CreateDataObject4IntfList(const pvDataList: IIntfList);
var
  i:Integer;
begin
  if pvDataList = nil then exit;
  for i := 0 to pvDataList.Count - 1 do
  begin
    CreateDataItem(pvDataList.Values[i]);
  end;
end;

function TfrmFastReport.CreatePreViewFM: TFMPreView;
begin
  Result := TFMPreView.Create(Self);
  rtpReport.Preview := Result.frxPreview;  
end;

end.
