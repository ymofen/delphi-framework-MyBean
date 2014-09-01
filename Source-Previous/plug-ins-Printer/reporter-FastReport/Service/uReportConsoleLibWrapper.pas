unit uReportConsoleLibWrapper;


interface  

uses
  Windows, SysUtils, Classes, Controls, uIReporter, Forms, uIFileAccess;

type
  TReportConsoleLibWrapper = class(TObject)
  public
    class procedure checkInitialize;
    class procedure checkFinalization;
  public
    class function getLastErrorCode: Integer;
    class function getLastErrorDesc: String;

    class function createReportConsole: IReportConsole; overload;
    class function createReportConsole(pvDefaultOperator:IReporterDefaultOperator):
        IReportConsole; overload;
    class function createReporterIM: IReporterIM;
    class function createReporterDefaultOperator(pvUserID:string;
        pvFileAccess:IFileAccess): IReporterDefaultOperator;
  end;

implementation

var
  __Handle:THandle=0;



class procedure TReportConsoleLibWrapper.checkFinalization;
begin
  if __Handle <> 0 then
  begin
    FreeLibrary(__Handle);
    __Handle := 0;
  end;
end;

class procedure TReportConsoleLibWrapper.checkInitialize;
var
  lvPath:String;
begin
  if __Handle = 0 then
  begin
    lvPath := ExtractFilePath(ParamStr(0)) + 'Libs\ReportConsole.dll';
    __Handle := LoadLibrary(PChar(lvPath));
    if __Handle = 0 then
    begin
      raise Exception.Create('加载ReportConsole出错,是否缺少ReportConsole必须的bpl文件?');
    end;
    lvPath := '';
  end;
end;

class function TReportConsoleLibWrapper.createReportConsole: IReportConsole;
var
  lvInvoke:function(pvApplicationHandle: THandle):IReportConsole; stdcall;
begin
  checkInitialize;
  @lvInvoke := nil;
  @lvInvoke := GetProcAddress(__Handle, 'createReportConsole');
  if @lvInvoke = nil then
  begin
    raise Exception.Create('找不到对应的createReporterConsole函数,非法的ReportConsole动态库文件');
  end;
  Result := lvInvoke(Application.Handle);
end;

class function TReportConsoleLibWrapper.createReportConsole(
    pvDefaultOperator:IReporterDefaultOperator): IReportConsole;
var
  lvOpera:IReporterDefaultOperatorSetter;
begin
  Result := createReportConsole;
  if Result.QueryInterface(IReporterDefaultOperatorSetter, lvOpera) = S_OK then
  begin
    lvOpera.setReporterDefaultOperator(pvDefaultOperator);
  end;                                                   
end;

class function TReportConsoleLibWrapper.createReporterDefaultOperator(
    pvUserID:string; pvFileAccess:IFileAccess): IReporterDefaultOperator;
var
  lvInvoke:function(const pvUserID: PAnsiChar; pvFileAccess:
    IFileAccess): IReporterDefaultOperator; stdcall;
  lvUserID:String;
begin
  checkInitialize;
  @lvInvoke := nil;
  @lvInvoke := GetProcAddress(__Handle, 'createReporterDefaultOperator');
  if @lvInvoke = nil then
  begin
    raise Exception.Create('找不到对应的createReporterDefaultOperator函数,非法的ReportConsole动态库文件');
  end;
  lvUserID := pvUserID;
  Result := lvInvoke(PAnsiChar(lvUserID), pvFileAccess); 
  lvUserID := '';
end;

class function TReportConsoleLibWrapper.createReporterIM: IReporterIM;
var
  lvInvoke:function(pvApplicationHandle: THandle):IReporterIM; stdcall;
begin
  checkInitialize;
  @lvInvoke := nil;
  @lvInvoke := GetProcAddress(__Handle, 'createReporterIM');
  if @lvInvoke = nil then
  begin
    raise Exception.Create('找不到对应的createReporterIM函数,非法的ReportConsole动态库文件');
  end;
  Result := lvInvoke(Application.Handle);
end;

class function TReportConsoleLibWrapper.getLastErrorCode: Integer;
var
  lvInvoke:function():Integer; stdcall;
begin
  checkInitialize;
  @lvInvoke := nil;
  @lvInvoke := GetProcAddress(__Handle, 'getLastErrorCode');
  if @lvInvoke = nil then
  begin
    raise Exception.Create('找不到对应的getLastErrorCode函数,非法的ReportConsole动态库文件');
  end;
  Result := lvInvoke();
end;

class function TReportConsoleLibWrapper.getLastErrorDesc: String;
var
  lvInvoke:function():PAnsiChar; stdcall;
begin
  checkInitialize;
  @lvInvoke := nil;
  @lvInvoke := GetProcAddress(__Handle, 'getLastErrorDesc');
  if @lvInvoke = nil then
  begin
    raise Exception.Create('找不到对应的getLastErrorDesc函数,非法的ReportConsole动态库文件');
  end;
  Result := lvInvoke();
end;

initialization

finalization
  TReportConsoleLibWrapper.checkFinalization;


end.
