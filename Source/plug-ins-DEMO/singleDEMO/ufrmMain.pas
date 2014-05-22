unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uAppPluginContext, FileLogger;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    btnSingletonForm: TButton;
    procedure btnSingletonFormClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uIUIForm, mBeanFrameVars, uIFormShow;

{$R *.dfm}

procedure TfrmMain.btnSingletonFormClick(Sender: TObject);
begin
  with appPluginContext.getBean('singletonDEMO') as IShowAsNormal do
  begin
    showAsNormal;
  end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  with TmBeanFrameVars.getBean('tester') as IUIForm do
  try
    showAsModal;
  finally
    UIFormFree;
  end;
end;

end.
