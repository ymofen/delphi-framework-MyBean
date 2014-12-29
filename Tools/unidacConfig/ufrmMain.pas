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
    procedure FormCreate(Sender: TObject);
    procedure actConfigExecute(Sender: TObject);
  private
    { Private declarations }
    procedure reloadConfig;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  reloadConfig;
end;

procedure TfrmMain.actConfigExecute(Sender: TObject);
var
  lvIniFile:TIniFile;
begin
  cbbSection.Items.Clear;
  lvIniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.appconfig.ini'));
  try
    UniConnection1.ConnectString := lvIniFile.ReadString('datasource', cbbSection.Text, '');
    if UniConnectDialog1.Execute then
    begin
      lvIniFile.WriteString('datasource', cbbSection.Text, UniConnection1.ConnectString);
    end;
  finally
    lvIniFile.Free;
  end;
end;

procedure TfrmMain.reloadConfig;
var
  lvIniFile:TIniFile;
  lvStrings:TStrings;
  i: Integer;
begin
  cbbSection.Items.Clear;
  lvStrings := TStringList.Create;
  try
    lvIniFile := TIniFile.Create(ChangeFileExt(ParamStr(0), '.appconfig.ini'));
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

end.
