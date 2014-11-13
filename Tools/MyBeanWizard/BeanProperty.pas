unit BeanProperty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

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
