unit mergePkg;

{$I WizDefine.inc}

interface

uses
  Classes, Windows, DesignIntf, ToolsApi, DesignEditors, WizHelpers, BeanConst;

const
  dpkMerageWizardComment = '把多个包合并成一个包';
  dpkMerageWizardName = '包合并向导';

type

  { TdpkMerageCreator }

  TdpkMerageCreator = class(TWzOTACustomProjectCreator)
  private
    FUnitList : TStringList;
  protected
    constructor Create(sUnitList: TStringList);
    procedure NewDefaultProjectModule(const Project: IOTAProject); override;
    function NewProjectSource(const ProjectName: string): IOTAFile; override;
    function GetCreatorType: string; override;
  public
    destructor Destroy; override;

  end;

  { TdpkMerageWizard }

  TdpkMerageWizard = class(TWzOTACustomRepositoryWizard, IOTAProjectWizard)
  protected
    procedure Execute; override;
    function GetIDString: string; override;
    function GetGlyph: Cardinal; override;
    function GetComment: string; override;
    function GetName: string; override;
  end;

implementation

uses
  SysUtils,Controls, uSelPackages;

{ TdpkMerageCreator }
constructor TdpkMerageCreator.Create(sUnitList: TStringList);
begin
  FUnitList := TStringList.Create;
  FUnitList.Assign(sUnitList);
end;

destructor TdpkMerageCreator.Destroy;
begin
  if Assigned(FUnitList) then
    FUnitList.Free;
  inherited;
end;

function TdpkMerageCreator.GetCreatorType: string;
begin
  Result := sPackage;
end;

procedure TdpkMerageCreator.NewDefaultProjectModule(const Project: IOTAProject);
var
  i: Integer;
begin
  for i := 0 to FUnitList.Count - 1 do
  begin
    try
      Project.AddFile(FUnitList[i] + '.dcu', False);
    except
      on E: Exception do
        OutputDebugString(PChar(E.Message));
    end;
  end;
end;

function TdpkMerageCreator.NewProjectSource(
  const ProjectName: string): IOTAFile;
var
  S: string;
begin
  s := 'package ' + ProjectName + ';' + #13#10 + #13#10 + '{$R *.res}' + #13#10
    + '{$ALIGN 8}' + #13#10 + '{$ASSERTIONS ON}' + #13#10 + '{$BOOLEVAL OFF}' +
    #13#10 + '{$DEBUGINFO ON}' + #13#10 + '{$EXTENDEDSYNTAX ON}' + #13#10 +
    '{$IMPORTEDDATA ON}' + #13#10 + '{$IOCHECKS ON}' + #13#10 +
    '{$LOCALSYMBOLS ON}' + #13#10 + '{$LONGSTRINGS ON}' + #13#10 +
    '{$OPENSTRINGS ON}' + #13#10 + '{$OPTIMIZATION ON}' + #13#10 +
    '{$OVERFLOWCHECKS OFF}' + #13#10 + '{$RANGECHECKS OFF}' + #13#10 +
    '{$REFERENCEINFO ON}' + #13#10 + '{$SAFEDIVIDE OFF}' + #13#10 +
    '{$STACKFRAMES OFF}' + #13#10 + '{$TYPEDADDRESS OFF}' + #13#10 +
    '{$VARSTRINGCHECKS ON}' + #13#10 + '{$WRITEABLECONST OFF}' + #13#10 +
    '{$MINENUMSIZE 1}' + #13#10 + '{$IMAGEBASE $400000}' + #13#10 + '{$RUNONLY}'
    + #13#10 + '{$IMPLICITBUILD OFF}' + #13#10 + #13#10 + 'end.';
  Result := StringToIOTAFile(S);
end;

{ TdpkMerageWizard }

procedure TdpkMerageWizard.Execute;
var
  AModuleServices: IOTAModuleServices;
  AStrList : TStringList;
begin
  frmSelPackages := TfrmSelPackages.Create(nil);
  AStrList := TStringList.Create;
  try
    if frmSelPackages.ShowModal = mrOK then
    begin
      frmSelPackages.GetUnitList(AStrList);

      if Supports(BorlandIDEServices, IOTAModuleServices, AModuleServices) then
      begin
        AModuleServices.CreateModule(TdpkMerageCreator.Create(AStrList));
      end;
    end;
  finally
    frmSelPackages.Free;
    AStrList.Free;
  end;

end;

function TdpkMerageWizard.GetComment: string;
begin
  Result := dpkMerageWizardComment;
end;

function TdpkMerageWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(HInstance, 'PKGMERAGE');
end;

function TdpkMerageWizard.GetIDString: string;
begin
  Result := '{43D88950-5836-479E-A42B-2591B6C8D99C}';
end;

function TdpkMerageWizard.GetName: string;
begin
  Result := dpkMerageWizardName;
end;


end.
