unit uFMPreView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, frxClass, frxPreview, uIControlLayout;

type
  TFMPreView = class(TFrame,
    IControlLayout)
    frxPreview: TfrxPreview;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ExecuteLayOut(pvParent:TWinControl);
    function getControlObject():TControl;
  end;

implementation

{$R *.dfm}

{ TFMPreView }

procedure TFMPreView.ExecuteLayOut(pvParent: TWinControl);
begin
  Self.Parent := pvParent;
  Self.Align := alClient;
end;

function TFMPreView.getControlObject: TControl;
begin
  Result := Self;
end;

end.
