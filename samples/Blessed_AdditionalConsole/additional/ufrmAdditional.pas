unit ufrmAdditional;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls,mybean.vcl.BaseForm,uIFormShow,
  StdCtrls, Buttons;

type
  TfrmAdditional = class(TMyBeanBaseForm,IShowAsChild)
    pnl1: TPanel;
    btn1: TBitBtn;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure showAsChild(pvParent:TWinControl); stdcall;
  end;

var
  frmAdditional: TfrmAdditional;

implementation

{$R *.dfm}

{ TfrmAdditional }

procedure TfrmAdditional.btn1Click(Sender: TObject);
begin
  ShowMessage('恭喜你可以使用了');
end;

procedure TfrmAdditional.showAsChild(pvParent: TWinControl);
begin
  self.Parent := pvParent;
  self.Align := alClient;
  self.Visible := True;
end;

end.
