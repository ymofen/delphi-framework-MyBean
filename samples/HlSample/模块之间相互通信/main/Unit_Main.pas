unit Unit_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,mybean.tools.beanFactory,UIShowAsNormal;

type
  TForm1 = class(TForm,IMainPlugCom)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     procedure Receive(msg:PChar);stdcall;
     procedure Send(msg:PChar);stdcall;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
var
  show1:IShowForm;
begin
  show1 :=  TMyBeanFactoryTools.GetBean('plug1') as IShowForm;
  show1.ShowAsNoraml;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  show2:IShowForm;
begin
  show2 :=  TMyBeanFactoryTools.GetBean('plug2') as IShowForm;
  show2.ShowAsNoraml;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  msg:pchar;
begin
  msg := PChar(Edit1.Text);
  send(msg);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMyBeanFactoryTools.SetObject('main',Self); //设置全局变量
end;

procedure TForm1.Receive(msg: PChar);
var
  str:string;
begin
  str := string(msg);
  Memo1.Lines.Add('接受到消息:'+str);

end;

procedure TForm1.Send(msg: PChar);
var
  com:IMainPlugCom;
begin
  // 和plug1 通信
  com  := TMyBeanFactoryTools.GetBean('Plug1') as IMainPlugCom;
  com.Receive(msg);
 //--- 和plug2 通信
  com  := TMyBeanFactoryTools.GetBean('Plug2') as IMainPlugCom;
  com.Receive(msg);
end;

end.
