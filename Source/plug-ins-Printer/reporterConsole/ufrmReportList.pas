unit ufrmReportList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBClient, ActnList, ImgList,
  uFieldCreator, ufrmReportEditor, ComObj, uSNTools, 
  uIFileAccess, uJSonTools, uFileTools, superobject, uIReporter,
  uIIntfList, Grids, DBGrids, DB, StdCtrls, Buttons, ExtCtrls, KeyStream,
  uKeyStreamTools, uKeyStreamCoder, uMsgTools, Menus,
  uIErrorINfo,
  uErrorINfoTools,
  mBeanFrameVars,
  uBeanFactory, FileLogger, uReporterDefaultOperator;

type
  TfrmReportList = class(TForm
     , IReportConsole
     , IReporterIM
     , IReporterDefaultOperatorSetter
     , IErrorINfo
     , IBeanConfigSetter)
    cdsMain: TClientDataSet;
    dsMain: TDataSource;
    actlstMain: TActionList;
    actNew: TAction;
    actEdit: TAction;
    actPreView: TAction;
    actDesign: TAction;
    actDelete: TAction;
    actImport: TAction;
    actExport: TAction;
    ilMain: TImageList;
    actExit: TAction;
    dbgrdMain: TDBGrid;
    pnlOperator: TPanel;
    btnNew: TSpeedButton;
    btnEdit: TSpeedButton;
    btnDesign: TSpeedButton;
    btnDelete: TSpeedButton;
    btnPreView: TSpeedButton;
    btnExport: TSpeedButton;
    btnImport: TSpeedButton;
    btnExit: TSpeedButton;
    dlgSave: TSaveDialog;
    dlgOpen: TOpenDialog;
    actCopy: TAction;
    btnCopy: TSpeedButton;
    actPrint: TAction;
    cds4Update: TClientDataSet;
    ds4Update: TDataSource;
    actSetDefault: TAction;
    pmGrid: TPopupMenu;
    mniExport: TMenuItem;
    mniImport: TMenuItem;
    mniDesign: TMenuItem;
    mniSetDefault: TMenuItem;
    N1: TMenuItem;
    procedure actCopyExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actDesignExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);

    procedure actExportExecute(Sender: TObject);
    procedure actImportExecute(Sender: TObject);

    procedure actNewExecute(Sender: TObject);
    procedure actPreViewExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actSetDefaultExecute(Sender: TObject);
    procedure cds4UpdateAfterInsert(DataSet: TDataSet);
    procedure dbgrdMainDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdVMainDblClick(Sender: TObject);
  private
    { Private declarations }
    __pass:String;
    FLastMessage:String;
    
    FDefaultID:String;

    FDefaultOperator:IReporterDefaultOperator;

    FshowEspecial:boolean;
    
    FJSonConfig:ISuperObject;

    FReportID:AnsiString;

    //
    FTypeConfig:ISuperObject;

    //
    FDataIntf: IInterface;

    FFileAccess:IFileAccess;

    function LocalDefault: Boolean;

    function checkGetDefaultID: String;

    function checkGetRFileName(pvDataSet: TDataSet): String;

    procedure checkLocate4Update;

    //是否准备数据
    procedure checkPrepare;

    procedure createRepListFields(pvCDS: TClientDataSet; pvAssignEvent: Boolean = true);


    //保存列表
    procedure saveList(pvCDS: TClientDataSet = nil; pvReportID: String = '');

    //
    procedure reloadList(pvCDS: TClientDataSet = nil; pvReportID: String = '');

    procedure OnCaptionGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);

    procedure OnTypeIDGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);

    procedure OnBitFieldGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);

    //导出一个报表文件
    procedure InnerExport(pvReportID: string; pvDataSet: TDataSet; pvFileName:
        string; IgnoreEmptyTemplateFile: Boolean = false);

    procedure Data2UI(pvCDS: TClientDataSet; pvLocate: Boolean = false);
  protected
    FLastError:Integer;
    FLastErrorDesc:AnsiString;
    procedure resetError;
  public
      //导出报表文件到一个路径
    procedure DoReporterExport(pvReportID, pvPath: PAnsiChar; pvProgConsole:
        IProgConsole); stdcall;

    //导入一个报表的打包文件,不用传入ReporterID
    procedure DoImportRepPackFile(pvFile:PAnsiChar); stdcall;

    procedure FreeReporterIM; stdcall;
 public
    procedure setReporterDefaultOperator(pvIntf:IReporterDefaultOperator);stdcall;
  public
    //打印报表,传入单个报表的ID
    procedure Print(pvID:PAnsiChar);stdcall;   //打印默认报表

    //预览报表,传入单个报表的ID
    procedure PreView(pvID:PAnsiChar);stdcall;

    //设计报表,传入单个报表的ID
    procedure Design(pvID: PAnsiChar); stdcall;

    //根据报表ID,获取一个报表 (如果传入的为空值,则预览第一个)
    function createReporter(pvID: PAnsiChar): IReporter; stdcall;

    // <summary>
    //   获取报表列表
    // </summary>
    // <returns>
    // [
    //    {caption:xxx,ID:xxxx},
    //    {caption:xxx,ID:xxxx}
    // ]
    // </returns>
    function getReports: PAnsiChar; stdcall;

    //保存报表文件
    function saveFileRes(pvID: PAnsiChar): PAnsiChar; stdcall;

    //获取报表信息
    function getReportINfo(pvID: PAnsiChar):PAnsiChar; stdcall;

    //设计一个新的报表
    function DesignNewReport(pvTypeID:PAnsiChar; pvRepName:PAnsiChar):PAnsiChar;stdcall;

    //获取第一个
    function getFirstReporterID: PAnsiChar; stdcall;

    //显示控制台
    procedure ShowConsole();

    //准备数据
    procedure Prepare; stdcall;

    //释放控制
    procedure FreeConsole();

    //设置配置
    procedure setConfig(pvConfig:PAnsiChar);stdcall;

    //设置报表列表ID,根据该ID去查找报表列表
    procedure setReportID(pvReportID:PAnsiChar);stdcall;

    //数据对象的接口列表
    procedure setDataList(const pvIntf: IInterface); stdcall;

    //文件操作接口
    procedure setFileAccess(const pvIntf: IFileAccess); stdcall;

    procedure checksetDefaultOperator();

  public
    procedure markModifyINfo(pvDataSet:TClientDataSet);

    function getCurrentReporter(pvCDS: TClientDataSet): IReporter;

    procedure designCurrentReporter(pvCDS: TClientDataSet);




    /// <summary>
    ///    导入报表文件打包的文件
    /// </summary>
    /// <param name="pvRepPackFile"> 打包的文件名 </param>
    /// <param name="pvReportID"> 要导入到的报表中,如果为空则取打包信息中__reportid  </param>
    /// <param name="pvForceAppend"> 是否强制添加,false时覆盖原有的文件 </param>
    /// <param name="pvCDS"> 为nil时创建临时的CDS </param>
    /// <param name="pvChangeOperator"> 是否记录操作员信息 </param>
    /// <param name="IgnoreEmptyTemplateFile"> 如果报表模版文件为空时不弹出错误 </param>
    ///
    function ImportRepPackFile(pvRepPackFile: String; pvReportID: String = '';
        pvForceAppend: Boolean = true; pvCDS: TClientDataSet = nil;
        pvChangeOperator: Boolean = false; IgnoreEmptyTemplateFile: Boolean =
        false): string;
  protected
    /// <summary>
    ///   获取错误代码，没有错误返回 0
    /// </summary>
    function getErrorCode: Integer; stdcall;
    /// <summary>
    ///   获取错误信息数据，返回读取到的错误信息长度，
    ///     如果传入的pvErrorDesc为nil指针，返回错误信息的长度
    /// </summary>
    function getErrorDesc(pvErrorDesc: PAnsiChar; pvLength: Integer): Integer; stdcall;
  protected
    FBeanConfig:ISuperObject;
    /// <summary>
    ///   设置配置中的Config
    /// </summary>
    /// <param name="pvBeanConfig">
    ///   配置文件中JSon格式的字符串
    /// </param>
    procedure setBeanConfig(pvBeanConfig: PAnsiChar); stdcall;


  public
    constructor Create(pvApplicationHandle: THandle); overload;
    destructor Destroy; override;

    { Public declarations }
    procedure DoEditor(pvIsAppend:Boolean);
  end;

