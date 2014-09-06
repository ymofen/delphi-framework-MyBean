unit ufrmAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, uIFormShow, mybean.core.intf;

type
  TfrmAbout = class(TForm, IShowAsModal, IFreeObject)
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    function showAsModal: Integer; stdcall;
    procedure FreeObject; stdcall;
  end;

var
  frmAbout: TfrmAbout;

implementation


{$R *.dfm}

{ TfrmAbout }

procedure TfrmAbout.FreeObject;
begin
  self.Free;
end;

function TfrmAbout.showAsModal: Integer;
begin
  Result :=ShowModal;
end;



end.
