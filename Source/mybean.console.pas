(*
 *	 Unit owner: D10.天地弦
 *	   blog: http://www.cnblogs.com/dksoft
 *
 *   2014-11-14 13:59:05
 *     添加GetBeanInfos
 *
 *   v0.1.2  (2014-09-06 10:50:44)
 *     为了满足各种加载需求, 去掉自动加载方式，
 *       需要在工程开始的地方调用applicationContextInitialize进行初始化
 *
 *   v0.1.1  (2014-09-03 23:46:16)
 *     添加 IApplicationContextEx01接口
 *      可以实现手动加载DLL和配置文件
 *
 *
 *   v0.1.0(2014-08-29 13:00)
 *     修改加载方式(beanMananger.dll-改造)
 *
 *	 v0.0.1(2014-05-17)
 *     + first release
 *
 *
 *)

unit mybean.console;

{$I 'MyBean.inc'}

interface

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

uses
  Classes, SysUtils, Windows, ShLwApi,
  mybean.core.intf,
  mybean.console.loader,
  mybean.console.loader.dll,
  mybean.strConsts,
  uKeyInterface, IniFiles,

{$IFDEF CONSOLE}

{$ELSE}
  // 引用Forms单元，避免在Application和Screen对象释放之后清理该单元
  {$if CompilerVersion < 23}
    Forms,
  {$else}
    Vcl.Forms,
  {$ifend}
{$ENDIF}

  safeLogger;



