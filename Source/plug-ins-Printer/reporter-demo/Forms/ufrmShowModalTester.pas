unit ufrmShowModalTester;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uIUIForm;

type
  TfrmShowModalTester = class(TForm, IUIForm)
    Memo1: TMemo;
  private
    { Private declarations }
  protected
    //关闭和释放窗体
    procedure closeAndFree; stdcall;
    procedure showAsMDI; stdcall;
    function showAsModal: Integer; stdcall;
  public
    { Public declarations }
  end;

var
  frmShowModalTester: TfrmShowModalTester;

implementation

uses
  uBeanFactory;

{$R *.dfm}

{ TfrmShowModalTester }

procedure TfrmShowModalTester.closeAndFree;
begin
  Self.Close;
  Self.Free;
end;

procedure TfrmShowModalTester.showAsMDI;
begin
  self.FormStyle := fsMDIChild;
  self.WindowState := wsMaximized;
  self.Show;
end;

function TfrmShowModalTester.showAsModal: Integer;
begin
  Result := ShowModal();
end;

initialization
  beanFactory.RegisterBean('UI_showModalTester', TfrmShowModalTester);

end.
