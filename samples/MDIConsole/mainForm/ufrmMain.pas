unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Menus, ActnList,
  Tabs, ExtCtrls, uIMainForm, PluginTabControl,
  StdCtrls, IniFiles;

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
    DEMO2: TMenuItem;
    edtPluginID: TEdit;
    btnCreateAsMDI: TButton;
    actCreatePluginAsMDI: TAction;
    Button1: TButton;
    btnShowAsNormal: TButton;
    procedure actAboutExecute(Sender: TObject);
    procedure actCreateDemoFormExecute(Sender: TObject);
    procedure actCreatePluginAsMDIExecute(Sender: TObject);
    procedure actCreateReporterDEMOExecute(Sender: TObject);
    procedure btnShowAsNormalClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    FTempIntf:IInterface;
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
  mybean.tools.beanFactory, uIFormShow, uMainFormTools;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  TMyBeanFactoryTools.setObject('main', Self);
  FPluginTabControl := TPluginTabControl.Create(Self);
  FPluginTabControl.Parent := pnlTabs;
  FPluginTabControl.Align := alClient;
end;

destructor TfrmMain.Destroy;
begin
  FPluginTabControl.freeAll;
  TMyBeanFactoryTools.removeObject('main');
  FreeAndNil(FPluginTabControl);
  inherited Destroy;
end;

procedure TfrmMain.actAboutExecute(Sender: TObject);
var
  lvIntf:IInterface;
begin
  lvIntf := TMyBeanFactoryTools.getBean('aboutForm');
  try
    (lvIntf as IShowAsModal).showAsModal;
  finally
    TMyBeanFactoryTools.freeBeanInterface(lvIntf);
  end;
end;

procedure TfrmMain.actCreateDemoFormExecute(Sender: TObject);
var
  lvPlugin:IInterface;
begin
  lvPlugin := TMyBeanFactoryTools.getBean('demoPluginForm');
  self.showPluginAsMDI(lvPlugin);
end;

procedure TfrmMain.actCreatePluginAsMDIExecute(Sender: TObject);
var
  lvPlugin:IInterface;
begin
  lvPlugin := TMyBeanFactoryTools.getBean(edtPluginID.Text);
  self.showPluginAsMDI(lvPlugin);
end;

procedure TfrmMain.actCreateReporterDEMOExecute(Sender: TObject);
var
  lvPlugin:IInterface;
begin
  lvPlugin := TMyBeanFactoryTools.getBean('reporterDemoForm');
  self.showPluginAsMDI(lvPlugin);
end;

procedure TfrmMain.btnShowAsNormalClick(Sender: TObject);
var
  lvPlugInf:IInterface;
begin
  lvPlugInf := TMyBeanFactoryTools.getBean(edtPluginID.Text);
  (lvPlugInf as IShowAsNormal).showAsNormal();
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  lvPlugInf:IInterface;
begin
  ShowMessage('请注意: 演示调用单实例窗体插件[mybeanForm]' + sLineBreak
           + '要求mybeanForm注册方式为单实例,单实例插件不能自己调用Free,或者在窗体中Action:=caFree');
  lvPlugInf := TMyBeanFactoryTools.getBean('mybeanForm');
  (lvPlugInf as IShowAsNormal).showAsNormal();

end;

procedure TfrmMain.closePluginQuery(const pvForm: IInterface; vCanClose:
    Boolean);
begin

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  lvINiFile:TIniFile;
begin
  lvINiFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.history.ini'));
  try
    lvINiFile.WriteString('main', 'lastPluginID', edtPluginID.Text);
  finally
    lvINiFile.Free;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  lvINiFile:TIniFile;
begin
  try
    self.OnShow := nil;
    lvINiFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.history.ini'));
    try
      edtPluginID.Text := lvINiFile.ReadString('main', 'lastPluginID', '');
    finally
      lvINiFile.Free;
    end;

    if edtPluginID.Text <> '' then
    begin
      actCreatePluginAsMDI.Execute;
    end;
  except

  end;
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
