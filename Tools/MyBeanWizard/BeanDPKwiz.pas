unit BeanDPKwiz;

{$I WizDefine.inc}

interface

uses
  Classes, Windows, DesignIntf, ToolsApi, DesignEditors, WizHelpers, BeanConst;

const
  dpkWizardComment = '创建 MyBean DPK 包';
  dpkWizardName = 'MyBean DPK 包';

type

  { TdpkBeanCreator }

  TdpkBeanCreator = class(TWzOTACustomProjectCreator)
  protected
    function NewProjectSource(const ProjectName: string): IOTAFile; override;
    function GetCreatorType: string; override;
  end;

  { TdpkBeanWizard }

  TdpkBeanWizard = class(TWzOTACustomRepositoryWizard, IOTAProjectWizard)
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

{ TdpkBeanCreator }
function TdpkBeanCreator.GetCreatorType: string;
begin
  Result := sPackage;
end;

function TdpkBeanCreator.NewProjectSource(
  const ProjectName: string): IOTAFile;
var
  S: string;
begin
  S:= LoadResResource('PACKAGEPROJ');
  S:= StringReplace(S, '%ProjectName%', ProjectName, [rfReplaceAll]);
  Result := StringToIOTAFile(S);
end;

{ TdpkBeanWizard }

procedure TdpkBeanWizard.Execute;
var
  AModuleServices: IOTAModuleServices;
begin
  if Supports(BorlandIDEServices, IOTAModuleServices, AModuleServices) then
  begin
    AModuleServices.CreateModule(TdpkBeanCreator.Create());
  end;
end;

function TdpkBeanWizard.GetComment: string;
begin
  Result := dpkWizardComment;
end;

function TdpkBeanWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(HInstance, 'LIBBEAN');
end;

function TdpkBeanWizard.GetIDString: string;
begin
  Result := '{288A2E59-7EDF-4523-8E2B-4DA12D828289}';
end;

function TdpkBeanWizard.GetName: string;
begin
  Result := dpkWizardName;
end;


end.

