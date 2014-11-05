unit WizHelpers;

{$I WizDefine.inc}

interface

uses
  Classes, Windows, DesignIntf, ToolsApi, DesignEditors, BeanConst ;

type

  { TWzOTACustomRepositoryWizard }

  TWzOTACustomRepositoryWizard = class(TNotifierObject,
    IOTARepositoryWizard,
    IOTARepositoryWizard60,
  {$IFDEF DELPHI8}
    IOTARepositoryWizard80,
  {$ENDIF}
    IOTAWizard)
  protected
    // IOTAWizard
    function GetIDString: string; virtual;
    function GetName: string; virtual; abstract;
    function GetState: TWizardState;
    procedure Execute; virtual; abstract;
    // IOTARepositoryWizard
    function GetAuthor: string;
    function GetComment: string; virtual;
    function GetGlyph: Cardinal; virtual;
    function GetPage: string;
    // IOTARepositoryWizard60
    function GetDesigner: string;
  {$IFDEF DELPHI8}
    // IOTARepositoryWizard80
    function GetGalleryCategory: IOTAGalleryCategory; virtual;
    function GetPersonality: string; virtual;
    property GalleryCategory: IOTAGalleryCategory read GetGalleryCategory;
    property Personality: string read GetPersonality;
  {$ENDIF}
  end;

  { TWzOTACustomCreator }

  TWzOTACustomCreator = class(TInterfacedObject, IOTACreator)
  protected
    // IOTACreator
    function GetCreatorType: string; virtual; abstract;
    function GetExisting: Boolean; virtual;
    function GetFileSystem: string; virtual;
    function GetOwner: IOTAModule; virtual;
    function GetUnnamed: Boolean; virtual;
  end;

  { TWzOTAFormCreator }

  TWzOTAFormCreator = class(TWzOTACustomCreator, IOTAModuleCreator)
  private
    FFormTemplate: string;
    FImplTemplate: string;
    FIntfTemplate: string;
    function CreateOTAFile(const ATemplate, AModuleIdent, AFormIdent, AAncestorIdent: string): IOTAFile;
  protected
    function ExpandTemplate(const ATemplate, AModuleIdent, AFormIdent, AAncestorIdent: string): string; virtual;
    // IOTACreator
    function GetCreatorType: string; override;
    // IOTAModuleCreator
    function GetAncestorName: string; virtual;
    function GetFormName: string; virtual;
    function GetImplFileName: string; virtual;
    function GetIntfFileName: string; virtual;
    function GetMainForm: Boolean; virtual;
    function GetShowForm: Boolean; virtual;
    function GetShowSource: Boolean; virtual;
    function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile; virtual;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; virtual;
    function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; virtual;
    procedure FormCreated(const FormEditor: IOTAFormEditor); virtual;
  public
    constructor Create(const AFormTemplate, AImplTemplate, AIntfTemplate: string);
    //
    property FormTemplate: string read FFormTemplate;
    property ImplTemplate: string read FImplTemplate;
    property IntfTemplate: string read FIntfTemplate;
  end;

  { TWzOTACustomProjectCreator }

  TWzOTACustomProjectCreator = class(TWzOTACustomCreator,
    IOTAProjectCreator50,
  {$IFDEF DELPHI8}
    IOTAProjectCreator80,
  {$ENDIF}
  {$IFDEF DELPHI16}
    IOTAProjectCreator160,
  {$ENDIF}
    IOTAProjectCreator)
  protected
    // IOTACreator
    function GetOwner: IOTAModule; override;
    // IOTAProjectCreator
    function GetFileName: string; virtual;
    function GetOptionFileName: string; // deprecated;
    function GetShowSource: Boolean; virtual;
    function NewOptionSource(const ProjectName: string): IOTAFile; // deprecated;
    function NewProjectSource(const ProjectName: string): IOTAFile; virtual;
    procedure NewDefaultModule; // deprecated;
    procedure NewProjectResource(const Project: IOTAProject); virtual;
    // IOTAProjectCreator50
    procedure NewDefaultProjectModule(const Project: IOTAProject); virtual;
  {$IFDEF DELPHI8}
    // IOTAProjectCreator80
    function GetProjectPersonality: string;
  {$ENDIF}
  {$IFDEF DELPHI16}
    // IOTAProjectCreator160
    function GetFrameworkType: string;
    function GetPlatforms: TArray<string>;
    function GetPreferredPlatform: string;
    procedure SetInitialOptions(const NewProject: IOTAProject);
  {$ENDIF}
  end;

