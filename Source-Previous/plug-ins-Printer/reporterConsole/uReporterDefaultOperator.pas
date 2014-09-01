unit uReporterDefaultOperator;
////
///    默认报表操作
///


interface

uses
  uIReporter, uIFileAccess, superobject, uFileTools, SysUtils, uJSonTools;

type
  TReporterDefaultOperator = class(TInterfacedObject, IReporterDefaultOperator)
  private
    FFileAccess: IFileAccess;
    FUserID: AnsiString;
    __pass:AnsiString;
  public
    constructor Create(const AUserID: AnsiString; AFileAccess: IFileAccess);

    destructor Destroy; override;
    
      //设置默认的报表
    procedure setDefault(pvCatalogID, pvID:PAnsiChar);stdcall;//设置默认报表

    //获取默认的报表样式
    function getDefault(pvCatalogID:PAnsiChar):PAnsiChar;stdcall;
  end;

implementation

constructor TReporterDefaultOperator.Create(const AUserID: AnsiString;
    AFileAccess: IFileAccess);
begin
  inherited Create;
  FUserID := AUserID;
  FFileAccess := AFileAccess;
end;

destructor TReporterDefaultOperator.Destroy;
begin
  FFileAccess := nil;
  inherited Destroy;
end;

{ TReporterDefaultOperator }

function TReporterDefaultOperator.getDefault(pvCatalogID: PAnsiChar): PAnsiChar;
var
  lvJSon:ISuperObject;
  lvRFile, lvLocalFile:AnsiString;
begin
  __pass := '';
  Result := '';
  lvLocalFile := TFileTools.createTempFileName('rep_', 'jsn');
  lvRFile := 'repDefault_' + FUserID + '.jsn';
  try
    FFileAccess.getFile(PAnsiChar(lvRFile), PAnsiChar(lvLocalFile), 'user_rep', False);
    if SysUtils.FileExists(lvLocalFile) then
    begin
      lvJSon := TJSonTools.JsnParseFromFile(lvLocalFile);
      __pass := lvJSon.S[pvCatalogID];
    end;
    lvRFile := '';
    lvLocalFile := '';
  finally
    if FileExists(lvLocalFile) then SysUtils.DeleteFile(lvLocalFile);
  end;                                
  Result := PAnsiChar(__pass);   
end;

procedure TReporterDefaultOperator.setDefault(pvCatalogID, pvID: PAnsiChar);
var
  lvJSon:ISuperObject;
  lvRFile, lvLocalFile:AnsiString;
begin
  lvLocalFile := TFileTools.createTempFileName('rep_', 'jsn');
  lvRFile := 'repDefault_' + FUserID + '.jsn';
  try
    FFileAccess.getFile(PAnsiChar(lvRFile), PAnsiChar(lvLocalFile), 'user_rep', False);
    if SysUtils.FileExists(lvLocalFile) then
    begin
      lvJSon := TJSonTools.JsnParseFromFile(lvLocalFile);
    end;
    if lvJSon = nil then
    begin
      lvJSon := SO();
    end;
    lvJSon.S[pvCatalogID] := pvID;

    TJSonTools.JsnSaveToFile(lvJSon, lvLocalFile);
    FFileAccess.saveFile(PAnsiChar(lvRFile), PAnsiChar(lvLocalFile), 'user_rep');
    lvRFile := '';
    lvLocalFile := '';
  finally
    if FileExists(lvLocalFile) then SysUtils.DeleteFile(lvLocalFile);
  end;                                
end;

end.
