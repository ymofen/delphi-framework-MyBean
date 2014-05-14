unit uIBeanFactory;

interface



type

  /// <summary>
  ///   插件工厂
  /// </summary>
  IBeanFactory = interface(IInterface)
    ['{480EC845-2FC0-4B45-932A-57711D518E70}']

    /// <summary>
    ///   获取所有的插件ID
    ///     返回获取ID的长度分隔符#10#13
    /// </summary>
    function getBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer; stdcall;

    /// 创建一个插件
    function getBean(pvPluginID: PAnsiChar): IInterface; stdcall;
  end;


implementation

end.
