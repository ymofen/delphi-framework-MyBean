unit uBeanFactory;

interface

uses
  uIBeanFactory, Classes, SysUtils, SyncObjs, Windows, Forms, superobject;

type
  TPluginINfo = class(TObject)
  private
    FInstance: IInterface;
    FID: string;
    FIsMainForm: Boolean;
    FPluginClass: TClass;
    FSingleton: Boolean;
  public
    destructor Destroy; override;
    property ID: string read FID write FID;
    property IsMainForm: Boolean read FIsMainForm write FIsMainForm;
    property PluginClass: TClass read FPluginClass write FPluginClass;
    property Singleton: Boolean read FSingleton write FSingleton;
  end;

  TBeanINfo = class(TObject)
  private
    FbeanID: string;
    FInstance: IInterface;
  public
    destructor Destroy; override;
    property beanID: string read FbeanID write FbeanID;

    /// <summary>
    ///   单实例时 保存的对象
    /// </summary>
    property Instance: IInterface read FInstance write FInstance;


  end;

  TOnInitializeProc = procedure;stdcall;
  TOnCreateInstanceProc = function(pvObject: TPluginINfo):TObject stdcall;
  TOnCreateInstanceProcEX = function(pvObject: TPluginINfo; var vBreak: Boolean):
      TObject stdcall;


  TBeanFactory = class(TInterfacedObject, IBeanFactory)
  private


    /// <summary>
    ///   bean的配置
    /// </summary>
    FConfig:ISuperObject;
    FCS: TCriticalSection;
    FInitializeProcInvoked:Boolean;
    FLastErr:String;
    FOnCreateInstanceProc: TOnCreateInstanceProc;
    FOnCreateInstanceProcEX: TOnCreateInstanceProcEX;
    FOnInitializeProc: TOnInitializeProc;
    FPlugins: TStrings;
    FBeanList:TStrings;
    function createInstance(pvObject: TPluginINfo): IInterface;
    procedure lock;
    procedure unLock;

    /// <summary>
    ///   根据beanID获取配置,如果没有返回nil值
    /// </summary>
    function findBeanConfig(pvBeanID:PAnsiChar):ISuperObject;

    /// <summary>
    ///   根据beanID获取插件ID
    /// </summary>
    function getPluginID(pvBeanID:PAnsiChar):String;


    /// <summary>
    ///   bean是否单实例
    /// </summary>
    function beanIsSingleton(pvBeanID:PAnsiChar):Boolean;

  protected
    procedure clear;
  public
    /// <summary>TBeanFactory.RegisterBean
    /// </summary>
    /// <returns>
    /// 
    /// </returns>
    /// <param name="pvPluginID"> ID </param>
    /// <param name="pvClass"> 类 </param>
    /// <param name="pvSingleton"> 是否单实例  </param>
    function RegisterBean(pvPluginID: String; pvClass: TClass; pvSingleton: Boolean
        = false): TPluginINfo;
    procedure RegisterMainFormBean(pvPluginID:string; pvClass: TClass);
     
    constructor Create; virtual;

    destructor Destroy; override;
  protected
    function getBeanMapKey(pvBeanID:PAnsiChar): String;

    function checkGetBeanConfig(pvBeanID:PAnsiChar): ISuperObject;

    /// 获取所有的插件ID
    function getBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer; stdcall;

    /// 创建一个插件
    function getBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   初始化,加载DLL后执行
    /// </summary>
    procedure checkInitalize;stdcall;

    /// <summary>
    ///   卸载DLL之前执行
    /// </summary>
    procedure checkFinalize;stdcall;

    /// <summary>
    ///   配置所有bean的相关的配置,会覆盖之前的Bean配置
    ///    pvConfig是Json格式
    ///      beanID(mapKey)
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function configBeans(pvConfig:PAnsiChar):Integer; stdcall;

    /// <summary>
    ///   配置bean的相关信息
    ///     pvConfig是Json格式的参数
    ///     会覆盖之前的bean配置
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function configBean(pvBeanID, pvConfig: PAnsiChar): Integer; stdcall;

    /// <summary>
    ///   配置bean配置
    ///     pluginID,内部的插件ID
    /// </summary>
    function configBeanPluginID(pvBeanID, pvPluginID: PAnsiChar): Integer; stdcall;


    /// <summary>
    ///   配置bean配置
    ///     singleton,单实例
    /// </summary>
    function configBeanSingleton(pvBeanID: PAnsiChar; pvSingleton:Boolean): Integer; stdcall;

  protected

    property OnInitializeProc: TOnInitializeProc read FOnInitializeProc write
        FOnInitializeProc;

    property OnCreateInstanceProc: TOnCreateInstanceProc read FOnCreateInstanceProc
        write FOnCreateInstanceProc;

    property OnCreateInstanceProcEX: TOnCreateInstanceProcEX read
        FOnCreateInstanceProcEX write FOnCreateInstanceProcEX;



  end;

