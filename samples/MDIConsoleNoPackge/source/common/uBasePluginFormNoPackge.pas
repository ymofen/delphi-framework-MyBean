unit uBasePluginFormNoPackge;

interface

uses
  Forms, uIPluginForm,  Classes, superobject, uIMainForm, ComObj,
  SysUtils,
  mybean.core.intf, mybean.tools.beanFactory,
  mBeanMainFormTools,
  uICaption,uIMainApplication;

type
  TBasePluginForm = class(TForm,
    IPluginForm,
    IFreeObject,
    ICaptionManager,
    IBeanConfigSetter)
  private
    FInstanceID: string;
  protected
    __pass:AnsiString;
    FBeanConfigStr:string;
    procedure DoClose(var Action: TCloseAction); override;
  protected
    function getCaption: PAnsiChar; stdcall;
    procedure setCaption(pvCaption: PAnsiChar); stdcall;
  protected
    /// <summary>
    ///   设置配置中的Config
    /// </summary>
    /// <param name="pvBeanConfig">
    ///   配置文件中JSon格式的字符串
    /// </param>
    procedure setBeanConfig(pvBeanConfig: PAnsiChar); virtual; stdcall;
  protected

    //获取实例Handle
    function getInstanceID: string; stdcall;
    //获取窗体对象
    function getObject: TObject; stdcall;

    procedure showAsMDI; stdcall;
    
    function showAsModal: Integer; stdcall;

    procedure showAsNormal(); stdcall;

    //关闭和释放窗体
    procedure closeForm; stdcall;


  protected
    procedure FreeObject; stdcall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override; 
  end;

implementation



constructor TBasePluginForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInstanceID := CreateClassID;
end;

destructor TBasePluginForm.Destroy;
begin

  //通知从主窗体中移除掉本插件
  TmBeanMainFormTools.removeFromMainForm(AnsiString(FInstanceID));

  //如果共享变量中存在该接口则进行移除(可以提早移除)
  TMyBeanFactoryTools.removeObject(AnsiString(FInstanceID));

  inherited Destroy;
end;

procedure TBasePluginForm.DoClose(var Action: TCloseAction);
begin
  if not (fsModal in self.FFormState) then action := caFree;
  inherited DoClose(Action);
end;

function TBasePluginForm.getCaption: PAnsiChar;
begin
  __pass := AnsiString(Caption);
  Result := PAnsiChar(__pass);
end;

function TBasePluginForm.getInstanceID: string;
begin
  Result := FInstanceID;
end;

function TBasePluginForm.getObject: TObject;
begin
  Result := Self;
end;

procedure TBasePluginForm.FreeObject;
begin
  Self.Free;
end;

procedure TBasePluginForm.setBeanConfig(pvBeanConfig: PAnsiChar);
begin
  FBeanConfigStr :=String(AnsiString(pvBeanConfig));
end;

procedure TBasePluginForm.setCaption(pvCaption: PAnsiChar);
begin
  self.Caption := String(AnsiString(pvCaption));
end;

procedure TBasePluginForm.showAsMDI;
begin
  //让DLL 的Application设置为主程序的Application
  //主程序应该把application对象保存到共享对象中，并命名为MainApplication

  //在DLL的工程源代码中应该保存原Application，并在卸载DLL前还原
  //Application := TmBeanMainFormTools.getMainForm.GetMainApplication;
 // self.Owner :=  Application;
  self.FormStyle := fsMDIChild;
  self.WindowState := wsMaximized;
  self.Show;
end;

function TBasePluginForm.showAsModal: Integer;
begin
  Result := ShowModal();
end;

procedure TBasePluginForm.showAsNormal;
begin
  self.Show;
end;

{ TBasePluginForm }

procedure TBasePluginForm.closeForm;
begin
  Self.Close;
end;

end.
