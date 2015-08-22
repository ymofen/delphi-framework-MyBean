unit uDIOCPFileAccessImpl;

interface

uses
  uIRemoteFileAccess, uIFileAccess,
  uFileOperaObject;

type
  TDIOCPFileAccessImpl = class(TInterfacedObject
     , IRemoteFileAccess
     , IQueryProgressInfo
     , IFileAccess
     , IFileAccessEx
     , IFileAccess02
     , IRemoteConnector)
  private
    FFileOperaObject: TFileOperaObject;
  protected

    /// <summary>
    ///   上传文件
    /// </summary>
    /// <param name="pvRFileName"> 远程文件名 </param>
    /// <param name="pvLocalFileName"> 本地文件名 </param>
    /// <param name="pvType"> 类型 </param>
    procedure UploadFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar);

    /// <summary>
    ///   删除文件
    /// </summary>
    /// <param name="pvRFileName"> 远程文件名 </param>
    procedure DeleteFile(pvRFileName, pvType: PAnsiChar);
    /// <summary>
    ///   下载文件
    /// </summary>
    /// <returns>
    ///   下载成功返回True
    /// </returns>
    /// <param name="pvRFileName"> 远程文件名 </param>
    /// <param name="pvLocalFileName"> 本地文件名 </param>
    function DownFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar): Boolean;


    /// <summary>
    ///   获取远程文件大小
    /// </summary>
    function FileSize(pvRFileName, pvType: PAnsiChar): Int64;
  public
    /// <summary>
    ///  查询最大
    /// </summary>
    function QueryMax: Int64; stdcall;

    /// <summary>
    ///  查询当前进度
    /// </summary>
    function QueryPosition: Int64; stdcall;

  public

    /// <summary>
    ///   保存文件
    /// </summary>
    /// <param name="pvRFileName"> 文件ID </param>
    /// <param name="pvLocalFileName"> 本地文件名 </param>
    /// <param name="pvType"> 类型 </param>
    procedure saveFile(pvRFileName, pvLocalFileName, pvType: PAnsiChar);


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

    /// <summary>
    ///   COPY文件
    /// </summary>
    /// <param name="pvRSourceFileName"> 远程源文件 </param>
    /// <param name="pvLocalFileName"> 远程目标文件 </param>
    /// <param name="pvType"> 类型 </param>
    procedure copyAFile(pvRSourceFileName, pvRDestFileName, pvType: PAnsiChar); 
  public
    constructor Create;
    procedure AfterConstruction;override;
    procedure SetHost(pvHost: PAnsiChar); stdcall;
    procedure SetPort(pvPort:Integer); stdcall;
    procedure Open; stdcall;
    procedure Close;stdcall;
    destructor Destroy; override;
  end;

implementation

procedure TDIOCPFileAccessImpl.AfterConstruction;
begin
  inherited AfterConstruction;
  FFileOperaObject := TFileOperaObject.Create;
end;

procedure TDIOCPFileAccessImpl.Close;
begin
  FFileOperaObject.BreakWork := True;
  FFileOperaObject.close;  
end;

procedure TDIOCPFileAccessImpl.copyAFile(pvRSourceFileName, pvRDestFileName,
  pvType: PAnsiChar);
begin
  FFileOperaObject.copyAFile(pvRSourceFileName, pvRDestFileName, pvType);
end;

constructor TDIOCPFileAccessImpl.Create;
begin
  inherited Create;

end;

procedure TDIOCPFileAccessImpl.DeleteFile(pvRFileName, pvType: PAnsiChar);
begin
  FFileOperaObject.deleteFile(pvRFileName, pvType);
end;

destructor TDIOCPFileAccessImpl.Destroy;
begin
  if FFileOperaObject <> nil then FFileOperaObject.Free;
  inherited Destroy;
end;

function TDIOCPFileAccessImpl.DownFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar): Boolean;
begin
  FFileOperaObject.downFile(pvRFileName, pvLocalFileName, pvType);
  Result := true;
end;

function TDIOCPFileAccessImpl.FileSize(pvRFileName, pvType: PAnsiChar): Int64;
begin
  FFileOperaObject.readFileINfo(pvRFileName, pvType, False);
  Result := FFileOperaObject.FileSize;
end;

function TDIOCPFileAccessImpl.getFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar; pvRaiseIfFalse: Boolean): Boolean;
begin
  FFileOperaObject.downFile(pvRFileName, pvLocalFileName, pvType);
  Result := true;
end;

procedure TDIOCPFileAccessImpl.Open;
begin
  FFileOperaObject.close;
  FFileOperaObject.Open;
  FFileOperaObject.BreakWork := False;
end;

function TDIOCPFileAccessImpl.QueryMax: Int64;
begin
  Result := FFileOperaObject.Max;
end;

function TDIOCPFileAccessImpl.QueryPosition: Int64;
begin
  Result := FFileOperaObject.Position;
end;

procedure TDIOCPFileAccessImpl.saveFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar);
begin
  FFileOperaObject.uploadFile(pvRFileName, pvLocalFileName, pvType);
end;

procedure TDIOCPFileAccessImpl.SetHost(pvHost: PAnsiChar);
begin
  FFileOperaObject.setHost(pvHost);
end;

procedure TDIOCPFileAccessImpl.SetPort(pvPort:Integer);
begin
  FFileOperaObject.setPort(pvPort);
end;

procedure TDIOCPFileAccessImpl.UploadFile(pvRFileName, pvLocalFileName,
  pvType: PAnsiChar);
begin
  FFileOperaObject.uploadFile(pvRFileName, pvLocalFileName, pvType);

end;

end.
