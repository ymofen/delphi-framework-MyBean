unit uIValueGSetter;

interface



type
  IStringValueGetter = interface(IInterface)
    ['{8673EC53-45BD-4EF7-B42B-D7308945A412}']
    function getValueAsString(pvValueID:string):String; stdcall;
  end;

  IStringValueSetter = interface(IInterface)
    ['{22DE4BCB-ACC5-492F-BA70-5959C378954F}']
    procedure setStringValue(pvValueID, pvValue: String); stdcall;   
  end;



implementation

end.
