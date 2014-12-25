unit uDIOCPFileAccessImpl;

interface

uses
  uIRemoteFileAccess,
  uFileOperaObject;

type
  TDIOCPFileAccessImpl = class(TInterfacedObject, IRemoteFileAccess, IRemoteConnector)
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
  FFileOperaObject.close;  
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

procedure TDIOCPFileAccessImpl.Open;
begin
  FFileOperaObject.close;
  FFileOperaObject.Open;
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
