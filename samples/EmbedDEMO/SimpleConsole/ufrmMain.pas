unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmMain = class(TForm)
    btnStdWin32DLL: TButton;
    procedure btnStdWin32DLLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure Load_frmTest(App: THandle);stdcall ;External 'StdWin32DLL.dll';

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnStdWin32DLLClick(Sender: TObject);
var
  lv:OVERLAPPED;
begin
  Load_frmTest(Application.Handle);
end;

end.