var
  frmReportList: TfrmReportList;

implementation

uses
  uCdsTools, uDBTools, uSOTools;

{$R *.dfm}

constructor TfrmReportList.Create(pvApplicationHandle: THandle);
begin
  FDefaultID :=''; 
  Application.Handle := pvApplicationHandle;
  FJSonConfig := SO();
  inherited Create(nil);
end;

destructor TfrmReportList.Destroy;
begin
  FDefaultOperator := nil;
  FDataIntf := nil;
  FFileAccess := nil;
  inherited Destroy;
end;

procedure TfrmReportList.actCopyExecute(Sender: TObject);
var
  lvTempFile, lvNewKey:String;
begin
  lvTempFile := TFileTools.createTempFileName('rep4Copy_');
  InnerExport(FReportID, cdsMain, lvTempFile);
  ImportRepPackFile(lvTempFile, FReportID, True, self.cds4Update, True);
  if FileExists(lvTempFile) then
    DeleteFile(lvTempFile);
  Data2UI(self.cds4Update);
  //reloadList();
end;

procedure TfrmReportList.actDeleteExecute(Sender: TObject);
var
  lvFileID, lvKey:AnsiString;
begin
  lvKey := cdsMain.FieldByName('FKey').AsString;
  if lvKey = '' then raise Exception.Create('没有选取任何报表!');

  if not TMsgTools.QueryMsg('删除报表后不能恢复!是否继续?') then Exit;

  lvFileID := checkGetRFileName(cdsMain);

  checkLocate4Update;

  //删除设计文件
  FFileAccess.deleteFile(PAnsiChar(lvFileID), 'report');
  TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);

  cdsMain.Delete;

  cds4Update.Delete;
  saveList(cds4Update);
  lvFileID := '';
end;

procedure TfrmReportList.actDesignExecute(Sender: TObject);
begin
  if cdsMain.FieldByName('FKey').AsString = '' then raise Exception.Create('没有选取任何报表!');
  if FFileAccess = nil then raise Exception.Create('缺少文件操作接口!');
  checkLocate4Update;
  designCurrentReporter(cds4Update);
  if self.Visible then
  begin
    dbgrdMain.SetFocus();
  end;
end;

procedure TfrmReportList.actEditExecute(Sender: TObject);
begin
  DoEditor(False);
end;

procedure TfrmReportList.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmReportList.actExportExecute(Sender: TObject);
var
  lvKeyStream:TKeyStream;
  lvRec:ISuperObject;

  lvTempFile:String;
  lvFileID:String;
  lvData:ISuperObject;
begin
  if cdsMain.FieldByName('FKey').AsString = '' then raise Exception.Create('没有选取任何报表!');
  dlgSave.Filter := '报表打包文件(*.repPack)|*.repPack';
  dlgSave.FileName := cdsMain.FieldByName('FName').AsString;
  dlgSave.DefaultExt := '.repPack';

  if not dlgSave.Execute() then exit;
  InnerExport(FReportID, cdsMain, dlgSave.FileName);
end;

procedure TfrmReportList.actImportExecute(Sender: TObject);
var
  i:Integer;
