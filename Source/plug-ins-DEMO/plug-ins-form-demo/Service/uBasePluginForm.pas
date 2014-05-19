unit uBasePluginForm;

interface

uses
  Forms, uIPluginForm,  Classes, superobject, uIMainForm, ComObj,
  SysUtils, uKeyInterface, uIFreeObject, mBeanMainFormTools, uICaption;

type
  TBasePluginForm = class(TForm,
    IPluginForm,
    IFreeObject,

    ICaptionManager)
  private
    FInstanceID: string;
  protected
    __pass:AnsiString;
    procedure DoClose(var Action: TCloseAction); override;
  protected
    function getCaption: PAnsiChar; stdcall;
    procedure setCaption(pvCaption: PAnsiChar); stdcall;
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

uses
  mBeanFrameVars;

constructor TBasePluginForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInstanceID := CreateClassID;
end;

destructor TBasePluginForm.Destroy;
begin

  //通知从主窗体中移除掉本插件
  TmBeanMainFormTools.removeFromMainForm(self.FInstanceID);

  //如果共享变量中存在改接口则进行移除(可以提早移除)
  TmBeanFrameVars.removeObject(FInstanceID);

  inherited Destroy;
end;

procedure TBasePluginForm.DoClose(var Action: TCloseAction);
begin
  if not (fsModal in self.FFormState) then action := caFree;
  inherited DoClose(Action);
end;

function TBasePluginForm.getCaption: PAnsiChar;
begin
  __pass := self.Caption;
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

procedure TBasePluginForm.setCaption(pvCaption: PAnsiChar);
begin
  self.Caption := pvCaption;
end;

procedure TBasePluginForm.showAsMDI;
begin
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
