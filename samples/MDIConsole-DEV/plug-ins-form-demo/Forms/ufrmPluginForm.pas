unit ufrmPluginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uBasePluginForm,
  mBeanMainFormTools,
  StdCtrls, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinscxPCPainter,
  dxSkinsDefaultPainters, cxPC, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid;

type
  TfrmPluginForm = class(TBasePluginForm)
    mmo1: TMemo;
    pnlOperator: TPanel;
    btnCreateAsModal: TButton;
    pnlConfig: TPanel;
    mmoConfig: TMemo;
    btnCreateAsMDI: TButton;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    cxGrid1DBTableView1Column2: TcxGridDBColumn;
    cxGrid1DBTableView1Column3: TcxGridDBColumn;
    cxGrid1DBTableView1Column4: TcxGridDBColumn;
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
