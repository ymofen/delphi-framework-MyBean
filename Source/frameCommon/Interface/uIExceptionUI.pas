unit uIExceptionUI;

interface

uses
  SysUtils;

type
  IExceptionUI = interface(IInterface)
   ['{DC24D841-06CA-44A4-A257-2C91D42B15D5}']
    procedure setException(pvE:Exception); stdcall;

    procedure showUI();stdcall;

    procedure freeUI();stdcall;
  end;

implementation

end.
