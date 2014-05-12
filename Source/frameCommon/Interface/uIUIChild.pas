unit uIUIChild;

interface

uses
  Controls;



type
  IUIChild = interface(IInterface)
    ['{E0F2D5D4-D925-4E4E-AC75-7BA93A5C26BC}']

    //释放Frame
    procedure UIFree; stdcall;

    //获取窗体对象
    function getObject:TWinControl; stdcall;

    //获取实例ID
    function getInstanceID: Integer; stdcall;

    //布局在一个Parent上面
    procedure ExecuteLayout(pvParent:TWinControl); stdcall;

    function getInstanceName: string; stdcall;
    procedure setInstanceName(const pvValue: string); stdcall;

    property InstanceName: string read GetInstanceName write SetInstanceName;


  end;

implementation

end.
