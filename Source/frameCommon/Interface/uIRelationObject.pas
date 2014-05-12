unit uIRelationObject;

interface

type
  IRelationObject = interface(IInterface)
    ['{38F2CCF3-E965-4008-B72F-49E70AA63693}']
    function findChildObject(pvInstanceID: PAnsiChar): IInterface; stdcall;

    procedure removeChildObject(pvInstanceID:PAnsiChar); stdcall;

    procedure DeleteChildObject(pvIndex:Integer); stdcall;

    procedure addChildObject(pvInstanceID:PAnsiChar; pvChild:IInterface); stdcall;

    procedure setOwnerObject(pvOwnerObject: IRelationObject); stdcall;

    function existsChildObject(pvInstanceID: PAnsiChar):Boolean;stdcall;

    function getCount():Integer; stdcall;

    function getChildObjectItems(pvIndex:Integer): IInterface; stdcall;



  end;

implementation

end.
