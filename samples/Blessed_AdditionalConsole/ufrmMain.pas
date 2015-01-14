unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, mybean.tools.beanFactory, mybean.core.intf, uIPluginForm, IniFiles, uIFormShow,
  ExtCtrls, Buttons;

type
  TfrmMain = class(TForm)
    btnShowModal: TButton;
    edtBeanID: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    btnGetBeanInfos: TButton;
    pnlAdd: TPanel;
    procedure btnGetBeanInfosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnShowModalClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
  uses Unit1;
{$R *.dfm}

procedure TfrmMain.btnGetBeanInfosClick(Sender: TObject);
var
  lvBuf: array[1..4096] of AnsiChar;
  s :String;
  l:Integer;
begin
  FillChar(lvBuf[1], 4096, 0);
  l := (TMyBeanFactoryTools.applicationContext as IApplicationContextEx3).GetBeanInfos(PAnsiChar(@lvBuf[1]), 4096);
  s := UTF8Decode(StrPas(PAnsiChar(@lvBuf[1])));

  Memo1.Clear;
  Memo1.Lines.Add(s);
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

procedure TfrmMain.btnShowModalClick(Sender: TObject);
var
  lvBean:IInterface;
  lvhowAsChild:IShowAsChild;
begin
  lvBean := TMyBeanFactoryTools.getBean(edtBeanID.Text);
  if lvBean.QueryInterface(IShowAsChild, lvhowAsChild) = S_OK then
  begin
     lvhowAsChild.showAsChild(pnlAdd);
  end;
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
