unit uIDEMO;

interface



type
  IMessageDispatch = interface(IInterface)
    ['{9CB41C8C-8362-40A5-8509-0B8D38D8D20A}']
    procedure DispatchMsg(pvMsg:PAnsiChar); stdcall;
  end;

implementation

end.
