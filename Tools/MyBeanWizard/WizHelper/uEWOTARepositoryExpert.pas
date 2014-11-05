unit uEWOTARepositoryExpert;

{$I eDefines.inc}

interface

uses
  {$IFDEF DELPHI5}DsgnIntf,{$ENDIF}
  {$IFDEF DELPHI6UP}DesignEditors,{$ENDIF}
  Windows, Classes, ToolsAPI;

{$IFNDEF BDS}
const
  sDelphiPersonality = 'Delphi.Personality';
{$ENDIF}

{$IFDEF DELPHI5}
  dAny = 'Any';
{$ENDIF}

type
  TEWRepositoryExpert = class(TInterfacedObject, IOTAWizard, IOTARepositoryWizard{$IFDEF DELPHI6UP}, IOTARepositoryWizard60{$ENDIF} {$IFDEF BDS}, IOTARepositoryWizard80{$ENDIF})
  private
    fIcon: Cardinal;
    fPersonality: string;
  protected
    procedure AfterSave; virtual;
    procedure BeforeSave; virtual;
    procedure Destroyed; virtual;
    procedure Modified; virtual;

    procedure Execute; virtual;
    function GetAuthor: String; virtual;
    function GetComment: String; virtual;
    function GetGlyph: {$IFDEF DELPHI5}HICON{$ELSE}Cardinal{$ENDIF};
    function GetIDString: String;
    function GetInternalIDString: String; virtual; abstract;
    function GetName: String; virtual; abstract;
    function GetPage: String; virtual; abstract;
    function GetState: TWizardState; virtual;
    function GetDesigner: String; virtual;

    {$IFDEF BDS}
    function GetGalleryCategory: IOTAGalleryCategory; virtual;
    {$ENDIF}
    function GetPersonality: string; virtual;

    function LoadGlyph: Cardinal; virtual;

    function CreateNewModuleFromTemplateFile(const aTemplateFile: string; const aName, aAncestor: string; aVariables: TStrings=nil):IOTAModule;
    function CreateNewModuleFromString(const aTemplateString: string; const aName, aAncestor: string; aVariables: TStrings=nil):IOTAModule;
    function CreateNewProject:IOTAProject;
    function CreateNewProjectFromTemplateFile(aTemplateFile: string; aProjectFileName: string; aVariables: TStrings=nil):IOTAProject;
    function CreateNewProjectFromTemplateFolder(const aTemplateFileName: string; const aProjectFileName: string; aVariables: TStrings=nil):IOTAProject;

  public
    constructor Create(aPersonality: string = sDelphiPersonality);
  end;


implementation

uses
  SysUtils, uEWOTAWizards, Dialogs, uEWOTAHelpers;

{ TEWRepositoryExpert }

procedure TEWRepositoryExpert.AfterSave;
begin

end;

procedure TEWRepositoryExpert.BeforeSave;
begin

end;

constructor TEWRepositoryExpert.Create(aPersonality: string);
begin
  fPersonality := aPersonality;
end;

function TEWRepositoryExpert.CreateNewModuleFromString(const aTemplateString, aName, aAncestor: string; aVariables: TStrings): IOTAModule;
var
  lModuleServices: IOTAModuleServices;
//  lSourceTemplate,lDfmTemplate: string;
//  lDfmTemplateFile: string;
begin
  if BorlandIDEServices.QueryInterface(IOTAModuleServices, lModuleServices) = S_OK then
    result := lModuleServices.CreateModule(TEWFormCreator.Create(aTemplateString,
                                                                 '',
                                                                 aName, aAncestor, aVariables));
end;

function TEWRepositoryExpert.CreateNewModuleFromTemplateFile(const aTemplateFile: string; const aName, aAncestor: string; aVariables: TStrings):IOTAModule;
var
  lModuleServices: IOTAModuleServices;
  lSourceTemplate,lDfmTemplate: string;
  lDfmTemplateFile: string;
begin
  lSourceTemplate := LoadStringFromFile(aTemplateFile);

  lDfmTemplate := '';
  lDfmTemplateFile := ChangeFileExt(aTemplateFile,'.dfm');
  if FileExists(lDfmTemplateFile) then begin
    lDfmTemplate := LoadStringFromFile(lDfmTemplateFile);
  end;

  if BorlandIDEServices.QueryInterface(IOTAModuleServices, lModuleServices) = S_OK then
    result := lModuleServices.CreateModule(TEWFormCreator.Create(lSourceTemplate,
                                                                 lDfmTemplate,
                                                                 aName, aAncestor, aVariables));
end;

function TEWRepositoryExpert.CreateNewProject: IOTAProject;
var
  lModuleServices: IOTAModuleServices;
begin
  if BorlandIDEServices.QueryInterface(IOTAModuleServices, lModuleServices) = S_OK then
    result := lModuleServices.CreateModule(TEWProjectCreator.Create('', '', nil)) as IOTAProject;
end;

