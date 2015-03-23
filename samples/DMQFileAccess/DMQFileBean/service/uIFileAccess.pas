(*
   添加FileAccessEX接口
     2014-09-16 15:25:24
*)
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

  IFileAccessSetter = interface(IInterface)
    ['{F00482DA-9B44-4215-99F6-FD2E7BBC853D}']
    procedure setFileAcccess(const pvFileAccess: IFileAccess); stdcall;
  end;

  IFileAccessEx = interface(IInterface)
    ['{FF76603C-1FFF-4985-88D3-16BCE2066B01}']
    
    /// <summary>
    ///   COPY文件
    /// </summary>
    /// <param name="pvRSourceFileName"> 远程源文件 </param>
    /// <param name="pvLocalFileName"> 远程目标文件 </param>
    /// <param name="pvType"> 类型 </param>
    procedure copyAFile(pvRSourceFileName, pvRDestFileName, pvType: PAnsiChar);
  end;

  IFileAccess02 = interface(IInterface)
    ['{BE9ED805-E022-41F6-9E01-FE619CFE3CA3}']

    /// <summary>
    ///   获取远程文件大小
    /// </summary>
    function FileSize(pvRFileName, pvType: PAnsiChar): Int64;
  end;
implementation

end.
