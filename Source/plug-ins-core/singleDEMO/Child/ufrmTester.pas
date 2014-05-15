unit ufrmTester;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uIUIForm, uBeanFactory;

type
  TfrmTester = class(TForm, IUIForm)
  private
    { Private declarations }
  public
    procedure showAsMDI; stdcall;

    function showAsModal: Integer; stdcall;

    //关闭
    procedure UIFormClose; stdcall;

    //释放窗体
    procedure UIFormFree; stdcall;

    //获取窗体对象
    function getObject:TObject; stdcall;

    //获取实例ID
    function getInstanceID: Integer; stdcall;
  end;

var
  frmTester: TfrmTester;

implementation

{$R *.dfm}

{ TfrmTester }

function TfrmTester.getInstanceID: Integer;
begin

end;

function TfrmTester.getObject: TObject;
begin

end;

procedure TfrmTester.showAsMDI;
begin

end;

function TfrmTester.showAsModal: Integer;
begin
  ShowModal;
end;

procedure TfrmTester.UIFormClose;
begin
  close;
end;

procedure TfrmTester.UIFormFree;
begin
  self.Free;
end;

initialization
  beanFactory.RegisterBean('tester', TfrmTester);

end.
