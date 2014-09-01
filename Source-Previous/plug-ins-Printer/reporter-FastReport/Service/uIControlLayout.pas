unit uIControlLayout;

interface

uses
  Controls;

type
  IControlLayout = interface(IInterface)
    ['{ED72A584-3269-451E-BE6F-1CF3FE1DD0A9}']
    procedure ExecuteLayOut(pvParent:TWinControl);
    function getControlObject():TControl;
  end;

implementation

end.
