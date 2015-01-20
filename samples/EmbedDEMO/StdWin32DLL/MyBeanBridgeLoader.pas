(*
 * 提供给非MyBean框架的DLL引用，进行初始化
 *   需要在EXE中进行MyBean的初始化(引用mybeanBridgeConsole.pas)
 *     对MyBeanBridge.dll进行注册对象
 * 该单元需要MyBeanBridge.dll
 *
*)

unit MyBeanBridgeLoader;

interface 

uses
  mybean.core.intf;

const
  LIB_FILE = 'MyBeanBridge.dll';

/// <summary>
///   获取ApplicationContext接口
/// </summary>
function GetApplicationContext: IApplicationContext; stdcall; external LIB_FILE;

/// <summary>
///   获取KeyMap接口
/// </summary>
function GetApplicationKeyMap: IKeyMap; stdcall; external LIB_FILE;


implementation


initialization
  /// 获取DLL提供的接口进行初始化
  GetApplicationContextFunc := GetApplicationContext;
  GetApplicationKeyMapFunc := GetApplicationKeyMap;

end.
