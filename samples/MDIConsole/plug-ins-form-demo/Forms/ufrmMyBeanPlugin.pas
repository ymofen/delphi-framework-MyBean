unit ufrmMyBeanPlugin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mybean.vcl.BaseForm, mybean.core.beanFactory;

type
  TfrmMyBeanPlugin = class(TMyBeanBaseForm)
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
