unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Menus, ActnList,
  Tabs, ExtCtrls, uIMainForm, PluginTabControl;

type
  TfrmMain = class(TForm, IMainForm)
    mmMain: TMainMenu;
    actlstMain: TActionList;
    actAbout: TAction;
    actAbout1: TMenuItem;
    pnlExp: TPanel;
    pnlTabs: TPanel;
    actCreateDemoForm: TAction;
    DEMO1: TMenuItem;
    procedure actAboutExecute(Sender: TObject);
    procedure actCreateDemoFormExecute(Sender: TObject);
  private
    FPluginTabControl: TPluginTabControl;
    procedure closePluginQuery(const pvForm: IInterface; vCanClose: Boolean);
        stdcall;
    function removePlugin(const pvInstanceID: PAnsiChar): boolean; stdcall;

    procedure showPluginAsMDI(const pvPlugin:IInterface);stdcall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  mBeanFrameVars, uIFormShow, uMainFormTools;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  TmBeanFrameVars.setObject('main', Self);
  FPluginTabControl := TPluginTabControl.Create(Self);
  FPluginTabControl.Parent := pnlTabs;
  FPluginTabControl.Align := alClient;
end;

destructor TfrmMain.Destroy;
begin
  FPluginTabControl.freeAll;
  TmBeanFrameVars.removeObject('main');
  FreeAndNil(FPluginTabControl);
  inherited Destroy;
end;

procedure TfrmMain.actAboutExecute(Sender: TObject);
var
  lvIntf:IInterface;
begin
  lvIntf := TmBeanFrameVars.getBean('aboutForm');
  try
    (lvIntf as IShowAsModal).showAsModal;
  finally
    TmBeanFrameVars.freeBeanInterface(lvIntf);
  end;
end;

procedure TfrmMain.actCreateDemoFormExecute(Sender: TObject);
var
  lvPlugin:IInterface;
begin
  lvPlugin := TmBeanFrameVars.getBean('demoPluginForm');
  self.showPluginAsMDI(lvPlugin);
end;

procedure TfrmMain.closePluginQuery(const pvForm: IInterface; vCanClose:
    Boolean);
begin

end;

function TfrmMain.removePlugin(const pvInstanceID: PAnsiChar): boolean;
begin
  FPluginTabControl.remove(String(AnsiString(pvInstanceID)));
  Result := true;
end;

procedure TfrmMain.showPluginAsMDI(const pvPlugin: IInterface);
begin
  TMainFormTools.showAsMDI(pvPlugin);
  FPluginTabControl.BindPlugin(pvPlugin, TMainFormTools.getInstanceID(pvPlugin));
end;

end.
