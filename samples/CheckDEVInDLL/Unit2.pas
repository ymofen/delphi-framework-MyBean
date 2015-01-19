unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton,ActiveX;

type
  TForm2 = class(TForm)
    Btn1: TRzBitBtn;
    procedure Btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  ITaskbarList = interface(IUnknown)
    ['{56FDF344-FD6D-11d0-958A-006097C9A090}']
    function HrInit():HRESULT;stdcall;
    function AddTab(hwnd:HWND):HRESULT;stdcall;
    function DeleteTab(hwnd:HWND):HRESULT;stdcall;
    function ActivateTab(hwnd:HWND):HRESULT;stdcall;
    function SetActiveAlt(hwnd:HWND):HRESULT;stdcall;
  end;
var
  Form2: TForm2;


implementation

{$R *.dfm}
  uses unit3;
procedure TForm2.Btn1Click(Sender: TObject);
begin
  Form3:=TForm3.Create(nil);
form3.ShowModal;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  hr:HResult;
  TaskbarList:ITaskbarList;
const
  CLSID_TaskbarList:TGUID='{56FDF344-FD6D-11d0-958A-006097C9A090}';
  IID_ITaskbarList:TGUID='{602D4995-B13A-429b-A66E-1935E44F4317}';
begin
  hr:=CoCreateInstance(CLSID_TaskbarList,Nil,CLSCTX_INPROC_HANDLER,
    IID_ITaskbarList,TaskbarList);
  TaskbarList.HrInit();
  TaskbarList.DeleteTab(Application.Handle);
end;

end.
