unit mybean.core.objects;

interface

type
  TMyBeanInterfacedObject = class(TInterfacedObject)
  public
    constructor Create; virtual;
  end;
  TMyBeanInterfacedObjectClass = class of TMyBeanInterfacedObject;

implementation

constructor TMyBeanInterfacedObject.Create;
begin
  inherited Create;
end;

end.
