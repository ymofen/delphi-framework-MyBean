unit uEWOTAHelpers;

{$I eDefines.inc}

interface

uses
  {$IFDEF DELPHI5}ComObj,{$ENDIF}
  ToolsAPI, Classes;

function GetDelphiVersion: Integer;

function GetDllPath: String;

function ModuleServices: IOTAModuleServices;
function CurrentProject: IOTAProject;
function ProjectByName(const aName: string): IOTAProject;
function CurrentProjectGroup: IOTAProjectGroup;

function GetUniqueProjectFilename(aProject: IOTAProject; aName: string): string;

function FindModuleByUnitName(const aProject: IOTAProject; const aModuleName: string): IOTAModule;

function RemoveInitialT(const aString:string):string;
function AddInitialT(const aString:string):string;

function ProjectName: string;

function LoadStringFromFile(iFilename:string):string;
procedure SaveStringToFile(const iFilename,iString:string);

function ReplaceVariables(const aString: string; aVariables: TStrings): string;

function ReadModuleSource(const aModule: IOTAModule): string;
procedure WriteModuleSource(const aModule: IOTAModule; const aCode, aHeader: string);
procedure AddOrReplaceNamedModule(const aProject: IOTAProject; aName, aCode: string);

function LanguageFromPersonality(aProject: IOTAProject): string;
function LanguageFromPersonalityEx(aProject: IOTAProject): string;

implementation

uses {$IFDEF MSWINDOWS}Windows, ActiveX, {$ENDIF} SysUtils, Forms, uEWHelpers;

function LoadStringFromFile(iFilename:string):string;
{$IFDEF DELPHI2009UP}
begin
  With TStringList.Create do try
    LoadFromFile(iFilename);
    Result := Text;
  finally
    Free;
  end;
end;
{$ELSE}
var t:text;
    s:string;
begin
  try
    AssignFile(t,iFilename);
    Reset(t);
    try
      result := '';
      while not Eof(t) do begin
        Readln(t,s);
        result := result+s+#13#10;
      end;
    finally
      CloseFile(t);
    end;
  except
    on E:Exception do
      raise EInOutError.Create('Error loading file '+iFilename+' ('+E.ClassName+': '+E.Message+')');
  end;
end;
{$ENDIF}

procedure SaveStringToFile(const iFilename,iString:string);
{$IFDEF DELPHI2009UP}
begin
  With TStringList.Create do try
    Text := iString;
    SaveToFile(iFilename);
  finally
    free;
  end;
end;
{$ELSE}
var t:TextFile;
begin
  try
    AssignFile(t,iFilename);
    Rewrite(t);
    try
      Write(t,iString);
    finally
      CloseFile(t);
    end;
  except
    on E:Exception do
      raise EInOutError.Create('Error saving file '+iFilename+' ('+E.ClassName+': '+E.Message+')');
  end;
end;
{$ENDIF}

function NewGuid:TGUID;
begin
  {$IFDEF MSWINDOWS}
  CoCreateGuid(result);
  {$ENDIF MSWINDOWS}
  {$IFDEF LINUX}
  CreateGuid(result);
  {$ENDIF}
end;

function NewGuidAsString:string;
begin
  result := GuidToString(NewGuid());
end;

function NewGuidAsStringNoBrackets:string;
begin
  result := GuidToString(NewGuid());
  result := Copy(result,2,Length(result)-2);
end;

function ReplaceVariables(const aString: string; aVariables: TStrings): string;
var
  i:integer;
begin
  { No, this isn't efficient code. But given the fact that this is used at designtime and
    in a place where the execution is abolutely not time-critical, clarity is preferable to
    efficiency, imho. mh. }

  result := aString;
  if Assigned(aVariables) then begin
    for i := 0 to aVariables.Count-1 do begin
      result := StringReplace(result,'$('+aVariables.Names[i]+')',aVariables.Values[aVariables.Names[i]],[rfReplaceAll,rfIgnoreCase]);
    end;
  end;
  result := StringReplace(result,'$(NewID)',NewGuidAsString(),[rfReplaceAll,rfIgnoreCase]);
  result := StringReplace(result,'$(NewID2)',NewGuidAsStringNoBrackets(),[rfReplaceAll,rfIgnoreCase]);
end;

function ProjectName: string;
var
  lProjectName:string;
