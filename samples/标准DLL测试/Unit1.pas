unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    btnInVoke: TButton;
    procedure btnInVokeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure Load_frmTest(App: THandle);stdcall ;External 'DllForm.dll';
var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnInVokeClick(Sender: TObject);
begin
  Load_frmTest(Application.Handle) ;
end;

end.
