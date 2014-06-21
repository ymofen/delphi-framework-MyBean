unit KeyStream;

interface

uses
  Classes, Contnrs;

type
  TKeyStreamItem = class;

  TKeyStream = class(TObject)
  private
    FKeys: TStrings;
    FObjectList: TObjectList;
    function GetCount: Integer;
    function getItem(pvKey:string): TKeyStreamItem;
  public
    constructor Create;
    destructor Destroy; override;

    //直接引用Item中的Stream
    function getStream(pvKey:String): TStream;
    function getItemObject(pvIndex:Integer): TKeyStreamItem;
    procedure Add(pvKey:string; pvStream:TStream; pvOwnStream:Boolean = false);
    property Count: Integer read GetCount;
    property Keys: TStrings read FKeys;

    procedure clear;
  end;

  //
  TKeyStreamItem = class(TObject)
  private
    FKey:String;
    FStream: TStream;
    FOwnStream:Boolean;
  public
    destructor Destroy; override;
    property Key: String read FKey;
    property OwnStream: Boolean read FOwnStream;
    property Stream: TStream read FStream;
  end;


implementation

constructor TKeyStream.Create;
begin
  inherited Create;
  FKeys := TStringList.Create;
  FObjectList := TObjectList.Create(true);
end;

destructor TKeyStream.Destroy;
begin
  FKeys.Free;
  FObjectList.Free;
  inherited Destroy;
end;

procedure TKeyStream.Add(pvKey:string; pvStream:TStream; pvOwnStream:Boolean =
    false);
var
  lvItem:TKeyStreamItem;
begin
  FKeys.Add(pvKey);
  lvItem := TKeyStreamItem.Create;
  lvItem.FKey := pvKey;
  lvItem.FStream := pvStream;
  lvItem.FOwnStream := pvOwnStream;
  FObjectList.Add(lvItem);
end;

procedure TKeyStream.clear;
begin
  FObjectList.Clear;
  FKeys.Clear;
end;

function TKeyStream.GetCount: Integer;
begin
  Result := FObjectList.Count;
end;

function TKeyStream.getItem(pvKey:string): TKeyStreamItem;
var
  i:Integer;
  lvItem:TKeyStreamItem;
begin
  Result := nil;
  for I := 0 to FObjectList.Count - 1 do
  begin
    lvItem := TKeyStreamItem(FObjectList.Items[i]);
    if lvItem.FKey = pvKey then
    begin
      Result := lvItem;
      Break;
    end;
  end;
end;

function TKeyStream.getItemObject(pvIndex:Integer): TKeyStreamItem;
begin
  Result := TKeyStreamItem(FObjectList[pvIndex]);
end;

function TKeyStream.getStream(pvKey:String): TStream;
var
  lvItem:TKeyStreamItem;
begin
  lvItem := getItem(pvKey);
  if lvItem <> nil then
  begin
    Result := lvItem.FStream;
  end else
  begin
    Result := nil;
  end; 
end;

destructor TKeyStreamItem.Destroy;
begin
  if FOwnStream then FStream.Free;
  inherited Destroy;
end;


end.
