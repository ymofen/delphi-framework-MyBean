unit mybean.vcl.baseForm;

interface

uses
  Windows, Classes, Messages, Controls, Forms,
  mybean.core.intf;

type
  /// <summary>
  ///   标准显示
  /// </summary>
  IShowAsNormal = interface(IInterface)
    ['{4A2274AB-3069-4A57-879F-BA3B3D15097D}']
    procedure ShowAsNormal; stdcall;
  end;

  /// <summary>
  ///   显示成Modal窗体
  /// </summary>
  IShowAsModal = interface(IInterface)
    ['{6A3A6723-8FE7-4698-94BC-5CEDFD4FC750}']
    function ShowAsModal: Integer; stdcall;
  end;

  /// <summary>
  ///   显示成MDI窗体
  /// </summary>
  IShowAsMDI = interface(IInterface)
    ['{F68D4D30-C70C-4BCC-9F83-F50D2D873629}']
    procedure ShowAsMDI; stdcall; 
  end;

  IShowAsChild = interface(IInterface)
    ['{B0AF3A34-8A50-46F9-B723-DEE17F92633B}']
    procedure ShowAsChild(pvParent:TWinControl); stdcall;
  end;


  { TMyBeanBaseForm }
  TMyBeanBaseForm = class(TForm
      , IInterfaceComponentReference
      , IShowAsNormal
      , IShowAsMDI
      , IShowAsModal
      , IShowAsChild
      , IFreeObject)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    {IInterfaceComponentReference}
    function GetComponent: TComponent;    
  public
    procedure ShowAsNormal; stdcall;
    procedure ShowAsMDI; stdcall;
    function ShowAsModal: Integer; stdcall;
    procedure ShowAsChild(pvParent:TWinControl); stdcall;
    procedure CloseForm; stdcall;
    procedure FreeObject; stdcall;
  end;

implementation

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

procedure TMyBeanBaseForm.CloseForm;
begin
  Close;
end;

procedure TMyBeanBaseForm.FreeObject;
begin
  Free;
end;

function TMyBeanBaseForm.GetComponent: TComponent;
begin
  Result := Self;
end;


procedure TMyBeanBaseForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if not (csDesigning in ComponentState) and (FormStyle <> fsMDIChild) then begin
    Params.Style := Params.Style xor (Params.style and (WS_Caption or WS_THICKFRAME));
  end;
end;


procedure TMyBeanBaseForm.ShowAsChild(pvParent: TWinControl);
begin
  Self.BorderStyle := bsNone;
  Self.Parent := pvParent;
  Self.Align := alClient;
  Self.Visible := true;
end;

procedure TMyBeanBaseForm.ShowAsMDI;
begin
  Self.FormStyle := fsMDIChild;
  Self.WindowState := wsMaximized;
  Self.Show;
end;

function TMyBeanBaseForm.ShowAsModal: Integer;
begin
  Result := ShowModal();
end;

procedure TMyBeanBaseForm.ShowAsNormal;
begin
  Show;
end;

end.