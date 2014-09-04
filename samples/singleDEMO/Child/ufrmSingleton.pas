unit ufrmSingleton;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, mybean.core.intf,
  uIFormShow;

type
  TfrmSingleton = class(TForm, IFreeObject, IShowAsNormal)
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FreeObject; stdcall;
    procedure showAsNormal; stdcall;
  end;

var
  frmSingleton: TfrmSingleton;

implementation

uses
  mybean.core.beanFactory;

{$R *.dfm}

{ TfrmSingleton }

procedure TfrmSingleton.FreeObject;
begin
  self.Free;
end;

procedure TfrmSingleton.showAsNormal;
begin
  Show();
end;

initialization
  beanFactory.RegisterBean('singletonDEMO', TfrmSingleton);
  beanFactory.configBeanSingleton('singletonDEMO', true);

end.
