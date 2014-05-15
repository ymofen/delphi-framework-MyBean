unit uFactoryInstanceObject;

interface

uses
  uBaseFactoryObject, uIBeanFactory;

type
  TFactoryInstanceObject = class(TBaseFactoryObject)
  public
    procedure setFactoryObject(const intf:IBeanFactory);
    procedure setNameSpace(const pvNameSpace:AnsiString);
  end;

implementation

procedure TFactoryInstanceObject.setFactoryObject(const intf:IBeanFactory);
begin
  FbeanFactory := intf;
end;

procedure TFactoryInstanceObject.setNameSpace(const pvNameSpace: AnsiString);
begin
  Fnamespace := pvNameSpace;
end;

end.