function wzGetActiveProject: IOTAProject;
function wzGetActiveProjectFileName: string;
procedure wzRegisterPackageWizard(AWizard: TWzOTACustomRepositoryWizard);
implementation

uses
{$IFDEF DELPHI16}
  PlatformAPI,
{$ENDIF}
{$IFNDEF DELPHI11}
  ToolIntf, ExptIntf,
{$ENDIF}
  SysUtils;

function wzGetActiveProject: IOTAProject;
{$IFDEF DELPHI9}
begin
  Result := GetActiveProject;
end;
{$ELSE}
var
  AProjectGroup: IOTAProjectGroup;
  AModuleServices: IOTAModuleServices;
  I: Integer;
begin
  Result := nil;
  if Assigned(BorlandIDEServices) then
  begin
    AProjectGroup := nil;
    AModuleServices := BorlandIDEServices as IOTAModuleServices;
    for I := 0 to AModuleServices.ModuleCount - 1 do
    begin
      if Supports(AModuleServices.Modules[I], IOTAProjectGroup, AProjectGroup) then
        Break;
    end;
    if AProjectGroup <> nil then
      Result := AProjectGroup.ActiveProject
    else
      if not Supports(AModuleServices.CurrentModule, IOTAProject, Result) then
        Result := nil;
  end;
end;
{$ENDIF}

function wzGetActiveProjectFileName: string;
var
  AProject: IOTAProject;
begin
{$IFNDEF DELPHI11}
  if Assigned(ToolServices) then
    Result := ToolServices.GetProjectName 
  else
{$ENDIF}
  begin
    AProject := wzGetActiveProject;
    if AProject <> nil then
      Result := AProject.FileName
    else
      Result := '';
  end;
end;

procedure wzRegisterPackageWizard(AWizard: TWzOTACustomRepositoryWizard);
begin
{$IFNDEF DELPHI8}
  if AWizard.Personality <> wzopDelphi then
  begin
    FreeAndNil(AWizard);
    Exit;
  end;
{$ENDIF}
  RegisterPackageWizard(AWizard);
end;

{ TWzOTACustomRepositoryWizard }

function TWzOTACustomRepositoryWizard.GetIDString: string;
begin
  Result := ClassName;
end;

function TWzOTACustomRepositoryWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

function TWzOTACustomRepositoryWizard.GetAuthor: string;
begin
  Result := Author;
end;

function TWzOTACustomRepositoryWizard.GetComment: string;
begin
  Result := '';
end;

function TWzOTACustomRepositoryWizard.GetGlyph: Cardinal;
begin
  Result := 0;
end;

function TWzOTACustomRepositoryWizard.GetPage: string;
begin
  Result := PageName;
end;

function TWzOTACustomRepositoryWizard.GetDesigner: string;
begin
  Result := dVCL;
end;

{$IFDEF DELPHI8}

function  TWzOTACustomRepositoryWizard.GetGalleryCategory: IOTAGalleryCategory;
begin
  result := NIL;
end;

function  TWzOTACustomRepositoryWizard.GetPersonality: string;
begin
  result :=  sDelphiPersonality;
end;


{$ENDIF}



{ TWzOTACustomCreator }
function TWzOTACustomCreator.GetExisting: Boolean;
begin
  Result := False;
end;

function TWzOTACustomCreator.GetFileSystem: string;
begin
  Result := '';
end;

function TWzOTACustomCreator.GetOwner: IOTAModule;
begin
  Result := wzGetActiveProject;
end;

function TWzOTACustomCreator.GetUnnamed: Boolean;
begin
  Result := True;
end;

{ TWzOTAFormCreator }

constructor TWzOTAFormCreator.Create(const AFormTemplate, AImplTemplate, AIntfTemplate: string);
begin
  inherited Create;
  FFormTemplate := AFormTemplate;
  FImplTemplate := AImplTemplate;
  FIntfTemplate := AIntfTemplate;
