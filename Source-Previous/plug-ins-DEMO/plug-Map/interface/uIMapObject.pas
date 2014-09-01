unit uIMapObject;

interface



type
  IMapObject = interface(IInterface)
    ['{7B7ED33B-9EEC-451E-BE98-8D88CF4BE4D4}']
    function getObject(pvKey: string): TObject; stdcall;
    procedure removeObject(pvKey: string); stdcall;
    procedure setObject(pvKey: string; pvObject: TObject); stdcall;

    procedure freeAll(); stdcall;



  end;

implementation

end.
