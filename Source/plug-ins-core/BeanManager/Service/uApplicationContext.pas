unit uApplicationContext;

interface

uses
  Classes, SysUtils, uLibFactoryObject, uIAppliationContext, Windows,
  uIBeanFactory,
  uIBeanFactoryRegister,
  uFactoryInstanceObject, uBaseFactoryObject,
  uKeyInterface, uKeyMapImpl, uIKeyMap;

type
  TApplicationContext = class(TInterfacedObject
     , IApplicationContext
     , IbeanFactoryRegister
     )
  private
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
  protected
    //直接加载模块文件
    procedure ExecuteLoadLibrary; stdcall;

    /// <summary>
    ///   根据提供的Lib文件得到TLibFactoryObject对象，如果不列表中不存在则新增一个对象
    /// </summary>
    function checkCreateLibObject(pvFileName:string): TLibFactoryObject;

  private
    FLibCachePath:String;
    FRootPath:String;

    /// <summary>
    ///   从单个配置文件中配置插件
    /// </summary>
    procedure executeLoadFromConfigFile(pvFileName: String);

    /// <summary>
    ///   从多个配置文件中读取配置插件
    /// </summary>
    procedure executeLoadFromConfigFiles(pvFiles: TStrings);

    procedure checkReady;

    /// <summary>
    ///   关联Bean和Lib对象(往FBeanMapList中注册关系)
    /// </summary>
    function checkRegisterBean(pvBeanID: string; pvFactoryObject:
        TBaseFactoryObject): Boolean;


    /// <summary>
    ///   从配置文件中加载
    /// </summary>
    procedure checkInitializeFromConfigFiles;


    /// <summary>
    ///   初始化工厂对象
    /// </summary>
    procedure checkInitializeFactoryObjects;

  public
    constructor Create;
    procedure BeforeDestruction; override;

    destructor Destroy; override;

    /// <summary>
    ///   执行反初始化
    /// </summary>
    procedure checkFinalize; stdcall;

    /// <summary>
    ///   执行初始化
    /// </summary>
    procedure checkInitialize(pvLoadLib:Boolean); stdcall;

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


    class function instance: TApplicationContext;

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





implementation

uses
  FileLogger, superobject, uSOTools;

var
  __instance:TApplicationContext;
  __instanceIntf:IInterface;

exports
   appPluginContext, appContextCleanup, registerFactoryObject, applicationKeyMap;

function GetFileNameList(aList: TStrings; const aSearchPath: string): integer;
var
  dirinfo: TSearchRec;
  dir, lCurrentDir: string;
begin
  result := 0;
  lCurrentDir := GetCurrentDir;
  SetCurrentDir(ExtractFileDir(ParamStr(0)));
  try
    dir := ExtractFilePath(ExpandFileName(aSearchPath));
    if (dir <> '') then
      dir := IncludeTrailingPathDelimiter(dir);

    if (SysUtils.FindFirst(aSearchPath, faArchive, dirinfo) = 0) then repeat
        aList.Add(dir + dirinfo.Name);
        Inc(result);
      until (FindNext(dirinfo) <> 0);
    SysUtils.FindClose(dirinfo);
  finally
    SetCurrentDir(lCurrentDir);
  end;
end;

function appPluginContext: IApplicationContext;
begin
  Result := TApplicationContext.instance;
end;

procedure appContextCleanup; stdcall;
begin
  //清理KeyMap对象
  executeKeyMapCleanup;

  if __instanceIntf = nil then exit;
  try
    try
      __instance.checkFinalize;
    except
    end;
    if __instance.RefCount > 1 then
    begin
      TFileLogger.instance.logErrMessage(Format('appPluginContext存在[%d]未释放的情况', [__instance.RefCount-1]));
    end;
    __instanceIntf := nil;
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



procedure TApplicationContext.checkInitialize(pvLoadLib:Boolean);
begin
  if FFactoryObjectList.Count = 0 then
  begin
    //ExecuteLoadLibrary;
    checkReady;
    checkInitializeFromConfigFiles();

    if pvLoadLib then
    begin
      //加载DLL文件
      checkInitializeFactoryObjects;
    end;
  end;
end;

procedure TApplicationContext.checkReady;
begin
  FRootPath := ExtractFilePath(ParamStr(0));
  FLibCachePath := FRootPath + 'plug-ins-cache\';
  ForceDirectories(FLibCachePath);

end;

function TApplicationContext.checkRegisterBean(pvBeanID: string;
    pvFactoryObject: TBaseFactoryObject): Boolean;
