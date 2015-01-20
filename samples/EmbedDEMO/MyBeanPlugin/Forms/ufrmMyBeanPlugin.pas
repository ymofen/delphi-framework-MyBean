unit ufrmMyBeanPlugin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mybean.vcl.BaseForm, mybean.core.beanFactory, StdCtrls;

type
  TfrmMyBeanPlugin = class(TMyBeanBaseForm)
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMyBeanPlugin: TfrmMyBeanPlugin;

implementation

{$R *.dfm}

function CreatePlugin:TObject;
begin
  Result := TfrmMyBeanPlugin.Create(beanFactory.VclOwners);
end;

initialization
  beanFactory.RegisterBean('mybeanMethodForm', CreatePlugin);

end.