function getBeanFactory: IBeanFactory; stdcall;
function beanFactory: TBeanFactory;

implementation

uses
  FileLogger, uSOTools;

var
  __instanceObject:TBeanFactory;
  __Instance:IBeanFactory;

exports
  getBeanFactory;

function getBeanFactory: IBeanFactory; stdcall;
begin
  Result := __Instance;
end;

function beanFactory: TBeanFactory;
begin
  Result := __instanceObject;
end;



function TBeanFactory.beanIsSingleton(pvBeanID: PAnsiChar): Boolean;
var
  lvConfig:ISuperObject;
begin
  Result := False;
  lvConfig := findBeanConfig(pvBeanID);
  if lvConfig <> nil then
  begin
    Result := lvConfig.B['singleton'];
  end;
end;

procedure TBeanFactory.checkFinalize;
begin
  clear;
end;

function TBeanFactory.checkGetBeanConfig(pvBeanID: PAnsiChar): ISuperObject;
var
  lvMapKey:String;
begin
  lvMapKey := getBeanMapKey(pvBeanID);
  Result := FConfig.O[lvMapKey];
  if Result = nil then
  begin
    Result := SO();
    FConfig.O[lvMapKey] := Result;
  end;
end;

procedure TBeanFactory.checkInitalize;
begin
  try
    if Assigned(FOnInitializeProc) and (not FInitializeProcInvoked) then
    begin
      if not FInitializeProcInvoked then
      begin
        FOnInitializeProc();
        FInitializeProcInvoked := true;
      end;
    end;
  except
    on E:Exception do
    begin
      TFileLogger.instance.logMessage('执行初始化时出现了异常' + sLineBreak + e.Message);
    end;
  end;
end;


procedure TBeanFactory.clear;
var
  i: Integer;
begin
  for i := 0 to FPlugins.Count -1 do
  begin
    FPlugins.Objects[0].Free;
  end;
  FPlugins.Clear;


  for i := 0 to FBeanList.Count -1 do
  begin
    FBeanList.Objects[0].Free;
  end;
  FBeanList.Clear;
end;

function TBeanFactory.configBean(pvBeanID, pvConfig: PAnsiChar): Integer;
var
  lvNewConfig, lvConfig:ISuperObject;
begin
  lvNewConfig := SO(String(AnsiString(pvConfig)));
  if (lvNewConfig = nil) or (not lvNewConfig.IsType(stObject)) then
  begin
    Result := -1;
    FLastErr := 'configBean执行失败, 非法的配置' + sLineBreak + String(AnsiString(pvConfig));
  end else
  begin
    Result := 0;
    lvConfig := checkGetBeanConfig(pvBeanID);
    lvConfig.Merge(lvNewConfig);
  end;
end;

function TBeanFactory.configBeanPluginID(pvBeanID,
  pvPluginID: PAnsiChar): Integer;
var
  lvConfig:ISuperObject;
