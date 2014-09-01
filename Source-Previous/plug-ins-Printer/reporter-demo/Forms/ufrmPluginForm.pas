unit ufrmPluginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uBasePluginForm, StdCtrls, ExtCtrls, DB, DBClient,
  Grids, DBGrids, uIFileAccess;

type
  TfrmPluginForm = class(TBasePluginForm)
    pnlOperator: TPanel;
    btnPreView: TButton;
    btnDesign: TButton;
    btnPrint: TButton;
    cbbUser: TComboBox;
    DBGrid1: TDBGrid;
    cdsMain: TClientDataSet;
    cdsMainFKey: TStringField;
    cdsMainFCode: TStringField;
    cdsMainFName: TStringField;
    cdsMainFUpbuildTime: TDateTimeField;
    dsMain: TDataSource;
    Label1: TLabel;
    procedure btnDesignClick(Sender: TObject);
    procedure btnPreViewClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    FFileAccess: IFileAccess;
    FDataIntf: IInterfaceList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure setBeanConfig(pvBeanConfig: PAnsiChar); override; stdcall;
  end;

var
  frmPluginForm: TfrmPluginForm;

implementation

uses
  mBeanFrameVars, uIPluginForm, uLocalFileAccess, uIReporter, ComObj,
  uDataSetWrapper, uErrorINfoTools;

{$R *.dfm}

constructor TfrmPluginForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ///演示数据
  cdsMain.Append;
  cdsMain.FieldByName('FKey').AsString := CreateClassID;
  cdsMain.FieldByName('FCode').AsString := '001';
  cdsMain.FieldByName('FName').AsString := '王五';
  cdsMain.FieldByName('FUpbuildTime').AsDateTime := Now();
  cdsMain.Append;
  cdsMain.FieldByName('FKey').AsString := CreateClassID;
  cdsMain.FieldByName('FCode').AsString := '002';
  cdsMain.FieldByName('FName').AsString := '张三';
  cdsMain.FieldByName('FUpbuildTime').AsDateTime := Now();
  cdsMain.Post;


  /// 本地文件存储接口
  FFileAccess := TLocalFileAccess.Create(ExtractFilePath(ParamStr(0)) + '\Files');

  /// 数据提供接口
  FDataIntf := TInterfaceList.Create;

  // 提供给打印的一个演示数据集
  FDataIntf.Add(TDataSetWrapper.Create(cdsMain));
end;

destructor TfrmPluginForm.Destroy;
begin
  FDataIntf.Clear;
  FDataIntf := nil;
  inherited Destroy;
end;

procedure TfrmPluginForm.btnDesignClick(Sender: TObject);
var
  lvID:String;
  lvConsole:IReportConsole;

  lvConfigStr:string;

begin
  lvConfigStr := '{operator:{name:"' + cbbUser.Text + '"}}';
  lvConsole := TmBeanFrameVars.getBean('reporterConsole') as IReportConsole;
  try
    //报表文件的存储, 可以替换成DB,或者FTP等文件操作接口
    lvConsole.setFileAccess(FFileAccess);

    //报表分类的ID,用于报表列表的存储和获取
    lvConsole.setReportID('1002579');

    //配置信息
    lvConsole.setConfig(PAnsiChar(AnsiString(lvConfigStr)));

    //打印数据提供接口
    lvConsole.setDataList(FDataIntf);

    //准备数据
    lvConsole.Prepare;

    //显示控制台
    lvConsole.ShowConsole;

    TErrorINfoTools.checkRaiseErrorINfo(lvConsole);

  finally
    lvConsole.FreeConsole;
  end;
//  with TReportConsoleLibWrapper.createReportConsole do
//  try
//    setFileAccess(FFileAccess);
//    setDataList(FDataIntf);
//    setReportID('1002579');
//    lvID := getFirstReporterID;
//    if lvID <> '' then
//    begin
//      Design(PAnsiChar(lvID));
//    end else
//    begin
//      DesignNewReport('RM', '标准报表');
//    end;
//  finally
//    FreeConsole;
//  end;

end;

procedure TfrmPluginForm.btnPreViewClick(Sender: TObject);
var
  lvID:String;
  lvConsole:IReportConsole;

  lvConfigStr:string;

begin
  lvConfigStr := '{operator:{name:"' + cbbUser.Text + '"}}';
  lvConsole := TmBeanFrameVars.getBean('reporterConsole') as IReportConsole;
  try
    //报表文件的存储, 可以替换成DB,或者FTP等文件操作接口
    lvConsole.setFileAccess(FFileAccess);

    //报表分类的ID,用于报表列表的存储和获取
    lvConsole.setReportID('1002579');

    //配置信息
    lvConsole.setConfig(PAnsiChar(AnsiString(lvConfigStr)));

    //打印数据提供接口
    lvConsole.setDataList(FDataIntf);

    //准备数据
    lvConsole.Prepare;

    //显示预览
    lvConsole.PreView('');

    TErrorINfoTools.checkRaiseErrorINfo(lvConsole);

  finally
    lvConsole.FreeConsole;
  end;

end;

procedure TfrmPluginForm.btnPrintClick(Sender: TObject);
var
  lvID:String;
  lvConsole:IReportConsole;

  lvConfigStr:string;

begin
  lvConfigStr := '{operator:{name:"' + cbbUser.Text + '"}}';
  lvConsole := TmBeanFrameVars.getBean('reporterConsole') as IReportConsole;
  try
    //报表文件的存储, 可以替换成DB,或者FTP等文件操作接口
    lvConsole.setFileAccess(FFileAccess);

    //报表分类的ID,用于报表列表的存储和获取
    lvConsole.setReportID('1002579');

    //配置信息
    lvConsole.setConfig(PAnsiChar(AnsiString(lvConfigStr)));

    //打印数据提供接口
    lvConsole.setDataList(FDataIntf);

    //准备数据
    lvConsole.Prepare;

    //打印
    lvConsole.Print('');

    TErrorINfoTools.checkRaiseErrorINfo(lvConsole);

  finally
    lvConsole.FreeConsole;
  end;

end;

procedure TfrmPluginForm.setBeanConfig(pvBeanConfig: PAnsiChar);
begin
  inherited;
  ;
end;

end.
