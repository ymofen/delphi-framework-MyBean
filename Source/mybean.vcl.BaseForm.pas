unit mybean.vcl.baseForm;



interface

uses
  Classes,
  Messages, Forms, Controls, ActnList,
  mybean.core.intf,
  Windows;

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


  { TMyBeanBaseForm }
  TMyBeanBaseForm = class(TForm
      , IInterfaceComponentReference
      , IShowAsNormal
      , IShowAsMDI
      , IShowAsModal
      , IFreeObject)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    function GetComponent: TComponent;    
    function GetObject: TObject;
    function GetInstanceID: integer;
  public
    procedure showAsNormal; stdcall;
    procedure showAsMDI; stdcall;
    function showAsModal: Integer; stdcall;

    procedure FreeObject; stdcall;
  end;

implementation




procedure TMyBeanBaseForm.FreeObject;
begin
  Free;
end;

function TMyBeanBaseForm.GetComponent: TComponent;
begin
  Result := Self;
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

function TMyBeanBaseForm.GetInstanceID: integer;
begin
  result := integer(Self);
end;


procedure TMyBeanBaseForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if not (csDesigning in ComponentState) and (FormStyle <> fsMDIChild) then begin
    Params.Style := Params.Style xor (Params.style and (WS_Caption or WS_THICKFRAME));
  end;
end;


procedure TMyBeanBaseForm.showAsMDI;
begin
  self.FormStyle := fsMDIChild;
  self.WindowState := wsMaximized;
  self.Show;
end;

function TMyBeanBaseForm.showAsModal: Integer;
begin
  Result := ShowModal();
end;

procedure TMyBeanBaseForm.showAsNormal;
begin
  Show;
end;

end.