type
  TApplicationContext = class(TInterfacedObject
     , IApplicationContext
     , IApplicationContextEx01
     , IApplicationContextEx2
     , IApplicationContextEx3
     , IbeanFactoryRegister
     )
  private
    FINIFile:TIniFile;

    FTraceLoadFile: Boolean;

    /// <summary>
    ///   保存FactoryObject列表,LibFile -> FactoryObject
    /// </summary>
    FFactoryObjectList: TStrings;

    /// <summary>
    ///   保存beanID和FactoryObject的对应关系
    /// </summary>
    FBeanMapList: TStrings;

    procedure DoRegisterPluginIDS(pvPluginIDS: String; pvFactoryObject:
        TBaseFactoryObject);
    procedure DoRegisterPlugins(pvPlugins: TStrings; pvFactoryObject:
        TBaseFactoryObject);

    procedure checkCreateINIFile;

    function checkInitializeFactoryObject(pvFactoryObject:TBaseFactoryObject;
        pvRaiseException:Boolean): Boolean;

    procedure removeRegistedBeans(pvLibFile:string);
  protected
    /// <summary>
    ///   卸载掉指定的插件宿主文件(dll)
    ///     在卸载之前应该释放掉由所创建的对象实例，和分配的内存空间，
    ///     否则会在退出EXE的时候，出现内存访问违规错误
    ///     卸载如果出现问题，请查看日志文件
    ///     *(谨慎使用)
    /// </summary>
    function unLoadLibraryFile(pvLibFile: PAnsiChar; pvRaiseException: Boolean =
        true): Boolean; stdcall;

    /// <summary>
    ///   判断BeanID是否存在
    /// </summary>
    function checkBeanExists(pvBeanID:PAnsiChar):Boolean; stdcall;


    /// <summary>
    ///   获取所有Bean信息
    ///   result:     返回读取到的数据长度
    ///   pvLength:   尝试读取的长度，传入的pvBeanInfo必须分配有足够的内存
    ///   pvBeanInfo: 返回读取到的数据
    ///    utf8 AnsiString
    ///    [
    ///      {"id":"beanid", "lib":"libfile"}
    ///      ...
    ///    ]
    /// </summary>
    function GetBeanInfos(pvBeanInfo:PAnsiChar; pvLength:Integer): Integer; stdcall;
  public
    /// <summary>
    ///  加载库文件
    /// </summary>
    /// <returns>
    ///    加载成功返回true, 失败返回false, 可以用raiseLastOsError获取异常
    /// </returns>
    /// <param name="pvLibFile"> (PAnsiChar) </param>
    function checkLoadLibraryFile(pvLibFile:PAnsiChar): Boolean; stdcall;

    /// <summary>
    ///    加载配置文件
    /// </summary>
    /// <returns>
    ///   加载失败返回false<文件可能不存在>
    /// </returns>
    /// <param name="pvConfigFile"> (PAnsiChar) </param>
    function checkLoadBeanConfigFile(pvConfigFile:PAnsiChar): Boolean; stdcall;
  protected

    /// <summary>
    ///    加载一个库文件, 获取其中插件，并进行注册
    /// </summary>
    procedure checkLoadALibFile(pvFile:string);

    /// <summary>
    ///   根据提供的Lib文件得到TLibFactoryObject对象，如果不列表中不存在则新增一个对象
    /// </summary>
    function checkCreateLibObject(pvFileName:string): TLibFactoryObject;


    /// <summary>
    ///   从FLibFactory中移除，加载失败时进行移除
    /// </summary>
    /// <returns>
    ///   如果移除返回true
    /// </returns>
    /// <param name="pvFileName"> 要移除的文件名(全路径) </param>
    function checkRemoveLibObjectFromList(pvFileName:String): Boolean;

  private
    /// <summary>
    ///   Copy的目的文件
    /// </summary>
    FCopyDestPath: String;


    /// <summary>
    ///   应用程序根目录
    /// </summary>
    FRootPath:String;

    /// <summary>
    ///   准备工作，读取配置文件
    /// </summary>
    procedure checkReady;

    /// <summary>
    ///   关联Bean和Lib对象(往FBeanMapList中注册关系)
    /// </summary>
    function checkRegisterBean(pvBeanID: string; pvFactoryObject:
        TBaseFactoryObject): Boolean;



    /// <summary>
    ///    确保DLL工厂都已经加载了对应的DLL
    /// </summary>
    procedure CheckInitializeFactoryObjects;

  public
    constructor Create;
    procedure BeforeDestruction; override;

    destructor Destroy; override;

    /// <summary>
    ///   执行反初始化
    /// </summary>
    procedure checkFinalize; stdcall;

    /// <summary>
    ///   初始化框架(线程不安全),
    ///     1.如果有配置文件<同名的.config.ini>则按照配置进行初始化
    ///     2.如果没有配置文件，直接加载DLL文件，读取bean注册信息
    /// </summary>
    procedure checkInitialize; stdcall;

    /// <summary>
    ///   获取根据BeanID获取一个对象
    /// </summary>
    function getBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   获取beanID对应的工厂接口
    /// </summary>
    function getBeanFactory(pvBeanID:PAnsiChar): IInterface; stdcall;

  protected
    /// <summary>
    ///   直接注册Bean工厂插件
    /// </summary>
    function registerBeanFactory(const pvFactory: IBeanFactory; const pvNameSapce:PAnsiChar):Integer;stdcall;

  public
    /// <summary>
    ///   从配置文件中加载, 返回成功处理的Bean配置数量
    ///   pvConfigFiles,配置文件通配符 *.plug-ins, *.config
    ///   对应的文件必须是json文件，如果不是则忽略
    /// </summary>
    function ExecuteLoadBeanFromConfigFiles(pvConfigFiles: string): Integer;

    /// <summary>
    ///   从单个配置文件中配置插件, 返回成功处理的Bean配置数量
    ///     会整理配置中Bean对应libFile库对象(TLibFactoryObject)
    /// </summary>
    function ExecuteLoadFromConfigFile(pvFileName: String): Integer;
    
    /// <summary>
    ///    从多个配置文件中读取配置插件, 返回成功处理的Bean配置数量
    /// </summary>
    function ExecuteLoadFromConfigFiles(pvFiles: TStrings): Integer;

    /// <summary>
    ///     直接从DLL和BPL文件中加载插件，在没有配置文件的情况下执行
    ///     plug-ins\*.DLL, plug-ins\*.BPL, *.DLL
    /// </summary>
    procedure ExecuteLoadLibrary; stdcall;

    /// <summary>
    ///   根据基础路径和相对路径获取绝对路径
    /// </summary>
    /// <returns>
    ///   返回完整路径
    /// </returns>
    /// <param name="BasePath"> (string) </param>
    /// <param name="RelativePath"> (string) </param>
    class function GetAbsolutePath(BasePath, RelativePath: string): string;


    /// <summary>
    ///    获取所有文件
    /// </summary>
    /// <returns>
    ///    返回文件数量
    /// </returns>
    /// <param name="vFileList"> 存放文件完整路径 </param>
    /// <param name="aSearchPath"> 搜索的路径, 可以包含通配符: *.config </param>
    class function GetFileNameList(vFileList: TStrings; const aSearchPath: string): integer;

    
    class function Instance: TApplicationContext;

    /// <summary>
    ///   确保路径带最后带一个"\"
    /// </summary>
    /// <returns>
    ///   路径
    /// </returns>
    /// <param name="Path"> 确保的路径 </param>
    class function PathWithBackslash(const Path: string): String;

    /// <summary>
    ///   确保路径带最后不带"\"
    /// </summary>
    /// <returns>
    ///   路径
    /// </returns>
    /// <param name="Path"> 确保的路径 </param>
    class function PathWithoutBackslash(const Path: string): string;
  end;


  TKeyMapImpl = class(TInterfacedObject, IKeyMap)
  private
    FKeyIntface:TKeyInterface;
  protected
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

  protected
    /// <summary>
    ///   判断是否存在接口
    /// </summary>
    function existsObject(const pvKey:PAnsiChar):Boolean; stdcall;

    /// <summary>
    ///   根据key值获取接口
    /// </summary>
    function getObject(const pvKey:PAnsiChar):IInterface; stdcall;

    /// <summary>
    ///  赋值接口
    /// </summary>
    procedure setObject(const pvKey:PAnsiChar; const pvIntf: IInterface); stdcall;

    /// <summary>
    ///   移除接口
    /// </summary>
    procedure removeObject(const pvKey:PAnsiChar); stdcall;

    /// <summary>
    ///   清理对象
    /// </summary>
    procedure cleanupObjects; stdcall;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;


/// <summary>
///   获取全局的appliationContext
/// </summary>
function appPluginContext: IApplicationContext; stdcall;

/// <summary>
///   应用程序清理
/// </summary>
procedure appContextCleanup; stdcall;

/// <summary>
///   注册beanFactory
/// </summary>
function registerFactoryObject(const pvBeanFactory:IBeanFactory; const
    pvNameSapce:PAnsiChar): Integer; stdcall;


procedure executeKeyMapCleanup;

/// <summary>
///   获取全局的KeyMap接口
/// </summary>
function applicationKeyMap: IKeyMap; stdcall;

/// <summary>
///   加载文件
///     ExecuteLoadLibFiles('plugin\*.dll');
/// </summary>
procedure ExecuteLoadLibFiles(const pvLibFiles: string);

/// <summary>
///   从配置文件中加载, 返回成功处理的Bean配置数量
///   可以调用多次
/// </summary>
/// <param name="pvConfigFile">
///     pvConfigFiles,配置文件通配符"*.plug-ins, *.config"
///     可以是指定多个通配符文件
///     对应的文件必须是json文件，如果不是则忽略
/// </param>
procedure ExecuteLoadBeanFromConfigFiles(const pvConfigFiles: string);


