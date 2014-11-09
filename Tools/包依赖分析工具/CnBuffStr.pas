unit CnBuffStr;

interface

uses
  Classes, SysUtils;

type
  TStringReader = class(TObject)
  private
    FBuffer: string;
    FPosition: Integer;
  public
    constructor Create(const S: string); overload;
    constructor Create; overload;
    procedure Reset(const S: string);
    function Seek(Offset: Integer; Origin: Word): Longint;
    function EoS: Boolean;
    procedure LoadFromFile(FileName: TFileName);
    procedure LoadFromStream(Stream: TStream);
    function Peep: Char;
    function At(Position: Integer): Char;
    function Read: Char; overload;
    function Read(Count: Integer): string; overload;
    function ReadLn: string;
    function SubString(Index, Count: Integer): string;
    procedure Unread;
    property Buffer: string read FBuffer;
    property Position: Integer read FPosition;
  end;

  TStringWriter = class(TObject)
  private
    FBuffer: string;
    FPosition: Integer;
    procedure Extend(I: Integer);
    function GetBuffer: string;
  public
    constructor Create(I: Integer); overload;
    constructor Create; overload;
    procedure Reset(I: Integer);
    procedure SaveToFile(FileName: TFileName);
    procedure SaveToStream(Stream: TStream);
    procedure Unwrite;
    procedure Write(Ch : Char); overload;
    procedure Write(const S: string); overload;
    procedure WriteLn; overload;
    procedure WriteLn(const S: string); overload;
    property Buffer: string read GetBuffer;
  end;

implementation

{ TStringReader }

function TStringReader.At(Position: Integer): Char;
begin
  Result := PChar(FBuffer)[Position];
end;

constructor TStringReader.Create(const S: string);
begin
  inherited Create();
  Reset(S);
end;

constructor TStringReader.Create;
begin
  Create('');
end;

function TStringReader.EoS: Boolean;
begin
  Result := PChar(FBuffer)[FPosition] = #0;
end;

procedure TStringReader.LoadFromFile(FileName: TFileName);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TStringReader.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  S: string;
begin
  Size := Stream.Size - Stream.Position;
  SetString(S, nil, Size);
  Stream.Read(Pointer(S)^, Size);
  FBuffer := S;
  FPosition := 0;
end;

function TStringReader.Peep: Char;
begin
  Result := PChar(FBuffer)[Position];
end;

function TStringReader.Read: Char;
begin
  Result := PChar(FBuffer)[FPosition];
  if Result <> #0 then Inc(FPosition);
end;

function TStringReader.Read(Count: Integer): string;
var
  Len: Integer;
begin
  Len := Length(FBuffer) - FPosition;
  if Len > Count then Len := Count;
  SetString(Result, PChar(@FBuffer[FPosition + 1]), Len);
  Inc(FPosition, Len);
end;

function TStringReader.ReadLn: string;
var
  P: LongInt;
begin
  P := FPosition;
  while not (PChar(FBuffer)[P] in [#0, #13, #10]) do Inc(P);
  SetString(Result, PChar(@FBuffer[FPosition + 1]), P - FPosition);
  if PChar(FBuffer)[P] = #13 then Inc(P);
  if PChar(FBuffer)[P] = #10 then Inc(P);
  FPosition := P;
end;

procedure TStringReader.Reset(const S: string);
begin
  FBuffer := S;
  FPosition := 0;
end;

function TStringReader.Seek(Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent:   FPosition := FPosition + Offset;
    soFromEnd:       FPosition := Length(FBuffer) - Offset;
  end;
  if FPosition > Length(FBuffer) then
    FPosition := Length(FBuffer)
  else if FPosition < 0 then FPosition := 0;
  Result := FPosition;
end;

function TStringReader.SubString(Index, Count: Integer): string;
begin
  Result := Copy(FBuffer, Index + 1, Count);
end;

procedure TStringReader.Unread;
begin
  if FPosition > 0 then Dec(FPosition);
end;

{ TStringWriter }

constructor TStringWriter.Create(I: Integer);
begin
  inherited Create();
  Reset(I);
end;

constructor TStringWriter.Create;
begin
  Create(4000);
end;

procedure TStringWriter.Extend(I: Integer);
begin
  if I < 4096 then I := 4096
  else I := I + I shr 1;
  SetLength(FBuffer, I);
end;

function TStringWriter.GetBuffer: string;
begin
  if FPosition = Length(FBuffer) then Result := FBuffer
  else SetString(Result, PChar(@FBuffer[1]), FPosition);
end;

procedure TStringWriter.Reset(I: Integer);
begin
  SetLength(FBuffer, I);
  FPosition := 0;
end;

procedure TStringWriter.SaveToFile(FileName: TFileName);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TStringWriter.SaveToStream(Stream: TStream);
begin
  Stream.WriteBuffer(Pointer(FBuffer)^, FPosition);
end;

procedure TStringWriter.Unwrite;
begin
  if FPosition > 0 then Dec(FPosition);
end;

procedure TStringWriter.Write(const S: string);
var
  I: Integer;
begin
  I := FPosition + Length(S);
  if I > Length(FBuffer) then Extend(I);

  for I := 1 to Length(S) do
  begin
    PChar(FBuffer)[FPosition] := S[I];
    Inc(FPosition, 1);
  end;
end;

procedure TStringWriter.Write(Ch: Char);
var
  I: Integer;
begin
  I := FPosition + 1;
  if I > Length(FBuffer) then Extend(I);

  PChar(FBuffer)[FPosition] := Ch;
  Inc(FPosition);
end;

procedure TStringWriter.WriteLn;
begin
  Write(#13);
  Write(#10);
end;

procedure TStringWriter.WriteLn(const S: string);
begin
  Write(S);
  Write(#13);
  Write(#10);
end;

end.
