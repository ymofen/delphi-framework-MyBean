unit mBeanMainFormTools;

interface

uses
  uIMainForm;

type
  TmBeanMainFormTools = class(TObject)
  public
    class procedure removeFromMainForm(const pvInstanceID: AnsiString);
    class procedure setMainForm(const pvMainForm: IMainForm);
    class function getMainForm():IMainForm;
  end;

implementation

uses
  mBeanFrameVars;

{ TmBeanMainFormTools }

class function TmBeanMainFormTools.getMainForm: IMainForm;
begin
  Result := nil;
  Result := (TmBeanFrameVars.getObject('main') as IMainForm);
end;

class procedure TmBeanMainFormTools.removeFromMainForm(const pvInstanceID:
    AnsiString);
var
  lvMainForm:IMainForm;
begin
  try
    lvMainForm := getMainForm;
    if lvMainForm <> nil then
    begin
      lvMainForm.Remove(PAnsiChar(pvInstanceID));
    end;
  except
  end;
end;

class procedure TmBeanMainFormTools.setMainForm(const pvMainForm: IMainForm);
begin
  TmBeanFrameVars.setObject('main', pvMainForm);
end;

end.
