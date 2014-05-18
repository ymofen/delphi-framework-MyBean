unit ufrmPluginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uBasePluginForm, Vcl.StdCtrls;

type
  TfrmPluginForm = class(TBasePluginForm)
    mmo1: TMemo;
    btnCreateAsModal: TButton;
    procedure btnCreateAsModalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPluginForm: TfrmPluginForm;

implementation

uses
  mBeanFrameVars, uIPluginForm;

{$R *.dfm}

procedure TfrmPluginForm.btnCreateAsModalClick(Sender: TObject);
begin
  with TmBeanFrameVars.getBean('demoPluginForm') as IPluginForm do
  try
    showAsModal();
  finally
    freeObject;
  end;
end;

end.
