unit uDBIntf;

interface

uses
  DB, superobject;


type
  IDataSetAfterInsert = interface;
  IDataSetGetter = interface(IInterface)
    ['{710743CE-3817-455B-A29C-39B3EA98DE5F}']
    function getDataSet():TDataSet; stdcall;
  end;

  IDataSetSetter = interface(IInterface)
    ['{BCC04843-0DED-4CDD-970F-0B3F2671D9FE}']
    procedure setDataSet(const pvDataSet:TDataSet);stdcall;
  end;

  IDataSetAfterInsertSetter = interface(IInterface)
    ['{0B657C1C-1BB1-468F-919B-B4CBE614F886}']
    procedure setDataSetAfterInsertIntf(const pvValue:IDataSetAfterInsert);stdcall;
  end;


  IDataSourceSetter = interface(IInterface)
    ['{4DFE3BB4-A1A3-432C-917F-C5273EA9D1A2}']
    procedure setDataSource(const pvValue:TDataSource); stdcall;
  end;

  
  IDataSourceGetter = interface(IInterface)
    ['{E1B65B81-B9AC-437C-A99E-69985249DD1E}']
    function getDataSource():TDataSource; stdcall;
  end;

  IReadOnlyOperator = interface(IInterface)
    ['{8E09C8F8-971E-4DB6-BCC7-B0F93AAA23D8}']
    procedure setReadOnly(pvReadOnly:Boolean); stdcall;
  end;

  //数据库操作接口
  IDataSetOpera = interface(IInterface)
    ['{57011298-F3D4-43AD-944F-C26FE3D74842}']

    //保存前
    procedure BeforeApplyUpdate;stdcall;

    //是否被修改
    function IsChange:Boolean; stdcall;

    //进行添加
    procedure Append;stdcall;

    //取消修改到初始状态
    procedure Cancel;stdcall;

    //打包保存数据
    function PackageUpdateData:String;stdcall;

    //保存
    procedure ApplyUpdate; stdcall;

    //清除数据还原的初始状态(未修改的状态)
    procedure EmptyData(); stdcall;

    //保存成功后
    procedure AfterApplyUpdate; stdcall;

    //打开
    procedure reOpen();stdcall;
  end;

  IDataSetAfterInsert = interface(IInterface)
    ['{01C53C31-EAB2-4798-BA94-B2893233BC96}']
    procedure DoAfterInsert(const ID: string; pvDataSet: TDataSet; pvConfig:
        ISuperObject); stdcall;
  end;


  //数据刷新
  IDataRefresh = interface(IInterface)
    ['{4047C1EF-1F5A-4D29-97AA-4E4A14FC191E}']
    //刷新数据, pvJsonData是当前记录
    procedure DoRefreshData(pvJSonData:ISuperObject); stdcall;
  end; 




implementation

end.
