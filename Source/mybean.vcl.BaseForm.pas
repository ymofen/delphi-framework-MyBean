unit mybean.vcl.BaseForm;

{$I Hydra.inc}

interface

uses
  Classes,
  {$IFDEF MSWINDOWS}
  Messages, Forms, Controls, ActnList;
  {$ENDIF}
  {$IFDEF LINUX}
  QForms, QControls, QActnList, QComCtrls, QMenus;
  {$ENDIF}

const
  WM_TABOUTOFPLUGIN = WM_USER + 1;
  WM_FOCUSOUTOFHOST = WM_USER + 2;
  WM_HOSTIDLE = WM_USER + 3;
  WM_GETHOSTTYPE = WM_USER + 5;
  FMX_HOST = $F1;

type
  /// <summary>
  ///   标准显示
  /// </summary>
  IShowAsNormal = interface(IInterface)
    ['{4A2274AB-3069-4A57-879F-BA3B3D15097D}']
    procedure showAsNormal; stdcall;
  end;

  /// <summary>
  ///   显示成Modal窗体
  /// </summary>
  IShowAsModal = interface(IInterface)
    ['{6A3A6723-8FE7-4698-94BC-5CEDFD4FC750}']
    function showAsModal: Integer; stdcall;
  end;

  /// <summary>
  ///   显示成MDI窗体
  /// </summary>
  IShowAsMDI = interface(IInterface)
    ['{F68D4D30-C70C-4BCC-9F83-F50D2D873629}']
    procedure showAsMDI; stdcall;
  end;

  IShowAsChild = interface(IInterface)
    ['{B0AF3A34-8A50-46F9-B723-DEE17F92633B}']
    procedure showAsChild(pvParent:TWinControl); stdcall;
  end;


  TReferenceCountOperation = (rcoAddRef, rcoReleaseRef);
  TReferenceCountChangeEvent = procedure(Sender: TObject; NewReferenceCount: integer;
    Operation: TReferenceCountOperation) of object;

  { TMyBeanBaseForm }
  TMyBeanBaseForm = class(TForm
      , IInterfaceComponentReference
      , IShowAsNormal
      , IShowAsModal)
  private
    fRefCount: integer;
    fBorder: boolean;
    fOnReferenceCountChange: TReferenceCountChangeEvent;
    procedure SetBorder(const Value: Boolean);
    property Border: Boolean read fBorder write SetBorder;
  protected
    procedure Paint; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    {$IFDEF LINUX}
    procedure InitWidget; override;
    {$ELSE}
    procedure CreateParams(var Params: TCreateParams); override;
    {$ENDIF}
    { IInterface }
    function QueryInterface(const IID: TGUID; out Obj): HResult; reintroduce; virtual; stdcall;
    {IInterfaceComponentReference}
    function GetComponent: TComponent;

    { IHYVisualPlugin }
    procedure ShowWindowed;
    procedure ShowParented(aParent: TWinControl);
    function GetVisible: boolean;
    procedure SetVisible(Value: boolean);

    { IHYPlugin }
    function GetObject: TObject;
    function GetInstanceID: integer;
    procedure WMHostIdle(var Message: TMessage); message WM_HOSTIDLE;
  public
    procedure showAsNormal; stdcall;
    function showAsModal: Integer; stdcall;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    class function NewInstance: TObject; override;
    procedure AfterConstruction; override;
    function SetFocusedControl(Control: TWinControl): Boolean; override;
  published
    property OnReferenceCountChange: TReferenceCountChangeEvent read fOnReferenceCountChange write fOnReferenceCountChange;
  end;

implementation

uses
  {$IFDEF MSWINDOWS}Windows, {$IFDEF DELPHI7UP}Themes,{$ENDIF} {$ENDIF}
  SysUtils;

{$IFNDEF DELPHI9UP}
type
  TApplicationHack = class (TApplication)
  end;
{$ENDIF}

procedure TMyBeanBaseForm.AfterConstruction;
begin
  inherited;
  InterlockedDecrement(FRefCount);
end;

constructor TMyBeanBaseForm.Create(aOwner: TComponent);
begin
  {$IFDEF DEBUG_HYDRA_INSTANCES}
  DebugServer.EnterMethod(['Hydra','Instances','Creation'],'%s.Create',[ClassName]);
  try
  {$ENDIF}
    inherited;
  {$IFDEF DEBUG_HYDRA_INSTANCES}
  finally
    DebugServer.ExitMethod(['Hydra','Instances','Creation'],'%s.Create',[ClassName]);
  end;
  {$ENDIF}
end;

