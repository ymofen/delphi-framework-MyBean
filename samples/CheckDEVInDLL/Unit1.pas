unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton;

type
  TForm1 = class(TForm)
    btn1: TRzButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
     procedure Load_frmTest(App: THandle);stdcall ;External 'StdWin32DLL.dll';
var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
  Load_frmTest(Application.Handle) ;
end;

end.
