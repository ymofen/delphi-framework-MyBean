unit uIBeanFactory;

interface



type

  /// <summary>
  ///   插件工厂接口,有DLL库文件提供
  /// </summary>
  IBeanFactory = interface(IInterface)
    ['{480EC845-2FC0-4B45-932A-57711D518E70}']

    /// <summary>
    ///   获取所有的插件ID
    ///     返回获取ID的长度分隔符#10#13
    /// </summary>
    function getBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer; stdcall;

    /// <summary>
    ///   根据beanID获取对应的插件
    /// </summary>
    function getBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   初始化,加载DLL后执行
    /// </summary>
    procedure checkInitalize;stdcall;

    /// <summary>
    ///   卸载DLL之前执行
    /// </summary>
    procedure checkFinalize;stdcall;



    /// <summary>
    ///   配置所有bean的相关的配置,会覆盖之前的Bean配置
    ///    pvConfig是Json格式
    ///      beanID(mapKey)
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function configBeans(pvConfig:PAnsiChar):Integer; stdcall;

    /// <summary>
    ///   配置bean的相关信息
    ///     pvConfig是Json格式的参数
    ///     会覆盖之前的bean配置
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function configBean(pvBeanID, pvConfig: PAnsiChar): Integer; stdcall;

    /// <summary>
    ///   配置bean配置
    ///     pluginID,内部的插件ID
    /// </summary>
    function configBeanPluginID(pvBeanID, pvPluginID: PAnsiChar): Integer; stdcall;


    /// <summary>
    ///   配置bean配置
    ///     singleton,单实例,
    ///     配置单实例时，请注意要么对象有接口管理生命周期，要么实现IFreeObject接口
    ///     不要手动释放释放对象.
    /// </summary>
    function configBeanSingleton(pvBeanID: PAnsiChar; pvSingleton:Boolean): Integer; stdcall;
  end;


implementation

end.
