unit uBaseFactoryObject;

interface

uses
  uIBeanFactory, superobject;

type
  TBaseFactoryObject = class(TObject)
  protected
    /// <summary>
    ///   bean的配置,文件中读取的有一个list配置数组
    /// </summary>
    FConfig: ISuperObject;
  protected
    FbeanFactory: IBeanFactory;
    Fnamespace: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure cleanup;virtual;

    procedure checkFinalize;virtual;
    procedure checkInitialize;virtual;
    
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

    property namespace: AnsiString read Fnamespace;
  end;

implementation

uses
  uSOTools;

constructor TBaseFactoryObject.Create;
begin
  inherited Create;
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

end.
