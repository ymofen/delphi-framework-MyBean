unit uBeanMgr;

interface

uses
  Classes, SysUtils, uLibObject, uIAppliationContext;

type
  TApplicationContext = class(TInterfacedObject, IApplicationContext)
  private
    FLibObjectList: TList;
    FPlugins: TStrings;

    procedure DoRegisterPluginIDS(pvPluginIDS:String; pvLibObject:TLibObject);
    procedure DoRegisterPlugins(pvPlugins:TStrings; pvLibObject:TLibObject);
  protected
    //直接加载模块文件
    procedure ExecuteLoadLibrary; stdcall;

    /// <summary>
    ///   从配置文件中加载
    /// </summary>
    procedure executeLoadConfigFiles;

  public
    constructor Create;
    procedure BeforeDestruction; override;

    destructor Destroy; override;

    /// <summary>
    ///   执行反初始化
    /// </summary>
    procedure checkFinalization;

    /// <summary>
    ///   执行初始化
    /// </summary>
    procedure checkInitialize;stdcall;

    function getBean(pvBeanID: PAnsiChar): IInterface; stdcall;
    class function instance: TApplicationContext;
  end;

function appPluginContext: IApplicationContext; stdcall;
procedure appContextCleanup; stdcall;



implementation

uses
  FileLogger;

var
  __instance:TApplicationContext;
  __instanceIntf:IInterface;

exports
   appPluginContext, appContextCleanup;

function GetFileNameList(aList: TStrings; const aSearchPath: string): integer;
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
        aList.Add(dir + dirinfo.Name);
        Inc(result);
      until (FindNext(dirinfo) <> 0);
    FindClose(dirinfo);
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
      __instance.checkFinalization;
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

procedure TApplicationContext.checkInitialize;
begin
  if FLibObjectList.Count = 0 then
  begin
    ExecuteLoadLibrary;
  end;
end;

procedure TApplicationContext.BeforeDestruction;
begin
  inherited;  
end;

procedure TApplicationContext.checkFinalization;
var
  lvLibObject:TLibObject;
begin
  FPlugins.Clear;
  while FLibObjectList.Count > 0 do
  begin
    lvLibObject := TLibObject(FLibObjectList[0]);
    lvLibObject.DoFreeLibrary;
    lvLibObject.Free;
    FLibObjectList.Delete(0);
  end;
end;

constructor TApplicationContext.Create;
begin
  inherited Create;
  FLibObjectList := TList.Create();
  FPlugins := TStringList.Create;
end;

destructor TApplicationContext.Destroy;
begin
  checkFinalization;
  FPlugins.Free;
  FLibObjectList.Free;
  inherited Destroy;
end;

function TApplicationContext.getBean(pvBeanID: PAnsiChar): IInterface;
var
  j:Integer;
  lvLibObject:TLibObject;
  lvBeanID:AnsiString;
begin
  Result := nil;
  lvBeanID := pvBeanID;
  j := FPlugins.IndexOf(lvBeanID);
  if j <> -1 then
  begin
    lvLibObject := TLibObject(FPlugins.Objects[j]);
    if lvLibObject.beanFactory = nil then
    begin
      lvLibObject.DoLoadLibrary;
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

procedure TApplicationContext.executeLoadConfigFiles;
begin
  ;
end;

procedure TApplicationContext.ExecuteLoadLibrary;
var
  lvStrings: TStrings;
  i: Integer;
  lvFile: string;
  lvLib:TLibObject;
  lvIsOK:Boolean;
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
        if lvLib.DoLoadLibrary then
        begin
          try
            DoRegisterPluginIDS(lvLib.beanFactory.getBeanList, lvLib);
            FLibObjectList.Add(lvLib);
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
