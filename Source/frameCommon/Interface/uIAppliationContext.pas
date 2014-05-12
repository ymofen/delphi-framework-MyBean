unit uIAppliationContext;

interface


type
  IApplicationContext = interface(IInterface)
    ['{0FE2FD2D-3A21-475B-B51D-154E1728893B}']
    procedure checkInitialize;stdcall;
    function getBean(pvPluginID: PAnsiChar): IInterface; stdcall;
  end;

implementation

end.