begin
  dlgOpen.Filter := '报表打包文件(*.repPack)|*.repPack';
  dlgOpen.DefaultExt := '.repPack';
  if not dlgOpen.Execute() then exit;

  for i := 0 to dlgOpen.Files.Count - 1 do
  begin
    self.ImportRepPackFile(dlgOpen.Files[i], FReportID, True, self.cds4Update);
  end;

  Data2UI(self.cds4Update);
  dbgrdMain.SetFocus();
end;

procedure TfrmReportList.actNewExecute(Sender: TObject);
begin
  DoEditor(True);
end;

procedure TfrmReportList.actPreViewExecute(Sender: TObject);
var
  lvReporter:IReporter;
var
  lvTempFile:AnsiString;
  lvFileID:AnsiString;
  lvData:ISuperObject;
begin
  if cdsMain.FieldByName('FKey').AsString = '' then raise Exception.Create('没有选取任何报表!');
  if FFileAccess = nil then raise Exception.Create('缺少文件操作接口!');
  lvTempFile := TFileTools.createTempFileName('rep', '.rep');
  lvFileID :=checkGetRFileName(cdsMain);
  FFileAccess.getFile(PAnsiChar(lvFileID), PAnsiChar(lvTempFile), 'report', False);
  TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);

  lvReporter := getCurrentReporter(cdsMain);
  lvReporter.Clear;
  lvReporter.setDesignFile(PAnsiChar(lvTempFile));
  lvReporter.setDataList(FDataIntf);
  lvReporter.Preview;
  if FileExists(lvTempFile) then
    DeleteFile(lvTempFile);
  lvTempFile := '';
  lvFileID := '';
end;

procedure TfrmReportList.actPrintExecute(Sender: TObject);
var
  lvReporter:IReporter;
  lvTempFile:String;
  lvFileID:String;
  lvData:ISuperObject;
begin
  if cdsMain.FieldByName('FKey').AsString = '' then raise Exception.Create('没有选取任何报表!');
  if FFileAccess = nil then raise Exception.Create('缺少文件操作接口,不能获取报表文件!');
  lvTempFile := TFileTools.createTempFileName('rep', '.rep');
  lvFileID :=checkGetRFileName(cdsMain);
  FFileAccess.getFile(PAnsiChar(lvFileID), PAnsiChar(lvTempFile), 'report', False);
  TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);

  lvReporter := getCurrentReporter(cdsMain);
  lvReporter.Clear;
  lvReporter.setDesignFile(PAnsiChar(lvTempFile));
  lvReporter.setDataList(FDataIntf);
  lvReporter.Print;
  
  if FileExists(lvTempFile) then
    DeleteFile(lvTempFile);

  lvTempFile := '';
  lvFileID := '';
end;

procedure TfrmReportList.actSetDefaultExecute(Sender: TObject);
begin
  if FDefaultOperator<> nil then
  begin
    FDefaultID := self.cdsMain.FieldByName('FKey').AsString;
    FDefaultOperator.setDefault(PAnsiChar(FReportID), PAnsiChar(FDefaultID));
  end;                                                                      
  
  Self.dbgrdMain.Refresh;
end;

procedure TfrmReportList.cds4UpdateAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('FKey').AsString := CreateClassID;
  DataSet.FieldByName('FIsEspecial').AsBoolean := false;
  DataSet.FieldByName('FIsPrivate').AsBoolean := false;
  if FJSonConfig<> nil then
  begin
    DataSet.FieldByName('FUpbuilder').AsString := FJSonConfig.S['Operator.name'];
  end;
end;

function TfrmReportList.checkGetDefaultID: String;
begin
  if FDefaultID = '' then
  begin
    if FDefaultOperator <> nil then
    begin
      FDefaultID := FDefaultOperator.getDefault(PAnsiChar(FReportID));
      if FDefaultID = '' then
      begin
        FDefaultID := 'none';
      end;
    end;
  end;

  Result := FDefaultID;
end;

function TfrmReportList.checkGetRFileName(pvDataSet: TDataSet): String;
begin
  Result := TFileTools.deleteInvalidChar(pvDataSet.FieldByName('FKey').AsString) + '.rep';
end;

procedure TfrmReportList.checkLocate4Update;
begin
  if not cds4Update.Locate('FKey', cdsMain.FieldByName('FKey').AsString, []) then
  begin
    raise Exception.Create('cds4Update定位不到记录');
  end;
end;

procedure TfrmReportList.checkPrepare;
begin
  if cdsMain.RecordCount = 0 then
  begin
    Prepare;
  end;
end;

procedure TfrmReportList.checksetDefaultOperator;
var
  lvUserID:String;
begin
  if FDefaultOperator = nil then
  begin
     lvUserID := FJSonConfig.S['operator.name'];
     if (FJSonConfig <> nil)
        and (lvUserID<> '')
        and (FFileAccess <> nil)
        then
     begin
       setReporterDefaultOperator(TReporterDefaultOperator.Create(lvUserID, FFileAccess));
     end;                                                                                 
  end;
end;

procedure TfrmReportList.createRepListFields(pvCDS: TClientDataSet;
    pvAssignEvent: Boolean = true);
var
  lvField:TField;
begin
  TFieldCreator.CreateField(pvCDS, 'FKey', ftGuid);
  TFieldCreator.CreateField(pvCDS, 'FSN', ftInteger);
  TFieldCreator.CreateField(pvCDS, 'FCode', ftString, 50);
  lvField:= TFieldCreator.CreateField(pvCDS, 'FName', ftString, 50);
  if pvAssignEvent then
    lvField.OnGetText := OnCaptionGetText;
    
  lvField:= TFieldCreator.CreateField(pvCDS, 'FTypeID', ftString, 20);
  if pvAssignEvent then
    lvField.OnGetText := OnTypeIDGetText;

  lvField:= TFieldCreator.CreateField(pvCDS, 'FIsPrivate', ftBoolean);  //是否私有
  if pvAssignEvent then
    lvField.OnGetText := OnBitFieldGetText;

  lvField := TFieldCreator.CreateField(pvCDS, 'FIsEspecial', ftBoolean);  //是否敏感数据报表
  if pvAssignEvent then
    lvField.OnGetText := OnBitFieldGetText;
  TFieldCreator.CreateField(pvCDS, 'FUpbuilder', ftString, 50);
  TFieldCreator.CreateField(pvCDS, 'FModifier', ftString, 50);
  TFieldCreator.CreateField(pvCDS, 'FModifyTime', ftDateTime);
