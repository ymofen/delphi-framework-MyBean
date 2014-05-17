unit uErrorINfoTools;

interface

uses
  SysUtils;

type
  TErrorINfoTools = class(TObject)
  public
    class procedure checkRaiseErrorINfo(const pvIntf: IInterface);
  end;

implementation

uses
  uIErrorINfo;

class procedure TErrorINfoTools.checkRaiseErrorINfo(const pvIntf: IInterface);
var
  lvErr:IErrorINfo;
  lvErrCode:Integer;
  lvErrDesc:AnsiString;
  j:Integer;
begin
  if pvIntf = nil then exit;
  if pvIntf.QueryInterface(IErrorINfo, lvErr) = S_OK then
  begin
    lvErrCode := lvErr.getErrorCode;
    if lvErrCode <> 0  then
    begin
      j:=lvErr.getErrorDesc(nil, 0);

      if j = 0 then
      begin
        lvErrDesc := '未知的错误信息';
      end else
      begin
        if j > 2048 then j := 2048;
        SetLength(lvErrDesc, j + 1);
        j := lvErr.getErrorDesc(PAnsiChar(lvErrDesc), j);
        lvErrDesc[j+1] := #0;
      end;

      if lvErrCode = -1 then
      begin
        raise Exception.Create(string(lvErrDesc));
      end else
      begin
        raise Exception.CreateFmt('错误信息:%s' + sLineBreak + '错误代码:%d', [lvErrDesc, lvErrCode]);
      end;
    end;
  end;


end;

end.
