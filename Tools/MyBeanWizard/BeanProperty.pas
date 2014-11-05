unit BeanProperty;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TbeanPropertyDlg = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lbEditBeanName: TLabeledEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  beanPropertyDlg: TbeanPropertyDlg;

implementation

{$R *.dfm}

end.