end;

function TfrmReportList.createReporter(pvID: PAnsiChar): IReporter;
var
  lvID:String;
  lvConsoleSetter:IReportConsoleSetter;

var
  lvReporter:IReporter;
var
  lvTempFile:AnsiString;
  lvFileID:AnsiString;
  lvData:ISuperObject;
begin
  checkPrepare;

  lvID := pvID;
  if lvID <> '' then
  begin
    if not cdsMain.Locate('FKey', lvID, []) then
    begin
      raise Exception.Create('没有找到对应的报表!');
    end;
  end else
  begin
    if cdsMain.RecordCount = 0 then
    begin
      raise Exception.Create('没有找到任何的报表!');
    end;
    if not LocalDefault then cdsMain.First;
  end;

  if cdsMain.FieldByName('FKey').AsString = '' then raise Exception.Create('没有选取任何报表!');
  if FFileAccess = nil then raise Exception.Create('缺少文件操作接口!');
  lvTempFile := TFileTools.createTempFileName('rep', '.rep');
  lvFileID :=checkGetRFileName(cdsMain);
  FFileAccess.getFile(PAnsiChar(lvFileID), PAnsiChar(lvTempFile), 'report', False);
  TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);

  Result := getCurrentReporter(cdsMain);
  if Result.QueryInterface(IReportConsoleSetter, lvConsoleSetter) = S_OK then
  begin
    lvConsoleSetter.setReportConsole(Self);
  end;


  Result.Clear;
  Result.setDesignFile(PAnsiChar(lvTempFile));
  Result.setDataList(FDataIntf);   
end;

procedure TfrmReportList.Data2UI(pvCDS: TClientDataSet; pvLocate: Boolean =
    false);
var
  lvBookmark:TBookmark;
  i:Integer;
  lvIsDeleted:Boolean;
  lvKey, lvTempStr:String;
begin
  lvBookmark:=TDBTools.DisableControlsAndGetBookMark(cdsMain);
  try
    if pvLocate then
      lvKey := pvCDS.FieldByName('FKey').AsString;
    
    cdsMain.Data := pvCDS.Data;
    TCdsTools.ApplySorting(cdsMain, 'FSN');
    cdsMain.First;
    while not cdsMain.Eof do
    begin
      lvIsDeleted := false;
      if (not FJSonConfig.B['showAllReporter']) then
      begin
        if cdsMain.FieldByName('FIsEspecial').AsBoolean  then
        begin
          if not FJSonConfig.B['showEspecial'] then
          begin
            cdsMain.Delete;
            lvIsDeleted := true;
          end;
        end;
        if cdsMain.FieldByName('FIsPrivate').AsBoolean  then
        begin
          lvTempStr := cdsMain.FieldByName('FUpbuilder').AsString;
          if (lvTempStr <> '')   //为空时都显示
             and
             (not SameText(lvTempStr, FJSonConfig.S['operator.name']))  //不是当前操作人的报表
          then
          begin
            cdsMain.Delete;
            lvIsDeleted := true;
          end;
        end;
      end;
      if not lvIsDeleted then
      begin
        cdsMain.Edit;
        cdsMain.FieldByName('FSN').AsInteger := cdsMain.RecNo;
        cdsMain.Next;
      end;
    end;
  finally
    TDBTools.EnableControlsAndFreeBookMark(cdsMain, lvBookmark);
  end;

  if pvLocate then cdsMain.Locate('FKey', lvKey, []);

//  grdList.Cells[0, 0] := '序号';
//  grdList.ColWidths[0] := 60;
//
//  grdList.Cells[1, 0] := '名称';
//  grdList.ColWidths[1] := 120;
//
//  grdList.Cells[2, 0] := '类型';
//  grdList.ColWidths[2] := 80;
//
//  grdList.Cells[3, 0] := '敏感报表';
//  grdList.ColWidths[2] := 80;
end;


procedure TfrmReportList.dbgrdMainDblClick(Sender: TObject);
begin
  if cdsMain.RecordCount = 0 then
  begin
    DoEditor(True);
  end else
  begin
    actPreView.Execute;
  end;
end;

procedure TfrmReportList.Design(pvID: PAnsiChar);
var
  lvID:String;
begin
  try
    resetError;
    checkPrepare;

    lvID := pvID;
    if lvID <> '' then
    begin
      if not cdsMain.Locate('FKey', lvID, []) then
      begin
        raise Exception.Create('没有找到对应的报表!');
      end;
    end else
    begin
      if cdsMain.RecordCount = 0 then
      begin
        raise Exception.Create('没有找到任何的报表!');
      end;
      if not LocalDefault then cdsMain.First;
    end;
    actDesign.Execute;
  except
    on e:Exception do
    begin
      FLastErrorDesc := e.Message;
      if FLastError = 0 then FLastError := -1;
    end;
  end;
end;

procedure TfrmReportList.designCurrentReporter(pvCDS: TClientDataSet);
var
  lvReporter:IReporter;
var
  lvTempFile:AnsiString;
  lvFileID:AnsiString;
  lvData:ISuperObject;
