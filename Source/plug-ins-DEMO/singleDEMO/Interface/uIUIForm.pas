unit uIUIForm;

interface 

type 
  /// <summary>
  ///   窗体插件
  /// </summary>
  IUIForm = interface(IInterface)
    ['{7E250C3C-331E-4732-AD05-F08CA1CA486A}']
    procedure showAsMDI; stdcall;

    function showAsModal: Integer; stdcall;

    //关闭
    procedure UIFormClose; stdcall;

    //释放窗体
    procedure UIFormFree; stdcall;

    //获取窗体对象
    function getObject:TObject; stdcall;

    //获取实例ID
    function getInstanceID: Integer; stdcall;
  end;

implementation

end.
