unit uFrameCleanupTools;

interface

type
  TFrameCleanupTools = class(TObject)
  public
    class procedure frameCoreCleanUp;
  end;

implementation

uses
  uIFrameCoreObject, uAppPluginContext;

{ TFrameCleanupTools }

class procedure TFrameCleanupTools.frameCoreCleanUp;
var
  lvFrameCoreObject:IFrameCoreObject;
begin
  lvFrameCoreObject :=(appPluginContext.getBean('frameCore') as IFrameCoreObject);
  if lvFrameCoreObject <> nil then
  begin
    lvFrameCoreObject.cleanupObjects;
  end;
end;

end.
