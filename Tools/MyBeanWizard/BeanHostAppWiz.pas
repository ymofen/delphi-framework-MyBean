unit BeanHostAppWiz;

{$I WizDefine.inc}

interface

uses
  Classes, Windows, DesignIntf, ToolsApi, DesignEditors, WizHelpers, BeanConst;

const
  HostApplicationWizardComment = '创建 MyBean HOST 程序';
  HostApplicationWizardName = 'MyBean HOST 程序';
  HostFormWizardComment = '创建HOST程序窗体';
  HostFormWizardName = 'HOST程序窗体';

type

  { THostApplicationCreator }

  THostApplicationCreator = class(TWzOTACustomProjectCreator)
  protected
    function NewProjectSource(const ProjectName: string): IOTAFile; override;
    function GetCreatorType: string; override;
  public

  end;

  { THostApplicationWizard }

  THostApplicationWizard = class(TWzOTACustomRepositoryWizard, IOTAProjectWizard)
  protected
    procedure Execute; override;
    function GetIDString: string; override;
    function GetGlyph: Cardinal; override;
    function GetComment: string; override;
    function GetName: string; override;
  end;

  { THostFormCreator }

  THostFormCreator = class(TWzOTAFormCreator)
  public
    constructor Create;
  end;

implementation

uses
  SysUtils;

{ THostApplicationCreator }
function THostApplicationCreator.GetCreatorType: string;
begin
  Result := sApplication;
end;

function THostApplicationCreator.NewProjectSource(
  const ProjectName: string): IOTAFile;
var
  S: string;
begin
  S:= LoadResResource('HOSTPROJ');
  S:= StringReplace(S, '%ProjectName%', ProjectName, [rfReplaceAll]);
  Result := StringToIOTAFile(S);
end;

{ THostApplicationWizard }

procedure THostApplicationWizard.Execute;
var
  AModuleServices: IOTAModuleServices;
begin
  if Supports(BorlandIDEServices, IOTAModuleServices, AModuleServices) then
  begin
    AModuleServices.CreateModule(THostApplicationCreator.Create());
    AModuleServices.CreateModule(THostFormCreator.Create());
  end;
end;

function THostApplicationWizard.GetComment: string;
begin
  Result := HostApplicationWizardComment;
end;

function THostApplicationWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(HInstance, 'HOSTAPP');
end;

function THostApplicationWizard.GetIDString: string;
begin
  Result := '{02A3E09A-F15F-49DD-8EA2-C604683A682A}';
end;

function THostApplicationWizard.GetName: string;
begin
  Result := HostApplicationWizardName;
end;

{ THostFormCreator }

constructor THostFormCreator.Create;
var
  AFormTemplate, AImplTemplate, AIntfTemplate: string;
begin
  AFormTemplate := LoadResResource('HOSTFORM');
  AIntfTemplate := '';
  AImplTemplate := LoadResResource('HOSTFORMUNIT');
  inherited Create(AFormTemplate, AImplTemplate, AIntfTemplate);
end;

end.

