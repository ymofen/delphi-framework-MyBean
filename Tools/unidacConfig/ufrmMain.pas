unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SQLiteUniProvider, SQLServerUniProvider, OracleUniProvider,
  AccessUniProvider, UniProvider, MySQLUniProvider, DBAccess,
  UniDacVcl, DB, Uni, StdCtrls, ODBCUniProvider, ActnList, IniFiles;

type
  TfrmMain = class(TForm)
    UniConnection1: TUniConnection;
    UniConnectDialog1: TUniConnectDialog;
    MySQLUniProvider1: TMySQLUniProvider;
    AccessUniProvider1: TAccessUniProvider;
    OracleUniProvider1: TOracleUniProvider;
    SQLServerUniProvider1: TSQLServerUniProvider;
    SQLiteUniProvider1: TSQLiteUniProvider;
    btnConfig: TButton;
    actlstMain: TActionList;
    actConfig: TAction;
    cbbSection: TComboBox;
    lblDataSourceID: TLabel;
    dlgOpenConfigFile: TOpenDialog;
    actOpen: TAction;
    actSave: TAction;
    btnOpen: TButton;
    btnSave: TButton;
    dlgSave: TSaveDialog;
    procedure actConfigExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
  private
    FCurrentFileName:String;
    procedure ReloadConfig;
    procedure Save2File(pvFile:String);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.actConfigExecute(Sender: TObject);
var
  lvIniFile:TIniFile;
begin
  lvIniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.appconfig.ini'));
  try
    UniConnection1.ConnectString := lvIniFile.ReadString('datasource', cbbSection.Text, '');
    UniConnectDialog1.Execute;
  finally
    lvIniFile.Free;
  end;
end;

procedure TfrmMain.actOpenExecute(Sender: TObject);
begin
  dlgOpenConfigFile.InitialDir := ExtractFilePath(ParamStr(0));
  if dlgOpenConfigFile.Execute() then
  begin
    FCurrentFileName := dlgOpenConfigFile.FileName;
    ReloadConfig;
  end;
end;

procedure TfrmMain.actSaveExecute(Sender: TObject);
begin
  dlgSave.FileName := FCurrentFileName;
  if dlgSave.Execute() then
  begin
    Save2File(dlgSave.FileName);
  end;
end;

procedure TfrmMain.ReloadConfig;
var
  lvIniFile:TIniFile;
  lvStrings:TStrings;
  i: Integer;
begin
  cbbSection.Items.Clear;
  lvStrings := TStringList.Create;
  try
    lvIniFile := TIniFile.Create(FCurrentFileName);
    lvIniFile.ReadSectionValues('datasource', lvStrings);
    for i := 0 to lvStrings.Count - 1 do
    begin
      cbbSection.Items.Add(lvStrings.Names[i]);
    end;

    lvIniFile.Free;
  finally
    lvStrings.Free;
  end;
  if cbbSection.Items.Count = 0 then
  begin
    cbbSection.Items.Add('main');
  end;
  cbbSection.ItemIndex := 0;
end;

procedure TfrmMain.Save2File(pvFile: String);
var
  lvIniFile:TIniFile;
begin
  lvIniFile := TIniFile.Create(pvFile);
  try
    lvIniFile.WriteString('datasource', cbbSection.Text, UniConnection1.ConnectString);
  finally
    lvIniFile.Free;
  end;
end;

end.
