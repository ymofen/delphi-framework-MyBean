unit uIFileAccess;

interface

type
  //文件存储接口
  IFileAccess = interface(IInterface)
    ['{C69EC3FB-0248-4C54-80CB-6DC11E85C66A}']

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

end.