begin
  if FFileAccess = nil then raise Exception.Create('缺少文件操作接口!');
  lvTempFile := TFileTools.createTempFileName('rep', '.rep');
  lvFileID :=checkGetRFileName(pvCDS);
  FFileAccess.getFile(PAnsiChar(lvFileID), PAnsiChar(lvTempFile), 'report', False);
  TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);

  lvReporter := getCurrentReporter(pvCDS);
  lvReporter.Clear;
  lvReporter.setDesignFile(PAnsiChar(lvTempFile));
  lvReporter.setDataList(FDataIntf);
  if lvReporter.Design then
  begin
    FFileAccess.saveFile(PAnsiChar(lvFileID), PAnsiChar(lvTempFile), 'report');
    TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);
    markModifyINfo(pvCDS);
    saveList(pvCDS);
  end;

  if FileExists(lvTempFile) then
    SysUtils.DeleteFile(lvTempFile);

  lvTempFile := '';
  lvFileID := '';
end;

function TfrmReportList.DesignNewReport(pvTypeID,
  pvRepName: PAnsiChar): PAnsiChar;
var
  lvSN:Integer;
begin
  checkPrepare;
  lvSN := TSNTools.GetNextSNIndex(cds4Update, 'FSN');
  try
    self.cds4Update.Append;
    self.cds4Update.FieldByName('FSN').AsInteger := lvSN;
    self.cds4Update.FieldByName('FName').AsString := pvRepName;
    self.cds4Update.FieldByName('FTypeID').AsString := pvTypeID;
    self.cds4Update.Post;
    __pass := self.cds4Update.FieldByName('FKey').AsString;
    designCurrentReporter(cds4Update);
    saveList(cds4Update);
    Result := PAnsiChar(__pass);
  except
    cds4Update.Delete;
    raise;
  end;
end;

procedure TfrmReportList.DoEditor(pvIsAppend:Boolean);
var
  lvEditor:TfrmReportEditor;
  lvSN:Integer;
begin
  if FTypeConfig = nil then raise Exception.Create('没有配置支持的报表列表(reporterList)');

  lvEditor := TfrmReportEditor.Create(Self);
  try
    lvEditor.setDataSource(self.ds4Update);
    lvEditor.setTypeConfig(FTypeConfig);

    lvEditor.dbchkFIsEspecial.Enabled := FshowEspecial;

    lvSN := TSNTools.GetNextSNIndex(cds4Update, 'FSN');
    if pvIsAppend then
    begin
      if lvEditor.cbbTypeID.Items.Count > 0 then
      begin
        lvEditor.cbbTypeID.ItemIndex := 0;
      end;
      
      self.cds4Update.Append;
      self.cds4Update.FieldByName('FSN').AsInteger := lvSN;

    end else
    begin
      checkLocate4Update;
      cds4Update.Locate('FKey', cdsMain.FieldByName('FKey').AsString , []);
      lvEditor.prepareForEditor;
    end;
    if lvEditor.ShowModal() = mrOk then
    begin
      markModifyINfo(cds4Update);
      TDBTools.DataSetPost(self.cds4Update);
      saveList(cds4Update);
      Data2UI(cds4Update, True);

      if pvIsAppend then
      begin
        actDesign.Execute;
      end;
    end else
    begin
      self.cds4Update.Cancel;
    end;
  finally
    lvEditor.Free;
  end;


end;

procedure TfrmReportList.DoImportRepPackFile(pvFile:PAnsiChar);
begin
  ImportRepPackFile(pvFile, '', False, nil, False, True);  
end;

procedure TfrmReportList.DoReporterExport(pvReportID, pvPath: PAnsiChar;
    pvProgConsole: IProgConsole);
var
  lvCDS:TClientDataSet;
  lvFile, lvBasePath:String;
begin
  lvCDS := TClientDataSet.Create(nil);
  try
    lvBasePath := TFileTools.PathWithBackslash(pvPath);
    ForceDirectories(lvBasePath);

    createRepListFields(lvCDS, false);
    lvCDS.CreateDataSet;
    reloadList(lvCDS, pvReportID);
    TCdsTools.ApplySorting(lvCDS, 'FSN');
    if lvCDS.RecordCount > 0 then
    begin
      lvCDS.First;
      if (pvProgConsole <> nil) then
      begin
        pvProgConsole.SetMax(lvCDS.RecordCount);
        pvProgConsole.SetPosition(0);
      end;
      while not lvCDS.Eof do
      begin
        if (pvProgConsole <> nil) then
        begin
          if (pvProgConsole.IsBreaked) then Break;
          pvProgConsole.SetPosition(lvCDS.RecNo);
        end;
        
        lvFile := lvBasePath + '\' + pvReportID + '_' + IntToStr(lvCDS.RecNo) + '_' +
         '_' + lvCDS.FieldByName('FName').AsString + '.repPack';
        if FileExists(lvFile) then DeleteFile(lvFile);
        InnerExport(pvReportID, lvCDS, lvFile, True);
        lvCDS.Next;
      end;
    end;   
  finally
    lvCDS.Free;
  end;
end;

procedure TfrmReportList.FormCreate(Sender: TObject);
var
  lvField:TField;
begin
  //TPrintReportFactory.checkInitialize;

  //FTypeConfig := SO(TPrintReportFactory.Instance.getReporterList);

  //测试数据
  FReportID := '1002578';

  createRepListFields(cdsMain);
  createRepListFields(cds4Update, False);

  cdsMain.CreateDataSet;
  cds4Update.CreateDataSet;
end;

procedure TfrmReportList.FreeConsole;
begin
  self.Close;
  Self.Free;
end;

procedure TfrmReportList.FreeReporterIM;
begin
  self.Free;
end;

function TfrmReportList.getCurrentReporter(pvCDS: TClientDataSet): IReporter;
var
  lvStr:String;
  lvReporter:IReporter;
