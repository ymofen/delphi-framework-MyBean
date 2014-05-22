unit ufrmPluginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uBasePluginForm, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmPluginForm = class(TBasePluginForm)
    mmo1: TMemo;
    pnlOperator: TPanel;
    btnCreateAsModal: TButton;
    pnlConfig: TPanel;
    mmoConfig: TMemo;
    procedure btnCreateAsModalClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure setBeanConfig(pvBeanConfig: PAnsiChar); override; stdcall;
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

procedure TfrmPluginForm.setBeanConfig(pvBeanConfig: PAnsiChar);
begin
  inherited;
  Self.mmoConfig.Lines.Text := pvBeanConfig;
end;

end.
