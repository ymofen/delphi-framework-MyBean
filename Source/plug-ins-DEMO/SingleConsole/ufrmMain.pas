unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, mybean.tools.beanFactory, uIPluginForm;

type
  TfrmMain = class(TForm)
    btnShowModal: TButton;
    edtBeanID: TEdit;
    Label1: TLabel;
    btnShow: TButton;
    procedure btnShowClick(Sender: TObject);
    procedure btnShowModalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnShowClick(Sender: TObject);
begin
  (TMyBeanFactoryTools.getBean(edtBeanID.Text) as IPluginForm).showAsNormal;
end;

procedure TfrmMain.btnShowModalClick(Sender: TObject);
begin
  (TMyBeanFactoryTools.getBean(edtBeanID.Text) as IPluginForm).showAsModal;
end;

end.
