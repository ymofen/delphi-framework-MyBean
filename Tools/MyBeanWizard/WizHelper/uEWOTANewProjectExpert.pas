unit uEWOTANewProjectExpert;

interface

uses
  {$IFDEF DELPHI5}DsgnIntf,{$ENDIF}
  {$IFDEF DELPHI6UP}DesignEditors,{$ENDIF}
  ToolsAPI, Classes, uEWOTARepositoryExpert;

type
  TEWNewProjectExpert = class(TEWRepositoryExpert, IOTAProjectWizard)
  end;

implementation

end.
