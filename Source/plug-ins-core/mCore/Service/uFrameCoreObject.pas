unit uFrameCoreObject;

interface

uses
  uIFrameCoreObject, uKeyInterface;

type
  TFrameCoreObject = class(TInterfacedObject, IFrameCoreObject)
  private
    FKeyIntface:TKeyInterface;
  protected
    //清理对象
    procedure cleanupObjects; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;


    function existsObject(const pvKey:PAnsiChar):Boolean; stdcall;

    function getObject(const pvKey:PAnsiChar):IInterface; stdcall;

    procedure setObject(const pvKey:PAnsiChar; const pvIntf: IInterface); stdcall;

    //移除对象
    procedure removeObject(const pvKey:PAnsiChar); stdcall;

  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;

implementation

procedure TFrameCoreObject.AfterConstruction;
begin
  inherited;
  FKeyIntface := TKeyInterface.Create;
end;

procedure TFrameCoreObject.cleanupObjects;
begin
  FKeyIntface.clear;
end;

destructor TFrameCoreObject.Destroy;
begin
  cleanupObjects;
  FKeyIntface.Free;
  FKeyIntface := nil;
  inherited Destroy;
end;




function TFrameCoreObject.existsObject(const pvKey: PAnsiChar): Boolean;
begin
  Result := FKeyIntface.exists(pvKey);
end;

function TFrameCoreObject.getObject(const pvKey: PAnsiChar): IInterface;
begin
  Result := FKeyIntface.find(pvKey);
end;

procedure TFrameCoreObject.removeObject(const pvKey: PAnsiChar);
begin
  try
    FKeyIntface.remove(pvKey);
  except
  end;
end;

procedure TFrameCoreObject.setObject(const pvKey: PAnsiChar;
  const pvIntf: IInterface);
begin
  try
    FKeyIntface.put(pvKey, pvIntf);
  except
  end;
end;

function TFrameCoreObject._AddRef: Integer;
begin
  Result := inherited _AddRef;
end;

function TFrameCoreObject._Release: Integer;
begin
  Result := inherited _Release;
end;

end.
