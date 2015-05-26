unit mybean.core.objects;

interface

{$IFDEF DEBUG}
uses
  Windows, SysUtils;  //  ‰≥ˆ»’÷æ
{$ENDIF}

type
  TMyBeanInterfacedObjectClass = class of TMyBeanInterfacedObject;
  TMyBeanInterfacedObject = class(TInterfacedObject {$IFDEF DEBUG},IInterface{$ENDIF})
  public
    constructor Create; virtual;
  public
    {$IFDEF DEBUG}
    __DebugInstanceID:String;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    destructor Destroy; override;
    {$ENDIF}
  end;


implementation

constructor TMyBeanInterfacedObject.Create;
begin
  inherited Create;
end;


{$IFDEF DEBUG}
function TMyBeanInterfacedObject.QueryInterface(const IID: TGUID; out Obj):
    HResult;
var
  __debugStr:string;
begin
  __debugStr := Format('[%s]:QueryInterface():IID:%s In Delphi' + sLineBreak, [__DebugInstanceID, GUIDToString(IID)]);
  OutputDebugString(PChar(__debugStr));
  Result := inherited QueryInterface(IID, Obj);
end;

function TMyBeanInterfacedObject._AddRef: Integer;
var
  __debugStr:string;
begin
  __debugStr := Format('[%s]:%d AddRef In Delphi' + sLineBreak, [__DebugInstanceID, RefCount + 1]);
  OutputDebugString(PChar(__debugStr));

  Result := inherited _AddRef;
end;

function TMyBeanInterfacedObject._Release: Integer;
var
  __debugStr:string;
begin
  __debugStr := Format('[%s]:%d Release In Delphi' + sLineBreak, [__DebugInstanceID, RefCount - 1]);
  OutputDebugString(PChar(__debugStr));
  
  Result := inherited _Release;
end;

destructor TMyBeanInterfacedObject.Destroy;
var
  __debugStr:string;
begin
  __debugStr := Format('[%s] is Destroying In Delphi', [__DebugInstanceID]);
  OutputDebugString(PChar(__debugStr));
  inherited;
end;
{$ENDIF}

end.
