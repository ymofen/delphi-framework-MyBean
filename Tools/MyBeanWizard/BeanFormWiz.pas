unit BeanFormWiz;

{$I WizDefine.inc}

interface

uses
  Classes, Windows, DesignIntf, ToolsApi, DesignEditors, WizHelpers, BeanConst;


type

  { TBeanFormCreator }
  TBeanFormCreator = class(TWzOTAFormCreator)
  public
    constructor Create();
  end;

  { TBeanFormWizard }
  TBeanFormWizard = class(TWzOTACustomRepositoryWizard
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

{ TBeanFormCreator }

constructor TBeanFormCreator.Create();
var
  AFormTemplate, AImplTemplate, AIntfTemplate: string;
begin
  AFormTemplate := LoadResResource('BEANFORM');
  AIntfTemplate := '';
  AImplTemplate := LoadResResource('BEANFORMUNIT');
  inherited Create(AFormTemplate, AImplTemplate, AIntfTemplate);
end;


{ TBeanFormWizard }

procedure TBeanFormWizard.Execute;
var
  AModuleServices: IOTAModuleServices;
begin
  if Supports(BorlandIDEServices, IOTAModuleServices, AModuleServices) then
    AModuleServices.CreateModule(TBeanFormCreator.Create());
end;

function TBeanFormWizard.GetComment: string;
begin
  Result := '´´½¨Bean Form´°Ìå';
end;

function TBeanFormWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(HInstance, 'FORMBEAN');
end;

function TBeanFormWizard.GetIDString: string;
begin
  result := '{2B4A073E-F1A1-4A36-AC47-0FEB4A148D9C}';
end;

function TBeanFormWizard.GetName: string;
begin
  Result := 'Bean Form';
end;


end.