begin
  if pvCDS.RecordCount = 0 then raise Exception.Create('没有设计任何报表!');
  lvStr := pvCDS.FieldByName('FTypeID').AsString;
  if lvStr = '' then
  begin
    raise Exception.Create('当前报表没有指定报表类型!');
  end;

  Result := TmBeanFrameVars.getBean(lvStr) as IReporter;
end;

function TfrmReportList.getErrorCode: Integer;
begin
  Result := FLastError;
end;

function TfrmReportList.getErrorDesc(pvErrorDesc: PAnsiChar; pvLength:
    Integer): Integer;
var
  j:Integer;
  lvStr:AnsiString;
begin
  lvStr := AnsiString(FLastErrorDesc);
  j := Length(lvStr);
  if pvErrorDesc <> nil then
  begin
    if j > pvLength then  j := pvLength;
    CopyMemory(pvErrorDesc, PAnsiChar(lvStr), j);
  end;
  Result := j;
  lvStr := '';
end;

function TfrmReportList.getFirstReporterID: PAnsiChar;
begin
  checkPrepare;
  __pass := cdsMain.FieldByName('FKey').AsString;
  Result := PAnsiChar(__pass);
end;

function TfrmReportList.getReportINfo(pvID: PAnsiChar): PAnsiChar;
var
  lvID:String;
  lvINfo:ISuperObject;
begin
  Result :='';
  checkPrepare;
  lvID := pvID;
  if lvID <> '' then
  begin
    if not cdsMain.Locate('FKey', lvID, []) then
    begin
      raise Exception.Create('没有找到对应的报表!');
    end;

    lvINfo := SO();
    TJSonTools.CopyRecord2JSon(cdsMain, lvINfo, True);
    __pass := lvINfo.AsJSon(True);
    Result := PAnsiChar(__pass);
  end;                            
end;

function TfrmReportList.getReports: PAnsiChar;
var
  lvData:ISuperObject;
  lvItem:ISuperObject;
begin
  FDefaultID := '';   //置空 checkGetDefaultID时重新获取
  Prepare;
  lvData := SO('[]');
  cdsMain.First;
  while not cdsMain.Eof do
  begin
    lvItem := SO();
    lvItem.S['ID'] := cdsMain.FieldByName('FKey').AsString;
    lvItem.S['caption'] := cdsMain.FieldByName('FName').AsString;
    if lvItem.S['ID'] = checkGetDefaultID then
    begin
      lvItem.B['default'] := True;
    end;
    lvData.AsArray.Add(lvItem);
    cdsMain.Next;
  end;
  __pass := lvData.AsJSon(True);
  Result := PAnsiChar(__pass);
end;

procedure TfrmReportList.grdVMainDblClick(Sender: TObject);
begin
  DoEditor(False);
end;

function TfrmReportList.ImportRepPackFile(pvRepPackFile: String; pvReportID:
    String = ''; pvForceAppend: Boolean = true; pvCDS: TClientDataSet = nil;
    pvChangeOperator: Boolean = false; IgnoreEmptyTemplateFile: Boolean =
    false): string;
var
  lvKeyStream:TKeyStream;
  lvRec:ISuperObject;

  lvReportID:AnsiString;

  lvTempFile:AnsiString;
  lvFileID:AnsiString;
  lvData:ISuperObject;
  lvInfo:AnsiString;

  lvInnerCDS, lvCDS:TClientDataSet;

  lvSN:Integer;
begin
  lvKeyStream := TKeyStream.Create;
  try
    TKeyStreamCoder.DecodeFromFile(lvKeyStream, pvRepPackFile);
    lvInfo := TKeyStreamCoder.ExtractString(lvKeyStream, 'info');
    if lvInfo = '' then raise Exception.Create('非法的报表导出文件[' + pvRepPackFile + ']');

    lvTempFile := TFileTools.createTempFileName('rep', '.rep');
    if FileExists(lvTempFile) then DeleteFile(lvTempFile);
    if not TKeyStreamCoder.ExtractFile(lvKeyStream, 'file', lvTempFile) then
    begin
      if not IgnoreEmptyTemplateFile then      
        raise Exception.Create('无法从报表打包文件中获取报表设计文件[' + pvRepPackFile + ']');
    end;

    lvRec := SO(lvInfo);

    lvReportID := pvReportID;
    if lvReportID = '' then  lvReportID := lvRec.S['__reportid'];

    lvCDS := pvCDS;
    if lvCDS = nil then lvInnerCDS := TClientDataSet.Create(nil);
    try
      if lvInnerCDS <> nil then
      begin
        lvCDS := lvInnerCDS;
        createRepListFields(lvCDS, false);
        lvCDS.CreateDataSet;
        reloadList(lvCDS, lvReportID);
      end;

      if pvForceAppend then
      begin
        lvSN := TSNTools.GetNextSNIndex(lvCDS, 'FSN');
        lvCDS.Append;
        self.cds4UpdateAfterInsert(lvCDS);
        TJSonTools.CopyDataRecordFromJsonData(lvCDS, lvRec);
        lvCDS.FieldByName('FKey').AsString := CreateClassID;
        lvCDS.FieldByName('FSN').AsInteger := lvSN;
      end else
      begin
        if lvCDS.Locate('FKey', lvRec.S['fkey'], []) then
        begin
          TJSonTools.CopyDataRecordFromJsonData(lvCDS, lvRec, '', 'FSN');
        end else
        begin
          lvSN := TSNTools.GetNextSNIndex(lvCDS, 'FSN', -1);
          lvCDS.Append;
          self.cds4UpdateAfterInsert(lvCDS);
          TJSonTools.CopyDataRecordFromJsonData(lvCDS, lvRec, '', 'FSN');
          lvCDS.FieldByName('FSN').AsInteger := lvSN;
        end;
      end;

      lvFileID := checkGetRFileName(lvCDS);
      
      //删除现有的报表
      FFileAccess.deleteFile(PAnsiChar(lvFileID), 'report');
      TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);

      Result := lvFileID;

      if pvChangeOperator then  markModifyINfo(lvCDS);
      
      TDBTools.DataSetPost(lvCDS);       

      //保存报表列表信息文件
      saveList(lvCDS, lvReportID);

      if FileExists(lvTempFile) then
      begin
        //保存文件
        FFileAccess.saveFile(PAnsiChar(lvFileID), PAnsiChar(lvTempFile), 'report');
        TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);
        DeleteFile(lvTempFile);
      end;                     
    finally
      if lvInnerCDS <> nil then lvInnerCDS.Free;
    end;
  finally
    lvKeyStream.Free;
  end;

  lvFileID := '';
  lvTempFile := '';
