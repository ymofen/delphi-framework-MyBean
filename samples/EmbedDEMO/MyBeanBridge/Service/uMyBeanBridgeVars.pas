unit uMyBeanBridgeVars;

interface

uses
  mybean.core.intf;


type
  LPFN_CONTEXT_GETTER = function:IApplicationContext; stdcall;
  LPFN_KEYMAP_GETTER = function:IKeyMap; stdcall;

/// <summary>
///   获取ApplicationContext接口
/// </summary>
function GetApplicationContext: IApplicationContext; stdcall;

/// <summary>
///   获取KeyMap接口
/// </summary>
function GetApplicationKeyMap: IKeyMap; stdcall;

/// <summary>
///   注册一个ApplicationiContext对象，由主控台初始化时进行设置
/// </summary>
procedure RegisterObject(pvContextGetter: LPFN_CONTEXT_GETTER; pvKeyMapGetter:
    LPFN_KEYMAP_GETTER); stdcall;

/// <summary>
///   清理ApplicationContext对象，由主控台退出时执行，释放ApplicationContext的引用
/// </summary>
procedure UnRegisterObject; stdcall;

implementation

exports
   GetApplicationContext, GetApplicationKeyMap, RegisterObject, UnRegisterObject;



var
  /// <summary>
  ///   提供一个获取appPluginContext对象的函数指针
  /// </summary>
  InnerContextGetterFunc: LPFN_CONTEXT_GETTER;

  /// <summary>
  ///   提供一个获取applicationKeyMap对象的函数指针
  /// </summary>
  InnerKeyMapGetterFunc: LPFN_KEYMAP_GETTER;


function GetApplicationContext: IApplicationContext;
begin
  Result := InnerContextGetterFunc();
end;

function GetApplicationKeyMap: IKeyMap;
begin
  Result := InnerKeyMapGetterFunc();
end;

procedure RegisterObject(pvContextGetter: LPFN_CONTEXT_GETTER; pvKeyMapGetter:
    LPFN_KEYMAP_GETTER);
begin
  InnerContextGetterFunc := pvContextGetter;
  InnerKeyMapGetterFunc := pvKeyMapGetter;
end;

procedure UnRegisterObject;
begin
  InnerContextGetterFunc := nil;
  InnerKeyMapGetterFunc := nil;
end;



end.
