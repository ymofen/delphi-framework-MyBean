unit ufrmPluginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uBasePluginForm,
  mBeanMainFormTools,
  StdCtrls, ExtCtrls,Menus;

type
  TfrmPluginForm = class(TBasePluginForm)
    mmo1: TMemo;
    pnlOperator: TPanel;
    btnCreateAsModal: TButton;
    pnlConfig: TPanel;
    mmoConfig: TMemo;
    btnCreateAsMDI: TButton;
    mm1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure btnCreateAsMDIClick(Sender: TObject);
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
  uIPluginForm, mybean.tools.beanFactory;

{$R *.dfm}

procedure TfrmPluginForm.btnCreateAsMDIClick(Sender: TObject);
begin
  TmBeanMainFormTools.getMainForm.showPluginAsMDI(TMyBeanFactoryTools.getBean('demoPluginForm'));

end;

procedure TfrmPluginForm.btnCreateAsModalClick(Sender: TObject);
begin
  with TMyBeanFactoryTools.getBean('demoPluginForm') as IPluginForm do
  try
    showAsModal();
  finally
    freeObject;
  end;
end;

procedure TfrmPluginForm.setBeanConfig(pvBeanConfig: PAnsiChar);
begin
  inherited;
  Self.mmoConfig.Lines.Text :=string(AnsiString(pvBeanConfig));
end;

end.
