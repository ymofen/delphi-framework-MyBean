unit uILogic;

interface



type
  /// <summary>
  ///   合计插件接口
  /// </summary>
  ISumExp = interface(IInterface)
    ['{D02C3764-1231-46EC-8C74-95DFBF2A1ED5}']
    function sum(i:Integer; j:Integer):Integer; stdcall;
  end;

  /// <summary>
  ///   日志插件接口
  /// </summary>
  IMyBeanLogger = interface(IInterface)
    ['{B872909D-99FF-47B9-A3F9-8CB9C26A8FD5}']
    procedure LogMessage(s: PAnsiChar); stdcall;
  end;

implementation

end.