/// <summary>
///   执行初始化，如果已经初始化过，则会跳过
///     根据 ini的配置进行初始化,
///     如果没有配置文件，直接加载 *.dll和plug-ins\*.dll
/// </summary>
procedure ApplicationContextInitialize;

/// <summary>
///   应用程序退出时可以手动调用该方法，
///    可以清理全局对象，卸载DLL
/// </summary>
procedure ApplicationContextFinalize;



procedure logDebugInfo;


/// <summary>
///   产生一个Hash值
///    QDAC群-Hash函数
/// </summary>
function hashOf(const p:Pointer;l:Integer): Integer; overload;

/// <summary>
///   产生一个Hash值
/// </summary>
function hashOf(const vStrData:String): Integer; overload;




implementation

uses
  superobject, uSOTools;



var
  __instanceAppContext:TApplicationContext;
  __instanceAppContextAppContextIntf:IInterface;
  
  __instanceKeyMap:TKeyMapImpl;
  __instanceKeyMapKeyIntf:IInterface;

  __beanLogger:TSafeLogger;



function appPluginContext: IApplicationContext;
begin
  Result := TApplicationContext.instance;
end;

procedure appContextCleanup; stdcall;
begin
  //清理KeyMap对象
  executeKeyMapCleanup;

  if __instanceAppContextAppContextIntf = nil then exit;
  try
    try
      __instanceAppContext.checkFinalize;
    except
    end;
  except
  end;
end;



function applicationKeyMap: IKeyMap;
begin
  Result := __instanceKeyMap;
end;

procedure executeKeyMapCleanup;
begin
  if __instanceKeyMapKeyIntf = nil then exit;
  try
    __instanceKeyMap.cleanupObjects;
  except
  end;
end;

function registerFactoryObject(const pvBeanFactory:IBeanFactory; const
    pvNameSapce:PAnsiChar): Integer;
begin
  try
    Result := TApplicationContext.instance.registerBeanFactory(pvBeanFactory, pvNameSapce);
  except
    Result := -1;
  end;
end;

procedure logDebugInfo;
begin
  if __instanceKeyMapKeyIntf = nil then exit;
  try
    if __instanceKeyMap.RefCount > 1 then
    begin
      __beanLogger.logMessage(sDebug_applicationKeyMapUnload,
        [__instanceKeyMap.RefCount-1], 'DEBUG_');
    end;
  except
  end;

  if __instanceAppContextAppContextIntf = nil then exit;
  try
    if __instanceAppContext.RefCount > 1 then
    begin
      __beanLogger.logMessage(sDebug_applicationContextUnload,
        [__instanceAppContext.RefCount-1], 'DEBUG_');
    end;
  except
  end;
end;

function hashOf(const p:Pointer;l:Integer): Integer;
var
  ps:PInteger;
  lr:Integer;
begin
  Result:=0;
  if l>0 then
  begin
    ps:=p;
    lr:=(l and $03);//检查长度是否为4的整数倍
    l:=(l and $FFFFFFFC);//整数长度
    while l>0 do
    begin
      Result:=((Result shl 5) or (Result shr 27)) xor ps^;
      Inc(ps);
      Dec(l,4);
    end;
    if lr<>0 then
    begin
      l:=0;
      Move(ps^,l,lr);
      Result:=((Result shl 5) or (Result shr 27)) xor l;
    end;
  end;
end;

function hashOf(const vStrData:String): Integer;
var
  lvStr:AnsiString;
begin
  lvStr := AnsiString(vStrData);
  Result := hashOf(PAnsiChar(lvStr), Length(lvStr));
end;

procedure ExecuteLoadLibFiles(const pvLibFiles: string);
begin
  TApplicationContext.instance.checkLoadLibraryFile(PAnsiChar(AnsiString(pvLibFiles)));
end;

procedure ApplicationContextInitialize;
begin
  appPluginContext.checkInitialize;
end;

procedure ApplicationContextFinalize;
begin
  mybean.core.intf.appPluginContext := nil;
  mybean.core.intf.applicationKeyMap := nil;

  executeKeyMapCleanup;
  appContextCleanup;
end;

procedure ExecuteLoadBeanFromConfigFiles(const pvConfigFiles: string);
begin
  TApplicationContext.instance.ExecuteLoadBeanFromConfigFiles(pvConfigFiles);
end;



procedure TApplicationContext.checkInitialize;
var
  lvConfigFiles:String;
begin
  // 判断是否已经进行过初始化
  if FFactoryObjectList.Count = 0 then
  begin
    // 先读取bean配置文件  plug-ins\*.plug-ins, *.plug-ins
    lvConfigFiles := FINIFile.ReadString('main', 'beanConfigFiles', '');
    if lvConfigFiles <> '' then
    begin
      if FTraceLoadFile then __beanLogger.logMessage(sDebug_loadFromConfigFile, 'LOAD_TRACE_');
      if ExecuteLoadBeanFromConfigFiles(lvConfigFiles) > 0 then
      begin
        if FINIFile.ReadBool('main', 'loadOnStartup', False) then
        begin
          // 确保DLL工厂都已经加载了对应的DLL
          CheckInitializeFactoryObjects;
        end;
      end else
      begin
        if FTraceLoadFile then __beanLogger.logMessage(sDebug_NoneConfigFile, 'LOAD_TRACE_');
      end;
    end else
    begin
      // 在没有配置文件的情况下执行
      if FTraceLoadFile then __beanLogger.logMessage(sDebug_directlyLoadLibFile, 'LOAD_TRACE_');

      /// 直接从(plug-ins\*.DLL, plug-ins\*.BPL, *.DLL)路径下 加载 DLL和BPL文件中的插件
      ExecuteLoadLibrary;

      /// 加载ConfigPlugins下面的 配置文件
      ExecuteLoadBeanFromConfigFiles('ConfigPlugins\*.plug-ins');
    end;
  end;
