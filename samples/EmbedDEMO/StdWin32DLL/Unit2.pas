unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActiveX, StdCtrls, mybean.tools.beanFactory, uIFormShow,
  uIPluginForm;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    edtBeanID: TEdit;
    Label1: TLabel;
    btnShowForm: TButton;
    procedure btnShowFormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;


implementation

{$R *.dfm}

procedure TForm2.btnShowFormClick(Sender: TObject);
var
  lvBean:IInterface;
  lvShow:IShowAsModal;
begin
  lvBean := TMyBeanFactoryTools.getBean(edtBeanID.Text);
  if lvBean.QueryInterface(IShowAsModal, lvShow) = S_OK then
  begin
    lvShow.showAsModal;
  end else
  begin
    (lvBean as IPluginForm).showAsModal;
  end;
end;

end.
