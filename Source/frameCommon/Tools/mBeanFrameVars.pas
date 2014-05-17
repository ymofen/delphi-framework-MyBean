unit mBeanFrameVars;

interface

uses
  uAppPluginContext, uIAppliationContext, SysUtils, uIBeanFactory, uIFreeObject;

type
  TmBeanFrameVars = class(TObject)
  public
    /// <summary>
    ///   获取applicationContext接口
    /// </summary>
    class function applicationContext: IApplicationContext;

    /// <summary>
    ///   根据beanID获取对应的插件接口,
    ///      如果beanID对应的配置为单实例模式，相应的对象只会创建一次
    /// </summary>
    class function getBean(pvBeanID: string; pvRaiseIfNil: Boolean = true): IInterface;

    /// <summary>
    ///   释放插件
    /// </summary>
    class procedure freeBeanInterface(const pvInterface:IInterface);

    /// <summary>
    ///   存放全局的对象
    /// </summary>
    class procedure setObject(const pvID: AnsiString; const pvObject: IInterface);

    /// <summary>
    ///   设置得到全局的接口对象
    /// </summary>
    class function getObject(const pvID:AnsiString):IInterface;

    /// <summary>
    ///   移除全局的接口对象
    /// </summary>
    class procedure removeObject(pvID:AnsiString);
  end;

implementation

uses
  uErrorINfoTools;


class function TmBeanFrameVars.applicationContext: IApplicationContext;
begin
  Result := appPluginContext;
end;

class procedure TmBeanFrameVars.freeBeanInterface(
  const pvInterface: IInterface);
var
  lvFree:IFreeObject;
begin
  if pvInterface.QueryInterface(IFreeObject, lvFree) = S_OK then
  begin
    lvFree.FreeObject;
    lvFree := nil;
  end;
end;

class function TmBeanFrameVars.getBean(pvBeanID: string; pvRaiseIfNil: Boolean
    = true): IInterface;
var
  lvFactory:IBeanFactory;
begin
  lvFactory := applicationContext.getBeanFactory(PAnsiChar(AnsiString(pvBeanID))) as IBeanFactory;
  if lvFactory = nil then
  begin
    if pvRaiseIfNil then
      raise Exception.CreateFmt('找不到插件[%s]对应的工厂', [pvBeanID]);
  end else
  begin
    result := lvFactory.getBean(PAnsiChar(AnsiString(pvBeanID)));
    if (Result = nil) and (pvRaiseIfNil) then
    begin
      TErrorINfoTools.checkRaiseErrorINfo(lvFactory);
    end;
  end;
end;

class function TmBeanFrameVars.getObject(const pvID: AnsiString): IInterface;
begin
  Result := applicationKeyMap.getObject(PAnsiChar(pvID));
end;

class procedure TmBeanFrameVars.removeObject(pvID: AnsiString);
begin
  applicationKeyMap.removeObject(PAnsiChar(pvID));
end;

class procedure TmBeanFrameVars.setObject(const pvID: AnsiString; const
    pvObject: IInterface);
begin
  applicationKeyMap.setObject(PAnsiChar(pvID), pvObject);
end;

end.