end;

procedure TApplicationContext.checkReady;
var
  lvTempPath:String;
  l:Integer;
begin
  lvTempPath := FINIFile.ReadString('main', 'copyDest', 'plug-ins\');

  FTraceLoadFile := FINIFile.ReadBool('main','traceLoadLib', FTraceLoadFile);


  FCopyDestPath := GetAbsolutePath(FRootPath, lvTempPath);
  l := Length(FCopyDestPath);
  if l = 0 then
  begin
    FCopyDestPath := FRootPath + 'plug-ins\';
  end else
  begin
    FCopyDestPath := PathWithBackslash(FCopyDestPath);
  end;

//  try
//    ForceDirectories(FCopyDestPath);
//  except
//    on E:Exception do
//    begin
//      __beanLogger.logMessage(
//                    '创建Copy目标文件夹[%s]出现异常:%s', [FCopyDestPath, e.Message],
//                    'LOAD_ERROR_');
//    end;
//  end;

end;

function TApplicationContext.checkRegisterBean(pvBeanID: string;
    pvFactoryObject: TBaseFactoryObject): Boolean;
var
  j:Integer;
  lvID:String;
  {$IFDEF LOG_ON}
  lvLibObject:TBaseFactoryObject;
  {$ENDIF}
begin
  Result := false;
  lvID := trim(pvBeanID);
  if (lvID <> '') then
  begin
    j := FBeanMapList.IndexOf(lvID);
    if j <> -1 then
    begin
      {$IFDEF LOG_ON}
        lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[j]);
        __beanLogger.logMessage(Format(sLoadTrace_BeanID_Repeat,
           [lvID,lvLibObject.namespace]), 'LOAD_TRACE_');
      {$ENDIF}
    end else
    begin
      FBeanMapList.AddObject(lvID, pvFactoryObject);
      Result := true;
    end;
  end;
end;

procedure TApplicationContext.BeforeDestruction;
begin
  inherited;  
end;

procedure TApplicationContext.checkFinalize;
var
  lvLibObject:TBaseFactoryObject;
  i:Integer;
begin
  ///清理掉applicationKeyMap中的全局资源
  applicationKeyMap.cleanupObjects;


  ///全部执行一次Finalize;
  for i := 0 to FFactoryObjectList.Count -1 do
  begin
    lvLibObject := TBaseFactoryObject(FFactoryObjectList.Objects[i]);
    lvLibObject.checkFinalize;
  end;

  ///卸载DLL
  for i := 0 to FFactoryObjectList.Count -1 do
  begin
    lvLibObject := TBaseFactoryObject(FFactoryObjectList.Objects[i]);
    try
      lvLibObject.cleanup;
    except
      on E:Exception do
      begin
        {$IFDEF LOG_ON}
        __beanLogger.logMessage(Format(sLoadTrace_UnloadError,
             [lvLibObject.namespace, E.Message]), 'LOAD_TRACE_');
        {$ENDIF}
      end;
    end;
    try
      lvLibObject.Free;
    except
    end;
  end;
  FFactoryObjectList.Clear;
  FBeanMapList.Clear;
end;

constructor TApplicationContext.Create;
begin
  inherited Create;
  FFactoryObjectList := TStringList.Create();
  FBeanMapList := TStringList.Create;

  FRootPath := ExtractFilePath(ParamStr(0));

  checkCreateINIFile;
  checkReady;
end;

destructor TApplicationContext.Destroy;
begin
  FINIFile.Free;
  checkFinalize;
  FBeanMapList.Free;
  FFactoryObjectList.Free;
  inherited Destroy;
end;

function TApplicationContext.checkBeanExists(pvBeanID: PAnsiChar): Boolean;
var
  lvBeanID:String;
begin
  lvBeanID := String(AnsiString(pvBeanID));
  Result := FBeanMapList.IndexOf(lvBeanID)<> -1;
end;

procedure TApplicationContext.checkCreateINIFile;
var
  lvFile:String;
begin
  lvFile := ChangeFileExt(ParamStr(0), '.config.ini');
  if not FileExists(lvFile) then
     lvFile := FRootPath + 'app.config.ini';

  // 不存在配置文件
  if not FileExists(lvFile) then
  begin
    {$IFDEF LOG_ON}
      FTraceLoadFile := true;
    {$ELSE}
      FTraceLoadFile := False;
    {$ENDIF}
  end;

  FINIFile := TIniFile.Create(lvFile);
end;

function TApplicationContext.checkRemoveLibObjectFromList(pvFileName:String):
    Boolean;
var
  lvNameSpace:String;
  i:Integer;
begin
  Result := False;
  lvNameSpace :=ExtractFileName(pvFileName) + '_' + IntToStr(hashOf(pvFileName));
  if Length(lvNameSpace) = 0 then Exit; 

  i := FFactoryObjectList.IndexOf(lvNameSpace);
  if i <> -1 then
  begin
    Result := true;
    FFactoryObjectList.Delete(i);
  end;
end;

function TApplicationContext.checkCreateLibObject(pvFileName:string):
    TLibFactoryObject;
var
  lvNameSpace:String;
  i:Integer;
begin
  Result := nil;
  lvNameSpace :=ExtractFileName(pvFileName) + '_' + IntToStr(hashOf(pvFileName));
  if Length(lvNameSpace) = 0 then Exit;

  i := FFactoryObjectList.IndexOf(lvNameSpace);
  if i = -1 then
  begin
    Result := TLibFactoryObject.Create;
    Result.LibFileName := pvFileName;
    FFactoryObjectList.AddObject(lvNameSpace, Result);
  end else
  begin
    Result := TLibFactoryObject(FFactoryObjectList.Objects[i]);
  end;  
