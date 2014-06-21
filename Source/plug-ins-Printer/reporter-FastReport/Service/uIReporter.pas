unit uIReporter;

interface

uses
  uIFileAccess, StdInterface;


type
  IReportConsole = interface;

  /// <summary>
  ///    报表默认操作接口
  /// </summary>
  IReporterDefaultOperator = interface(IInterface)
    ['{E2AE8588-8400-4833-953F-E3347784D93E}']

    //设置默认的报表
    procedure setDefault(pvCatalogID, pvID:PAnsiChar);stdcall;//设置默认报表

    //获取默认的报表样式
    function getDefault(pvCatalogID:PAnsiChar):PAnsiChar;stdcall;
  end;

  IReporterDefaultOperatorSetter = interface(IInterface)
    ['{1093C31E-9FD7-463B-9101-8DEC7C1661D8}']
    procedure setReporterDefaultOperator(pvIntf:IReporterDefaultOperator);stdcall;
  end;

  //报表接口
  IReporter = interface(IInterface)
    ['{0FC68D26-DACC-4C42-BA5A-B2810FB9F0D2}']

    //有改变时返回true
    function Design: Boolean; stdcall;

    procedure Preview; stdcall;

    procedure Print; stdcall;

    //设置设计好的报表文件模板 
    procedure setDesignFile(pvFile: PAnsiChar); stdcall;

    //数据对象的接口列表
    procedure setDataList(pvIntf: IInterface); stdcall;

    //设置名字
    procedure setName(pvName:PAnsiChar);stdcall;

    //清理
    procedure Clear; stdcall;
  end;


  //报表导入导出(升级)
  IReporterIM = interface(IInterface)
    ['{57C68B20-94B2-420B-B08B-90DE777C713C}']
    //导入一个报表的打包文件
    procedure DoImportRepPackFile(pvFile:PAnsiChar);stdcall;

    //导出报表文件到一个路径
    procedure DoReporterExport(pvReportID, pvPath: PAnsiChar; pvProgConsole:
        IProgConsole); stdcall;

    //文件操作接口
    procedure setFileAccess(const pvIntf: IFileAccess); stdcall;

    procedure FreeReporterIM();stdcall;
  end;


  IReportConsoleSetter = interface(IInterface)
    ['{8D8073A8-5D75-4398-B559-0F9C6C426D7F}']
    procedure setReportConsole(const pvConsole: IReportConsole); stdcall;
  end;

  //打印控制台
  IReportConsole = interface(IInterface)
    ['{F76412E1-1BEE-49C9-9C4F-8047E1D8DC74}']

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

  

  //负责注册IReporter库,在ReportConsole中使用
  IReporterFactory = interface(IInterface)
  ['{5E122846-374C-4BF3-B7EC-C8AA62D32793}']
    
    //注册一个报表接口
    procedure registerReporter(pvID, pvCaption: PAnsiChar; const pvReporter:
        IReporter);

    //获取一个报表接口
    function getReporter(pvID: PAnsiChar): IReporter;


    //ids:['FR','RM'], list:{FR:{ID:"FR","Remark":"FR报表"},RM:{ID...}
    function getReporterList:PAnsiChar; stdcall;
  end;
  

  //打印数据配置获取
  //暂时没有使用
  IPrintDATAConfigGetter = interface(IInterface)
   ['{FDD3F8B5-1E56-41A4-9E09-D0377B948C10}']

    /// <summary>
    ///   打印数据选项
    /// </summary>
    /// <returns>
    ///     {
    ///        isAll:true, //打印所有记录
    ///   }
    /// </returns>
    function getPrintDATAConfig: PAnsiChar; stdcall;
  end;


implementation

end.
