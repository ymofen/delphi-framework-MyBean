unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uIFormShow, StdCtrls, uIRemoteFileAccess;

type
  TfrmMain = class(TForm, IShowAsModal)
    edtHost: TEdit;
    edtPort: TEdit;
    btnConnect: TButton;
    dlgOpen: TOpenDialog;
    btnUpload: TButton;
    btnDownload: TButton;
    edtRFileID: TEdit;
    Label1: TLabel;
    btnDel: TButton;
    btnFileSize: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure btnFileSizeClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
  private
    { Private declarations }
    FDIOCPFileAccess:IRemoteFileAccess;
  public
    function showAsModal: Integer; stdcall;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  mybean.tools.beanFactory, uDIOCPFileAccessTools;

{$R *.dfm}


procedure TfrmMain.btnConnectClick(Sender: TObject);
var
  lvHost:AnsiString;
begin
  lvHost := edtHost.Text;
  (FDIOCPFileAccess as IRemoteConnector).SetHost(PAnsiChar(lvHost));
  (FDIOCPFileAccess as IRemoteConnector).SetPort(StrToInt(edtPort.Text));
  (FDIOCPFileAccess as IRemoteConnector).Open;

  ShowMessage('连接成功!');
  lvHost := '';
end;

procedure TfrmMain.btnDelClick(Sender: TObject);
begin
  TDIOCPFileAccessTools.DeleteFile(
    FDIOCPFileAccess,
   edtRFileID.Text   //远程文件
   );
  ShowMessage('删除文件成功!');

end;

procedure TfrmMain.btnDownloadClick(Sender: TObject);
var
  lvLocalFile:String;
begin
  lvLocalFile := ExtractFilePath(ParamStr(0)) + 'tempFiles\' + ExtractFileName(edtRFileID.Text);
  ForceDirectories(ExtractFilePath(lvLocalFile));
  TDIOCPFileAccessTools.DownFile(
    FDIOCPFileAccess,
   edtRFileID.Text,   //远程文件
   lvLocalFile);                                  //本地文件
  ShowMessage('下载文件成功!');
end;

procedure TfrmMain.btnFileSizeClick(Sender: TObject);
begin
  ShowMessage('文件大小:' +
    intToStr(
    TDIOCPFileAccessTools.FileSize(
    FDIOCPFileAccess,
   edtRFileID.Text   //远程文件
   )));
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDIOCPFileAccess := TMyBeanFactoryTools.getBean('diocpRemoteFile') as IRemoteFileAccess;
end;


procedure TfrmMain.btnUploadClick(Sender: TObject);
var
  lvRFileID:String;
begin
  if dlgOpen.Execute then
  begin
    lvRFileID := 'diocpBean\' + ExtractFileName(dlgOpen.FileName);
    TDIOCPFileAccessTools.UploadFile(
      FDIOCPFileAccess,
     lvRFileID,   //远程文件
     dlgOpen.FileName);                                  //本地文件
    ShowMessage('上传文件成功!');
    edtRFileID.Text := lvRFileID;
  end;
end;

{ TfrmMain }

function TfrmMain.showAsModal: Integer;
begin
  Result := ShowModal;
end;

end.
