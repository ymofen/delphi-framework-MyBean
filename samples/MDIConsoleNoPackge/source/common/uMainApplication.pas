unit uMainApplication;

interface
uses
  Forms,
  mybean.tools.beanFactory,
  uIMainApplication;
type
  TMainApplication = class (TInterfacedObject,IMainApplication)
  private
    FMainApplication :TApplication;
  public
    function GetMainApplication :TApplication;
  end;

var
  MainApplication : TMainApplication;
implementation

{ TMainApplication }

function TMainApplication.GetMainApplication: TApplication;
begin
  Result := FMainApplication;
end;

initialization
  MainApplication:= TMainApplication.Create;
  MainApplication.FMainApplication := Application;
  TMyBeanFactoryTools.setObject('MainApplication', MainApplication);

finalization
  TMyBeanFactoryTools.removeObject('MainApplication');
  //MainApplication.FMainApplication := nil;
 // MainApplication.Free ;
 // MainApplication := nil;

end.
