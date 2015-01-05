unit BeanDataModuleWiz;

{$I WizDefine.inc}

interface

uses
  Classes, Windows, DesignIntf, ToolsApi, DesignEditors, WizHelpers, BeanConst;


type

  { TBeanDataModuleCreator }
  TBeanDataModuleCreator = class(TWzOTAFormCreator)
  public
    constructor Create();
    function GetAncestorName: string; override;
  end;

  { TBeanDataModuleWizard }
  TBeanDataModuleWizard = class(TWzOTACustomRepositoryWizard
    {$IFDEF DELPHI8}, IOTAProjectWizard{$ENDIF}
  )
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

{ TBeanDataModuleCreator }

constructor TBeanDataModuleCreator.Create();
var
  AFormTemplate, AImplTemplate, AIntfTemplate: string;
begin
  AFormTemplate := LoadResResource('BEANDATAMODULE');
  AIntfTemplate := '';
  AImplTemplate := LoadResResource('BEANDATAMODULEUNIT');
  inherited Create(AFormTemplate, AImplTemplate, AIntfTemplate);
end;


function TBeanDataModuleCreator.GetAncestorName: string;
begin
  Result := 'DataModule';
end;

{ TBeanDataModuleWizard }

procedure TBeanDataModuleWizard.Execute;
var
  AModuleServices: IOTAModuleServices;
begin
  if Supports(BorlandIDEServices, IOTAModuleServices, AModuleServices) then
    AModuleServices.CreateModule(TBeanDataModuleCreator.Create());
end;

function TBeanDataModuleWizard.GetComment: string;
begin
  Result := '´´½¨Bean DataModule';
end;

function TBeanDataModuleWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(HInstance, 'BEANDATAMUDULE');
end;

function TBeanDataModuleWizard.GetIDString: string;
begin
  result :='{E6CB69AE-737D-469D-98FC-0B35D742DD02}';
end;

function TBeanDataModuleWizard.GetName: string;
begin
  Result := 'Bean DataModule';
end;


end.
