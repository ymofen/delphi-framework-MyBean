unit uKeyMapImpl;

interface

uses
  uIKeyMap, uKeyInterface;

type
  TKeyMapImpl = class(TInterfacedObject, IKeyMap)
  private
    FKeyIntface:TKeyInterface;
  protected
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

  protected
    /// <summary>
    ///   判断是否存在接口
    /// </summary>
    function existsObject(const pvKey:PAnsiChar):Boolean; stdcall;

    /// <summary>
    ///   根据key值获取接口
    /// </summary>
    function getObject(const pvKey:PAnsiChar):IInterface; stdcall;

    /// <summary>
    ///  赋值接口
    /// </summary>
    procedure setObject(const pvKey:PAnsiChar; const pvIntf: IInterface); stdcall;

    /// <summary>
    ///   移除接口
    /// </summary>
    procedure removeObject(const pvKey:PAnsiChar); stdcall;

    /// <summary>
    ///   清理对象
    /// </summary>
    procedure cleanupObjects; stdcall;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;


procedure executeKeyMapCleanup;

/// <summary>
///   获取全局的KeyMap接口
/// </summary>
function applicationKeyMap: IKeyMap; stdcall;

implementation

uses
  FileLogger, SysUtils;

var
  __instance:TKeyMapImpl;
  __instanceIntf:IInterface;


function applicationKeyMap: IKeyMap;
begin
  Result := __instance;
end;

procedure executeKeyMapCleanup;
begin
  if __instanceIntf = nil then exit;
  try
    try
      __instance.cleanupObjects;
    except
    end;
    if __instance.RefCount > 1 then
    begin
      TFileLogger.instance.logErrMessage(Format('keyMap存在[%d]未释放的情况',
        [__instance.RefCount-1]));
    end;
  except
  end;
end;

procedure TKeyMapImpl.AfterConstruction;
begin
  inherited;
  FKeyIntface := TKeyInterface.Create;
end;

procedure TKeyMapImpl.cleanupObjects;
begin
  FKeyIntface.clear;
end;

destructor TKeyMapImpl.Destroy;
begin
  cleanupObjects;
  FKeyIntface.Free;
  FKeyIntface := nil;
  inherited Destroy;
end;




function TKeyMapImpl.existsObject(const pvKey: PAnsiChar): Boolean;
begin
  Result := FKeyIntface.exists(string(AnsiString(pvKey)));
end;

function TKeyMapImpl.getObject(const pvKey: PAnsiChar): IInterface;
begin
  Result := FKeyIntface.find(string(AnsiString(pvKey)));
end;


procedure TKeyMapImpl.removeObject(const pvKey: PAnsiChar);
begin
  try
    FKeyIntface.remove(string(AnsiString(pvKey)));
  except
  end;
end;

procedure TKeyMapImpl.setObject(const pvKey: PAnsiChar;
  const pvIntf: IInterface);
begin
  try
    FKeyIntface.put(string(AnsiString(pvKey)), pvIntf);
  except
  end;
end;

function TKeyMapImpl._AddRef: Integer;
begin
  Result := inherited _AddRef;
end;

function TKeyMapImpl._Release: Integer;
begin
  Result := inherited _Release;
end;

initialization
  __instance := TKeyMapImpl.Create;
  __instanceIntf := __instance;


finalization
  executeKeyMapCleanup;
  __instanceIntf := nil;


end.