var
  j:Integer;
  lvID:String;
  lvLibObject:TBaseFactoryObject;
begin
  Result := false;
  lvID := trim(pvBeanID);
  if (lvID <> '') then
  begin
    j := FBeanMapList.IndexOf(lvID);
    if j <> -1 then
    begin
      lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[j]);
      TFileLogger.instance.logMessage(Format('在注册插件[%s]时发现重复,已经在[%s]进行了注册',
         [lvID,lvLibObject.namespace]));
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
    try
      lvLibObject := TBaseFactoryObject(FFactoryObjectList.Objects[i]);
      lvLibObject.cleanup;
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
end;

destructor TApplicationContext.Destroy;
begin
  checkFinalize;
  FBeanMapList.Free;
  FFactoryObjectList.Free;
  inherited Destroy;
end;

function TApplicationContext.checkCreateLibObject(pvFileName:string):
    TLibFactoryObject;
var
  lvFileName, lvCacheFile:String;
  i:Integer;
begin
  Result := nil;
  lvFileName :=ExtractFileName(pvFileName);
  if Length(lvFileName) = 0 then Exit;

  i := FFactoryObjectList.IndexOf(lvFileName);
  if i = -1 then
  begin
    lvCacheFile := FLibCachePath + lvFileName;
    if FileExists(lvCacheFile) then
      DeleteFile(PChar(lvCacheFile));

    CopyFile(PChar(pvFileName), PChar(lvCacheFile),False);


    Result := TLibFactoryObject.Create;
    Result.LibFileName := lvCacheFile;
    FFactoryObjectList.AddObject(lvFileName, Result);
  end else
  begin
    Result := TLibFactoryObject(FFactoryObjectList.Objects[i]);
  end;

end;

function TApplicationContext.getBean(pvBeanID: PAnsiChar): IInterface;
var
  j:Integer;
  lvLibObject:TBaseFactoryObject;
  lvBeanID:AnsiString;
begin
  Result := nil;
  lvBeanID := pvBeanID;
  j := FBeanMapList.IndexOf(String(lvBeanID));
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
  lvLibObject:TBaseFactoryObject;
begin
  for i := 0 to pvPlugins.Count - 1 do
  begin
    lvID := trim(pvPlugins[i]);
    if (lvID <> '') then
    begin
      j := FBeanMapList.IndexOf(lvID);
      if j <> -1 then
      begin
        lvLibObject := TBaseFactoryObject(FBeanMapList.Objects[j]);
        TFileLogger.instance.logMessage(Format('在注册插件[%s]时发现重复,已经在[%s]进行了注册',
           [lvID,lvLibObject.namespace]));
      end else
      begin
        FBeanMapList.AddObject(lvID, pvFactoryObject);
      end;
    end;
  end;
end;

procedure TApplicationContext.checkInitializeFactoryObjects;
var
  i: Integer;
  lvFactoryObject:TBaseFactoryObject;
begin
  for i := 0 to FFactoryObjectList.Count -1  do
  begin
    lvFactoryObject := TBaseFactoryObject(FFactoryObjectList.Objects[i]);
    try
      lvFactoryObject.checkInitialize;
    except
      on E:Exception do
      begin
        TFileLogger.instance.logMessage(
                      Format('加载插件文件[%s]出现异常', [lvFactoryObject.namespace]) + e.Message,
                      'pluginLoaderErr');
      end;
    end;
  end;

end;

procedure TApplicationContext.checkInitializeFromConfigFiles;
var
  lvStrings: TStrings;
begin
  lvStrings := TStringList.Create;
  try
    GetFileNameList(lvStrings, FRootPath + '*.plug-ins');
    executeLoadFromConfigFiles(lvStrings);

    lvStrings.Clear;
    GetFileNameList(lvStrings, FRootPath + 'beanConfig\*.plug-ins');
    executeLoadFromConfigFiles(lvStrings);

    lvStrings.Clear;
    GetFileNameList(lvStrings, FRootPath + 'plug-ins\*.plug-ins');
    executeLoadFromConfigFiles(lvStrings);
  finally
    lvStrings.Free;
  end;
end;

procedure TApplicationContext.executeLoadFromConfigFile(pvFileName: String);
var
  lvConfig, lvPluginList, lvItem:ISuperObject;
  I: Integer;
  lvLibFile, lvID:String;
  lvLibObj:TBaseFactoryObject;
