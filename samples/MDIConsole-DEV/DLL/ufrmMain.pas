unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PivotCube_SRC, PivotMap_SRC, ExtCtrls, DB, DBClient, PivotGrid_SRC,
  StdCtrls, uFieldCreator, PivotToolBar_SRC, uIFormShow;

type
  TfrmMain = class(TForm, IShowAsMDI)
    
    cdsMain: TClientDataSet;
    pnlTop: TPanel;
    btnCreateDataSet: TButton;
    pnlClient: TPanel;
    procedure btnCreateDataSetClick(Sender: TObject);
  private
    FOperaCube: TPivotCube;
    FOperaMap: TPivotMap;

    FPVColToolBar: TPVColToolBar;
    FPVRowToolBar: TPVRowToolBar;
    FPivotGrid: TPivotGrid;
    FPVDimToolBar: TPVDimToolBar;
    FPVMeasureToolBar: TPVMeasureToolBar;
    FPivotMap: TPivotMap;
    FPivotCube: TPivotCube;
    procedure initializeGrid;

    
  protected
    procedure CreateColumnDEMO;
    procedure reOpenForDEMO;
    procedure showAsMDI; stdcall;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnCreateDataSetClick(Sender: TObject);
var
  lvField:TDimensionItem;
  lvMField:TMeasureItem;
begin
  cdsMain.Close;
  TFieldCreator.CreateField(cdsMain, 'FCode', ftString, 50);
  TFieldCreator.CreateField(cdsMain, 'FName', ftString, 80);
  TFieldCreator.CreateField(cdsMain, 'FSaleNum', ftInteger);
  TFieldCreator.CreateField(cdsMain, 'FInNum', ftInteger);
  cdsMain.CreateDataSet;

  cdsMain.Append;
  cdsMain.FieldByName('FCode').AsString := '001';
  cdsMain.FieldByName('FName').AsString := '喝水杯子-L';
  cdsMain.FieldByName('FSaleNum').AsInteger := 100;
  cdsMain.FieldByName('FInNum').AsInteger := 150;
  cdsMain.Post;

  cdsMain.Append;
  cdsMain.FieldByName('FCode').AsString := '002';
  cdsMain.FieldByName('FName').AsString := '喝水杯子-M';
  cdsMain.FieldByName('FSaleNum').AsInteger := 101;
  cdsMain.FieldByName('FInNum').AsInteger := 120;
  cdsMain.Post;


  CreateColumnDEMO;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  initializeGrid;
  
  reOpenForDEMO;


end;

procedure TfrmMain.initializeGrid;
begin
  FPivotMap := TPivotMap.Create(Self);
  FPivotCube := TPivotCube.Create(Self);
  FPivotCube.FactTableDataSet := self.cdsMain;
  FOperaCube := FPivotCube;
  FOperaMap := FPivotMap;
  FPivotGrid := TPivotGrid.Create(Self);
  FPVDimToolBar := TPVDimToolBar.Create(Self);
  FPVColToolBar := TPVColToolBar.Create(Self);
  FPVRowToolBar := TPVRowToolBar.Create(Self);
  FPVMeasureToolBar := TPVMeasureToolBar.Create(Self);
  FPivotGrid.Map := FOperaMap;
  FPivotMap.Cube := FOperaCube;
  FPivotGrid.Parent := pnlClient;
  FPivotGrid.Map := FOperaMap;
  FPivotGrid.Align := alClient;
  FPVDimToolBar.Name := 'FPVDimToolBar';
  FPVDimToolBar.Caption := '';
  FPVDimToolBar.Parent := pnlClient;
  FPVDimToolBar.Map := FOperaMap;
  FPVMeasureToolBar.Name := 'FPVMeasureToolBar';
  FPVMeasureToolBar.Caption := '';
  FPVMeasureToolBar.Parent := pnlClient;
  FPVMeasureToolBar.Map := FOperaMap;
  FPVColToolBar.Name := 'FPVColToolBar';
  FPVColToolBar.Caption := '';
  FPVColToolBar.Parent := pnlClient;
  FPVColToolBar.Map := FOperaMap;
  FPVRowToolBar.Name := 'FPVRowToolBar';
  FPVRowToolBar.Caption := '';
  FPVRowToolBar.Parent := pnlClient;
  FPVRowToolBar.Map := FOperaMap;
end;

procedure TfrmMain.CreateColumnDEMO;
var
  lvDField:TDimensionItem;
  lvMField:TMeasureItem;
