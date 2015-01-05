unit BeanLogicWiz;

{$I WizDefine.inc}

interface

uses
  Classes, Windows, DesignIntf, ToolsApi, DesignEditors, WizHelpers, BeanConst;

type

  { TLogicBeanCreator }
  TLogicBeanCreator = class(TWzOTAFormCreator)
  public
    constructor Create(beanName: string);
  end;

  { TLogicBeanWizard }
  TLogicBeanWizard = class(TWzOTACustomRepositoryWizard
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
  SysUtils,  Controls, BeanProperty;

{ TLogicBeanCreator }

constructor TLogicBeanCreator.Create(beanName: string);
var
  AFormTemplate, AImplTemplate, AIntfTemplate: string;
begin
  AFormTemplate := '';
  AIntfTemplate := '';
  AImplTemplate := LoadResResource('LOGICBEAN');
  AImplTemplate := StringReplace(AImplTemplate, '%BeanName%', beanName, [rfReplaceAll]);
  inherited Create(AFormTemplate, AImplTemplate, AIntfTemplate);
end;


{ TLogicBeanWizard }

procedure TLogicBeanWizard.Execute;
var
  AModuleServices: IOTAModuleServices;
  beanName : string;
begin
  beanName := 'GreenBean';
  beanPropertyDlg := TbeanPropertyDlg.Create(NIL);
  try
    if beanPropertyDlg.ShowModal = mrOK then
    begin
      if trim(beanPropertyDlg.lbEditBeanName.Text)<>'' then
        beanName := beanPropertyDlg.lbEditBeanName.Text;
      if Supports(BorlandIDEServices, IOTAModuleServices, AModuleServices) then
        AModuleServices.CreateModule(TLogicBeanCreator.Create(beanName));
    end;
  finally
    beanPropertyDlg.Free;
  end;
end;

function TLogicBeanWizard.GetComment: string;
begin
  Result := '´´½¨Logic bean';
end;

function TLogicBeanWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(HInstance, 'BEAN');
end;

function TLogicBeanWizard.GetIDString: string;
begin
  result := '{8E39604D-CD03-4401-AD9D-72D2D1258828}';
end;

function TLogicBeanWizard.GetName: string;
begin
  Result := 'Logic Bean';
end;


end.