begin
  if Assigned(CurrentProject()) then begin
    lProjectName := (CurrentProject as IOTAModule).FileName;
    lProjectName := ChangeFileExt(ExtractFileName(lProjectName),'');
  end
  else begin
    lProjectName := '';
  end;
  result := lProjectName;
end;

function RemoveInitialT(const aString:string):string;
begin
  result := aString;
  if (result <> '') and (result[1] = 'T') then Delete(result,1,1);
end;

function AddInitialT(const aString:string):string;
begin
  result := aString;
  if (result <> '') and (result[1] <> 'T') then result := 'T'+result;
end;

function GetDllPath: String;
var TheFileName : array[0..MAX_PATH] of char;
begin
  FillChar(TheFileName, SizeOf(TheFileName), #0);
  {$IFDEF KYLIX}System.{$ENDIF}GetModuleFileName(hInstance, TheFileName, sizeof(TheFileName));
  Result := ExtractFilePath(TheFileName);
end;

function ModuleServices: IOTAModuleServices;
begin
  result := (BorlandIDEServices as IOTAModuleServices);
end;

function CurrentProject: IOTAProject;
var
  services: IOTAModuleServices;
  module: IOTAModule;
  project: IOTAProject;
  projectgroup: IOTAProjectGroup;
  multipleprojects: Boolean;
  i: Integer;
begin
  result := nil;

  multipleprojects := False;
  services := ModuleServices;

  if (services = nil) then Exit;

  for I := 0 to (services.ModuleCount - 1) do begin
    module := services.Modules[I];
    if (module.QueryInterface(IOTAProjectGroup, ProjectGroup) = S_OK) then begin
      result := ProjectGroup.ActiveProject;
      Exit;
    end

    else if module.QueryInterface(IOTAProject, Project) = S_OK then begin
      if (result = nil) then
        result := Project // Found the first project, so save it
      else
        multipleprojects := True; // It doesn't look good, but keep searching for a project group
    end;
  end;

  if multipleprojects then result := nil;
end;

function ProjectByName(const aName: string): IOTAProject;
var
  services: IOTAModuleServices;
  module: IOTAModule;
  project: IOTAProject;
  i: Integer;
begin
  result := nil;

  services := ModuleServices;

  if (services = nil) then Exit;

  for I := 0 to (services.ModuleCount - 1) do begin
    module := services.Modules[I];
    if module.QueryInterface(IOTAProject, Project) = S_OK then begin
      if module.FileName = aName then begin
        result := Project;
        exit;
      end;
    end;
  end;
end;

function CurrentProjectGroup: IOTAProjectGroup;
var
  services: IOTAModuleServices;
  i: Integer;
begin
  Result := nil;
  services := ModuleServices;
  for i := 0 to ModuleServices.ModuleCount - 1 do begin
    if Supports(ModuleServices.Modules[i], IOTAProjectGroup, Result) then begin
      Break;
    end;
  end;
end;

function GetUniqueProjectFilename(aProject: IOTAProject; aName: string): string;
var
  lBaseName, lName: string;
  lCount: integer;

  function ProjectHasFile: boolean;
  var
    i: integer;
  begin
    result := false;
    for i := 0 to aProject.GetModuleCount-1 do begin
      if (aProject.GetModule(i).Name = lName) or (aProject.GetModule(i).Name = ChangeFileExt(lName, '')) then begin
        result := true;
        break;
      end;
    end;
  end;

begin
  lName := aName;
  lBaseName := ChangeFileExt(aName, '');
  lCount := 0;
  while ProjectHasFile() do begin
    inc(lCount);
    lName := lBaseName+IntToStr(lCount)+ExtractFileExt(aName);
  end;
  result := lName;
end;

function FindModuleByUnitName(const aProject: IOTAProject; const aModuleName: string): IOTAModule;
var
  i: integer;
begin
  result := nil;
  for i := 0 to aProject.GetModuleCount - 1 do
    if (CompareText(ExtractFileName(aModuleName), ExtractFileName(aProject.GetModule(i).FileName)) = 0) then begin
      result := aProject.GetModule(i).OpenModule;
      Exit;
    end;
end;


const
  MaxSourceSize = 10000;

function ReadModuleSource(const aModule: IOTAModule): String;
var
  l, i: integer;
  editor: IOTASourceEditor;
  reader: IOTAEditReader;
  lSource: AnsiString;
begin
  result := '';
  with aModule do
    for i := 0 to GetModuleFileCount - 1 do begin
      if Supports(GetModuleFileEditor(i), IOTASourceEditor, editor) then begin
        // TODO: find a way not to depend on files smaller than 10k... I only use this for DPRs so it's fine for now
        SetLength(lSource, MaxSourceSize);
        //l := 0; to remove warning

        reader := editor.CreateReader;
        l := reader.GetText(0, @lSource[1], MaxSourceSize);
        reader := nil;
        SetLength(lSource, l);

        result := {$IFDEF DELPHI2009UP}UTF8ToString{$ENDIF}(lSource);
        Exit;
      end;
    end;
end;

procedure WriteModuleSource(const aModule: IOTAModule; const aCode, aHeader: string);
var
  i: integer;
  lEditor: IOTASourceEditor;
  writer: IOTAEditWriter;
begin
  with aModule do begin
    for i := 0 to GetModuleFileCount - 1 do begin
      if Supports(GetModuleFileEditor(i), IOTASourceEditor, lEditor) then begin
        if LowerCase(ExtractFileExt(GetModuleFileEditor(i).FileName)) = '.h' then begin
          if aHeader <> '' then begin
            writer := lEditor.CreateWriter;
            writer.DeleteTo(MaxInt);
            writer.Insert(PAnsiChar({$IFDEF DELPHI2009UP}UTF8Encode{$ENDIF}(aHeader)));
            writer := nil;
          end;
        end
        else begin
          writer := lEditor.CreateWriter;
          writer.DeleteTo(MaxInt);
          writer.Insert(PAnsiChar({$IFDEF DELPHI2009UP}UTF8Encode{$ENDIF}(aCode)));
          writer := nil;
        end;
      end;
    end;
  end;
end;

procedure AddOrReplaceNamedModule(const aProject: IOTAProject; aName, aCode: string);
var
  lModule: IOTAModule;
begin
  lModule := FindModuleByUnitName(aProject, aName);
  if assigned(lModule) then begin
    WriteModuleSource(lModule, aCode, '');
  end
  else begin
    aName :=  ExtractFilePath(CurrentProject.FileName)+aName;
    SaveStringToFile(aName, aCode);
    CurrentProject.AddFile(aName, true);
    lModule := FindModuleByUnitName(CurrentProject, aName);
    {$IFDEF DELPHI9UP}
    if assigned(lModule) then lModule.Show();
    {$ENDIF DELPHI9UP}
  end;
end;

function GetDelphiVersion: Integer;
begin
{$IFDEF DELPHI5}
  result := 5;
{$ELSE}
{$IFDEF DELPHI2007}
  result := 11;
{$ELSE}
{$IFDEF DELPHI2010}
  result := 14;
{$ELSE}
{$IFDEF DELPHI2011}
  result := 15;
{$ELSE}
{$IFDEF DELPHIXE2}
  result := 16;
{$ELSE}
{$IFDEF DELPHIXE3}
  result := 17;
{$ELSE}
{$IFDEF DELPHIXE4}
  result := 18;
{$ELSE}
{$IFDEF DELPHIXE5}
  result := 19;
{$ELSE}
  result := Trunc(RTLVersion)-8;
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
end;

function LanguageFromPersonality(aProject: IOTAProject): string;
{$IFDEF BDS}
var s: string;
{$ENDIF}
begin
  {$IFDEF BDS}
  s := aProject.Personality;
  if s = sDelphiPersonality then result := 'Delphi for Win32'
  else if s = sDelphiDotNetPersonality then result := 'Delphi for .NET'
  else if s = sCSharpPersonality then result := 'C#'
  else if s = sVBPersonality then result := 'Visual Basic'
  else if s = sCBuilderPersonality then result := 'C++'
  else result := 'Unknown';
  {$ELSE}
  result := 'Delphi for Win32';
  {$ENDIF}
end;

function LanguageFromPersonalityEx(aProject: IOTAProject): string;
begin
  result := LanguageFromPersonality(aProject);
  {$IFDEF BDS}
  if result = 'Delphi for .NET' then
    result := result+'/'+IntToStr(GetDelphiVersion);
  {$ENDIF}
end;

end.
