unit Unit_Plug1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,mybean.core.beanFactory,UIShowAsNormal,mybean.tools.beanfactory;

type
  TfrmPlug1 = class(TForm,IShowForm,IMainPlugCom)
    Memo1: TMemo;
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    Edit1: TEdit;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ShowAsNoraml;stdcall;
    procedure ShowAsMdi;stdcall;
    procedure Receive(msg:PChar);stdcall;
    procedure Send(msg:PChar);stdcall;
    procedure addtomemo(str:string);
    { Public declarations }
  end;

var
  frmPlug1: TfrmPlug1;

implementation

{$R *.dfm}

procedure TfrmPlug1.addtomemo(str: string);
begin
  Memo1.Lines.Add(str);
 // ShowMessage(Memo1.Lines.Text);
end;

procedure TfrmPlug1.Button1Click(Sender: TObject);
begin
//  addtomemo(datetimetostr(now));
  Memo2.Lines.Assign(Memo1.Lines);
end;

procedure TfrmPlug1.Button2Click(Sender: TObject);
begin
 Send(PChar(edit1.Text));
end;

procedure TfrmPlug1.FormCreate(Sender: TObject);
begin
 TMyBeanFactoryTools.SetObject('plug1',self);
end;

procedure TfrmPlug1.Receive(msg: PChar);
var
  str :string;
begin
  str :=string(msg);
 // Edit1.Text := str;
//  addtomemo(datetimetostr(now));
  addtomemo('接受到的消息:'+str);//单例模式可以直接显示
 // Application.ProcessMessages;
 Show;
end;

procedure TfrmPlug1.Send(msg: PChar);
var
  com:IMainPlugCom;
begin
  com := TMyBeanFactoryTools.GetObject('main') as IMainPlugCom;
  if com<>nil then
  begin
    com.Receive(msg);
  end;
  //----------------
  com := TMyBeanFactoryTools.GetObject('plug2') as IMainPlugCom;
  if com<>nil then
  begin
    com.Receive(msg);
  end;
end;

procedure TfrmPlug1.ShowAsMdi;
begin
  //
end;

procedure TfrmPlug1.ShowAsNoraml;
begin
  Show;
end;

initialization
  beanFactory.RegisterBean('plug1',TfrmPlug1,true);
  //beanFactory.

end.
