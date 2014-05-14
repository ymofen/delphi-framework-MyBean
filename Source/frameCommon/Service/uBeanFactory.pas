unit uBeanFactory;

interface

uses
  uIBeanFactory, Classes, SysUtils, SyncObjs, Windows, Forms;

type
  TBeanINfo = class(TObject)
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

  TOnInitializeProc = procedure;stdcall;
  TOnCreateInstanceProc = function(pvObject: TBeanINfo):TObject stdcall;
  TOnCreateInstanceProcEX = function(pvObject: TBeanINfo; var vBreak: Boolean):
      TObject stdcall;


  TBeanFactory = class(TInterfacedObject, IBeanFactory)
  private
    FCS: TCriticalSection;
    FInitializeProcInvoked:Boolean;
    FLastErr:AnsiString;
    FOnCreateInstanceProc: TOnCreateInstanceProc;
    FOnCreateInstanceProcEX: TOnCreateInstanceProcEX;
    FOnInitializeProc: TOnInitializeProc;
    FPlugins: TStrings;
    function createInstance(pvObject: TBeanINfo): IInterface;
    procedure lock;
    procedure unLock;
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
        = false): TBeanINfo;
    procedure RegisterMainFormBean(pvPluginID:string; pvClass: TClass);
     
    constructor Create; virtual;

    destructor Destroy; override;
    
    /// 获取所有的插件ID
    function getBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer; stdcall;

    /// 创建一个插件
    function getBean(pvPluginID: PAnsiChar): IInterface; stdcall;

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
  FileLogger;

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



procedure TBeanFactory.clear;
begin
  while FPlugins.Count > 0 do
  begin
    FPlugins.Objects[0].Free;
    FPlugins.Delete(0);
  end;
end;

constructor TBeanFactory.Create;
begin
  inherited Create;
  FPlugins := TStringList.Create;
  FCS := TCriticalSection.Create();
end;

function TBeanFactory.createInstance(pvObject: TBeanINfo): IInterface;
var
  lvResultObject:TObject;
  lvClass: TClass;
  lvBreak:Boolean;
begin
  lvResultObject := nil;
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
  FreeAndNil(FCS);
  clear;
  FPlugins.Free;
  inherited Destroy;
end;

{ TBeanFactory }

function TBeanFactory.getBean(pvPluginID: PAnsiChar): IInterface;
var
  i:Integer;
  lvObject:TBeanINfo;
  lvIDs:String;
begin
  lvIDs := String(AnsiString(pvPluginID));
  Result := nil;
  try
    if Assigned(FOnInitializeProc) and (not FInitializeProcInvoked) then
    begin
      self.lock;
      try
        if not FInitializeProcInvoked then
        begin
          FOnInitializeProc();
          FInitializeProcInvoked := true;
        end;
      finally
        self.unLock;
      end;
    end;
    i := FPlugins.IndexOf(lvIDs);
    if i = -1 then
    begin
      FLastErr := '找不到对应的插件[' + pvPluginID + ']';
      exit;
    end;

    lvObject :=TBeanINfo(FPlugins.Objects[i]);
    if lvObject.Singleton then
    begin
      lock;
      try
        if lvObject.FInstance <> nil then
        begin
          Result := lvObject.FInstance;
          exit;
        end else
        begin
          Result := createInstance(lvObject);
          lvObject.FInstance := Result;
        end;
      finally
        unLock;
      end;
    end else
    begin
      Result := createInstance(lvObject);
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

procedure TBeanFactory.lock;
begin
  FCS.Enter;
end;

procedure TBeanFactory.RegisterMainFormBean(pvPluginID:string; pvClass: TClass);
var
  lvObject:TBeanINfo;
begin
  //已经注册不再进行注册
  if FPlugins.IndexOf(pvPluginID) <> -1 then Exit;
  lvObject := TBeanINfo.Create;
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
    pvSingleton: Boolean = false): TBeanINfo;
var
  lvObject:TBeanINfo;
begin
  if FPlugins.IndexOf(pvPluginID) <> -1 then Exit;
  lvObject := TBeanINfo.Create;
  lvObject.FID := pvPluginID;
  lvObject.FPluginClass := pvClass;
  lvObject.IsMainForm := false;
  lvObject.FSingleton := pvSingleton;
  lvObject.FInstance := nil;
  FPlugins.AddObject(pvPluginID, lvObject);
  Result := lvObject;
end;

destructor TBeanINfo.Destroy;
begin
  FInstance := nil;
  inherited Destroy;
end;

initialization
  __instanceObject := TBeanFactory.Create;
  __Instance := __instanceObject;

finalization
  __instance := nil;

end.
