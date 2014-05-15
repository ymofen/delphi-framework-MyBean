unit uBeanMgr;

interface

uses
  Classes, SysUtils, uLibObject, uIAppliationContext, Windows;

type
  TApplicationContext = class(TInterfacedObject, IApplicationContext)
  private
    FLibObjectList: TStrings;
    FPlugins: TStrings;

    procedure DoRegisterPluginIDS(pvPluginIDS:String; pvLibObject:TLibObject);
    procedure DoRegisterPlugins(pvPlugins:TStrings; pvLibObject:TLibObject);
  protected
    //直接加载模块文件
    procedure ExecuteLoadLibrary; stdcall;

    function checkCreateLibObject(pvFileName:string): TLibObject;

  private
    FLibCachePath:String;
    FRootPath:String;
    /// <summary>
    ///   从单个配置文件中配置插件
    /// </summary>
    procedure executeLoadFromConfigFile(pvFileName: String; pvLoadLib: Boolean);

    procedure executeLoadFromConfigFiles(pvFiles: TStrings; pvLoadLib: Boolean);

    procedure checkReady;

    procedure checkRegisterBean(pvBeanID:string; pvLibObj:TLibObject);


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


    class function instance: TApplicationContext;
  end;

function appPluginContext: IApplicationContext; stdcall;
procedure appContextCleanup; stdcall;



implementation

uses
  FileLogger, superobject, uSOTools;

var
  __instance:TApplicationContext;
  __instanceIntf:IInterface;

exports
   appPluginContext, appContextCleanup;

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

procedure TApplicationContext.checkInitialize(pvLoadLib:Boolean);
begin
  if FLibObjectList.Count = 0 then
  begin
    //ExecuteLoadLibrary;
    checkReady;
    checkInitializeFromConfigFiles(pvLoadLib);
  end;
end;

procedure TApplicationContext.checkReady;
begin
  FLibCachePath := ExtractFileName(ParamStr(0)) + 'plug-ins-cache\';
  ForceDirectories(FLibCachePath);
  FRootPath := ExtractFileName(ParamStr(0));
end;

procedure TApplicationContext.checkRegisterBean(pvBeanID: string;
  pvLibObj: TLibObject);
var
  j:Integer;
  lvID:String;
  lvLibObject:TLibObject;
begin
  lvID := trim(pvBeanID);
  if (lvID <> '') then
  begin
    j := FPlugins.IndexOf(lvID);
    if j <> -1 then
    begin
      lvLibObject := TLibObject(FPlugins.Objects[j]);
      TFileLogger.instance.logMessage(Format('在注册插件[%s]时发现重复,已经在[%s]进行了注册',
         [lvID,lvLibObject.LibFileName]));
    end else
    begin
      FPlugins.AddObject(lvID, pvLibObj);
    end;
  end;
end;

procedure TApplicationContext.BeforeDestruction;
begin
  inherited;  
end;

procedure TApplicationContext.checkFinalize;
var
  lvLibObject:TLibObject;
begin
  FPlugins.Clear;
  while FLibObjectList.Count > 0 do
  begin
    lvLibObject := TLibObject(FLibObjectList.Objects[0]);
    lvLibObject.DoFreeLibrary;
    lvLibObject.Free;
    FLibObjectList.Delete(0);
  end;
end;

constructor TApplicationContext.Create;
begin
  inherited Create;
  FLibObjectList := TStringList.Create();
  FPlugins := TStringList.Create;
end;

destructor TApplicationContext.Destroy;
begin
  checkFinalize;
  FPlugins.Free;
  FLibObjectList.Free;
  inherited Destroy;
end;

function TApplicationContext.checkCreateLibObject(pvFileName:string):
    TLibObject;
var
  lvFileName, lvCacheFile:String;
  i:Integer;
begin
  Result := nil;
  lvFileName :=ExtractFileName(pvFileName);
  if Length(lvFileName) = 0 then Exit;

  i := FLibObjectList.IndexOf(lvFileName);
  if i = -1 then
  begin
    lvCacheFile := FLibCachePath + lvFileName;
    if FileExists(lvCacheFile) then
      DeleteFile(PChar(lvCacheFile));

    CopyFile(PChar(pvFileName), PChar(lvCacheFile),False);


    Result := TLibObject.Create;
    Result.LibFileName := lvCacheFile;
  end else
  begin
    Result := TLibObject(FLibObjectList.Objects[i]);
  end;

end;

function TApplicationContext.getBean(pvBeanID: PAnsiChar): IInterface;
var
  j:Integer;
  lvLibObject:TLibObject;
  lvBeanID:AnsiString;
begin
  Result := nil;
  lvBeanID := pvBeanID;
  j := FPlugins.IndexOf(String(lvBeanID));
  if j <> -1 then
  begin
    lvLibObject := TLibObject(FPlugins.Objects[j]);
    if lvLibObject.beanFactory = nil then
    begin
      lvLibObject.checkLoadLibrary;
    end;

    if lvLibObject.beanFactory <> nil then
    begin
      Result := lvLibObject.beanFactory.getBean(PAnsiChar(AnsiString(pvBeanID)));
    end;
  end;
end;

procedure TApplicationContext.DoRegisterPluginIDS(pvPluginIDS: String;
  pvLibObject: TLibObject);
var
  lvStrings:TStrings;
begin
  lvStrings := TStringList.Create;
  try
    lvStrings.Text := pvPluginIDS;
    DoRegisterPlugins(lvStrings, pvLibObject);
  finally
    lvStrings.Free;
  end;               
end;

procedure TApplicationContext.DoRegisterPlugins(pvPlugins: TStrings; pvLibObject: TLibObject);
var
  i, j:Integer;
  lvID:String;
  lvLibObject:TLibObject;
begin
  for i := 0 to pvPlugins.Count - 1 do
  begin
    lvID := trim(pvPlugins[i]);
    if (lvID <> '') then
    begin
      j := FPlugins.IndexOf(lvID);
      if j <> -1 then
      begin
        lvLibObject := TLibObject(FPlugins.Objects[j]);
        TFileLogger.instance.logMessage(Format('在注册插件[%s]时发现重复,已经在[%s]进行了注册',
           [lvID,lvLibObject.LibFileName]));
      end else
      begin
        FPlugins.AddObject(lvID, pvLibObject);
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
  lvLibObj:TLibObject;
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
            lvLibObj.checkLoadLibrary;
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
                          Format('加载插件文件[%s]出现异常:', [lvLibObj.libFileName]) + e.Message,
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
  lvLib:TLibObject;
  lvIsOK:Boolean;

  lvBeanIDs:array[1..4096] of AnsiChar;
begin
  lvStrings := TStringList.Create;
  try
    GetFileNameList(lvStrings, ExtractFilePath(ParamStr(0)) + 'plug-ins\*.dll');
    for i := 0 to lvStrings.Count - 1 do
    begin
      lvFile := lvStrings[i];
      lvLib := TLibObject.Create;
      lvIsOK := false;
      try
        lvLib.LibFileName := lvFile;
        if lvLib.checkLoadLibrary then
        begin
          try
            ZeroMemory(@lvBeanIDs[1], 4096);
            lvLib.beanFactory.getBeanList(@lvBeanIDs[1], 4096);
            DoRegisterPluginIDS(String(lvBeanIDs), lvLib);
            FLibObjectList.AddObject(ExtractFileName(lvFile), lvLib);
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

initialization
  __instance := TApplicationContext.Create;
  __instanceIntf := __instance;


finalization
  appContextCleanup;


end.