begin
  FPivotCube.Active := false;

  FPivotCube.Dimensions.Clear;
  FPivotCube.Measures.Clear;
  FPivotMap.Rows.Clear;
  FPivotMap.Columns.Clear;
  FPivotMap.HideEmptyColumns := True;
  FPivotMap.HideEmptyRows := True;



  FOperaCube.Dimensions.Clear;
  FOperaCube.Measures.Clear;
  FOperaMap.Rows.Clear;
  FOperaMap.Columns.Clear;
  FOperaMap.HideEmptyColumns := True;
  FOperaMap.HideEmptyRows := True;

  lvDField := FOperaCube.Dimensions.Add;
  lvDField.FieldName := 'FCode';
  lvDField.DataSet := cdsMain;
  lvDField.KeyField := 'idFCode';
  lvDField.DisplayName := '编号';
  lvDField.Sorting := dmtKeySort;

  lvDField := FOperaCube.Dimensions.Add;
  lvDField.FieldName := 'FName';
  lvDField.DataSet := cdsMain;
  lvDField.KeyField := 'idFName';
  lvDField.DisplayName := '名称';
  lvDField.Sorting := dmtKeySort;


  lvMField := FOperaCube.Measures.Add;
  lvMField.DisplayName := '销售数量';
  lvMField.FieldName := 'FSaleNum';
  lvMField.CalcType := ctSumma;

  lvMField := FOperaCube.Measures.Add;
  lvMField.FieldName := 'FInNum';
  lvMField.DisplayName := '进仓数量';
  lvMField.CalcType := ctSumma;

//  for i := 0 to FFieldCentre.Count -1 do
//  begin
//    lvField := FFieldCentre.Items[i];
//    if lvField.CheckJsnObject then
//    begin
//      lvStr := lvField.JsonObject.S['grid.area'];
//      if SameText(lvStr, 'data') then
//      begin
//        lvMField := FPivotCube.Measures.Add;
//        lvMField.DisplayName := lvField.GetFieldCaption;
//        lvMField.FieldName := lvField.GetFieldName;
//        lvMField.CalcType := ctSumma;
//      end else if SameText(lvStr, 'row') then
//      begin
//        lvDField := FPivotCube.Dimensions.Add;
//        lvDField.FieldName := lvField.GetFieldName;
//        lvDField.DataSet := cdsMain;
//        lvDField.KeyField := 'id' + lvField.GetFieldName;
//        lvDField.DisplayName := lvField.GetFieldCaption;
//        lvDField.Sorting := dmtKeySort;
//      end else if lvField.GetColumnVisible then
//      begin
//        lvDField := FPivotCube.Dimensions.Add;
//        lvDField.FieldName := lvField.GetFieldName;
//        lvDField.DataSet := cdsMain;
//        lvDField.KeyField := 'id' + lvField.GetFieldName;
//        lvDField.DisplayName := lvField.GetFieldCaption;
//        lvDField.Sorting := dmtKeySort;
//      end;
//    end;
//  end;
  
  FPivotCube.Active := true;

end;

procedure TfrmMain.reOpenForDEMO;
var
  lvField:TDimensionItem;
  lvMField:TMeasureItem;
begin
  cdsMain.Close;
  TFieldCreator.CreateField(cdsMain, 'FCode', ftString, 50);
  TFieldCreator.CreateField(cdsMain, 'FName', ftString, 80);
  TFieldCreator.CreateField(cdsMain, 'FSaleNum', ftInteger);
  TFieldCreator.CreateField(cdsMain, 'FInNum', ftInteger);
  cdsMain.CreateDataSet;

  cdsMain.Append;
  cdsMain.FieldByName('FCode').AsString := '001';
  cdsMain.FieldByName('FName').AsString := '喝水杯子-L';
  cdsMain.FieldByName('FSaleNum').AsInteger := 100;
  cdsMain.FieldByName('FInNum').AsInteger := 150;
  cdsMain.Post;

  cdsMain.Append;
  cdsMain.FieldByName('FCode').AsString := '002';
  cdsMain.FieldByName('FName').AsString := '喝水杯子-M';
  cdsMain.FieldByName('FSaleNum').AsInteger := 101;
  cdsMain.FieldByName('FInNum').AsInteger := 120;
  cdsMain.Post;


  CreateColumnDEMO;
end;

procedure TfrmMain.showAsMDI;
begin
  self.FormStyle := fsMDIChild;
  Show;
end;

end.
