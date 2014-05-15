unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uAppPluginContext, FileLogger;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    edtThreadCounter: TEdit;
    btnStart: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure workerTester();
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uIUIForm;

{$R *.dfm}

function ThreadFunc(p: Pointer): Integer;
begin
  TfrmMain(p).workerTester;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
var
  i, iCount: Integer;
  tid: Cardinal; 
begin
  iCount := StrToInt(edtThreadCounter.Text);
  for i:=1 to iCount do
  begin
    BeginThread(nil,0,ThreadFunc,Self,0,tid);
  end;     
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  with appPluginContext.getBean('tester') as IUIForm do
  try
    showAsModal;
  finally
    UIFormFree;
  end;
end;

procedure TfrmMain.workerTester;
var
  i: Integer;
begin
  try
    for i := 1 to 10 do
    begin
      with appPluginContext.getBean('tester') as IUIForm do
      try

      finally
        UIFormFree;
      end;
    end;
  except
    on E:Exception do
    begin
      TFileLogger.instance.logErrMessage(E.Message);
    end;                                           
  end;
end;

end.