end;

function TApplicationContext.checkInitializeFactoryObject(
    pvFactoryObject:TBaseFactoryObject; pvRaiseException:Boolean): Boolean;
begin
  try
    if pvFactoryObject.beanFactory = nil then
    begin
      if FTraceLoadFile then
      begin
        __beanLogger.logMessage(
          sLoadTrace_Lib_Initalize, [String(pvFactoryObject.namespace)], 'LOAD_TRACE_');
      end;
      
      if pvRaiseException then
      begin   // 抛出异常的情况下, 直接进行初始化
        pvFactoryObject.checkInitialize;
      end else
      begin        //
        if pvFactoryObject.checkIsValidLib(False) then
        begin
          pvFactoryObject.checkInitialize;
        end else
        begin
        {$IFDEF LOG_ON}
            __beanLogger.logMessage(
                          Format(sLoadTrace_Lib_Invalidate, [String(pvFactoryObject.namespace)]),
                          'LOAD_TRACE_');
        {$ENDIF}
        end;
      end;
    end;
    Result := pvFactoryObject.beanFactory <> nil;
  except
    on E:Exception do
    begin
      Result := false;
      {$IFDEF LOG_ON}
      __beanLogger.logMessage(
                    sLoadTrace_Lib_Error,
                    [String(pvFactoryObject.namespace), e.Message],
                    'LOAD_TRACE_');
      {$ENDIF}
      if pvRaiseException then
        raise;
    end;
  end;
end;

function TApplicationContext.getBean(pvBeanID: PAnsiChar): IInterface;
var
  j:Integer;
  lvLibObject:TBaseFactoryObject;
  lvBeanID:String;
begin
  Result := nil;
  lvBeanID := string(AnsiString(pvBeanID));
  j := FBeanMapList.IndexOf(lvBeanID);
  if j <> -1 then
  begin
    lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[j]);
    Result := lvLibObject.getBean(lvBeanID);
  end;
end;

procedure TApplicationContext.DoRegisterPluginIDS(pvPluginIDS: String;
    pvFactoryObject: TBaseFactoryObject);
var
  lvStrings:TStrings;
begin
  lvStrings := TStringList.Create;
  try
    lvStrings.Text := pvPluginIDS;
    DoRegisterPlugins(lvStrings, pvFactoryObject);
  finally
    lvStrings.Free;
  end;               
end;

procedure TApplicationContext.DoRegisterPlugins(pvPlugins: TStrings;
    pvFactoryObject: TBaseFactoryObject);
var
  i, j:Integer;
  lvID:String;
  {$IFDEF LOG_ON}
  lvLibObject:TBaseFactoryObject;
  {$ENDIF}
begin
  for i := 0 to pvPlugins.Count - 1 do
  begin
    lvID := trim(pvPlugins[i]);
    if (lvID <> '') then
    begin
      j := FBeanMapList.IndexOf(lvID);
      if j <> -1 then
      begin
      {$IFDEF LOG_ON}
        lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[j]);
        __beanLogger.logMessage(Format(sLoadTrace_BeanID_Repeat,
           [lvID,lvLibObject.namespace]));
      {$ENDIF}
      end else
      begin
        FBeanMapList.AddObject(lvID, pvFactoryObject);
      end;
    end;
  end;
end;

procedure TApplicationContext.CheckInitializeFactoryObjects;
var
  i: Integer;
  lvFactoryObject:TBaseFactoryObject;
begin
  for i := 0 to FFactoryObjectList.Count -1  do
  begin
    lvFactoryObject := TBaseFactoryObject(FFactoryObjectList.Objects[i]);
    try
      if FTraceLoadFile then
        __beanLogger.logMessage(sLoadTrace_Factory_Initalize, [string(lvFactoryObject.namespace)],
           'LOAD_TRACE_');
      lvFactoryObject.checkInitialize;
    except
      on E:Exception do
      begin
        __beanLogger.logMessage(
                      sLoadTrace_Lib_Error, [lvFactoryObject.namespace,e.Message],
                      'LOAD_TRACE_');
      end;
    end;
  end;

end;

function TApplicationContext.ExecuteLoadBeanFromConfigFiles(pvConfigFiles:
    string): Integer;
var
  lvFilesList, lvStrings: TStrings;
  i: Integer;
  lvStr, lvFileName, lvPath:String;
begin
  Result := 0;
  lvStrings := TStringList.Create;
  lvFilesList := TStringList.Create;
  try
    lvFilesList.Text := StringReplace(pvConfigFiles, ',', sLineBreak, [rfReplaceAll]);
    for i := 0 to lvFilesList.Count - 1 do
    begin
      lvStr := lvFilesList[i];

      lvFileName := ExtractFileName(lvStr);
      lvPath := ExtractFilePath(lvStr);
      lvPath := GetAbsolutePath(FRootPath, lvPath);
      lvFileName := lvPath + lvFileName;


      lvStrings.Clear;
      GetFileNameList(lvStrings, lvFileName);
      Result := Result + ExecuteLoadFromConfigFiles(lvStrings);
    end;
  finally
    lvFilesList.Free;
    lvStrings.Free;
  end;
end;

procedure TApplicationContext.checkLoadALibFile(pvFile: string);
var
  lvFile: string;
  lvLib:TLibFactoryObject;
  lvIsOK:Boolean;
  lvBeanIDs:array[1..4096] of AnsiChar;
