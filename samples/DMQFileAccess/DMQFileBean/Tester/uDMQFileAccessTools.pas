unit uDMQFileAccessTools;

interface

uses
  uIRemoteFileAccess;

type
  TDMQFileAccessTools = class(TObject)
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

class procedure TDMQFileAccessTools.DeleteFile(
  const pvFileAccess: IRemoteFileAccess; pvRFile, pvType: String);
begin
  pvFileAccess.DeleteFile(PAnsiChar(AnsiString(pvRFile)),
    PAnsiChar(AnsiString(pvType))
    );
end;

class procedure TDMQFileAccessTools.DownFile(const pvFileAccess:
    IRemoteFileAccess; pvRFile, pvLocalFile: String; pvType: String = '');
begin
  pvFileAccess.DownFile(PAnsiChar(AnsiString(pvRFile)),
    PAnsiChar(AnsiString(pvLocalFile)),
    PAnsiChar(AnsiString(pvType))
    );
end;


class function TDMQFileAccessTools.FileSize(const pvFileAccess:
    IRemoteFileAccess; pvRFile: String; pvType: String = ''): Int64;
begin
  Result:= pvFileAccess.FileSize(PAnsiChar(AnsiString(pvRFile)),
    PAnsiChar(AnsiString(pvType))
    );
end;

class procedure TDMQFileAccessTools.UploadFile(const pvFileAccess:
    IRemoteFileAccess; pvRFile, pvLocalFile: String; pvType: String = '');
begin
  pvFileAccess.UploadFile(PAnsiChar(AnsiString(pvRFile)),
    PAnsiChar(AnsiString(pvLocalFile)),
    PAnsiChar(AnsiString(pvType))
    );
end;

end.
