unit ufrmSingleton;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uIFreeObject, uIShow;

type
  TfrmSingleton = class(TForm, IFreeObject, IShowForm)
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FreeObject; stdcall;
    procedure ShowForm(); stdcall;
  end;

var
  frmSingleton: TfrmSingleton;

implementation

uses
  uBeanFactory;

{$R *.dfm}

{ TfrmSingleton }

procedure TfrmSingleton.FreeObject;
begin
  self.Free;
end;

procedure TfrmSingleton.ShowForm;
begin
  Show();
end;

initialization
  beanFactory.RegisterBean('singletonDEMO', TfrmSingleton);
  beanFactory.configBeanSingleton('singletonDEMO', true);

end.