function TEWRepositoryExpert.CreateNewProjectFromTemplateFile(aTemplateFile: string; aProjectFileName: string; aVariables: TStrings): IOTAProject;
{$IFNDEF BDS}
var
  lModuleServices: IOTAModuleServices;
{$ENDIF}
begin
  result := NIL;
  {$IFDEF BDS} // AleF: Fixed a typo here. It said BSD!!!
  aProjectFileName := ChangeFileExt(aProjectFileName, '.bdsproj');
  if FileExists(aProjectFileName) then begin
    (BorlandIDEServices as IOTAActionServices).OpenProject(aProjectFileName, false); // Vynnyk: Rolled back - because not compilable
     result := (BorlandIDEServices as IOTAModuleServices).GetActiveProject;
  end;
  {$ELSE}
  if BorlandIDEServices.QueryInterface(IOTAModuleServices, lModuleServices) = S_OK then begin
    result := lModuleServices.CreateModule(TEWProjectCreator.Create(aTemplateFile, aProjectFileName, aVariables)) as IOTAProject;
  end;
  {$ENDIF}
end;

function TEWRepositoryExpert.CreateNewProjectFromTemplateFolder(const aTemplateFileName: string; const aProjectFileName: string; aVariables: TStrings): IOTAProject;
var
  lString, lName, lFileExt: string;
  lOk: dword;
  lTemplateFolder, lProjectFolder: string;
  lSearch: TSearchRec;
begin
  lTemplateFolder := ExtractFilePath(aTemplateFileName);
  lProjectFolder := ExtractFilePath(aProjectFileName);

  if not FileExists(aTemplateFileName) then
    raise Exception.Create('Template not found at '+ExtractFilePath(aTemplateFileName));

  lOk := FindFirst(lTemplateFolder+'*.*',faAnyFile,lSearch);
  try
    while lOk = 0 do try
      if (lSearch.Attr and faDirectory) = 0 then begin
        {$IFNDEF BDS}
        if ExtractFileExt(lSearch.Name) = '.bdsproj' then
          Continue;
        {$ENDIF}

        lFileExt := ExtractFileExt(lSearch.Name);
        lName := ReplaceVariables(lSearch.Name, aVariables);
        if SameText(lFileExt,'.res') then begin
          CopyFile(pChar(lTemplateFolder+lSearch.Name), pChar(lProjectFolder+lName),false);
        end
        else begin
          lString := ReplaceVariables(LoadStringFromFile(lTemplateFolder+lSearch.Name), aVariables);
          SaveStringToFile(lProjectFolder+lName,lString);
        end;
      end;
    finally
      lOk := FindNext(lSearch);
    end;    { while }
  finally
    FindClose(lSearch);
  end;
  result := CreateNewProjectFromTemplateFile(aTemplateFileName, aProjectFileName, aVariables);
end;

procedure TEWRepositoryExpert.Destroyed;
begin
end;

procedure TEWRepositoryExpert.Execute;
begin
end;

function TEWRepositoryExpert.GetAuthor: String;
begin
  result := 'RemObjects Software'
end;

function TEWRepositoryExpert.GetComment: String;
begin

end;

function TEWRepositoryExpert.GetDesigner: String;
begin
  Result := dAny;
end;

function TEWRepositoryExpert.GetGlyph: {$IFDEF DELPHI5}HICON{$ELSE}Cardinal{$ENDIF};
begin
  { We'll cache the Glpyh locally so it won't be loaded again and again.
    Apparently Delphi doesn't free the Glpyh, so this would leak otherwise }

  if fIcon = 0 then fIcon := LoadGlyph();
  result := fIcon;
end;

function TEWRepositoryExpert.GetIDString: String;
begin
  result := GetInternalIDString+'.'+fPersonality;
end;

function TEWRepositoryExpert.LoadGlyph: Cardinal;
begin
  result := LoadIcon(hInstance,'EverwoodWizardStandardIcon');
end;


function TEWRepositoryExpert.GetState: TWizardState;
begin
  result := [wsEnabled];
end;

procedure TEWRepositoryExpert.Modified;
begin

end;

{$IFDEF BDS}
function TEWRepositoryExpert.GetGalleryCategory: IOTAGalleryCategory;
var
  lGalleryCategory: string;
  lGalleryManager: IOTAGalleryCategoryManager;
  lGallery: IOTAGalleryCategory;
begin
  if fPersonality = sDelphiPersonality then
    lGalleryCategory := sCategoryDelphiNew
  else if fPersonality = sCBuilderPersonality then
    lGalleryCategory := sCategoryCBuilderNew
  else if fPersonality = sDelphiDotNetPersonality then
    lGalleryCategory := sCategoryDelphiDotNetNew
  else if fPersonality = sCSharpPersonality then
    lGalleryCategory := sCategoryCSharpNew
  else if fPersonality = sVBPersonality then
    lGalleryCategory := sCategoryVBNew
  else
    exit;

  lGalleryManager := (BorlandIDEServices as IOTAGalleryCategoryManager);

  lGallery := lGalleryManager.FindCategory(lGalleryCategory);
  if assigned(lGallery) then begin

    if fPersonality = sVBPersonality then
      ShowMessage(lGalleryCategory+' '+fPersonality+' '+GetName+ ' - '+lGallery.DisplayName);

    result := lGalleryManager.FindCategory(GetPage());
    if not assigned(result) then begin
      lGalleryManager.AddCategory(lGallery, GetPage()+'.'+fPersonality, GetPage());
    end;
  end
  else begin
    result := lGalleryManager.FindCategory(sCategoryGalileoOther);
  end;

end;
{$ENDIF}

function TEWRepositoryExpert.GetPersonality: string;
begin
  result := fPersonality;
end;

end.