begin
  if pvFile = '' then exit;
  lvFile := pvFile;
  lvLib := checkCreateLibObject(lvFile);
  lvIsOK := false;
  try
    if lvLib.Tag = 1 then
    begin  //已经加载
      lvIsOK := true;
    end else
    begin
      if checkInitializeFactoryObject(TBaseFactoryObject(lvLib), False) then
      begin
        try
          ZeroMemory(@lvBeanIDs[1], 4096);
          lvLib.beanFactory.getBeanList(@lvBeanIDs[1], 4096);

          DoRegisterPluginIDS(String(AnsiString(PAnsiChar(@lvBeanIDs[1]))), TBaseFactoryObject(lvLib));
          lvIsOK := true;
          lvLib.Tag := 1;
        except
          on E:Exception do
          begin
            {$IFDEF LOG_ON}
              __beanLogger.logMessage(sLoadTrace_Lib_Error, [lvLib.LibFileName, e.Message],
                            'LOAD_TRACE_');
            {$ENDIF}
          end;
        end;
      end;
    end;

  finally
    if not lvIsOK then
    begin
      try
        checkRemoveLibObjectFromList(lvFile);
        lvLib.DoFreeLibrary;
        lvLib.Free;
      except
      end;
    end;
  end;
end;

function TApplicationContext.checkLoadBeanConfigFile(
  pvConfigFile: PAnsiChar): Boolean;
begin
  Result := ExecuteLoadBeanFromConfigFiles(String(AnsiString(pvConfigFile))) > 0;
end;

function TApplicationContext.checkLoadLibraryFile(
  pvLibFile: PAnsiChar): Boolean;
var
  lvFilesList, lvStrings: TStrings;
  i, j: Integer;
  lvStr, lvFileName, lvPath:String;
begin
  lvStrings := TStringList.Create;
  lvFilesList := TStringList.Create;
  try
    lvStr :=String(AnsiString(pvLibFile));
   {$IFDEF LOG_ON}
    __beanLogger.logMessage('加载插件宿主文件[%s]', [lvStr], 'LOAD_TRACE_');
   {$ENDIF}
    lvFilesList.Text := StringReplace(lvStr, ',', sLineBreak, [rfReplaceAll]);
    for i := 0 to lvFilesList.Count - 1 do
    begin
      lvStr := lvFilesList[i];

      lvFileName := ExtractFileName(lvStr);
      lvPath := ExtractFilePath(lvStr);
      lvPath := GetAbsolutePath(FRootPath, lvPath);
      lvFileName := lvPath + lvFileName;

      lvStrings.Clear;
      GetFileNameList(lvStrings, lvFileName);

      for j := 0 to lvStrings.Count -1 do
      begin
        checkLoadALibFile(trim(lvStrings[j]));

      end;

    end;

    Result := true;

  finally
    lvFilesList.Free;
    lvStrings.Free;
  end;
end;



function TApplicationContext.ExecuteLoadFromConfigFile(pvFileName: String):
    Integer;
var
  lvConfig, lvPluginList, lvItem:ISuperObject;
  I: Integer;
  lvLibFile, lvID:String;
  lvLibObj:TBaseFactoryObject;
  lvBasePath:String;
begin
  Result := 0;
  lvConfig := TSOTools.JsnParseFromFile(pvFileName);
  if lvConfig = nil then Exit;
  if lvConfig.IsType(stArray) then lvPluginList := lvConfig
  else if lvConfig.O['list'] <> nil then lvPluginList := lvConfig.O['list']
  else if lvConfig.O['plugins'] <> nil then lvPluginList := lvConfig.O['plugins'];

  // 获取配置文件的路径
  lvBasePath := ExtractFilePath(pvFileName);

  if (lvPluginList = nil) or (not lvPluginList.IsType(stArray)) then
  begin
    {$IFDEF LOG_ON}
    __beanLogger.logMessage(Format('配置文件[%s]非法', [pvFileName]), 'LOAD_TRACE_');
    {$ENDIF}
    Exit;
  end;

  for I := 0 to lvPluginList.AsArray.Length - 1 do
  begin
    lvItem := lvPluginList.AsArray.O[i];
    lvLibFile := lvItem.S['lib'];
    if Pos('%root%', lvLibFile) > 0 then
    begin
      lvLibFile := StringReplace(lvLibFile, '%root%', FRootPath, [rfIgnoreCase]);
    end else
    begin  // 相对于配置文件的相对路径
      lvLibFile := GetAbsolutePath(lvBasePath, lvLibFile);
    end;
    // lvLibFile := FRootPath + lvItem.S['lib'];
    if not FileExists(lvLibFile) then
    begin
     {$IFDEF LOG_ON}
      __beanLogger.logMessage(Format('未找到配置文件[%s]中的Lib文件[%s]', [pvFileName, lvLibFile]),
         'LOAD_TRACE_');
     {$ENDIF}
    end else
    begin
      lvLibObj := TBaseFactoryObject(checkCreateLibObject(lvLibFile));
      if lvLibObj = nil then
      begin
        {$IFDEF LOG_ON}
        __beanLogger.logMessage(Format('未找到Lib文件[%s]', [lvLibFile]), 'LOAD_TRACE_');
        {$ENDIF}
      end else
      begin
        try

          lvID := lvItem.S['id'];

          if lvID = '' then
          begin
            raise Exception.Create('非法的插件配置,没有指定beanID:' + sLineBreak + lvItem.AsJSon(true, false));
          end;


          if checkRegisterBean(lvID, lvLibObj) then
          begin
            //将配置放到对应的节点管理中
            lvLibObj.addBeanConfig(lvItem);
          end;

          Inc(result);
        except
          on E:Exception do
          begin
            {$IFDEF LOG_ON}
            __beanLogger.logMessage(
                      sLoadTrace_Lib_Error,
                      [String(lvLibObj.namespace), e.Message],
                          'LOAD_TRACE_');
            {$ENDIF}
          end;
        end;
      end;
    end;
  end;
