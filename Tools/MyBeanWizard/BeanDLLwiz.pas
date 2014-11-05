unit BeanDLLwiz;

{$I WizDefine.inc}

interface

uses
  Classes, Windows, DesignIntf, ToolsApi, DesignEditors, WizHelpers, BeanConst;

const
  DllWizardComment = '´´½¨ MyBean DLL';
  DllWizardName = 'MyBean DLL';

type

  { TDllBeanCreator }

  TDllBeanCreator = class(TWzOTACustomProjectCreator)
  private
  protected
    function NewProjectSource(const ProjectName: string): IOTAFile; override;
    function GetCreatorType: string; override;
  public
    constructor Create(); virtual;
  end;

  { TDllBeanWizard }

  TDllBeanWizard = class(TWzOTACustomRepositoryWizard, IOTAProjectWizard)
  protected
    procedure Execute; override;
    function GetIDString: string; override;
    function GetGlyph: Cardinal; override;
    function GetComment: string; override;
    function GetName: string; override;
  end;

implementation

uses
  SysUtils;

{ TDllBeanCreator }

constructor TDllBeanCreator.Create();
begin
  inherited Create;

end;

function TDllBeanCreator.GetCreatorType: string;
begin
  Result := sLibrary;
end;

function TDllBeanCreator.NewProjectSource(
  const ProjectName: string): IOTAFile;
var
  S: string;
begin
  S:= LoadResResource('DLLPROJ');
  S:= StringReplace(S, '%ProjectName%', ProjectName, [rfReplaceAll]);
  Result := StringToIOTAFile(S);
end;

{ TDllBeanWizard }

procedure TDllBeanWizard.Execute;
var
  AModuleServices: IOTAModuleServices;
begin
  if Supports(BorlandIDEServices, IOTAModuleServices, AModuleServices) then
  begin
    AModuleServices.CreateModule(TDllBeanCreator.Create());
  end;
end;

function TDllBeanWizard.GetComment: string;
begin
  Result := DllWizardComment;
end;

function TDllBeanWizard.GetGlyph: Cardinal;
begin

  Result := LoadIcon(HInstance, 'DLLBEAN');

end;

function TDllBeanWizard.GetIDString: string;
begin
  Result := '{02A373F9-DE9D-4E6B-887E-3B5FEEF968F1}';
end;

function TDllBeanWizard.GetName: string;
begin
  Result := DllWizardName;

end;


end.

