unit uICaption;

interface



type
  ICaptionManager = interface(IInterface)
    ['{D179A46F-9233-4868-8444-4EA97BDD3E74}']
    function getCaption: PAnsiChar; stdcall;
    procedure setCaption(pvCaption: PAnsiChar); stdcall;
  end;

  ICaptionManagerSetter = interface(IInterface)
    ['{84A9810C-615C-4BF1-A45A-732F5B8E3DE2}']
    procedure setCaptionManager(const pvCaptionManager: ICaptionManager); stdcall;
  end;

  

implementation

end.
