unit ObjList;


interface

uses
  Classes, SysUtils, uIObjectList, uCore;

type
  TStrObjBlock = record
    Key: string[255];
    Value: TObject;
  end;

  TStrObjBlockArray = array of TStrObjBlock;

  TObjList = class(TInterfacedObject, IObjectList)
  private
    FOwnObject: Boolean;
    FList: TStrObjBlockArray;
    FCapacity: Integer;
    FCount: Integer;
    procedure CheckIndex(pvIndex: Integer);

    procedure DoFreeBlock(var vBlock: TStrObjBlock; pvFreeValueOnly: Boolean =
        false);
  protected
    function GetCount: Integer; stdcall;
    function GetValues(pvIndex: Integer): TObject; stdcall;
    function GetKeys(pvIndex: Integer): PMyChar; stdcall;
    procedure Grow; virtual;

  public
    constructor Create(pvOwnObject: Boolean = true);
    destructor Destroy; override;
  public
    //清除所有接口对象
    procedure Clear; stdcall;

    function CheckGet(pvKey: string; pvRaiseIfNil: Boolean = true): TObject;
    procedure CheckPut(pvKey: string; const pvValue: TObject; pvRaiseIfExists:
      Boolean = true);
    procedure Remove(pvKey: string);
    property Count: Integer read GetCount;
    property Keys[pvIndex: Integer]: PMyChar read GetKeys;
    property Values[pvIndex: Integer]: TObject read GetValues; default;
  end;

implementation

procedure TObjList.CheckIndex(pvIndex: Integer);
begin
  if (pvIndex < 0) or (pvIndex >= FCount) then
    raise Exception.CreateFmt('访问列表范围异常(%d)', [pvIndex]); 
end;

procedure TObjList.CheckPut(pvKey: string; const pvValue: TObject;
  pvRaiseIfExists: Boolean = true);
var
  i: Integer;
  lvProcessed: Boolean;
begin
  lvProcessed := false;

  for i := 0 to FCount - 1 do
  begin
    if SameText(FList[i].Key, pvKey) then
    begin
      if pvRaiseIfExists then
        raise Exception.CreateFmt('%s已经注册了对象', [pvKey]);

      DoFreeBlock(FList[i], true);

      FList[i].Value := pvValue;
      lvProcessed := true;
    end;
  end;

  if not lvProcessed then
  begin
    if FCount = FCapacity then Grow;
    FList[FCount].Key := pvKey;
    FList[FCount].Value := pvValue;
    Inc(FCount);
  end;

end;

procedure TObjList.Clear;
var
  i: Integer;
begin
  for i := 0 to FCount - 1 do
  begin
    DoFreeBlock(FList[i]);
  end;
  FCount := 0;
end;

constructor TObjList.Create(pvOwnObject: Boolean = true);
begin
  inherited Create;
  FOwnObject := pvOwnObject;
  FCapacity := 16;
  SetLength(FList, FCapacity);
end;

destructor TObjList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TObjList.CheckGet(pvKey: string; pvRaiseIfNil: Boolean = true):
  TObject;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FCount - 1 do
  begin
    if SameText(FList[i].Key, pvKey) then
    begin
      Result := FList[i].Value;
      Break;
    end;
  end;

  if (Result = nil) and pvRaiseIfNil then
    raise Exception.CreateFmt('获取不到该对象(%s)', [pvKey]);
end;

procedure TObjList.DoFreeBlock(var vBlock: TStrObjBlock; pvFreeValueOnly:
    Boolean = false);
begin
  if not pvFreeValueOnly then vBlock.Key := '';
  if FOwnObject then
  begin
    if vBlock.Value <> nil then
    begin
      vBlock.Value.Free;
      vBlock.Value := nil;
    end;
  end;
end;

function TObjList.GetCount: Integer;
begin
  // TODO -cMM: TObjList.GetCount default body inserted
  Result := FCount;
end;

function TObjList.GetKeys(pvIndex: Integer): PMyChar;
begin
  CheckIndex(pvIndex);
  Result := PMyChar(MyString(FList[pvIndex].Key));
end;

function TObjList.GetValues(pvIndex: Integer): TObject;
begin
  CheckIndex(pvIndex);
  Result := FList[pvIndex].Value;
end;

procedure TObjList.Grow;
var
  lvCapacity: Integer;
begin
  lvCapacity := FCapacity;
  if lvCapacity > 64 then
    lvCapacity := lvCapacity + lvCapacity div 4
  else
    lvCapacity := lvCapacity * 4;
  SetLength(FList, lvCapacity);
end;

procedure TObjList.Remove(pvKey: string);
var
  I: Integer;
begin
  if pvKey = '' then Exit;
  for I := 0 to FCount - 1 do
    if SameText(FList[i].Key, pvKey) then
    begin
      DoFreeBlock(FList[i]);

      System.Move(FList[I + 1], FList[I],
        (FCount - I) * SizeOf(TStrObjBlock));
      Dec(FCount);
      Exit;
    end;
end;

end.

