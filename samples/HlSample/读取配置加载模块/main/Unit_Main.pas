unit Unit_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,mybean.tools.beanfactory,UIShowAsNormal,mybean.core.intf;

type
  TForm1 = class(TForm,IMainPlugCom)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
   procedure Receive(msg:PChar);stdcall;
  procedure Send(msg:PChar);stdcall;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  a01: IApplicationContextEx01;
begin
  a01 := (TMyBeanFactoryTools.applicationContext as IApplicationContextEx01);
 // a01.CheckLoadLibraryFile('plugs\\plug1.dll');   //直接加载 库文件
 a01.CheckLoadBeanConfigFile('plugs.plug-ins');
end;

procedure TForm1.Button2Click(Sender: TObject);
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

procedure TForm1.Button3Click(Sender: TObject);
var
  showf:IShowForm;
begin
  showf :=  TMyBeanFactoryTools.GetBean('plug1') as IShowForm;
  showf.ShowAsNoraml;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  showf:IShowForm;
begin
  showf :=  TMyBeanFactoryTools.GetBean('plug2') as IShowForm;
  showf.ShowAsNoraml;
end;

procedure TForm1.Receive(msg: PChar);
begin
  ///
end;

procedure TForm1.Send(msg: PChar);
begin
 //
end;

end.
