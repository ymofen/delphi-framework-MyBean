unit MyBeanSubscribeImpl;

interface

uses
  mybean.ex.designmode.intf, mybean.core.intf, utils.hashs, mybean.core.objects, PublisherImpl;

type
  TPublisherObject = class(TObject)
  private
    FID:MyBeanString;
    FPublisher: IPublisher;
  public
    constructor Create();
    destructor Destroy; override;
  end;

  TMyBeanSubscribeImpl = class(TMyBeanInterfacedObject, ISubscribeCenter)
  private
    FPublisherList:TDHashTableSafe;
  public
    constructor Create(); override;
    destructor Destroy; override;
    /// <summary>
    ///   通过ID获取一个发布者接口实例, 如果该实例不存在则进行创建。否则直接返回
    ///   线程安全版本(
    /// </summary>
    /// <returns>
    ///   S_OK：获取成功
    ///   S_FALSE: 获取失败
    /// </returns>
    /// <param name="pvID"> 同一个ID获取的发布者实例是相同的 </param>
    /// <param name="vPubInstance"> 返回的接口实例 </param>
    function GetPublisher(pvID: PMyBeanChar; out vPubInstance: IPublisher):
        HRESULT; stdcall;
  end;

implementation

constructor TMyBeanSubscribeImpl.Create;
begin
  inherited;
  FPublisherList := TDHashTableSafe.Create();
  {$IFDEF DEBUG}
  __DebugInstanceID := 'MyBeanSubscribe';
  {$ENDIF}
end;

destructor TMyBeanSubscribeImpl.Destroy;
begin
  FPublisherList.FreeAllDataAsObject;
  FPublisherList.Free;
  inherited;
end;

function TMyBeanSubscribeImpl.GetPublisher(pvID: PMyBeanChar; out vPubInstance:
    IPublisher): HRESULT;
var
  lvObj:TPublisherObject;
begin
  FPublisherList.Lock;
  lvObj := TPublisherObject(FPublisherList.ValueMap[pvID]);
  if lvObj = nil then
  begin
    lvObj := TPublisherObject.Create;
    FPublisherList.ValueMap[pvID] := lvObj;
  end;                             
  vPubInstance := lvObj.FPublisher;
  FPublisherList.unLock;
  Result := S_OK;
end;

{ TPublisherObject }

constructor TPublisherObject.Create;
begin
  inherited Create;
  FPublisher := TPublisherImpl.Create;  
end;

destructor TPublisherObject.Destroy;
begin
  try
    FPublisher := nil;
  except
  end;
  inherited;
end;

end.
