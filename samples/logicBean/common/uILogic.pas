unit uILogic;

interface



type
  ISumExp = interface(IInterface)
    ['{D02C3764-1231-46EC-8C74-95DFBF2A1ED5}']
    function sum(i:Integer; j:Integer):Integer; stdcall;
  end;

implementation

end.
