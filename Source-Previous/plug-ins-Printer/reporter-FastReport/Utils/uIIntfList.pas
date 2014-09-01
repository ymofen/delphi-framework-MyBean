unit uIIntfList;

interface

uses
  uCore;

type
  IIntfList = interface;
  IIntfListSetter = interface(IInterface)
    ['{C30CFA10-C32B-4634-A7BF-F398458CFF7C}']
    procedure setIntfList(const pvIntf:IIntfList);stdcall;
  end;

  IIntfListGetter = interface(IInterface)
    ['{D1EDEFD2-8FB7-4156-9B25-C405B867F551}']
    function getIntfList():IIntfList;stdcall;
  end;

  IRelationListGetter = interface(IInterface)
    ['{71260F3A-2E44-447E-A64C-F96114A1F789}']
    function getRelationList: IIntfList; stdcall;
  end;

  IRelationListSetter = interface(IInterface)
    ['{142FE5AD-54A1-4953-A9F7-FB5EC1AC1708}']
    procedure setRelationIntfList(const pvIntf:IIntfList); stdcall;
  end;

  IIntfList = interface(IInterface)
  ['{8B806B0F-DEF9-4A09-B419-2111990A4B24}']
    procedure Clear; stdcall;
    function CheckQueryInterface(pvKey: PMyChar; const IID: TGUID; out Obj;
        pvRaiseIfNil: Boolean = true; pvIsAliasKey: Boolean = false): Boolean;
    function CheckQueryIndexInterface(const pvIndex: Integer; const IID: TGUID; out
        Obj; pvRaiseIfNil: Boolean = true): Boolean; stdcall;

    function CheckGet(pvKey: PMyChar; pvRaiseIfNil: Boolean = true; pvIsAliasKey:
        Boolean = false): IInterface;
    function ContainKey(pvKey: PMyChar): Boolean; stdcall;
    procedure CheckPut(pvKey: PMyChar; const pvInterface: IInterface; pvAliasKey:
        PMyChar = nil; pvRaiseIfExists: Boolean = true; pvOverlay: Boolean = false);
    function GetCount: Integer; stdcall;
    function GetKeys(pvIndex: Integer): PMyChar; stdcall;
    function GetValues(pvIndex: Integer): IInterface; stdcall;
    procedure Lock; stdcall;
    procedure UnLock; stdcall;
    procedure Remove(pvKey: PMyChar; pvIsAliasKey: Boolean = false);
    procedure SetValues(pvIndex: Integer; const Value: IInterface); stdcall;

    property Count: Integer read GetCount;
    property Values[pvIndex: Integer]: IInterface read GetValues write SetValues;
    default;
    property Keys[pvIndex: Integer]: PMyChar read GetKeys;



  end;

implementation

end.

