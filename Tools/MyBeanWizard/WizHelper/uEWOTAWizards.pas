unit uEWOTAWizards;

{----------------------------------------------------------------------------}
{ RemObjects' Everwood - IDE Library
{
{ compiler: Delphi 6 and up, Kylix 3 and up
{ platform: Win32, Linux
{
{ (c)opyright RemObjects Software. all rights reserved.
{
{ Using this code requires a valid license of Everwood
{ which can be obtained at http://www.remobjects.com.
{----------------------------------------------------------------------------}

{$I eDefines.inc}

interface

uses
  {$IFDEF DELPHI5}DsgnIntf,{$ENDIF}
  {$IFDEF DELPHI6UP}DesignEditors,{$ENDIF}
  SysUtils, Classes,
  Dialogs, ToolsAPI;

type
  TEWSourceFile = class(TInterfacedObject, IOTAFile)
  private
    fAge: TDateTime;
    fSource:string;
  public
    function GetSource: string;
    function GetAge: TDateTime;
    constructor Create(const iSource:string);
  end;

  TEWCreator = class(TInterfacedObject, IOTACreator)
  private
    fVariables: TStrings;
    fAncestorName: String;
    fName: string;
  public
    constructor Create(const aName, aAncestorName:string; aVariables:TStrings);
    destructor Destroy; override;

    function GetCreatorType: string; virtual; abstract;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule; virtual;
    function GetUnnamed: Boolean; virtual;

    function CreateOTAFile(const aTemplate: string; const ModuleIdent: string=''; const FormIdent: string =''; const AncestorIdent: string=''): IOTAFile;

  end;

  TEWFormCreator = class(TEWCreator, IOTAModuleCreator)
  public
    constructor Create(const aCodeTemplate, aDfmTemplate, aName, aAncestor:string; aVariables:TStrings);

    function GetCreatorType: string; override;

    function GetAncestorName: string;
    function GetImplFileName: string;
    function GetIntfFileName: string;
    function GetFormName: string;
    function GetMainForm: Boolean;
    function GetShowForm: Boolean;
    function GetShowSource: Boolean;
    function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
    function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;

    procedure FormCreated(const FormEditor: IOTAFormEditor);

  private
    fCodeTemplate, fDfmTemplate: String;
  end;

  TEWProjectCreator = class(TEWCreator, IOTAProjectCreator, IOTAProjectCreator50{$IFDEF BDS}, IOTAProjectCreator80{$ENDIF})
  public
    constructor Create(const aCodeTemplateFile, aName:string; aVariables:TStrings);

    function GetCreatorType: string; override;
    function GetOwner: IOTAModule; override;
    function GetUnnamed: Boolean; override;

    function GetFileName: string;
    function GetOptionFileName: string;
    function GetShowSource: Boolean;
    procedure NewDefaultModule;
    function NewOptionSource(const ProjectName: string): IOTAFile;
    procedure NewProjectResource(const Project: IOTAProject);
    function NewProjectSource(const ProjectName: string): IOTAFile;

    procedure NewDefaultProjectModule(const Project: IOTAProject); virtual;

    {$IFDEF BDS}
    function GetProjectPersonality: string;
    {$ENDIF}

  private
    fCodeTemplateFile: string;
  end;

implementation

uses
  uEWOTAHelpers, Windows;

{ TEWCreator }

constructor TEWCreator.Create(const aName, aAncestorName:string; aVariables:TStrings);
begin
  fName := aName;
  fAncestorName := aAncestorName;
  fVariables := aVariables;
end;

destructor TEWCreator.Destroy;
begin
  inherited;
end;

function TEWCreator.GetExisting: Boolean;
begin
  result := false;
end;

function TEWCreator.GetFileSystem: string;
begin
  result := '';
end;

function TEWCreator.GetOwner: IOTAModule;
begin
  result := CurrentProject();
end;

function TEWCreator.GetUnnamed: Boolean;
begin
  result := true;
end;

function TEWCreator.CreateOTAFile(const aTemplate: string; const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
var
  i: integer;
  lCode: string;
begin
  lCode := aTemplate;

  { No, this isn't efficient code. But given the fact that this is used at designtime and
    in a place where the execution is abolutely not time-critical, clarity is preferable to
    efficiency, imho. mh. }

  if ModuleIdent <> '' then begin
    lCode := StringReplace(lCode,'$(Module)',ModuleIdent,[rfReplaceAll,rfIgnoreCase]);
  end;
  if FormIdent <> '' then begin
    lCode := StringReplace(lCode,'$(FormName)',RemoveInitialT(FormIdent),[rfReplaceAll,rfIgnoreCase]);
    lCode := StringReplace(lCode,'$(FormClass)',AddInitialT(FormIdent),[rfReplaceAll,rfIgnoreCase]);
  end;
  if AncestorIdent <> ''then begin
    lCode := StringReplace(lCode,'$(Ancestor)',AncestorIdent,[rfReplaceAll,rfIgnoreCase]);
  end;
  lCode := StringReplace(lCode,'$(Project)',ProjectName,[rfReplaceAll,rfIgnoreCase]);
  if Assigned(fVariables) then begin
    for i := 0 to fVariables.Count-1 do begin
      lCode := StringReplace(lCode,'$('+fVariables.Names[i]+')',fVariables.Values[fVariables.Names[i]],[rfReplaceAll,rfIgnoreCase]);
    end;
  end;
  lCode := StringReplace(lCode,'$((','$(',[rfReplaceAll,rfIgnoreCase]);
  {$IFDEF DEBUG_EVERWOOD_SHOW_NEW_MODULE_CODE}
  ShowMessage(lCode);
  {$ENDIF DEBUG_EVERWOOD_SHOW_NEW_MODULE_CODE}
  result := TEWSourceFile.Create(lCode);
end;

{ TEWFormCreator }

constructor TEWFormCreator.Create(const aCodeTemplate, aDfmTemplate, aName, aAncestor: string; aVariables: TStrings);
begin
  inherited Create(aName, aAncestor, aVariables);
  fCodeTemplate := aCodeTemplate;
  fDfmTemplate := aDfmTemplate;
end;

function TEWFormCreator.GetCreatorType: string;
begin
  result := sForm;
end;

procedure TEWFormCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin

end;

function TEWFormCreator.GetAncestorName: string;
begin
  result := fAncestorName;
end;

function TEWFormCreator.GetFormName: string;
begin
  result := '';
end;

function TEWFormCreator.GetImplFileName: string;
begin
  result := IncludeTrailingPathDelimiter(ExtractFilePath(CurrentProject.FileName))+GetUniqueProjectFilename(CurrentProject, fName);
end;

function TEWFormCreator.GetIntfFileName: string;
begin
  result := '';
end;

function TEWFormCreator.GetMainForm: Boolean;
begin
  result := false;
end;

function TEWFormCreator.GetShowForm: Boolean;
begin
  result := true;
end;

function TEWFormCreator.GetShowSource: Boolean;
begin
  result := true;
end;

function TEWFormCreator.NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
begin
  {$IFDEF DEBUG_EVERWOOD_SHOW_NEW_MODULE_CODE}
  ShowMessage('dfm: '+FormIdent+' - '+AncestorIdent);
  {$ENDIF DEBUG_EVERWOOD_SHOW_NEW_MODULE_CODE}
  result := TEWSourceFile.Create(Format(fDfmTemplate,['',RemoveInitialT(FormIdent),ProjectName]));
  result := CreateOTAFile(fDfmTemplate, '$(Module)', FormIdent, AncestorIdent);
end;

function TEWFormCreator.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  {$IFDEF DEBUG_EVERWOOD_SHOW_NEW_MODULE_CODE}
  ShowMessage('pas: '+ModuleIdent+' - '+FormIdent+' - '+AncestorIdent);
  {$ENDIF DEBUG_EVERWOOD_SHOW_NEW_MODULE_CODE}
  result := CreateOTAFile(fCodeTemplate, ModuleIdent, FormIdent, AncestorIdent);
end;

function TEWFormCreator.NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
begin
  result := nil;
end;

{ TEWProjectCreator }

constructor TEWProjectCreator.Create(const aCodeTemplateFile, aName: string; aVariables: TStrings);
begin
  inherited Create(aName, '', aVariables);
  fCodeTemplateFile := aCodeTemplateFile;
end;

function TEWProjectCreator.GetCreatorType: string;
begin
  result := sLibrary;
end;

function TEWProjectCreator.GetFileName: string;
begin
  result := fName;
end;

function TEWProjectCreator.GetOptionFileName: string;
begin
  result := '';
end;

function TEWProjectCreator.GetOwner: IOTAModule;
begin
  result := CurrentProjectGroup;
end;

function TEWProjectCreator.GetShowSource: Boolean;
begin
  result := false;
end;

function TEWProjectCreator.GetUnnamed: Boolean;
begin
  result := (fName = '');
end;

procedure TEWProjectCreator.NewDefaultModule;
begin

end;

procedure TEWProjectCreator.NewDefaultProjectModule(const Project: IOTAProject);
begin
end;

{$IFDEF BDS}
function TEWProjectCreator.GetProjectPersonality: string;
begin
  result := sDelphiPersonality;
end;
{$ENDIF}

function TEWProjectCreator.NewOptionSource(const ProjectName: string): IOTAFile;
begin
  result := nil;
end;

procedure TEWProjectCreator.NewProjectResource(const Project: IOTAProject);
begin
  CopyFile(pChar(ChangeFileExt(fCodeTemplateFile,'.res')),pChar(ChangeFileExt(Project.FileName,'.res')),false);
end;

function TEWProjectCreator.NewProjectSource(const ProjectName: string): IOTAFile;
begin
  //ShowMessage('x:'+ProjectName);
  if fCodeTemplateFile <> '' then
    result := CreateOTAFile(LoadStringFromFile(fCodeTemplateFile),ProjectName)
  else
    result := nil;
end;

{ TEWSourceFile }

constructor TEWSourceFile.Create(const iSource: string);
begin
  inherited Create();
  fSource := iSource;
  fAge := Now;
end;

function TEWSourceFile.GetAge: TDateTime;
begin
  result := fAge;
end;

function TEWSourceFile.GetSource: string;
begin
  result := fSource;
end;

end.
