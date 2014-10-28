unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Menus, ActnList,
  Tabs, ExtCtrls, uIMainForm, PluginTabControl,
  StdCtrls, IniFiles, DockTabSet, Spin;

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
    DockTabSet1: TDockTabSet;
    Panel1: TPanel;
    actCreateDataBase: TAction;
    dlgOpen1: TOpenDialog;
    actOpenDatabase: TAction;
    actCloseDatabase: TAction;
    F1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    actAddPerson: TAction;
    btnGetPerson: TButton;
    dlgOpen2: TOpenDialog;
    procedure actAboutExecute(Sender: TObject);
    procedure actCreateDemoFormExecute(Sender: TObject);
    procedure actCreatePluginAsMDIExecute(Sender: TObject);
    procedure actCreateReporterDEMOExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnGetPersonClick(Sender: TObject);

  private
    FDatabaseFile : string;
    FPluginTabControl: TPluginTabControl;
    procedure closePluginQuery(const pvForm: IInterface; vCanClose: Boolean);
        stdcall;
    function removePlugin(const pvInstanceID: PAnsiChar): boolean; stdcall;

    procedure showPluginAsMDI(const pvPlugin:IInterface);stdcall;

    function GetMainApplication:TApplication;

    function OpenDatabase(FileName:string):boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  mybean.tools.beanFactory,uIFormShow,uIPluginForm, uMainFormTools;

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  TMyBeanFactoryTools.setObject('main', Self);


 // TMyBeanFactoryTools.setObject('MainApplication', Application); //注册对象，供调用DLL MDI子窗体
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


procedure TfrmMain.btnGetPersonClick(Sender: TObject);
var
  lvPlugin:IInterface;
begin
  lvPlugin := TMyBeanFactoryTools.getBean('demoPluginMdiForm');
  self.showPluginAsMDI(lvPlugin);
end;

procedure TfrmMain.closePluginQuery(const pvForm: IInterface; vCanClose:
    Boolean);
begin

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  lvINiFile:TIniFile;
begin
  lvINiFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.config.ini'));
  try
    lvINiFile.WriteString('main', 'lastPluginID', edtPluginID.Text);
    lvINiFile.WriteString('main', 'Database', FDatabaseFile);
  finally
    lvINiFile.Free;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  lvINiFile:TIniFile;
begin

  try
    self.OnShow := nil;                    //FormShow只执行一次
    lvINiFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.Config.ini'));
    try
      edtPluginID.Text := lvINiFile.ReadString('main', 'lastPluginID', '');
      FDatabaseFile :=  lvINiFile.ReadString('main', 'Database', '');
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

function TfrmMain.GetMainApplication: TApplication;
begin
   Result := Application;
end;

function TfrmMain.OpenDatabase(FileName: string):boolean;
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