end;

procedure TfrmReportList.InnerExport(pvReportID: string; pvDataSet: TDataSet;
    pvFileName: string; IgnoreEmptyTemplateFile: Boolean = false);
var
  lvKeyStream: TKeyStream;
  lvRec: ISuperObject;
  lvTempFile: AnsiString;
  lvFileID: AnsiString;
begin
  lvRec := SO();
  TJSonTools.CopyRecord2JSon(pvDataSet, lvRec, True);
  lvRec.S['__reportid'] := pvReportID;
  lvKeyStream := TKeyStream.Create;
  try
    TKeyStreamCoder.AddString(lvKeyStream, 'info', lvRec.AsJSon(False));
    lvTempFile := TFileTools.createTempFileName('rep', '.rep');
    if FFileAccess = nil then raise Exception.Create('缺少文件操作接口!');
    lvFileID := checkGetRFileName(pvDataSet);
    FFileAccess.getFile(PAnsiChar(lvFileID), PAnsiChar(lvTempFile), 'report', False);
    TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);
    if FileExists(lvTempFile) then
    begin
      TKeyStreamCoder.AddFile(lvKeyStream, 'file', lvTempFile);
    end else
    begin
      if not IgnoreEmptyTemplateFile then
      begin
        raise Exception.Create('当前报表没有模版设计文体!');
      end;
    end;

    TKeyStreamCoder.Encode2File(lvKeyStream, pvFileName);    
  finally
    lvKeyStream.Free;
  end;
  lvFileID := '';
  lvTempFile := '';
end;

function TfrmReportList.LocalDefault: Boolean;
var
  lvDefaultID:String;
begin
  Result := false;
  lvDefaultID := checkGetDefaultID;
  if (lvDefaultID <> '') and (lvDefaultID <> 'none') then
  begin
    Result := cdsMain.Locate('FKey', lvDefaultID, []);
  end;
end;

procedure TfrmReportList.markModifyINfo(pvDataSet:TClientDataSet);
begin
  if FJSonConfig<> nil then
  begin
    TDBTools.DataSetEdit(pvDataSet);
    pvDataSet.FieldByName('FModifier').AsString := FJSonConfig.S['Operator.name'];
    pvDataSet.FieldByName('FModifyTime').AsDateTime := now();
  end;
end;

procedure TfrmReportList.OnBitFieldGetText(Sender: TField; var Text: string;
    DisplayText: Boolean);
begin
  Text := '';
  if Sender.AsBoolean then
  begin
    Text := '是';
  end;
end;

procedure TfrmReportList.OnCaptionGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if cdsMain.FieldByName('FKey').AsString = checkGetDefaultID then
  begin
    Text := '(默认)' + Sender.AsString;
  end else
  begin
    Text :=  Sender.AsString;
  end;
end;

procedure TfrmReportList.OnTypeIDGetText(Sender: TField; var Text: string;
    DisplayText: Boolean);
var
  lvItem:ISuperObject;
begin
  Text := Sender.AsString;
  if FTypeConfig = nil then exit;
  
  if (FTypeConfig <> nil) and (FTypeConfig.O['list']<>nil) then
  begin
    lvItem := FTypeConfig.O['list.' + TSOTools.makeMapKey(Text)];
    if lvItem <> nil then
    begin
      Text := lvItem.S['remark'];
    end;
  end;
end;

procedure TfrmReportList.Prepare;
begin
  try
    if FJSonConfig <> nil then
    begin
      FshowEspecial := FJSonConfig.B['showEspecial'];
    end else
    begin
      FshowEspecial := true;
    end;

    checksetDefaultOperator;


    

    reloadList(cds4Update);
    Data2UI(cds4Update);
    actSetDefault.Enabled := FDefaultOperator <> nil;
  except
    on E:Exception do
    begin
      TMsgTools.ShowError('读取报表列表文件出错!' + sLineBreak + e.Message);
    end;
  end;  
end;

procedure TfrmReportList.PreView(pvID: PAnsiChar);
var
  lvID:String;
begin
  try
    resetError;
    checkPrepare;
    lvID := pvID;
    if lvID <> '' then
    begin
      if not cdsMain.Locate('FKey', lvID, []) then
      begin
        raise Exception.Create('没有找到对应的报表!');
      end;
    end else
    begin
      if cdsMain.RecordCount = 0 then
      begin
        raise Exception.Create('没有找到任何的报表!');
      end;
      if not LocalDefault then cdsMain.First;
    end;
    actPreView.Execute;
  except
    on e:Exception do
    begin
      FLastErrorDesc := e.Message;
      if FLastError = 0 then FLastError := -1;      
    end;
  end;
end;

procedure TfrmReportList.Print(pvID: PAnsiChar);
var
  lvID:String;
begin
  try
    resetError;
    lvID := pvID;
    checkPrepare;
    if lvID <> '' then
    begin
      if not cdsMain.Locate('FKey', lvID, []) then
      begin
        raise Exception.Create('没有找到对应的报表!');
      end;
    end else
    begin
      if cdsMain.RecordCount = 0 then
      begin
        raise Exception.Create('没有找到任何的报表!');
      end;
      if not LocalDefault then cdsMain.First;
    end;
    actPrint.Execute;
  except
    on e:Exception do
    begin
      FLastErrorDesc := e.Message;
      if FLastError = 0 then FLastError := -1;      
    end;
  end;
