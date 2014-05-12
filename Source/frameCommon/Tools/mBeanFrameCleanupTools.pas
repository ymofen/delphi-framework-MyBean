unit mBeanFrameCleanupTools;

interface

uses
  mBeanFrameVars;

type
  TmBeanFrameCleanupTools = class(TObject)
  public
    class procedure RemoveFromMainForm(pvInstanceID: Integer);
  end;

implementation


class procedure TmBeanFrameCleanupTools.RemoveFromMainForm(pvInstanceID:
    Integer);
begin
  TmBeanFrameVars.frameCoreObject.mainForm.Remove(pvInstanceID);
end;

end.
