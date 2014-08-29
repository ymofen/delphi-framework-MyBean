unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,
  Grids, DBGrids, uBasePluginForm,
  mBeanFrameVars,
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
    procedure btnConnectClick(Sender: TObject);
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
  FRemoteSvr := TmBeanFrameVars.getBean('diocpRemoteSvr') as IRemoteServer;
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
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


end.