destructor TMyBeanBaseForm.Destroy;
begin
  {$IFDEF DEBUG_HYDRA_INSTANCES}
  DebugServer.EnterMethod(['Hydra','Instances','Destruction'],'%s.Destroy',[ClassName]);
  try
  {$ENDIF}
    inherited;
  {$IFDEF DEBUG_HYDRA_INSTANCES}
  finally
    DebugServer.ExitMethod(['Hydra','Instances','Destruction'],'%s.Destroy',[ClassName]);
  end;
  {$ENDIF}
end;

function TMyBeanBaseForm.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  result := inherited QueryInterface(IID, Obj);
end;

function TMyBeanBaseForm.GetComponent: TComponent;
begin
  Result := Self;
end;

procedure TMyBeanBaseForm.ShowParented(aParent: TWinControl);
begin
  Parent := aParent;

  if aParent <> nil then begin
    Align := alClient;
    Border := False;
  end
  else begin
    Align := alNone;
    Border := True;
  end;

  {$IFDEF MSWINDOWS}
  BorderStyle := bsNone;
  {$ENDIF}
  {$IFDEF LINUX}
  BorderStyle := fbsSizeable;//fbsNone;
  {$ENDIF}

  if not Visible then Show;
end;

function TMyBeanBaseForm.GetObject: TObject;
begin
  result := Self;
end;

function GetShiftState: TShiftState;
begin
  Result := [];
  if GetKeyState(VK_SHIFT) < 0 then
  Include(Result, ssShift);
  if GetKeyState(VK_CONTROL) < 0 then
  Include(Result, ssCtrl);
  if GetKeyState(VK_MENU) < 0 then
  Include(Result, ssAlt);
end;

procedure TMyBeanBaseForm.WMHostIdle(var Message: TMessage);
{$IFNDEF DELPHI9UP}
var
  IdleMessage: tagMSG;
{$ENDIF}
begin
  {$IFNDEF DELPHI9UP}
  IdleMessage.hwnd := 0;
  IdleMessage.message := 0;
  IdleMessage.wParam := 0;
  IdleMessage.lParam := 0;
  THYApplicationHack(Application).Idle(IdleMessage);
  {$ELSE}
  Application.DoApplicationIdle;
  {$ENDIF}
end;

class function TMyBeanBaseForm.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TMyBeanBaseForm(Result).FRefCount := 1;
end;

procedure TMyBeanBaseForm.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
end;

function TMyBeanBaseForm.GetInstanceID: integer;
begin
  result := integer(Self);
end;

{$IFDEF LINUX}
procedure TMyBeanBaseForm.InitWidget;
begin
end;
{$ELSE}
procedure TMyBeanBaseForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if not (csDesigning in ComponentState) and (FormStyle <> fsMDIChild) then begin
    Params.Style := Params.Style xor (Params.style and (WS_Caption or WS_THICKFRAME));
  end;
end;
{$ENDIF}

function TMyBeanBaseForm.GetVisible: boolean;
begin
  result := Visible
end;

procedure TMyBeanBaseForm.SetVisible(Value: boolean);
begin
  Visible := Value;
end;

function TMyBeanBaseForm.showAsModal: Integer;
begin
  Result := ShowModal();
end;

procedure TMyBeanBaseForm.showAsNormal;
begin
  Show;
end;

function TMyBeanBaseForm.SetFocusedControl(Control: TWinControl): Boolean;
begin
  Result := inherited SetFocusedControl(Control);
  if ActiveControl <> nil then
    SendMessage(ParentWindow, WM_FOCUSOUTOFHOST, 0, 0);
end;

procedure TMyBeanBaseForm.Paint;
begin
  inherited;
  {$IFDEF DELPHIXE2UP}
  if StyleServices.Enabled then
    StyleServices.DrawParentBackground(Handle, Canvas.Handle, nil, False);
  {$ELSE}
  {$IFDEF DELPHI7UP}
  if ThemeServices.ThemesEnabled then
    ThemeServices.DrawParentBackground(Handle, Canvas.Handle, nil, False);
  {$ENDIF}
  {$ENDIF}
end;

procedure TMyBeanBaseForm.ShowWindowed;
begin
  Align := alNone;
  Parent := nil;
  SetBorder(True);
  inherited Show;
end;

procedure TMyBeanBaseForm.SetBorder(const Value: Boolean);
var
  Style: Longint;
begin
  if fBorder <> Value then
  begin
    fBorder := Value;
    if HandleAllocated then
    begin
      Style := GetWindowLong(Handle, GWL_STYLE) and not WS_THICKFRAME;
      if Value then Style := Style or WS_THICKFRAME;
      SetWindowLong(Handle, GWL_STYLE, Style);
    end;
  end;
end;

end.
