unit uLastErrorTools;

interface

type
  TLastErrorTools = class(TObject)
  public
    class procedure setLastErrorINfo(pvCode:Integer; pvDesc:string);
  end;


function getLastErrorCode: Integer; stdcall;
function getLastErrorDesc: PAnsiChar; stdcall;


implementation

var
  __lastErrorCode:Integer;
  __lastErrorDesc:String;

function getLastErrorCode: Integer;
begin
  Result := __lastErrorCode;
end;

function getLastErrorDesc: PAnsiChar;
begin
  Result := PAnsiChar(AnsiString(__lastErrorDesc));
end;

class procedure TLastErrorTools.setLastErrorINfo(pvCode:Integer; pvDesc:string);
begin
  __lastErrorCode := pvCode;
  __lastErrorDesc := pvDesc;
end;

end.
