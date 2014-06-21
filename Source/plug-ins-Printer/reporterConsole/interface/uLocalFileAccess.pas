unit uLocalFileAccess;
{
  本地文件存储
}

interface

uses
  uIFileAccess, SysUtils, uFileTools, uStringTools, Windows;

type
  TLocalFileAccess = class(TInterfacedObject, IFileAccess)
  private
    FBasePath: String;
  public
    constructor Create(const ABasePath: String);
    destructor Destroy; override;

    /// <summary>
    ///   保存文件
    /// </summary>
    /// <param name="pvRFileName"> 文件ID </param>
    /// <param name="pvLocalFileName"> 本地文件名 </param>
    /// <param name="pvType"> 类型 </param>
    procedure saveFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar);

    //删除文件
    procedure deleteFile(pvRFileName, pvType: PAnsiChar);

    /// <summary>
    ///   获取文件
    /// </summary>
    /// <returns>
    ///   获取成功否
    /// </returns>
    /// <param name="pvRFileName"> 文件ID </param>
    /// <param name="pvLocalFileName"> 获取回来后保存在本地文件名 </param>
    /// <param name="pvType"> 类型 </param>
    /// <param name="pvRaiseIfFalse"> 是否Raise错误 </param>
    function getFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar;
        pvRaiseIfFalse: Boolean = true): Boolean;
  end;

implementation

constructor TLocalFileAccess.Create(const ABasePath: String);
begin
  inherited Create;
  if ABasePath<>'' then
  begin
    FBasePath := TFileTools.PathWithBackslash(ABasePath);
  end;
end;

destructor TLocalFileAccess.Destroy;
begin
  
  inherited Destroy;
end;

procedure TLocalFileAccess.deleteFile(pvRFileName, pvType: PAnsiChar);
var
  lvPath, lvTempStr:string;
begin
  lvPath := FBasePath + pvType;

  ForceDirectories(lvPath);

  lvPath := lvPath + '\' + pvRFileName;

  SysUtils.DeleteFile(lvPath);
end;

function TLocalFileAccess.getFile(pvRFileName, pvLocalFileName, pvType:
    PAnsiChar; pvRaiseIfFalse: Boolean = true): Boolean;
var
  lvFile:string;
begin
  Result := false;
  lvFile := FBasePath + pvType+  '\' + pvRFileName;

  Result := FileExists(lvFile);

  if Result then
  begin
    ForceDirectories(ExtractFilePath(pvLocalFileName));
    Result := TFileTools.FileCopy(lvFile, pvLocalFileName, True);

    if not Result then
    begin
      if pvRaiseIfFalse then
      begin
        raise Exception.Create('copy文件失败!');
      end;
    end;
  end else
  begin
    if pvRaiseIfFalse then
    begin
      raise Exception.Create('要获取的文件不存在!' + lvFile);
    end;
  end;
end;

procedure TLocalFileAccess.saveFile(pvRFileName, pvLocalFileName, pvType:
    PAnsiChar);
var
  lvPath, lvTempStr:string;
begin
  lvPath := FBasePath + pvType;

  ForceDirectories(lvPath);

  lvTempStr := pvLocalFileName;

  lvPath := lvPath + '\' + pvRFileName;
  
  TFileTools.FileCopy(pvLocalFileName,lvPath, True);
end;

end.
