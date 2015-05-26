(*
 *	 Unit owner: D10.Mofen
 *	       blog: http://www.cnblogs.com/dksoft
 *
 *   v0.1.0(2014-08-29 13:00)
 *     修改加载方式(beanMananger.dll-改造)
 *
 *	 v0.0.1(2014-05-17)
 *     + first release
 *
 *
 *)
 
unit mybean.console.loader;

interface

uses
  mybean.core.intf, superobject, Windows, SysUtils;

type
  TBaseFactoryObject = class(TObject)
  private
    FTag: Integer;
  protected
    // Delphi的库文件
    FIsDelphiLib:Boolean;
    /// <summary>
    ///   bean的配置,文件中读取的有一个list配置数组
    /// </summary>
    FConfig: ISuperObject;
  protected
    FBeanFactory: IBeanFactory;
    FNamespace: string;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Cleanup; virtual;

    procedure CheckFinalize; virtual;

    procedure CheckInitialize; virtual;

    procedure StartService;virtual;

    /// <summary>
    ///   检测是否是有效的插件宿主文件
    /// </summary>
    function CheckIsValidLib(pvUnLoadIfSucc: Boolean = false): Boolean; virtual;

    /// <summary>
    ///   beanID和配置信息
    /// </summary>
    procedure AddBeanConfig(pvBeanConfig: ISuperObject);

    /// <summary>
    ///   根据beanID获取插件
    /// </summary>
    function GetBean(pvBeanID:string): IInterface; virtual;


    function GetBeanForCPlus(pvBeanId:string; out vInstance:IInterface): HRESULT;

    /// <summary>
    ///   DLL中BeanFactory接口
    /// </summary>
    property BeanFactory: IBeanFactory read FBeanFactory;


    property Namespace: string read FNamespace;

    property Tag: Integer read FTag write FTag;


  end;

  /// <summary>
  ///   可以用户手动注册实例
  /// </summary>
  TFactoryInstanceObject = class(TBaseFactoryObject)
  public
    procedure SetFactoryObject(const intf:IBeanFactory);
    procedure SetNameSpace(const pvNameSpace: string);
  end;

implementation

uses
  mybean.core.SOTools;

constructor TBaseFactoryObject.Create;
begin
  inherited Create;
  FTag := 0;
  FConfig := SO();
  FConfig.O['list'] := SO('[]');
end;

destructor TBaseFactoryObject.Destroy;
begin
  FConfig := nil;
  inherited Destroy;
end;

function TBaseFactoryObject.GetBean(pvBeanID:string): IInterface;
var
  lvFactoryCPlus:IBeanFactoryForCPlus;
begin
  if FBeanFactory = nil then
  begin
    CheckInitialize;

    // GetBean的时候如果FBeanFactory还没有赋值，
    //  代表库文件是按需加载的，所以需要执行一次StartService
    StartService;
  end;

  if FBeanFactory <> nil then
  begin
    if FBeanFactory.QueryInterface(IBeanFactoryForCPlus, lvFactoryCPlus) = S_OK then
    begin  // C++ 方式获取
      lvFactoryCPlus.GetBeanForCPlus(PAnsiChar(AnsiString(pvBeanID)), Result);
    end else
    begin
      Result := FBeanFactory.GetBean(PAnsiChar(AnsiString(pvBeanID)));
    end;
  end;
end;

function TBaseFactoryObject.GetBeanForCPlus(pvBeanId:string; out
    vInstance:IInterface): HRESULT;
var
  lvFactoryCPlus:IBeanFactoryForCPlus;
begin
  if FBeanFactory = nil then
  begin
    CheckInitialize;
  end;

  if FBeanFactory <> nil then
  begin
    if FBeanFactory.QueryInterface(IBeanFactoryForCPlus, lvFactoryCPlus) = S_OK then
    begin  // C++ 方式获取
      Result := lvFactoryCPlus.GetBeanForCPlus(PAnsiChar(AnsiString(pvBeanID)), vInstance);
    end else
    begin
      vInstance := FBeanFactory.GetBean(PAnsiChar(AnsiString(pvBeanID)));
      Result := S_OK;
    end;
  end else
  begin
    Result := S_FALSE;
  end;
end;

procedure TBaseFactoryObject.StartService;
begin

end;

{ TBaseFactoryObject }

procedure TBaseFactoryObject.CheckFinalize;
begin
  if FBeanFactory <> nil then
  begin
    FBeanFactory.CheckFinalize;
  end;
end;

procedure TBaseFactoryObject.CheckInitialize;
begin

end;

procedure TBaseFactoryObject.Cleanup;
begin
  FBeanFactory := nil;
end;

procedure TBaseFactoryObject.AddBeanConfig(pvBeanConfig: ISuperObject);
begin
  FConfig.A['list'].Add(pvBeanConfig);
end;

function TBaseFactoryObject.CheckIsValidLib(pvUnLoadIfSucc: Boolean = false):
    Boolean;
begin
  Result := False;
end;

procedure TFactoryInstanceObject.SetFactoryObject(const intf:IBeanFactory);
begin
  FbeanFactory := intf;
end;

procedure TFactoryInstanceObject.SetNameSpace(const pvNameSpace: string);
begin
  Fnamespace := pvNameSpace;
end;

end.
