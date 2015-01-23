unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Buttons,
  Dialogs, StdCtrls, ExtCtrls, CnSMRBplUtils;

type
  TfrmMain = class(TForm)
    dlgOpen: TOpenDialog;
    gpAnalyse: TPanel;
    Panel2: TPanel;
    pnlRequiredPackages: TPanel;
    Label2: TLabel;
    mmoRequirePackages: TMemo;
    pnlExeFiles: TPanel;
    Label3: TLabel;
    lstFiles: TListBox;
    pnlButton: TPanel;
    btnOpenFiles: TBitBtn;
    btnAnalyse: TBitBtn;
    btnClearFiles: TBitBtn;
    btnCopyUnits: TBitBtn;
    Label1: TLabel;
    mmoUnits: TMemo;
    lblCopyTo: TLabel;
    mmoDevUnits: TMemo;
    cbbType: TComboBox;
    procedure btnCopyUnitsClick(Sender: TObject);
    procedure btnClearFilesClick(Sender: TObject);
    procedure lstFilesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lstFilesClick(Sender: TObject);
    procedure btnAnalyseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOpenFilesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FAnalyseResults: TPackageInfosList;
    FUIUpdating: Boolean;
    FPerformUIUpdating: Boolean;
    FAnalysing: Boolean;

    function GetSelectedFile: string;
    function IndexOfAnalyseResult(const s: string): Integer;

    procedure AddFiles(ss: TStrings);
    procedure AnalyseAFile(const FileName: string; AllowException: Boolean = False);
    procedure AnalyseAllFiles(var Errors: string);
    procedure Analysing(b: Boolean);
    procedure UpdateAnalyseResultView(PPI: PPackageInfos); overload;
    procedure UpdateAnalyseResultView(ssUnits, ssRequirePackages: TStrings); overload;
    procedure UpdateAnalyseResultView; overload;
    procedure UpdateControlsState;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses StrUtils, CnBaseUtils;

{$R *.dfm}

const
  CRLF = #13#10;
var
  // 需要本地化的字符串
  SCnAnalyzedResultsSaved: string = 'Analyzed Results Saved Successed to File %s.';
  SCnDuplicatedNameFound: string = 'Can NOT Save analyzed result: Duplicated File Names Found:'#13#10#13#10'%s';
  SCnSomeAnalyzedFailed: string = 'All Files Analyzed, but Some Files Analyzed Failed:'#13#10;


function StringProcessProc(const s: string): string;
begin
  Result := ExtractFileName(s);
end;

procedure TfrmMain.AddFiles(ss: TStrings);
var
  i: Integer;
  tmpSs: TStringList;
begin
  tmpSs := TStringList.Create;
  try
    tmpSs.Assign(lstFiles.Items);
    tmpSs.Sorted := True;
    for i := 0 to ss.Count - 1 do
    begin
      if FileExists(ss[i]) then
      begin
        tmpSs.Add(ss[i]);
      end;
    end;
    lstFiles.Items.Assign(tmpSs);
  finally
    tmpSs.Free;
  end;
end;

procedure TfrmMain.AnalyseAFile(const FileName: string; AllowException: Boolean = False);
begin
  try
    FAnalyseResults.AddFile(FileName);
  except
    if AllowException then
    begin
      raise;
    end;
  end;
end;

procedure TfrmMain.AnalyseAllFiles(var Errors: string);
var
  i: Integer;
begin
  FAnalyseResults.BeginUpdate;
  try
    FAnalyseResults.Clear;
    for i := 0 to lstFiles.Items.Count - 1 do
    begin
      try
        AnalyseAFile(lstFiles.Items[i], True);
      except
        on E: Exception do
        begin
          Errors := Errors + E.Message + #13#10;
        end;
      end;
    end;
  finally
    FAnalyseResults.EndUpdate;
  end;
end;

procedure TfrmMain.Analysing(b: Boolean);
begin
  FAnalysing := b;
  UpdateControlsState;
end;

procedure TfrmMain.btnAnalyseClick(Sender: TObject);
var
  Errors: string;
  I, J: Integer;
  S: string;
  lvDXUnit: Boolean;
begin
  Analysing(True);
  try
    Errors := '';
    AnalyseAllFiles(Errors);
    if Errors <> '' then
    begin
      raise Exception.Create(SCnSomeAnalyzedFailed + Errors);
    end;
  finally
    Analysing(False);
  end;

  for I := 0 to FAnalyseResults.Count - 1 do
  begin
    for J := 0 to FAnalyseResults.PackageInfos[I].Units.Count - 1 do
    begin
      S := FAnalyseResults.PackageInfos[I].Units.Strings[J];
      lvDXUnit := (LeftStr(S, 2) = 'cx') or (LeftStr(S, 2) = 'dx');
      case cbbType.ItemIndex of
        0:
          if not lvDXUnit and (S <> 'dbrtl') and (S <> 'rtl')
            and (S <> 'vcl') and (S <> 'vcldb')
            and (S <> 'vclimg') and (S <> 'vclx')
            and (S <> 'SysInit') and (S <> 'System')
            and (mmoDevUnits.Lines.IndexOf(S) = -1) then
            mmoDevUnits.Lines.Add(S);
        1:
          if lvDXUnit and (mmoDevUnits.Lines.IndexOf(S) = -1) then
            mmoDevUnits.Lines.Add(S);
      end;
    end;
  end;
end;

