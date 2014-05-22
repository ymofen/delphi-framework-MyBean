unit uFrameVars;

interface

uses
  uIFrameCoreObject, uAppPluginContext;

type
  TFrameVars = class(TObject)
  public
    class function frameCoreObject: IFrameCoreObject;
  end;

implementation


class function TFrameVars.frameCoreObject: IFrameCoreObject;
begin
  Result := appPluginContext.getBean('frameCore') as IFrameCoreObject;
end;

end.