end;

procedure TfrmReportList.reloadList(pvCDS: TClientDataSet = nil; pvReportID:
    String = '');
var
  lvData:ISuperObject;
  lvTempFile, lvReportID:AnsiString;
  lvCDS:TClientDataSet;
begin
  lvCDS := pvCDS;
  if lvCDS = nil then lvCDS := cds4Update;
  lvReportID := pvReportID;
  if lvReportID = '' then lvReportID := FReportID;

  lvTempFile := TFileTools.createTempFileName('rep', '.jsn');
  if FFileAccess = nil then raise Exception.Create('缺少文件操作接口!');
  FFileAccess.getFile(PAnsiChar(lvReportID+'.jsn'), PAnsiChar(lvTempFile), 'report', False);
  TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);

  lvData := TJSonTools.JsnParseFromFile(lvTempFile);
  TJSonTools.DataSetUnPack(lvCDS, lvData);

  if FileExists(lvTempFile) then
    DeleteFile(lvTempFile);
  lvReportID := '';
  lvTempFile := '';
end;

procedure TfrmReportList.resetError;
begin
  FLastError := 0;
  FLastErrorDesc := '';
end;

function TfrmReportList.saveFileRes(pvID: PAnsiChar): PAnsiChar;
var
  lvFileID, lvID, lvTempFile:AnsiString;
begin
  Result := '';
  checkPrepare;
  lvID := pvID;
  if lvID <> '' then
  begin
    if not cdsMain.Locate('FKey', lvID, []) then
    begin
      raise Exception.Create('没有找到对应的报表!');
    end;

    if cdsMain.FieldByName('FKey').AsString = '' then raise Exception.Create('没有选取任何报表!');
    if FFileAccess = nil then raise Exception.Create('缺少文件操作接口!');
    lvTempFile := TFileTools.createTempFileName('rep', '.rep');
    lvFileID :=checkGetRFileName(cdsMain);
    FFileAccess.getFile(PAnsiChar(lvFileID), PAnsiChar(lvTempFile), 'report', False);
    TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);

    __pass := lvTempFile;
    Result := PAnsiChar(__pass);
  end;
end;

procedure TfrmReportList.saveList(pvCDS: TClientDataSet = nil; pvReportID:
    String = '');
var
  lvTempFile, lvReportID:AnsiString;
  lvCDS:TClientDataSet;
begin
  lvCDS := pvCDS;
  if lvCDS = nil then lvCDS := cds4Update;
  lvReportID := pvReportID;
  if lvReportID = '' then lvReportID := FReportID;


  lvTempFile := TFileTools.createTempFileName('rep', '.jsn');
  TJSonTools.JsnSaveToFile(TJSonTools.DataSetPack(lvCDS), lvTempFile);
  FFileAccess.saveFile(PAnsiChar(lvReportID+'.jsn'), PAnsiChar(lvTempFile), 'report');
  TErrorINfoTools.checkRaiseErrorINfo(FFileAccess);

  if FileExists(lvTempFile) then
    DeleteFile(lvTempFile);
  lvReportID := '';
end;

procedure TfrmReportList.setBeanConfig(pvBeanConfig: PAnsiChar);
var
  lvItem:ISuperObject;
  i:Integer;
begin
  FBeanConfig := SO(pvBeanConfig);
  if (FBeanConfig <> nil) and (not FBeanConfig.IsType(stObject)) then
    FBeanConfig := nil;

  if FBeanConfig <> nil then
  begin
    if FBeanConfig.O['reporterList'] = nil then exit;

    FTypeConfig := SO();

    for i := 0 to FBeanConfig.A['reporterList'].Length - 1 do
    begin
      lvItem := FBeanConfig.A['reporterList'].O[i];
      FTypeConfig.O['list.' + TSOTools.makeMapKey(lvItem.S['id'])] := lvItem;
    end;
  end;
end;

procedure TfrmReportList.setConfig(pvConfig: PAnsiChar);
var
  lvString:String;
begin
  lvString := pvConfig;
  FJSonConfig := SO(lvString);
  if FJSonConfig = nil then
  begin
    raise Exception.Create('非法的配置格式' + sLineBreak + pvConfig);
  end; 

end;

procedure TfrmReportList.setDataList(const pvIntf: IInterface);
begin
  FDataIntf := pvIntf;
end;

procedure TfrmReportList.setFileAccess(const pvIntf: IFileAccess);
begin
  TFileLogger.instance.logMessage('准备执行setFileAccess');
  FFileAccess := pvIntf;
end;

procedure TfrmReportList.setReporterDefaultOperator(
  pvIntf: IReporterDefaultOperator);
begin
  FDefaultOperator := pvIntf;
end;

procedure TfrmReportList.setReportID(pvReportID: PAnsiChar);
begin
  FReportID := pvReportID;
end;

procedure TfrmReportList.ShowConsole;
begin
  try
    resetError;
    //TFileLogger.instance.logMessage('准备执行showConsole');
    checkPrepare;

    if FJSonConfig = nil then  raise Exception.Create('打印控制台,缺少配置信息(JSon格式)');
    


    if FJSonConfig.S['operator.name'] <> '' then
    begin
      self.Caption := '欢迎[' + FJSonConfig.S['operator.name'] + ']进入打印报表控制台';
    end;

    self.dbgrdMain.Columns[5].Visible :=  FshowEspecial;
    Self.ShowModal();
  except
    on E:Exception do
    begin
      FLastErrorDesc := e.Message;
      if FLastError = 0 then FLastError := -1;

      FLastMessage:= E.Message;
      TFileLogger.instance.logErrMessage(E.Message);

    end;
  end;
end;

end.