procedure TfrmMain.btnClearFilesClick(Sender: TObject);
begin
  FAnalyseResults.Clear;
  lstFiles.Clear;
  mmoDevUnits.Clear;
  UpdateControlsState;
end;

procedure TfrmMain.btnCopyUnitsClick(Sender: TObject);
var
  I: Integer;
  List: TStrings;
begin
  List := TStringList.Create;
  case cbbType.ItemIndex of
    0: List.Add('package dpPack;');
    1: List.Add('package dxPack;');
  end;
  List.Add('');
  List.Add('{$R *.res}');
  List.Add('{$IFDEF IMPLICITBUILDING This IFDEF should not be used by users}');
  List.Add('{$ALIGN 8}');
  List.Add('{$ASSERTIONS ON}');
  List.Add('{$BOOLEVAL OFF}');
  List.Add('{$DEBUGINFO OFF}');
  List.Add('{$EXTENDEDSYNTAX ON}');
  List.Add('{$IMPORTEDDATA ON}');
  List.Add('{$IOCHECKS ON}');
  List.Add('{$LOCALSYMBOLS ON}');
  List.Add('{$LONGSTRINGS ON}');
  List.Add('{$OPENSTRINGS ON}');
  List.Add('{$OPTIMIZATION OFF}');
  List.Add('{$OVERFLOWCHECKS OFF}');
  List.Add('{$RANGECHECKS OFF}');
  List.Add('{$REFERENCEINFO ON}');
  List.Add('{$SAFEDIVIDE OFF}');
  List.Add('{$STACKFRAMES ON}');
  List.Add('{$TYPEDADDRESS OFF}');
  List.Add('{$VARSTRINGCHECKS ON}');
  List.Add('{$WRITEABLECONST OFF}');
  List.Add('{$MINENUMSIZE 1}');
  List.Add('{$IMAGEBASE $400000}');
  List.Add('{$DEFINE DEBUG}');
  List.Add('{$ENDIF IMPLICITBUILDING}');
  List.Add('{$IMPLICITBUILD ON}');
  List.Add('');
  if cbbType.ItemIndex > 0 then
  begin
    List.Add('requires');
    List.Add('  rtl,');
    List.Add('  vcl;');
    List.Add('');
  end;
  List.Add('contains');
  for I := 0 to mmoDevUnits.Lines.Count - 1 do
  begin
    if I = mmoDevUnits.Lines.Count - 1 then
      List.Add('  ' + mmoDevUnits.Lines[I] + ';')
    else
      List.Add('  ' + mmoDevUnits.Lines[I] + ',');
  end;
  List.Add('');
  List.Add('end.');

  case cbbType.ItemIndex of
    0: List.SaveToFile('dpPack.dpk');
    1: List.SaveToFile('dxPack.dpk');
  end;
end;

procedure TfrmMain.btnOpenFilesClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    AddFiles(dlgOpen.Files);
    UpdateControlsState;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FAnalyseResults := TPackageInfosList.Create;
  FAnalyseResults.Sorted := True;
  FAnalyseResults.StringProcessProc := StringProcessProc;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FAnalyseResults.Free;
end;

function TfrmMain.GetSelectedFile: string;
begin
  Result := '';
  if lstFiles.ItemIndex >= 0 then
  begin
    Result := lstFiles.Items[lstFiles.ItemIndex];
  end;
end;

function TfrmMain.IndexOfAnalyseResult(const s: string): Integer;
begin
  Result := -1;
  if s = '' then
  begin
    Exit;
  end;

  Result := FAnalyseResults.IndexOf(s);
end;

procedure TfrmMain.lstFilesClick(Sender: TObject);
begin
  UpdateControlsState;
end;

procedure TfrmMain.lstFilesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FPerformUIUpdating then
  begin
    UpdateControlsState;
  end;
end;

procedure TfrmMain.UpdateAnalyseResultView;
begin
  UpdateAnalyseResultView(FAnalyseResults.PackageInfos[IndexOfAnalyseResult(GetSelectedFile)]);
end;

procedure TfrmMain.UpdateAnalyseResultView(ssUnits, ssRequirePackages: TStrings);
begin
  if Assigned(ssUnits) then
    mmoUnits.Lines.Assign(ssUnits);
  if Assigned(ssRequirePackages) then
    mmoRequirePackages.Lines.Text := ssRequirePackages.Text;
end;

procedure TfrmMain.UpdateAnalyseResultView(PPI: PPackageInfos);
begin
  if PPI = nil then
  begin
    UpdateAnalyseResultView(nil, nil);
  end
  else
  begin
    UpdateAnalyseResultView(PPI.Units, PPI.RequiredPackages);
  end;
end;

procedure TfrmMain.UpdateControlsState;
var
  bEnabled: Boolean;
begin
  if FUIUpdating then
  begin
    Exit;
  end;

  FUIUpdating := True;
  try
    bEnabled := not FAnalysing;

    btnOpenFiles.Enabled := bEnabled;
    btnAnalyse.Enabled := bEnabled and (lstFiles.Items.Count > 0);
    btnClearFiles.Enabled := btnAnalyse.Enabled;
    lstFiles.Enabled := bEnabled;
  finally
    UpdateAnalyseResultView;
    FUIUpdating := False;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  I: Integer;
begin
  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i] is TButton then
    begin
      with TButton(Controls[i]) do
      begin
        Caption := StringReplace(Caption, ' ', #13#10, [rfReplaceAll]);
      end;
    end;
  end;
  UpdateControlsState;
end;

end.