begin
  lvConfig := TSOTools.JsnParseFromFile(pvFileName);
  if lvConfig = nil then Exit;
  if lvConfig.IsType(stArray) then lvPluginList := lvConfig
  else if lvConfig.O['list'] <> nil then lvPluginList := lvConfig.O['list']
  else if lvConfig.O['plugins'] <> nil then lvPluginList := lvConfig.O['plugins'];

  if (lvPluginList = nil) or (not lvPluginList.IsType(stArray)) then
  begin
    TFileLogger.instance.logMessage(Format('配置文件[%s]非法', [pvFileName]), 'pluginsLoader');
    Exit;
  end;

  for I := 0 to lvPluginList.AsArray.Length - 1 do
  begin
    lvItem := lvPluginList.AsArray.O[i];
    lvLibFile := FRootPath + lvItem.S['lib'];
    if not FileExists(lvLibFile) then
    begin
      TFileLogger.instance.logMessage(Format('未找到配置文件[%s]中的Lib文件[%s]', [pvFileName, lvLibFile]), 'pluginsLoader');
    end else
    begin
      lvLibObj := checkCreateLibObject(lvLibFile);
      if lvLibObj = nil then
      begin
        TFileLogger.instance.logMessage(Format('未找到Lib文件[%s]', [lvLibFile]), 'pluginsLoader');
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
        except
          on E:Exception do
          begin
            TFileLogger.instance.logMessage(
                          Format('加载插件文件[%s]出现异常:', [lvLibObj.namespace]) + e.Message,
                          'pluginLoaderErr');
          end;
        end;
      end;
    end;
  end;
end;

procedure TApplicationContext.executeLoadFromConfigFiles(pvFiles: TStrings);
var
  i:Integer;
  lvFile:String;
begin
  for i := 0 to pvFiles.Count - 1 do
  begin
    lvFile := pvFiles[i];
    executeLoadFromConfigFile(lvFile);
  end;
end;

procedure TApplicationContext.ExecuteLoadLibrary;
var
  lvStrings: TStrings;
  i: Integer;
  lvFile: string;
  lvLib:TLibFactoryObject;
  lvIsOK:Boolean;

  lvBeanIDs:array[1..4096] of AnsiChar;
begin
  lvStrings := TStringList.Create;
  try
    GetFileNameList(lvStrings, ExtractFilePath(ParamStr(0)) + 'plug-ins\*.dll');
    for i := 0 to lvStrings.Count - 1 do
    begin
      lvFile := lvStrings[i];
      lvLib := TLibFactoryObject.Create;
      lvIsOK := false;
      try
        lvLib.LibFileName := lvFile;
        if lvLib.checkLoadLibrary then
        begin
          try
            ZeroMemory(@lvBeanIDs[1], 4096);
            lvLib.beanFactory.getBeanList(@lvBeanIDs[1], 4096);
            DoRegisterPluginIDS(String(lvBeanIDs), lvLib);
            FFactoryObjectList.AddObject(ExtractFileName(lvFile), lvLib);
            lvIsOK := true;
          except
            on E:Exception do
            begin
              TFileLogger.instance.logMessage(
                            Format('加载插件文件[%s]出现异常', [lvLib.LibFileName]) + e.Message,
                            'pluginLoaderErr');
            end;
          end;
        end;
      finally
        if not lvIsOK then
        begin
          try
            lvLib.DoFreeLibrary;
            lvLib.Free;
          except
          end;
        end;
      end;
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
      lvLibObject.checkInitialize;
      Result := lvLibObject.beanFactory;
    end else
    begin
      TFileLogger.instance.logMessage(
                    Format('找不到对应的[%s]插件工厂', [lvBeanID]),
                    'pluginLoaderErr');
    end;
  except
    on E:Exception do
    begin
      TFileLogger.instance.logMessage(
                    Format('获取插件工厂[%s]出现异常', [lvBeanID]) + e.Message,
                    'pluginLoaderErr');
    end;
  end;
end;

class function TApplicationContext.instance: TApplicationContext;
begin
  Result := __instance;
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
    lvObj.setNameSpace(pvNameSapce);
    ZeroMemory(@lvBeanIDs[1], 4096);
    lvObj.beanFactory.getBeanList(@lvBeanIDs[1], 4096);
    DoRegisterPluginIDS(String(lvBeanIDs), lvObj);
    FFactoryObjectList.AddObject(pvNameSapce, lvObj);
    Result := 0;
  except
    Result := -1;
  end;
end;

initialization
  __instance := TApplicationContext.Create;
  __instanceIntf := __instance;


finalization
  appContextCleanup;


end.
