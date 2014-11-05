unit uEWOTANewModuleExpert;

interface

uses
  {$IFDEF DELPHI5}DsgnIntf,{$ENDIF}
  {$IFDEF DELPHI6UP}DesignEditors,{$ENDIF}
  ToolsAPI, Classes, uEWOTARepositoryExpert;

type
  TEWNewModuleExpert = class(TEWRepositoryExpert, IOTAFormWizard)
  end;

implementation

end.
