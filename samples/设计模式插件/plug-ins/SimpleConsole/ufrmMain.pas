unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, mybean.tools.beanFactory,
  mybean.core.intf, IniFiles, mybean.ex.designmode.intf, uIDEMO;

type
  TfrmMain = class(TForm, ISubscribeListener, IMessageDispatch)
    Memo1: TMemo;
    edtMsg: TEdit;
    btnDispatchMsg: TButton;
    btnSubscribe: TButton;
    btnRemoveSubscribe: TButton;
    procedure btnDispatchMsgClick(Sender: TObject);
    procedure btnRemoveSubscribeClick(Sender: TObject);
    procedure btnSubscribeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FSubscriberID:Integer;
  public
    destructor Destroy; override;

    /// <summary>
    ///   添加了一个订阅者
    /// </summary>
    /// <param name="pvSubscriberID"> 订阅者ID </param>
    /// <param name="pvSubscriber"> 订阅者 </param>
    procedure OnAddSubscriber(pvSubscriberID: Integer; const pvSubscriber:
        IInterface); stdcall;

    /// <summary>
    ///   移除了一个订阅者
    /// </summary>
    /// <param name="pvSubscriberID"> 订阅者ID </param>
    procedure OnRemoveSubscriber(pvSubscriberID: Integer); stdcall;

  public
    /// <summary>
    ///   收到发布者发布的信息
    /// </summary>
    procedure DispatchMsg(pvMsg:PAnsiChar); stdcall;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  mybean.ex.designmode.utils;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  // 像tester订阅者，添加订阅侦听者(用于侦听订阅/取消订阅动作)
  GetPublisher('tester').AddSubscribeListener(Self);

  
end;

procedure TfrmMain.OnAddSubscriber(pvSubscriberID: Integer;
  const pvSubscriber: IInterface);
begin
  Memo1.Lines.Add(Format('增加了一个订阅者[%d]', [pvSubscriberID]));
end;

procedure TfrmMain.OnRemoveSubscriber(pvSubscriberID: Integer);
begin
  Memo1.Lines.Add(Format('移除了订阅者[%d]', [pvSubscriberID]));
end;

destructor TfrmMain.Destroy;
begin
  GetPublisher('tester').RemoveSubscribeListener(Self);
  inherited;
end;

procedure TfrmMain.DispatchMsg(pvMsg: PAnsiChar);
begin
  Memo1.Lines.Add('接受到发布者发布的信息:' + pvMsg);
end;

procedure TfrmMain.btnDispatchMsgClick(Sender: TObject);
var
  lvPublisher:IPublisher;
  lvIntf:IInterface;
  lvDispatcher:IMessageDispatch;
  i:Integer;
  s:AnsiString;
begin
  s := edtMsg.Text;
  lvPublisher := GetPublisher('tester');
  for i := 0 to lvPublisher.GetSubscriberCount - 1 do
  begin
    lvPublisher.GetSubscriber(i, lvIntf);
    if lvIntf.QueryInterface(IMessageDispatch, lvDispatcher) = S_OK then
    begin
      lvDispatcher.DispatchMsg(PAnsiChar(s));
    end;
  end;

  s := '';


end;

procedure TfrmMain.btnRemoveSubscribeClick(Sender: TObject);
begin
  GetPublisher('tester').RemoveSubscriber(FSubscriberID);
  FSubscriberID := 0;
end;

procedure TfrmMain.btnSubscribeClick(Sender: TObject);
begin
  if FSubscriberID <> 0 then raise Exception.Create('已经订阅');  
  FSubscriberID := GetPublisher('tester').AddSubscriber(Self);
end;

end.