begin
  lvConfig := checkGetBeanConfig(pvBeanID);
  lvConfig.S['pluginID'] := pvPluginID;
end;

function TBeanFactory.configBeans(pvConfig: PAnsiChar): Integer;
var
  lvConfig:ISuperObject;
begin
  lvConfig := SO(pvConfig);
  if lvConfig = nil then
  begin
    Result := -1;
    FLastErr := 'configBeans执行失败, 非法的配置' + sLineBreak + StrPas(pvConfig);
  end else
  begin
    FConfig.Merge(lvConfig);
    Result := 0;
  end;
end;

function TBeanFactory.configBeanSingleton(pvBeanID: PAnsiChar;
  pvSingleton: Boolean): Integer;
var
  lvConfig:ISuperObject;
begin
  lvConfig := checkGetBeanConfig(pvBeanID);
  lvConfig.B['singleton'] := pvSingleton;
  Result := 0;
end;

constructor TBeanFactory.Create;
begin
  inherited Create;
  FConfig := SO();
  FPlugins := TStringList.Create;
  FCS := TCriticalSection.Create();
end;

function TBeanFactory.createInstance(pvObject: TPluginINfo): IInterface;
var
  lvResultObject:TObject;
  lvClass: TClass;
  lvBreak:Boolean;
begin
  lvResultObject := nil;

  ///使用事件创建接口
  if Assigned(FOnCreateInstanceProcEX) then
  begin
    lvBreak := false;
    lvResultObject := FOnCreateInstanceProcEX(pvObject, lvBreak);
    if lvResultObject <> nil then
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]未实现IInterface接口,不能进行创建bean', [pvObject.FPluginClass.ClassName]);
      Exit;
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
    if lvBreak then exit;
  end;


  ///使用事件2创建
  if Assigned(FOnCreateInstanceProc) then
  begin
    lvResultObject := FOnCreateInstanceProc(pvObject);
    if lvResultObject <> nil then
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]未实现IInterface接口,不能进行创建bean', [pvObject.FPluginClass.ClassName]);
      Exit;
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
  end;


  ///默认方式创建
  lvClass := pvObject.PluginClass;
  if (pvObject.IsMainForm) then
  begin
    Application.CreateForm(TCustomFormClass(lvClass), lvResultObject);
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]未实现IInterface接口,不能进行创建bean', [pvObject.FPluginClass.ClassName]);      
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
  end else if lvClass.InheritsFrom(TComponent) then
  begin
    lvResultObject := TComponentClass(lvClass).Create(nil);
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]未实现IInterface接口,不能进行创建bean', [pvObject.FPluginClass.ClassName]);      
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
  end else
  begin
    lvResultObject := lvClass.Create;
    try
      lvResultObject.GetInterface(IInterface, Result);
      if Result = nil then raise Exception.CreateFmt('[%s]未实现IInterface接口,不能进行创建bean', [pvObject.FPluginClass.ClassName]);
    except
      lvResultObject.Free;
      lvResultObject := nil;
      raise;
    end;
  end;
end;

destructor TBeanFactory.Destroy;
begin
  FConfig := nil;
  FreeAndNil(FCS);
  clear;
  FPlugins.Free;
  inherited Destroy;
end;

function TBeanFactory.findBeanConfig(pvBeanID: PAnsiChar): ISuperObject;
var
  lvMapKey:String;
begin
  Result := '';
  lvMapKey := getBeanMapKey(pvBeanID);
  Result := FConfig.O[lvMapKey];
end;

{ TBeanFactory }

function TBeanFactory.getBean(pvBeanID: PAnsiChar): IInterface;
var
  i:Integer;
  lvPluginINfo:TPluginINfo;
  lvPluginID:String;
