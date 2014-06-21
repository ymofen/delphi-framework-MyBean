unit uPreviewObjectWrapper;

interface

uses
  uIControlLayout, Forms, Controls;

type
  TPreviewObjectWrapper = class(TInterfacedObject, IControlLayout)
  private
    FFreeObject: TObject;
    FLayOutControl: TWinControl;
  public
    destructor Destroy; override;
    procedure ExecuteLayOut(pvParent:TWinControl);
    function getControlObject():TControl;
  public

    property FreeObject: TObject read FFreeObject write FFreeObject;
    property LayOutControl: TWinControl read FLayOutControl write FLayOutControl;
  end;

implementation

destructor TPreviewObjectWrapper.Destroy;
begin
  FFreeObject.Free;
  FFreeObject := nil;
  inherited Destroy;
end;

{ TPreviewObjectWrapper }

procedure TPreviewObjectWrapper.ExecuteLayOut(pvParent: TWinControl);
begin
  FLayOutControl.Parent := pvParent;
  FLayOutControl.Align := alClient;
end;

function TPreviewObjectWrapper.getControlObject: TControl;
begin
  Result := FLayOutControl;
end;

end.
