unit ObjectGC;

interface

uses
  superobject, SysUtils;

type
  TObjectGC = class(TObject)
  private
    FGC: ISuperObject;
    procedure clearCatalog(pvItem:ISuperObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure clear(pvCatalogID: String = ''; pvClearAllCatalog: Boolean = false);

    //添加到垃圾回收站
    function add(pvValue:TObject; pvCatalogID:String = ''): TObject; overload;

    function add(pvValue: TObject; pvCatalogID: Integer): TObject; overload;
    procedure clearObjects4CatalogID(pvCatalogID: Integer);


    function add(pvValue: TObject; pvOwner: TObject): TObject; overload;
    procedure clearObjects4Owner(pvOwner: TObject);

    class function instance: TObjectGC;
    class procedure releaseInstance;

  end;

implementation

var
  __instance:TObjectGC = nil;

constructor TObjectGC.Create;
begin
  inherited Create;
  FGC := SO();
end;

destructor TObjectGC.Destroy;
begin
  clear('', True);
  FGC := nil;
  inherited Destroy;
end;

function TObjectGC.add(pvValue:TObject; pvCatalogID:String = ''): TObject;
var
  lvCatalogID:String;
  lvItem:ISuperObject;
  lvObjectINt:Integer;
begin
  Result := pvValue;
  lvCatalogID := pvCatalogID;
  if lvCatalogID = '' then lvCatalogID := '__default';

  lvItem := FGC.O[lvCatalogID];
  if lvItem = nil then
  begin
    lvItem := SO();
    FGC.O[lvCatalogID] := lvItem;
  end;

  lvObjectINt := Integer(pvValue);
  lvItem.I[IntToStr(lvObjectINt)] := lvObjectINt;
end;

function TObjectGC.add(pvValue: TObject; pvCatalogID: Integer): TObject;
begin
  Result := add(pvValue, IntToStr(pvCatalogID));
end;

function TObjectGC.add(pvValue, pvOwner: TObject): TObject;
begin
  Result := add(pvValue, Integer(pvOwner));
end;

procedure TObjectGC.clear(pvCatalogID: String = ''; pvClearAllCatalog: Boolean
    = false);
var
  lvItem:ISuperObject;
  lvCatalogID:string;
begin
  if pvClearAllCatalog then
  begin
    for lvItem in FGC do
    begin
      clearCatalog(lvItem);
    end;
    FGC.clear();
  end else
  begin
    lvCatalogID := pvCatalogID;
    if lvCatalogID = '' then lvCatalogID := '__default';

    lvItem := FGC.O[lvCatalogID];
    if lvItem <> nil then clearCatalog(lvItem);
  end;
end;

procedure TObjectGC.clearCatalog(pvItem:ISuperObject);
var
  lvItem:TSuperAvlEntry;
begin
  for lvItem in pvItem.AsObject do
  begin
    try
      if (lvItem.Value <> nil) and (lvItem.Value.AsInteger <> 0) then
      begin
        TObject(lvItem.Value.AsInteger).Free;
      end;
    except                              
    end;
  end;

  pvItem.clear();  
end;

procedure TObjectGC.clearObjects4CatalogID(pvCatalogID: Integer);
begin
  Clear(IntToStr(pvCatalogID));
end;

procedure TObjectGC.clearObjects4Owner(pvOwner: TObject);
begin
  clearObjects4CatalogID(Integer(pvOwner));
end;

class function TObjectGC.instance: TObjectGC;
begin
  if __instance = nil then  __instance := TObjectGC.Create;
  Result := __instance;
end;

class procedure TObjectGC.releaseInstance;
begin
  if __instance <> nil then
  begin
    __instance.Free;
    __instance := nil;
  end;
end;


initialization

finalization
  TObjectGC.releaseInstance;

end.
