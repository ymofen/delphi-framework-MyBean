unit mBeanFrameVars;

interface

uses
  uIFrameCoreObject, uAppPluginContext, uIAppliationContext, SysUtils;

type
  TmBeanFrameVars = class(TObject)
  public
    class function frameCoreObject: IFrameCoreObject;
    class function applicationContext: IApplicationContext;
    class function getBean(pvBeanID: AnsiString; pvRaiseIfNil: Boolean = true):
        IInterface;

    class procedure setObject(const pvID: AnsiString; const pvObject: IInterface);

    class function getObject(const pvID:AnsiString):IInterface;
    
    class procedure removeObject(pvID:AnsiString);
  end;

implementation


class function TmBeanFrameVars.applicationContext: IApplicationContext;
begin
  Result := appPluginContext;
end;

class function TmBeanFrameVars.frameCoreObject: IFrameCoreObject;
begin
  Result := appPluginContext.getBean('frameCore') as IFrameCoreObject;
end;

class function TmBeanFrameVars.getBean(pvBeanID: AnsiString; pvRaiseIfNil:
    Boolean = true): IInterface;
begin
  Result := applicationContext.getBean(PAnsiChar(pvBeanID));
  if (Result = nil) and (pvRaiseIfNil) then
  begin
    raise exception.CreateFmt('»ñÈ¡²å¼þ(%s)Ê§°Ü!', [pvBeanID]);
  end;                                                                 
end;

class function TmBeanFrameVars.getObject(const pvID: AnsiString): IInterface;
begin
  Result := frameCoreObject.getObject(PAnsiChar(pvID));
end;

class procedure TmBeanFrameVars.removeObject(pvID: AnsiString);
begin
  frameCoreObject.removeObject(PAnsiChar(pvID));
end;

class procedure TmBeanFrameVars.setObject(const pvID: AnsiString; const
    pvObject: IInterface);
begin
  frameCoreObject.setObject(PAnsiChar(pvID), pvObject);
end;

end.
