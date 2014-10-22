unit ufrmAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, uIFormShow, mybean.core.intf;

type
  TfrmAbout = class(TForm, IShowAsModal, IShowAsNormal, IFreeObject)
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    function showAsModal: Integer; stdcall;
    procedure showAsNormal; stdcall;

    procedure FreeObject; stdcall;

    destructor Destroy; override;
  end;

var
  frmAbout: TfrmAbout;

implementation


{$R *.dfm}

{ TfrmAbout }

destructor TfrmAbout.Destroy;
begin

  inherited;
end;

procedure TfrmAbout.FreeObject;
begin
  self.Free;
end;

function TfrmAbout.showAsModal: Integer;
begin
  Result :=ShowModal;
end;



procedure TfrmAbout.showAsNormal;
begin
  self.Show;
end;

end.
