unit ufrmTester;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uIUIForm,  mybean.core.beanFactory, uIFormShow;

type
  TfrmTester = class(TForm, IUIForm, IShowAsNormal)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;

    procedure showAsMDI; stdcall;

    function showAsModal: Integer; stdcall;
    procedure showAsNormal; stdcall;
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

constructor TfrmTester.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TfrmTester.FormCreate(Sender: TObject);
begin

end;

{ TfrmTester }

function TfrmTester.getInstanceID: Integer;
begin
  Result := 0;
end;

function TfrmTester.getObject: TObject;
begin
  Result := self;
end;

procedure TfrmTester.showAsMDI;
begin
  Show;
end;

function TfrmTester.showAsModal: Integer;
begin
  Result := ShowModal;
end;

procedure TfrmTester.showAsNormal;
begin
  Show();
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