begin
  lvPluginID := getPluginID(pvBeanID);
  Result := nil;
  try
    i := FPlugins.IndexOf(lvPluginID);
    if i = -1 then
    begin
      FLastErr := '找不到对应的插件[' + pvBeanID + ']';
      exit;
    end;

    lvPluginINfo :=TPluginINfo(FPlugins.Objects[i]);
    if lvPluginINfo.Singleton then
    begin
      lock;
      try
        if lvPluginINfo.FInstance <> nil then
        begin
          Result := lvPluginINfo.FInstance;
          exit;
        end else
        begin
          Result := createInstance(lvPluginINfo);
          lvPluginINfo.FInstance := Result;
        end;
      finally
        unLock;
      end;
    end else
    begin
      if beanIsSingleton(pvBeanID) then
      begin
        i := FBeanList.IndexOf(pvBeanID);
        if i = -1 then
        begin
          FLastErr := '找不到对应的插件[' + pvBeanID + ']';
          exit;
        end;
      end else
      begin
        Result := createInstance(lvPluginINfo);
      end;
    end;
  except
    on E:Exception do
    begin
      FLastErr := E.Message;
      TFileLogger.instance.logErrMessage(string(FLastErr));
    end;
  end;
end;

function TBeanFactory.getBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer;
var
  lvLen:Integer;
  lvStr:AnsiString;
begin
  lvStr := AnsiString(FPlugins.Text);
  lvLen := Length(lvStr);
  if lvLen > pvLength then lvLen := pvLength;
  
  CopyMemory(pvIDs, PAnsiChar(lvStr), lvLen);
  Result := lvLen;
end;

function TBeanFactory.getBeanMapKey(pvBeanID:PAnsiChar): String;
begin
  Result := TSOTools.makeMapKey(AnsiString(pvBeanID));
end;

function TBeanFactory.getPluginID(pvBeanID: PAnsiChar): String;
var
  lvConfig:ISuperObject;
begin
  Result := '';
  lvConfig := findBeanConfig(pvBeanID);
  if lvConfig <> nil then
  begin
    Result := Trim(lvConfig.S['pluginID']);
    if Result = '' then
    begin
      Result :=Trim(lvConfig.S['id']);
    end;
  end;

  if Result = '' then
  begin
    Result := string(AnsiString(pvBeanID));
  end;

end;

procedure TBeanFactory.lock;
begin
  FCS.Enter;
end;

procedure TBeanFactory.RegisterMainFormBean(pvPluginID:string; pvClass: TClass);
var
  lvObject:TPluginINfo;
begin
  //已经注册不再进行注册
  if FPlugins.IndexOf(pvPluginID) <> -1 then Exit;
  lvObject := TPluginINfo.Create;
  lvObject.FID := pvPluginID;
  lvObject.FPluginClass := pvClass;
  lvObject.FIsMainForm := true;
  lvObject.FInstance := nil;
  FPlugins.AddObject(pvPluginID, lvObject);    
end;

procedure TBeanFactory.unLock;
begin
  FCS.Leave;
end;

function TBeanFactory.RegisterBean(pvPluginID: String; pvClass: TClass;
    pvSingleton: Boolean = false): TPluginINfo;
var
  lvObject:TPluginINfo;
begin
  if FPlugins.IndexOf(pvPluginID) <> -1 then Exit;
  lvObject := TPluginINfo.Create;
  lvObject.FID := pvPluginID;
  lvObject.FPluginClass := pvClass;
  lvObject.IsMainForm := false;
  lvObject.FSingleton := pvSingleton;
  lvObject.FInstance := nil;
  FPlugins.AddObject(pvPluginID, lvObject);
  Result := lvObject;
end;

destructor TPluginINfo.Destroy;
begin
  try
    FInstance := nil;
  except
  end;
  inherited Destroy;
end;

destructor TBeanINfo.Destroy;
begin
  try
    FInstance := nil;
  except
  end;
  inherited Destroy;
end;

initialization
  __instanceObject := TBeanFactory.Create;
  __Instance := __instanceObject;

finalization
  __instance := nil;

end.
