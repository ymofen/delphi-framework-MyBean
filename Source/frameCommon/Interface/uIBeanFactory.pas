unit uIBeanFactory;

interface



type

  /// <summary>
  ///   插件工厂
  /// </summary>
  IBeanFactory = interface(IInterface)
    ['{480EC845-2FC0-4B45-932A-57711D518E70}']

    /// 获取所有的插件ID
    function getBeanList: PAnsiChar; stdcall;

    /// 创建一个插件
    function getBean(pvPluginID: PAnsiChar): IInterface; stdcall;
  end;

implementation

end.
