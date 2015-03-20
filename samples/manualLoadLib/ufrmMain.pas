unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls
  , mybean.tools.beanFactory
  , mybean.core.intf
  , uIPluginForm, IniFiles;

type
  TfrmMain = class(TForm)
    btnShowModal: TButton;
    edtBeanID: TEdit;
    Label1: TLabel;
    btnShow: TButton;
    Memo1: TMemo;
    dlgOpen: TOpenDialog;
    btnManualLoad: TButton;
    btnUnLoad: TButton;
    procedure btnManualLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnShowClick(Sender: TObject);
    procedure btnShowModalClick(Sender: TObject);
    procedure btnUnLoadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnManualLoadClick(Sender: TObject);
var
  lvFile:string;
  lvBeanFactory:IBeanFactory;
  lvBeanIDs:array[1..4096] of AnsiChar;
begin
  if not dlgOpen.Execute then exit;
  lvFile := dlgOpen.FileName;
  lvBeanFactory := (TMyBeanFactoryTools.applicationContext as IApplicationContextEx3).CheckLoadALibFile(PAnsiChar(AnsiString(lvFile)));

  if lvBeanFactory <> nil then
  begin
    ZeroMemory(@lvBeanIDs[1], 4096);
    lvBeanFactory.getBeanList(@lvBeanIDs[1], 4096);
    ShowMessage(PAnsiChar(@lvBeanIDs[1]));
  end;
  lvFile :='';
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  lvINiFile:TIniFile;
begin
  lvINiFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.history.ini'));
  try
    edtBeanID.Text := lvINiFile.ReadString('main', 'lastPluginID', '');
  finally
    lvINiFile.Free;
  end;
end;

procedure TfrmMain.btnShowClick(Sender: TObject);
begin
  (TMyBeanFactoryTools.getBean(edtBeanID.Text) as IPluginForm).showAsNormal;
end;

procedure TfrmMain.btnShowModalClick(Sender: TObject);
begin
  (TMyBeanFactoryTools.getBean(edtBeanID.Text) as IPluginForm).showAsModal;
end;

procedure TfrmMain.btnUnLoadClick(Sender: TObject);
var
  lvFile:string;
begin
  if not dlgOpen.Execute then exit;
  lvFile := dlgOpen.FileName;
  if (TMyBeanFactoryTools.applicationContext as IApplicationContextEx2).unLoadLibraryFile(PAnsiChar(AnsiString(lvFile))) then
  begin
    ShowMessage('–∂‘ÿ≥…π¶');
  end;
  //lvFile :='';
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  lvINiFile:TIniFile;
begin
  lvINiFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.history.ini'));
  try
    lvINiFile.WriteString('main', 'lastPluginID', edtBeanID.Text);
  finally
    lvINiFile.Free;
  end;
end;

end.
