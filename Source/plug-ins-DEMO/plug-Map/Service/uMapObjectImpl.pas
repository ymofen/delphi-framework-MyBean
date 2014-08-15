unit uMapObjectImpl;

interface

uses
  uIMapObject, uMapObject;



type
  TMapObjectImpl = class(TInterfacedObject, IMapObject)
  private
    FMap: TMapObject;
  protected

    function getObject(pvKey: string): TObject; stdcall;
    procedure removeObject(pvKey: string); stdcall;
    procedure setObject(pvKey: string; pvObject: TObject); stdcall;
    procedure freeAll(); stdcall;
  public
    destructor Destroy; override;
    procedure AfterConstruction; override;
  end;

implementation

destructor TMapObjectImpl.Destroy;
begin
  freeAll();
  FMap.Free;
  inherited Destroy;
end;

procedure TMapObjectImpl.freeAll;
var
  i:Integer;
begin
  for i := FMap.count-1 downto 0 do
  begin
    try
      TObject(FMap.Values[i]).Free;
    except
    end;
  end;

  FMap.clear;
end;

{ TMapObjectImpl }

procedure TMapObjectImpl.AfterConstruction;
begin
  inherited;
  FMap := TMapObject.Create;
end;

function TMapObjectImpl.getObject(pvKey: string): TObject;
begin
  Result := TObject(FMap.find(pvKey));
end;

procedure TMapObjectImpl.removeObject(pvKey: string);
begin
  FMap.remove(pvKey);

end;

procedure TMapObjectImpl.setObject(pvKey: string; pvObject: TObject);
begin
  FMap.put(pvKey, pvObject);
end;

end.
