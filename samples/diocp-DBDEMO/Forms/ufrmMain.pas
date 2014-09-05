unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,
  Grids, DBGrids, uBasePluginForm,
  mybean.tools.beanFactory,
  uIRemoteServer, DB, DBClient;

type
  TfrmMain = class(TBasePluginForm)
    mmoSQL: TMemo;
    btnConnect: TButton;
    edtHost: TEdit;
    edtPort: TEdit;
    DBGrid1: TDBGrid;
    btnOpen: TButton;
    cdsMain: TClientDataSet;
    dsMain: TDataSource;
    btnGetTime: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure btnGetTimeClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
  private
    { Private declarations }
    FRemoteSvr:IRemoteServer;

  public
    { Public declarations }

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation





{$R *.dfm}

{ TfrmMain }

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  // 获取单实例的远程连接操作接口
  FRemoteSvr := TMyBeanFactoryTools.getBean('diocpRemoteSvr') as IRemoteServer;
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
  // 打开远程连接，如果打开过可以不用打开，其他插件中可以直接使用
  (FRemoteSvr as IRemoteServerConnector).setHost(PAnsiChar(AnsiString(edtHost.Text)));
  (FRemoteSvr as IRemoteServerConnector).setPort(StrToInt(edtPort.Text));
  (FRemoteSvr as IRemoteServerConnector).open;
  ShowMessage('open succ!');
end;

procedure TfrmMain.btnOpenClick(Sender: TObject);
var
  vData:OleVariant;
  l : Cardinal;
begin
  vData := mmoSQL.Lines.Text;

  l := GetTickCount;

  // 在远程打开SQL
  if FRemoteSvr.Execute(1, vData) then
  begin
    self.cdsMain.Data := vData;
    Self.Caption := Format('query: count:%d, time:%d',
      [self.cdsMain.RecordCount, GetTickCount - l]);
  end;
end;

destructor TfrmMain.Destroy;
begin
  FRemoteSvr := nil;
  inherited Destroy;
end;

procedure TfrmMain.btnGetTimeClick(Sender: TObject);
var
  vData:OleVariant;
  l : Cardinal;
begin
  l := GetTickCount;

  // 在远程打开SQL
  if FRemoteSvr.Execute(0, vData) then
  begin
    Self.Caption := Format('服务器时间:%s, 耗时:%d',
      [FormatDateTime('yyyy-MM-dd hh:nn:ss', vData), GetTickCount - l]);
  end;
end;


end.
