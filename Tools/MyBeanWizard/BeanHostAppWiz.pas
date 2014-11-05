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
  private
  protected
    function NewProjectSource(const ProjectName: string): IOTAFile; override;
    function GetCreatorType: string; override;
  public
    constructor Create; virtual;
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
  private
  protected

  public
    constructor Create;
    //
  end;

  { THostFormWizard }

  THostFormWizard = class(TWzOTACustomRepositoryWizard
    {$IFDEF DELPHI8}, IOTAProjectWizard{$ENDIF}
  )
  protected
    procedure Execute; override;
    function GetIDString: string; override;
    function GetComment: string; override;
    function GetName: string; override;
  end;

implementation

uses
  SysUtils;

{ THostApplicationCreator }

constructor THostApplicationCreator.Create;
begin
  inherited Create;
end;

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
//  LoadTemplates(APersonality, AFormTemplate, AImplTemplate, AIntfTemplate);
  AFormTemplate := LoadResResource('HOSTFORM');
  AIntfTemplate := '';
  AImplTemplate := LoadResResource('HOSTFORMUNIT');
  inherited Create(AFormTemplate, AImplTemplate, AIntfTemplate);
end;


{ THostFormWizard }

procedure THostFormWizard.Execute;
var
  AModuleServices: IOTAModuleServices;
begin
  if Supports(BorlandIDEServices, IOTAModuleServices, AModuleServices) then
    AModuleServices.CreateModule(THostFormCreator.Create());
end;

function THostFormWizard.GetComment: string;
begin
  Result := HostFormWizardComment;
end;

function THostFormWizard.GetIDString: string;
begin
  Result := '{6558DE12-35D8-426F-8230-E5B4102EFAFE}';
end;

function THostFormWizard.GetName: string;
begin
  Result := HostFormWizardName;
end;

end.