end;

function TWzOTAFormCreator.ExpandTemplate(
  const ATemplate, AModuleIdent, AFormIdent, AAncestorIdent: string): string;
begin
  Result := ATemplate;
  Result := StringReplace(Result, '%FormIdent%', AFormIdent, [rfReplaceAll]);
  Result := StringReplace(Result, '%AncestorIdent%', AAncestorIdent, [rfReplaceAll]);
  Result := StringReplace(Result, '%ModuleIdent%', AModuleIdent, [rfReplaceAll]);
end;

function TWzOTAFormCreator.GetCreatorType: string;
begin
  Result := sForm;
end;

function TWzOTAFormCreator.GetAncestorName: string;
begin
  Result := '';
end;

function TWzOTAFormCreator.GetFormName: string;
begin
  Result := '';
end;

function TWzOTAFormCreator.GetImplFileName: string;
begin
  Result := '';
end;

function TWzOTAFormCreator.GetIntfFileName: string;
begin
  Result := '';
end;

function TWzOTAFormCreator.GetMainForm: Boolean;
begin
  Result := False;
end;

function TWzOTAFormCreator.GetShowForm: Boolean;
begin
  Result := True;
end;

function TWzOTAFormCreator.GetShowSource: Boolean;
begin
  Result := True;
end;

function TWzOTAFormCreator.NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := CreateOTAFile(FormTemplate, '', FormIdent, AncestorIdent);
end;

function TWzOTAFormCreator.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := CreateOTAFile(ImplTemplate, ModuleIdent, FormIdent, AncestorIdent);
end;

function TWzOTAFormCreator.NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := CreateOTAFile(IntfTemplate, ModuleIdent, FormIdent, AncestorIdent);
end;

procedure TWzOTAFormCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin
end;

function TWzOTAFormCreator.CreateOTAFile(const ATemplate, AModuleIdent, AFormIdent, AAncestorIdent: string): IOTAFile;
begin
  if ATemplate <> '' then
    Result := TOTAFile.Create(ExpandTemplate(ATemplate, AModuleIdent, AFormIdent, AAncestorIdent))
  else
    Result := nil;
end;

{ TWzOTACustomProjectCreator }

function TWzOTACustomProjectCreator.GetOwner: IOTAModule;
begin
  Result := nil;
end;

function TWzOTACustomProjectCreator.GetFileName: string;
begin
  Result := '';
end;

function TWzOTACustomProjectCreator.GetOptionFileName: string;
begin
  Result := '';
end;

function TWzOTACustomProjectCreator.GetShowSource: Boolean;
begin
  Result := False;
end;

function TWzOTACustomProjectCreator.NewOptionSource(const ProjectName: string): IOTAFile;
begin
  Result := nil;
end;

function TWzOTACustomProjectCreator.NewProjectSource(const ProjectName: string): IOTAFile;
begin
  Result := nil; // Default project source
end;

procedure TWzOTACustomProjectCreator.NewDefaultModule;
begin
  // do nothing
end;

procedure TWzOTACustomProjectCreator.NewProjectResource(const Project: IOTAProject);
begin
  // do nothing
end;

procedure TWzOTACustomProjectCreator.NewDefaultProjectModule(const Project: IOTAProject);
begin
  // do nothing
end;

{$IFDEF DELPHI8}
function TWzOTACustomProjectCreator.GetProjectPersonality: string;
begin
  Result := sDelphiPersonality;
end;
{$ENDIF}

{$IFDEF DELPHI16}
function TWzOTACustomProjectCreator.GetFrameworkType: string;
begin
  Result := sFrameworkTypeVCL;
end;

function TWzOTACustomProjectCreator.GetPlatforms: TArray<string>;
begin
  SetLength(Result, 2);
  Result[0] := cWin32Platform;
  Result[1] := cWin64Platform;;
end;

function TWzOTACustomProjectCreator.GetPreferredPlatform: string;
begin
  Result := cWin32Platform;
end;

procedure TWzOTACustomProjectCreator.SetInitialOptions(const NewProject: IOTAProject);
begin
  // do nothing
end;
{$ENDIF}

end.