end;

function TApplicationContext.ExecuteLoadFromConfigFiles(pvFiles: TStrings):
    Integer;
var
  i:Integer;
  lvFile:String;
begin
  Result := 0;
  for i := 0 to pvFiles.Count - 1 do
  begin
    lvFile := pvFiles[i];
    Result := Result +  ExecuteLoadFromConfigFile(lvFile);
  end;
end;

procedure TApplicationContext.ExecuteLoadLibrary;
var
  lvStrings: TStrings;
  i: Integer;
  lvFile: string;
begin
  lvStrings := TStringList.Create;
  try
    GetFileNameList(lvStrings, ExtractFilePath(ParamStr(0)) + 'plug-ins\*.dll');
    GetFileNameList(lvStrings, ExtractFilePath(ParamStr(0)) + 'plug-ins\*.bpl');
    GetFileNameList(lvStrings, ExtractFilePath(ParamStr(0)) + '*.dll');
    for i := 0 to lvStrings.Count - 1 do
    begin
      lvFile := lvStrings[i];
      checkLoadALibFile(lvFile);
    end;
  finally
    lvStrings.Free;
  end;
end;

function TApplicationContext.getBeanFactory(pvBeanID:PAnsiChar): IInterface;
var
  j:Integer;
  lvLibObject:TBaseFactoryObject;
  lvBeanID:AnsiString;
begin
  Result := nil;
  lvBeanID := pvBeanID;
  try
    j := FBeanMapList.IndexOf(String(lvBeanID));
    if j <> -1 then
    begin
      lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[j]);
      if lvLibObject.beanFactory = nil then
      begin
        if FTraceLoadFile then
          __beanLogger.logMessage(sLoadTrace_Factory_Init_BEGIN, [lvLibObject.namespace],
             'LOAD_TRACE_');
        lvLibObject.checkInitialize;
        if FTraceLoadFile then
          __beanLogger.logMessage(sLoadTrace_Factory_Init_END, [lvLibObject.namespace],
            'LOAD_TRACE_');
      end;
      Result := lvLibObject.beanFactory;
    end else
    begin
      {$IFDEF LOG_ON}
      __beanLogger.logMessage(
                    Format('找不到对应的[%s]插件工厂', [lvBeanID]),
                    'LOAD_TRACE_');
      {$ENDIF}
    end;
  except
    on E:Exception do
    begin
      __beanLogger.logMessage(
                    Format('获取插件工厂[%s]出现异常', [lvBeanID]) + e.Message,
                    'LOAD_TRACE_');
    end;
  end;
end;



class function TApplicationContext.Instance: TApplicationContext;
begin
  Result := __instanceAppContext;
end;

class function TApplicationContext.GetAbsolutePath(BasePath, RelativePath:
    string): string;
var
  Dest: array[0..MAX_PATH] of Char;
begin
  FillChar(Dest, SizeOf(Dest), 0);
  PathCombine(Dest, PChar(BasePath), PChar(RelativePath));
  Result := string(Dest);
end;

function TApplicationContext.GetBeanInfos(pvBeanInfo:PAnsiChar;
    pvLength:Integer): Integer;
var
  i:Integer;
  lvLibObject:TBaseFactoryObject;
  lvJSon, lvItem:ISuperObject;
  s :AnsiString;
begin
  lvJSon := SO('[]');
  for i := 0 to FBeanMapList.Count - 1 do
  begin
    lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[i]);
    lvItem := SO();
    lvItem.S['id'] := FBeanMapList.Strings[i];
    if lvLibObject is TLibFactoryObject then
    begin
      lvItem.s['lib'] := TLibFactoryObject(lvLibObject).libFileName;
    end else
    begin
      lvItem.s['lib'] := lvLibObject.namespace;
    end;
    lvJSon.AsArray.Add(lvItem);
  end;
  s := UTF8Encode(lvJSon.AsJSon(True, False));
  Result := Length(s);

  if pvBeanInfo <> nil then
  begin
    if pvLength < Result then Result := pvLength;
    Move(s[1], pvBeanInfo^, Result);
  end;                             
end;

class function TApplicationContext.GetFileNameList(vFileList: TStrings; const
    aSearchPath: string): integer;
var dirinfo: TSearchRec;
  dir, lCurrentDir: string;
begin
  result := 0;
  lCurrentDir := GetCurrentDir;
  SetCurrentDir(ExtractFileDir(ParamStr(0)));
  try
    dir := ExtractFilePath(ExpandFileName(aSearchPath));
    if (dir <> '') then
      dir := IncludeTrailingPathDelimiter(dir);

    if (FindFirst(aSearchPath, faArchive, dirinfo) = 0) then repeat
        vFileList.Add(dir + dirinfo.Name);
        Inc(result);
      until (FindNext(dirinfo) <> 0);
    SysUtils.FindClose(dirinfo);
  finally
    SetCurrentDir(lCurrentDir);
  end;
end;

class function TApplicationContext.PathWithBackslash(const Path: string):
    String;
var
  ilen: Integer;
