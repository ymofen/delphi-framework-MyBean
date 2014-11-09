program Units;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain},
  CnSMRBplUtils in 'CnSMRBplUtils.pas',
  CnBaseUtils in 'CnBaseUtils.pas',
  CnBuffStr in 'CnBuffStr.pas',
  CnSMRPEUtils in 'CnSMRPEUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
