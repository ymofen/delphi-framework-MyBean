unit PublisherImpl;


interface

uses
  mybean.ex.designmode.intf, mybean.core.objects, Classes, SyncObjs;

type
  TPublisherImpl = class(TMyBeanInterfacedObject, IPublisher)
  private
    { Private declarations }
    FSubscribers: TList;
    FListeners:IInterfaceList;
    FSubscriberDNA: Integer;
    FLocker: TCriticalSection;
    procedure Clear;
    function FindSubscriber(pvSubscriberID: Integer): Integer;
  public
    constructor Create; override;

    destructor Destroy; override;




    /// <summary>
    ///   注册一个侦听者到发布者实例中
    /// </summary>
    /// <returns>
    ///   返回一个ID,移除时通过该ID进行移除, 注册失败返回-1
    /// </returns>
    /// <param name="pvSubscriber"> (IInterface) </param>
    function AddSubscriber(const pvSubscriber: IInterface): Integer; stdcall;

    /// <summary>
    ///   从发布者中移除掉一个侦听者
    /// </summary>
    /// <returns>
    ///   成功返回True, 失败返回:False
    /// </returns>
    /// <param name="pvSubscriberID"> 订阅者ID(添加时返回的ID) </param>
    function RemoveSubscriber(pvSubscriberID: Integer): HRESULT; stdcall;


    /// <summary>
    ///   获取订阅者数量
    /// </summary>
    /// <returns>
    ///   个数
    /// </returns>
    function GetSubscriberCount: Integer; stdcall;


    /// <summary>
    ///   获取其中的一个订阅者
    /// </summary>
    /// <returns>
    ///   S_OK,获取成功
    /// </returns>
    /// <param name="pvIndex">  序号 </param>
    /// <param name="vSubscribeInstance"> 返回的订阅者 </param>
    function GetSubscriber(pvIndex: Integer; out vSubscribeInstance: IInterface):
        HRESULT; stdcall;


    /// <summary>
    ///   添加了一个订阅侦听者
    ///   添加或者移除订阅者时进行通知
    /// </summary>
    /// <returns>
    ///   S_OK: 成功
    /// </returns>
    /// <param name="pvInstance"> 订阅侦听者 </param>
    function AddSubscribeListener(const pvInstance: ISubscribeListener): HRESULT;
        stdcall;

    /// <summary>
    ///   移除一个订阅侦听者
    /// </summary>
    /// <returns> S_OK: 成功
    /// </returns>
    /// <param name="pvInstance"> (ISubscribeListener) </param>
    function RemoveSubscribeListener(const pvInstance: ISubscribeListener):
        HRESULT; stdcall;

  end;

implementation


type
  TInterfaceItem = class(TObject)
  private
    FInstance:IInterface;
    FID:Integer;
  public
    destructor Destroy; override;
  end;


function TPublisherImpl.AddSubscribeListener(
  const pvInstance: ISubscribeListener): HRESULT;
var
  i:Integer;
  lvObj:TInterfaceItem;
begin
  FLocker.Enter;
  try
    FListeners.Add(pvInstance);
    Result := S_OK;

    try
      for i := 0 to FSubscribers.Count - 1 do
      begin
        lvObj := TInterfaceItem(FSubscribers[i]);
        pvInstance.OnAddSubscriber(lvObj.FID, lvObj.FInstance);
      end;
    except
    end;
  finally
    FLocker.Leave;
  end;
  
end;

function TPublisherImpl.AddSubscriber(const pvSubscriber: IInterface): Integer;
var
  lvObj:TInterfaceItem;
  i: Integer;
  lvListener:ISubscribeListener;
begin
  FLocker.Enter;
  try
    FSubscriberDNA := FSubscriberDNA + 1;
    Result := FSubscriberDNA;
    lvObj := TInterfaceItem.Create;
    lvObj.FInstance := pvSubscriber;
    lvObj.FID := Result;
    FSubscribers.Add(lvObj);
    for i := 0 to FListeners.Count - 1 do
    begin
      if FListeners[i].QueryInterface(ISubscribeListener, lvListener) = S_OK then
      begin
        lvListener.OnAddSubscriber(Result, pvSubscriber);
      end;
    end;
  finally
    FLocker.Leave;
  end;

end;

procedure TPublisherImpl.Clear;
var
  I: Integer;
begin
  for I := 0 to FSubscribers.Count - 1 do
  begin
    try
      TObject(FSubscribers[i]).Free;
    except      
    end;
  end;
  FSubscribers.Clear;

  FListeners.Clear;
end;

constructor TPublisherImpl.Create;
begin
  inherited;
  FSubscribers:= TList.Create;
  FListeners := TInterfaceList.Create;
  FSubscriberDNA := 0;
  FLocker := TCriticalSection.Create;

  {$IFDEF DEBUG}
  __DebugInstanceID := 'Publisher';
  {$ENDIF}
end;

destructor TPublisherImpl.Destroy;
begin
  Clear();
  FSubscribers.Free;
  FListeners := nil;
  FLocker.Free;
  inherited;
end;

function TPublisherImpl.FindSubscriber(pvSubscriberID: Integer): Integer;
var
  I: Integer;
  lvObj:TInterfaceItem;
begin
  Result := -1;
  for I := 0 to FSubscribers.Count - 1 do
  begin
    lvObj := TInterfaceItem(FSubscribers[i]);
    if lvObj.FID = pvSubScriberID then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TPublisherImpl.GetSubscriber(pvIndex: Integer;
  out vSubscribeInstance: IInterface): HRESULT;
begin
  FLocker.Enter;
  try
    if (pvIndex <=0) and (pvIndex >= FSubscribers.Count) then
    begin
      Result := S_FALSE;
      Exit;
    end;
    vSubscribeInstance := TInterfaceItem(FSubscribers[pvIndex]).FInstance;
    Result := S_OK;
  finally
    FLocker.Leave;
  end; 
end;

function TPublisherImpl.GetSubscriberCount: Integer;
begin
  FLocker.Enter;
  Result := FSubscribers.Count;
  FLocker.Leave;
end;

function TPublisherImpl.RemoveSubscribeListener(
  const pvInstance: ISubscribeListener): HRESULT;
begin
  FLocker.Enter;
  FListeners.Remove(pvInstance);
  Result := S_OK;
  FLocker.Leave;
end;

function TPublisherImpl.RemoveSubscriber(pvSubscriberID: Integer): HRESULT;
var
  lvIndex:Integer;
  i:Integer;
  lvListener:ISubscribeListener;
begin
  FLocker.Enter;
  try
    lvIndex := FindSubscriber(pvSubscriberID);
    if lvIndex <> -1 then
    begin
      TObject(FSubscribers[lvIndex]).Free;
      FSubscribers.Delete(lvIndex);

      for i := 0 to FListeners.Count - 1 do
      begin
        if FListeners[i].QueryInterface(ISubscribeListener, lvListener) = S_OK then
        begin
          lvListener.OnRemoveSubscriber(pvSubscriberID);
        end;
      end;
      Result := S_OK;
    end else
    begin
      Result := S_FALSE;
    end;
  finally
    FLocker.Leave;
  end;

end;

{ TInterfaceItem }

destructor TInterfaceItem.Destroy;
begin
  try
    FInstance := nil;
  except
  end;
  inherited;
end;

end.
