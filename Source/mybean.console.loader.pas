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
    /// <summary>
    ///   bean的配置,文件中读取的有一个list配置数组
    /// </summary>
    FConfig: ISuperObject;
  protected
    FbeanFactory: IBeanFactory;
    Fnamespace: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure cleanup;virtual;

    procedure checkFinalize;virtual;

    procedure checkInitialize;virtual;

    /// <summary>
    ///   检测是否是有效的插件宿主文件
    /// </summary>
    function checkIsValidLib(pvUnLoadIfSucc: Boolean = false): Boolean; virtual;

    /// <summary>
    ///   beanID和配置信息
    /// </summary>
    procedure addBeanConfig(pvBeanConfig: ISuperObject);

    /// <summary>
    ///   根据beanID获取插件
    /// </summary>
    function getBean(pvBeanID:string):IInterface; virtual;

    /// <summary>
    ///   DLL中BeanFactory接口
    /// </summary>
    property beanFactory: IBeanFactory read FBeanFactory;

    property namespace: string read Fnamespace;

    property Tag: Integer read FTag write FTag;


  end;

  /// <summary>
  ///   可以用户手动注册实例
  /// </summary>
  TFactoryInstanceObject = class(TBaseFactoryObject)
  public
    procedure setFactoryObject(const intf:IBeanFactory);
    procedure setNameSpace(const pvNameSpace: string);
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

function TBaseFactoryObject.getBean(pvBeanID: string): IInterface;
begin
  if beanFactory = nil then
  begin
    checkInitialize;
  end;

  if beanFactory <> nil then
  begin
    Result := beanFactory.getBean(PAnsiChar(AnsiString(pvBeanID)));
  end;
end;

{ TBaseFactoryObject }

procedure TBaseFactoryObject.checkFinalize;
begin
  if FbeanFactory <> nil then
  begin
    FbeanFactory.checkFinalize;
  end;
end;

procedure TBaseFactoryObject.checkInitialize;
begin

end;

procedure TBaseFactoryObject.cleanup;
begin
  FbeanFactory := nil;
end;

procedure TBaseFactoryObject.addBeanConfig(pvBeanConfig: ISuperObject);
begin
  FConfig.A['list'].Add(pvBeanConfig);
end;

function TBaseFactoryObject.checkIsValidLib(pvUnLoadIfSucc: Boolean = false):
    Boolean;
begin
  Result := False;
end;

procedure TFactoryInstanceObject.setFactoryObject(const intf:IBeanFactory);
begin
  FbeanFactory := intf;
end;

procedure TFactoryInstanceObject.setNameSpace(const pvNameSpace: string);
begin
  Fnamespace := pvNameSpace;
end;

end.
