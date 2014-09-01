unit ObjRecycle;
{
  对象回收管理
}

interface

uses
  Classes, Contnrs, SysUtils;

type
  TObjectRecycle = class(TObject)
  private
    FCatalogRecycle: TStrings;
    FDefaultRecycle: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(pvObject:TObject): TObject;
    procedure Clear();
  end;

implementation

procedure TObjectRecycle.Clear;
begin
  FDefaultRecycle.Clear;
end;

constructor TObjectRecycle.Create;
begin
  inherited Create;
  FCatalogRecycle := TStringList.Create;
  FDefaultRecycle := TObjectList.Create(True);
end;

destructor TObjectRecycle.Destroy;
begin
  FDefaultRecycle.Free;
  FreeAndNil(FCatalogRecycle);
  inherited Destroy;
end;

function TObjectRecycle.Add(pvObject:TObject): TObject;
begin
  FDefaultRecycle.Add(pvObject);
  Result := pvObject;
end;

end.
