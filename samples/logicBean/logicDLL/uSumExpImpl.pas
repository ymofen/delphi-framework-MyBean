unit uSumExpImpl;

interface

uses
  mybean.core.objects, uILogic;



type
  TSumExpImpl = class(TMyBeanInterfacedObject, ISumExp)
  protected
    function sum(i:Integer; j:Integer):Integer; stdcall;
  end;

implementation

{ TSumExpImpl }

function TSumExpImpl.sum(i, j: Integer): Integer;
begin
  Result := i + j;
end;

end.
