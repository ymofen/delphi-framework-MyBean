unit NewInterface;

{$I WizDefine.inc}

interface

uses
  Classes, Windows, DesignIntf, ToolsApi, DesignEditors, WizHelpers, BeanConst;

type

  { TBeanInterfaceCreator }
  TBeanInterfaceCreator = class(TWzOTAFormCreator)
  public
    constructor Create(IntfName: string);
  end;

  { TBeanInterfaceWizard }

  TBeanInterfaceWizard = class(TWzOTACustomRepositoryWizard
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
  SysUtils,  Vcl.Controls, BeanProperty;

{ TBeanInterfaceCreator }

constructor TBeanInterfaceCreator.Create(IntfName: string);
var
  AFormTemplate, AImplTemplate, AIntfTemplate: string;
begin
  AFormTemplate := '';
  AIntfTemplate := '';
  AImplTemplate := LoadResResource('BEANINTERFACEUNIT');
  AImplTemplate := StringReplace(AImplTemplate, '%IntfName%', IntfName, [rfReplaceAll]);
  inherited Create(AFormTemplate, AImplTemplate, AIntfTemplate);
end;


{ TBeanInterfaceWizard }

procedure TBeanInterfaceWizard.Execute;
var
  AModuleServices: IOTAModuleServices;
  beanName : string;
begin
  beanName := 'AInterface';
  beanPropertyDlg := TbeanPropertyDlg.Create(NIL);
  try
    if beanPropertyDlg.ShowModal = mrOK then
    begin
      if trim(beanPropertyDlg.lbEditBeanName.Text)<>'' then
        beanName := beanPropertyDlg.lbEditBeanName.Text;
      if Supports(BorlandIDEServices, IOTAModuleServices, AModuleServices) then
        AModuleServices.CreateModule(TBeanInterfaceCreator.Create(beanName));
    end;
  finally
    beanPropertyDlg.Free;
  end;
end;

function TBeanInterfaceWizard.GetComment: string;
begin
  Result := '创建接口文件';
end;

function TBeanInterfaceWizard.GetGlyph: Cardinal;
begin
  Result := LoadIcon(HInstance, 'BEANINTERFACE');

end;

function TBeanInterfaceWizard.GetIDString: string;
begin
  result := '{4B872CF9-3B49-44D2-87C2-69A5EA952982}';
end;

function TBeanInterfaceWizard.GetName: string;
begin
  Result := '接口文件';
end;

end.
