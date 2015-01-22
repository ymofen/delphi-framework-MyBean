(*
 * 提供给非MyBean框架使用，进行初始化
 *   对MyBeanBridge.dll中的获取地址进行桥接
*)

unit mybean.tools.bridgeConsole;

interface 

uses
  mybean.core.intf;

const
  LIB_FILE = 'MyBeanBridge.dll';

type
  LPFN_CONTEXT_GETTER = function:IApplicationContext; stdcall;
  LPFN_KEYMAP_GETTER = function:IKeyMap; stdcall;

/// <summary>
///   注册一个ApplicationiContext对象，由主控台初始化时进行设置
/// </summary>
procedure RegisterObject(pvContextGetter: LPFN_CONTEXT_GETTER; pvKeyMapGetter:
    LPFN_KEYMAP_GETTER); stdcall; external LIB_FILE;

/// <summary>
///   清理ApplicationContext对象，由主控台退出时执行，释放ApplicationContext的引用
/// </summary>
procedure UnRegisterObject; stdcall; external LIB_FILE;



implementation


function ConsoleContextGetter:IApplicationContext; stdcall;
begin
  Result := mybean.core.intf.appPluginContext;
end;

function ConsoleMapGetter:IKeyMap; stdcall;
begin
  Result := mybean.core.intf.applicationKeyMap;
end;


initialization
  RegisterObject(ConsoleContextGetter, ConsoleMapGetter);


finalization
  UnRegisterObject();

end.
