unit uIRemoteServer;

interface


type
  IRemoteServer = interface(IInterface)
    ['{20B5F070-461C-41F4-AA0C-E500A36E18E4}']

    /// <summary>
    ///   执行远程动作
    /// </summary>
    function Execute(pvCmdIndex: Integer; var vData: OleVariant): Boolean; stdcall;
  end;

  IRemoteServerConnector = interface(IInterface)
    ['{65931F56-07BA-42F8-BD5C-7409053F5B2C}']
    procedure setHost(pvHost: PAnsiChar);
    procedure setPort(pvPort:Integer);
    procedure open;
  end;

implementation

end.
