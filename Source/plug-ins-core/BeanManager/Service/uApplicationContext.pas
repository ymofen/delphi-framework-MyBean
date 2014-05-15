unit uApplicationContext;

interface

uses
  Classes, SysUtils, uLibFactoryObject, uIAppliationContext, Windows,
  uIBeanFactory,
  uIBeanFactoryRegister,
  uFactoryInstanceObject, uBaseFactoryObject;

type
  TApplicationContext = class(TInterfacedObject
     , IApplicationContext
     , IbeanFactoryRegister
     )
  private
    FFactoryObjectList: TStrings;
    FPlugins: TStrings;

    procedure DoRegisterPluginIDS(pvPluginIDS: String; pvFactoryObject:
        TBaseFactoryObject);
    procedure DoRegisterPlugins(pvPlugins: TStrings; pvFactoryObject:
        TBaseFactoryObject);
  protected
    //直接加载模块文件
    procedure ExecuteLoadLibrary; stdcall;

    function checkCreateLibObject(pvFileName:string): TLibFactoryObject;

  private
    FLibCachePath:String;
    FRootPath:String;
    /// <summary>
    ///   从单个配置文件中配置插件
    /// </summary>
    procedure executeLoadFromConfigFile(pvFileName: String; pvLoadLib: Boolean);

    procedure executeLoadFromConfigFiles(pvFiles: TStrings; pvLoadLib: Boolean);

    procedure checkReady;

    /// <summary>
    ///   关联Bean和Lib对象
    /// </summary>
    procedure checkRegisterBean(pvBeanID: string; pvFactoryObject:
        TBaseFactoryObject);


    /// <summary>
    ///   从配置文件中加载
    /// </summary>
    procedure checkInitializeFromConfigFiles(pvLoadLib: Boolean);

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

  protected
    /// <summary>
    ///   直接注册Bean工厂插件
    /// </summary>
    function registerBeanFactory(const pvFactory: IBeanFactory; const pvNameSapce:PAnsiChar):Integer;stdcall;

  public


    class function instance: TApplicationContext;

  end;

function appPluginContext: IApplicationContext; stdcall;
procedure appContextCleanup; stdcall;
function registerFactoryObject(const pvBeanFactory:IBeanFactory; const
    pvNameSapce:PAnsiChar): Integer; stdcall;



implementation

uses
  FileLogger, superobject, uSOTools;

var
  __instance:TApplicationContext;
  __instanceIntf:IInterface;

exports
   appPluginContext, appContextCleanup, registerFactoryObject;

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
    checkInitializeFromConfigFiles(pvLoadLib);
  end;
end;

procedure TApplicationContext.checkReady;
begin
  FRootPath := ExtractFilePath(ParamStr(0));
  FLibCachePath := FRootPath + 'plug-ins-cache\';
  ForceDirectories(FLibCachePath);

end;

procedure TApplicationContext.checkRegisterBean(pvBeanID: string;
    pvFactoryObject: TBaseFactoryObject);
var
  j:Integer;
  lvID:String;
  lvLibObject:TBaseFactoryObject;
begin
  lvID := trim(pvBeanID);
  if (lvID <> '') then
  begin
    j := FPlugins.IndexOf(lvID);
    if j <> -1 then
    begin
      lvLibObject := TBaseFactoryObject(FPlugins.Objects[j]);
      TFileLogger.instance.logMessage(Format('在注册插件[%s]时发现重复,已经在[%s]进行了注册',
         [lvID,lvLibObject.namespace]));
    end else
    begin
      FPlugins.AddObject(lvID, pvFactoryObject);
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
begin
  FPlugins.Clear;
  while FFactoryObjectList.Count > 0 do
  begin
    lvLibObject := TBaseFactoryObject(FFactoryObjectList.Objects[0]);
    lvLibObject.cleanup;
    lvLibObject.Free;
    FFactoryObjectList.Delete(0);
  end;
end;

constructor TApplicationContext.Create;
begin
  inherited Create;
  FFactoryObjectList := TStringList.Create();
  FPlugins := TStringList.Create;
end;

destructor TApplicationContext.Destroy;
begin
  checkFinalize;
  FPlugins.Free;
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
  j := FPlugins.IndexOf(String(lvBeanID));
  if j <> -1 then
  begin
    lvLibObject := TBaseFactoryObject(FPlugins.Objects[j]);
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
      j := FPlugins.IndexOf(lvID);
      if j <> -1 then
      begin
        lvLibObject := TBaseFactoryObject(FPlugins.Objects[j]);
        TFileLogger.instance.logMessage(Format('在注册插件[%s]时发现重复,已经在[%s]进行了注册',
           [lvID,lvLibObject.namespace]));
      end else
      begin
        FPlugins.AddObject(lvID, pvFactoryObject);
      end;
    end;
  end;
end;

procedure TApplicationContext.checkInitializeFromConfigFiles(pvLoadLib:
    Boolean);
var
  lvStrings: TStrings;
begin
  lvStrings := TStringList.Create;
  try
    GetFileNameList(lvStrings, FRootPath + '*.plug-ins');
    executeLoadFromConfigFiles(lvStrings, pvLoadLib);

    lvStrings.Clear;
    GetFileNameList(lvStrings, FRootPath + 'plug-ins\*.plug-ins');
    executeLoadFromConfigFiles(lvStrings, pvLoadLib);
  finally
    lvStrings.Free;
  end;
end;

procedure TApplicationContext.executeLoadFromConfigFile(pvFileName: String;
    pvLoadLib: Boolean);
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
          if pvLoadLib then
          begin
            lvLibObj.checkInitialize;
          end;

          lvID := lvItem.S['beanID'];
          if lvID = '' then lvID := lvItem.S['id'];

          //将配置放到对应的节点管理中
          lvLibObj.configBean(lvID, lvItem);

          checkRegisterBean(lvID, lvLibObj);
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

procedure TApplicationContext.executeLoadFromConfigFiles(pvFiles: TStrings;
    pvLoadLib: Boolean);
var
  i:Integer;
  lvFile:String;
begin
  for i := 0 to pvFiles.Count - 1 do
  begin
    lvFile := pvFiles[i];
    executeLoadFromConfigFile(lvFile, pvLoadLib);
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
