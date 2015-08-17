unit Unit_plug2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,UIShowAsNormal,mybean.core.beanfactory,mybean.Tools.beanfactory;

type
  TForm1 = class(TForm,IShowForm,IMainPlugCom)
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     procedure ShowAsNoraml;stdcall;
     procedure ShowAsMdi;stdcall;
      procedure Receive(msg:PChar);stdcall;
    procedure Send(msg:PChar);stdcall;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
 Send(PChar(Edit1.Text));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
TMyBeanFactoryTools.SetObject('plug2',Self);
end;

procedure TForm1.Receive(msg: PChar);
var
  str :string;
begin
  str :=string(msg);
  Memo1.Lines.Add('接受到消息:'+str);
  show;
end;

procedure TForm1.Send(msg: PChar);
var
  com:IMainPlugCom;
begin
  com := TMyBeanFactoryTools.GetObject('main') as IMainPlugCom;
  if com<>nil then
  begin
    com.Receive(msg);
  end;
  //----------------
  com := TMyBeanFactoryTools.GetObject('plug1') as IMainPlugCom;
  if com<>nil then
  begin
    com.Receive(msg);
  end;
end;
procedure TForm1.ShowAsMdi;
begin
//
end;

procedure TForm1.ShowAsNoraml;
begin
  Show;
end;

initialization
  beanFactory.RegisterBean('plug2',TForm1,True);

end.