begin
  Result := Path;
  ilen := Length(Result);
  if (ilen > 0) and
   {$IFDEF UNICODE}
     not CharInSet(Result[ilen], ['\', '/'])
   {$ELSE}
     not (Result[ilen] in ['\', '/'])
   {$ENDIF}
    then
    Result := Result + '\';
end;

class function TApplicationContext.PathWithoutBackslash(const Path: string):
    string;
var
  I, ilen: Integer;
begin
  Result := Path;
  ilen := Length(Result);
  for I := ilen downto 1 do
  begin
   {$IFDEF UNICODE}
     if not CharInSet(Result[I], ['\', '/', ' ', #13]) then Break;
   {$ELSE}
     if not (Result[I] in ['\', '/', ' ', #13]) then Break;
   {$ENDIF}

  end;
  if I <> ilen then
    SetLength(Result, I);
end;

function TApplicationContext.registerBeanFactory(const pvFactory: IBeanFactory;
  const pvNameSapce: PAnsiChar): Integer;
var
  lvObj:TFactoryInstanceObject;
  lvBeanIDs:array[1..4096] of AnsiChar;
begin
  lvObj := TFactoryInstanceObject.Create;
  try
    lvObj.setFactoryObject(pvFactory);
    lvObj.setNameSpace(String(AnsiString(pvNameSapce)));
    ZeroMemory(@lvBeanIDs[1], 4096);
    lvObj.beanFactory.getBeanList(@lvBeanIDs[1], 4096);
    DoRegisterPluginIDS(String(AnsiString(PAnsiChar(@lvBeanIDs[1]))), lvObj);
    FFactoryObjectList.AddObject(String(AnsiString(pvNameSapce)), lvObj);
    Result := 0;
  except
    Result := -1;
  end;
end;

procedure TApplicationContext.removeRegistedBeans(pvLibFile: string);
var
  i:Integer;
 // lvNameSpace:String;
  lvObj:TBaseFactoryObject;
begin
//  lvNameSpace :=ExtractFileName(pvLibFile) + '_' + IntToStr(hashOf(pvLibFile));
//  if Length(lvNameSpace) = 0 then Exit;
  for i := FBeanMapList.Count - 1 downto 0 do
  begin
    lvObj := TBaseFactoryObject(FBeanMapList.Objects[i]);
    if lvObj.namespace = pvLibFile  then
    begin
      FBeanMapList.Delete(i);
    end;                        
  end;
end;

function TApplicationContext.unLoadLibraryFile(pvLibFile: PAnsiChar;
    pvRaiseException: Boolean = true): Boolean;
var
  lvNameSpace:String;
  i:Integer;
  lvObj:TBaseFactoryObject;
begin
  Result := true;

  lvNameSpace :=ExtractFileName(String(AnsiString(pvLibFile))) + '_' +
    IntToStr(hashOf(String(AnsiString(pvLibFile))));
  if Length(lvNameSpace) = 0 then Exit;

  i := FFactoryObjectList.IndexOf(lvNameSpace);
  if i <> -1 then
  begin
    lvObj := TBaseFactoryObject(FFactoryObjectList.Objects[i]);
    try
      FFactoryObjectList.Delete(i);
      removeRegistedBeans(String(AnsiString(pvLibFile)));

      lvObj.checkFinalize;
      lvObj.cleanup;
      lvObj.Free;

    except
      on E:Exception do
      begin
        Result := false;
        
        {$IFDEF LOG_ON}
        __beanLogger.logMessage(
                      Format('卸载插件宿主文件时[%s]出现了异常' + sLineBreak + e.Message, [pvLibFile]),
                      'LOAD_TRACE_');
        {$ENDIF}

        if pvRaiseException then
        begin
          raise;
        end;
      end;
    end;
  end;  
end;

procedure TKeyMapImpl.AfterConstruction;
begin
  inherited;
  FKeyIntface := TKeyInterface.Create;
end;

procedure TKeyMapImpl.cleanupObjects;
begin
  FKeyIntface.clear;
end;

destructor TKeyMapImpl.Destroy;
begin
  cleanupObjects;
  FKeyIntface.Free;
  FKeyIntface := nil;
  inherited Destroy;
end;

function TKeyMapImpl.existsObject(const pvKey: PAnsiChar): Boolean;
begin
  Result := FKeyIntface.exists(string(AnsiString(pvKey)));
end;

function TKeyMapImpl.getObject(const pvKey: PAnsiChar): IInterface;
begin
  Result := FKeyIntface.find(string(AnsiString(pvKey)));
end;

procedure TKeyMapImpl.removeObject(const pvKey: PAnsiChar);
begin
  try
    FKeyIntface.remove(string(AnsiString(pvKey)));
  except
  end;
end;

procedure TKeyMapImpl.setObject(const pvKey: PAnsiChar;
  const pvIntf: IInterface);
begin
  try
    FKeyIntface.put(string(AnsiString(pvKey)), pvIntf);
  except
  end;
end;

function TKeyMapImpl._AddRef: Integer;
begin
  Result := inherited _AddRef;
end;

function TKeyMapImpl._Release: Integer;
begin
  Result := inherited _Release;
end;

initialization
  __beanLogger := TSafeLogger.Create;
  __beanLogger.setAppender(TLogFileAppender.Create(False));


  __instanceKeyMap := TKeyMapImpl.Create;
  __instanceKeyMapKeyIntf := __instanceKeyMap;

  __instanceAppContext := TApplicationContext.Create;
  __instanceAppContextAppContextIntf := __instanceAppContext;

  mybean.core.intf.appPluginContext := __instanceAppContext;
  mybean.core.intf.applicationKeyMap := __instanceKeyMap;

//  // 初始化
//  appPluginContext.checkInitialize;

finalization  
  ApplicationContextFinalize;

  // 记录未释放的情况
  {$IFDEF LOG_ON}
  logDebugInfo;
  {$ENDIF}

  __instanceAppContextAppContextIntf := nil;
  __instanceKeyMapKeyIntf := nil;

  __beanLogger.Free;
  __beanLogger := nil;



end.
