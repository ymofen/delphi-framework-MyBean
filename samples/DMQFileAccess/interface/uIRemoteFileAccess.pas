unit uIRemoteFileAccess;

interface

type
  /// <summary>
  ///   远程文件存储接口
  /// </summary>
  IRemoteFileAccess = interface(IInterface)
    ['{7F33D84A-5D10-40E7-A0D0-5519F8743BFC}']

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
  end;

  IRemoteConnector = interface(IInterface)
    ['{ABDDE5A3-4E88-4006-99E1-47E16C86DEC5}']
    procedure SetHost(pvHost:PAnsiChar); stdcall;
    procedure SetPort(pvPort:Integer); stdcall;

    procedure Open;stdcall;
    procedure Close;stdcall;
  end;

  

implementation

end.
