unit mybean.core.keyInterface;
////
//// 添加Delete函数
///    2014年1月20日 14:07:30
//// 添加remove函数
////   2014年1月17日 17:21:26


interface

uses
  Classes, SysUtils, Windows;

type
  TKeyStr = string[255];
  TEntryBlock = record
    key: TKeyStr;
    intf: IInterface;
  end;

  PEntryBlock = ^TEntryBlock;
  
  TKeyInterface = class(TObject)
  private
    FList: TList;
    function findBlock(const key: TKeyStr): PEntryBlock;
    function findIndex(const key:String): Integer;
    function Getcount: Integer;
    function GetValues(Index: Integer): IInterface;
  public
    procedure clear;
    constructor Create;
    destructor Destroy; override;

    function exists(const key:string): Boolean;

    function find(const key:string): IInterface;

    procedure remove(const key:string);

    procedure Delete(pvIndex:Integer);

    procedure put(const key: string; const intf: IInterface);

    property count: Integer read Getcount;
    
    property Values[Index: Integer]: IInterface read GetValues; default;         


  end;

implementation

procedure TKeyInterface.clear;
var
  lvBlock:PEntryBlock;
begin
  while FList.Count > 0 do
  begin
    lvBlock := PEntryBlock(FList[0]);
    try
      lvBlock.intf := nil;
    except
      //屏蔽掉释放错误
    end;
    FreeMem(lvBlock, SizeOf(TEntryBlock));
    FList.Delete(0);
  end;
end;

constructor TKeyInterface.Create;
begin
  inherited Create;
  FList := TList.Create();
end;

procedure TKeyInterface.Delete(pvIndex: Integer);
var
  lvBlock:PEntryBlock;
begin
  if (pvIndex < 0) or (pvIndex >= FList.Count) then
    raise Exception.CreateFmt('keyInterface out of bound[%d]', [pvIndex]);
    
  lvBlock := PEntryBlock(FList[pvIndex]);
  try
    lvBlock.intf := nil;
  except
  end;
  FreeMem(lvBlock, SizeOf(TEntryBlock));
  FList.Delete(pvIndex); 
end;

destructor TKeyInterface.Destroy;
begin
  if FList <> nil then
  begin
    clear;
    FList.Free;
  end;
  inherited Destroy;
end;

function TKeyInterface.exists(const key:string): Boolean;
begin
  Result := findBlock(TKeyStr(key)) <> nil;
end;

function TKeyInterface.find(const key:string): IInterface;
var
  lvBlock:PEntryBlock;
begin
  lvBlock := findBlock(TKeyStr(key));
  if lvBlock <> nil then
  begin
    Result := lvBlock.intf;
  end;
end;

function TKeyInterface.findBlock(const key: TKeyStr): PEntryBlock;
var
  i:Integer;
  lvBlock:PEntryBlock;
begin
  Result := nil;
  for i := 0 to FList.Count - 1 do
  begin
    lvBlock := PEntryBlock(FList[i]);

    if sameText(string(lvBlock.key), String(key)) then
    begin
      Result := lvBlock;
      Break;
    end;
  end;
end;

function TKeyInterface.findIndex(const key: String): Integer;
var
  i:Integer;
  lvBlock:PEntryBlock;
begin
  Result := -1;
  for i := 0 to FList.Count - 1 do
  begin
    lvBlock := PEntryBlock(FList[i]);
    if sameText(string(lvBlock.key), key) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TKeyInterface.Getcount: Integer;
begin
  Result := FList.Count;
end;

function TKeyInterface.GetValues(Index: Integer): IInterface;
var
  lvBlock:PEntryBlock;
begin
  Result := nil;
  lvBlock := PEntryBlock(FList[Index]);
  if lvBlock <> nil then
  begin
    Result := lvBlock.intf;
  end;
end;

procedure TKeyInterface.put(const key: string; const intf: IInterface);
var
  lvBlock:PEntryBlock;
  lvkey:TKeyStr;
begin
  lvkey := TKeyStr(key);
  
  lvBlock := findBlock(lvkey);
  if lvBlock <> nil then
  begin
    lvBlock.intf := intf;
  end else
  begin
    GetMem(lvBlock, SizeOf(TEntryBlock));
    ZeroMemory(lvBlock, SizeOf(TEntryBlock));
    lvBlock.key := lvkey;
    lvBlock.intf := intf;
    FList.Add(lvBlock);
  end;
end;

procedure TKeyInterface.remove(const key: string);
var
  lvBlock:PEntryBlock;
  i:Integer;
begin
  i := findIndex(key);
  if i <> -1 then
  begin
    lvBlock := PEntryBlock(FList[i]);
    lvBlock.intf := nil;
    FreeMem(lvBlock, SizeOf(TEntryBlock));
    FList.Delete(i);
  end;
end;

end.
