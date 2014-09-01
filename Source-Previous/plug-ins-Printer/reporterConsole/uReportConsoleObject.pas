unit uReportConsoleObject;

interface

uses
  uIReporter, uIFileAccess, Forms, ufrmReportList, SysUtils,
  FileLogger;

type
  TReportConsoleObject = class(TInterfacedObject, IReportConsole)
  private
    FLastMessage:String;
    FFileAccess:IFileAccess;
    FConfig:String;
    FDataList:IInterface;
    FReportList: TfrmReportList;
    FReportID:String;
  public
    constructor Create;
    destructor Destroy; override;
    //打印报表,传入单个报表的ID
    procedure Print(pvID:PAnsiChar);stdcall;   //打印默认报表

    //预览报表,传入单个报表的ID (如果传入的为空值,则预览第一个)
    procedure PreView(pvID:PAnsiChar);stdcall;

    //设计报表,传入单个报表的ID (如果传入的为空值,则预览第一个)
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
    function getReportINfo(pvID:PAnsiChar):PAnsiChar; stdcall;

    //设计一个新的报表,返回设计好的报表ID
    function DesignNewReport(pvTypeID:PAnsiChar; pvRepName:PAnsiChar):PAnsiChar;stdcall;

    //获取第一个ID
    function getFirstReporterID():PAnsiChar;stdcall;

    //显示控制台
    procedure ShowConsole();

    //准备数据
    procedure Prepare;stdcall;

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
  end;

implementation

constructor TReportConsoleObject.Create;
begin
  inherited Create;
  FReportList:=TfrmReportList.Create(nil);
end;

destructor TReportConsoleObject.Destroy;
begin
  FReportList.Free;
  FFileAccess := nil;
  inherited Destroy;
end;

{ TReportConsoleObject }

function TReportConsoleObject.createReporter(pvID: PAnsiChar): IReporter;
begin
  
end;

procedure TReportConsoleObject.Design(pvID: PAnsiChar);
begin

end;

function TReportConsoleObject.DesignNewReport(pvTypeID,
  pvRepName: PAnsiChar): PAnsiChar;
begin

end;

procedure TReportConsoleObject.FreeConsole;
begin

end;

function TReportConsoleObject.getFirstReporterID: PAnsiChar;
begin

end;

function TReportConsoleObject.getReportINfo(pvID: PAnsiChar): PAnsiChar;
begin

end;

function TReportConsoleObject.getReports: PAnsiChar;
begin

end;

procedure TReportConsoleObject.Prepare;
begin

end;

procedure TReportConsoleObject.PreView(pvID: PAnsiChar);
begin

end;

procedure TReportConsoleObject.Print(pvID: PAnsiChar);
begin

end;

function TReportConsoleObject.saveFileRes(pvID: PAnsiChar): PAnsiChar;
begin

end;

procedure TReportConsoleObject.setConfig(pvConfig: PAnsiChar);
begin
  FConfig := pvConfig;
end;

procedure TReportConsoleObject.setDataList(const pvIntf: IInterface);
begin
  FDataList := pvIntf;
end;

procedure TReportConsoleObject.setFileAccess(const pvIntf: IFileAccess);
begin
  FFileAccess := pvIntf;
end;

procedure TReportConsoleObject.setReportID(pvReportID: PAnsiChar);
begin
  FReportID := pvReportID;
end;

procedure TReportConsoleObject.ShowConsole;
begin
  try
    FReportList.setFileAccess(FFileAccess);
    FReportList.setDataList(FDataList);
    FReportList.setConfig(PAnsiChar(FConfig));
    FReportList.setReportID(PAnsiChar(FReportID));
    FReportList.ShowConsole();
  except
    on E:Exception do
    begin
      FLastMessage:= E.Message;
      TFileLogger.instance.logErrMessage(E.Message);    
    end;
  end;
end;

end.
