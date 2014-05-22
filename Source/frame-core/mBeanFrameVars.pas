unit mBeanFrameVars;

interface

uses
  uAppPluginContext, uIAppliationContext, SysUtils;

type
  TmBeanFrameVars = class(TObject)
  public
    class function applicationContext: IApplicationContext;
    class function getBean(pvBeanID: string; pvRaiseIfNil: Boolean = true):
        IInterface;

    class procedure setObject(const pvID: AnsiString; const pvObject: IInterface);

    class function getObject(const pvID:AnsiString):IInterface;
    
    class procedure removeObject(pvID:AnsiString);
  end;

implementation

uses
  uErrorINfoTools, uIBeanFactory;


class function TmBeanFrameVars.applicationContext: IApplicationContext;
begin
  Result := appPluginContext;
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
