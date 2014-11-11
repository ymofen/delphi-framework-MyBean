unit uDIOCPFileAccessTools;

interface

uses
  uIRemoteFileAccess;

type
  TDIOCPFileAccessTools = class(TObject)
  public
    class procedure UploadFile(const pvFileAccess: IRemoteFileAccess; pvRFile,
        pvLocalFile: String; pvType: String = '');
    class procedure DownFile(const pvFileAccess: IRemoteFileAccess; pvRFile,
        pvLocalFile: String; pvType: String = '');
    class function FileSize(const pvFileAccess: IRemoteFileAccess; pvRFile: String;
        pvType: String = ''): Int64;
    class procedure DeleteFile(const pvFileAccess: IRemoteFileAccess; pvRFile:
       String; pvType: String = '');

  end;

implementation

class procedure TDIOCPFileAccessTools.DeleteFile(
  const pvFileAccess: IRemoteFileAccess; pvRFile, pvType: String);
begin
  pvFileAccess.DeleteFile(PAnsiChar(AnsiString(pvRFile)),
    PAnsiChar(AnsiString(pvType))
    );
end;

class procedure TDIOCPFileAccessTools.DownFile(const pvFileAccess:
    IRemoteFileAccess; pvRFile, pvLocalFile: String; pvType: String = '');
begin
  pvFileAccess.DownFile(PAnsiChar(AnsiString(pvRFile)),
    PAnsiChar(AnsiString(pvLocalFile)),
    PAnsiChar(AnsiString(pvType))
    );
end;


class function TDIOCPFileAccessTools.FileSize(const pvFileAccess:
    IRemoteFileAccess; pvRFile: String; pvType: String = ''): Int64;
begin
  Result:= pvFileAccess.FileSize(PAnsiChar(AnsiString(pvRFile)),
    PAnsiChar(AnsiString(pvType))
    );
end;

class procedure TDIOCPFileAccessTools.UploadFile(const pvFileAccess:
    IRemoteFileAccess; pvRFile, pvLocalFile: String; pvType: String = '');
begin
  pvFileAccess.UploadFile(PAnsiChar(AnsiString(pvRFile)),
    PAnsiChar(AnsiString(pvLocalFile)),
    PAnsiChar(AnsiString(pvType))
    );
end;

end.
