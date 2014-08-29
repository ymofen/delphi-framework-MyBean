unit mybean.core.intf;

interface


type
  /// <summary>
  ///   接口已经改变需要重新编译所有的DLL和主控台
  ///     2014年5月15日 20:55:28
  ///     D10.天地弦
  ///     添加了 checkFinalize
  ///     修改了 checkInitialize(pvLoadLib:Boolean);stdcall; 添加了参数
  /// </summary>
  IApplicationContext = interface(IInterface)
    ['{0FE2FD2D-3A21-475B-B51D-154E1728893B}']

    /// <summary>
    ///   初始化配置(线程不安全),
    ///      pvLoadLib为true时加载配置文件的同时加载DLL文件(服务端程序推荐)
    ///               为flase时只加载配置文件(客户端程序推荐)
    ///      pvUseLibCache为true时copy,dll文件到Plug-ins-cache文件夹然后进行加载
    ///                   为false时不进行copy，原来目录进行加载
    /// </summary>
    procedure checkInitialize; stdcall;


    /// <summary>
    ///   执行反初始化在程序准备退出的时候使用
    /// </summary>
    procedure checkFinalize; stdcall;



    /// <summary>
    ///   获取一个bean接口(线程安全)
    ///     如果单实例内部开启互斥
    /// </summary>
    function getBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   获取beanID对应的工厂接口
    /// </summary>
    function getBeanFactory(pvBeanID:PAnsiChar):IInterface; stdcall;
  end;


  /// <summary>
  ///   插件工厂接口,由插件宿主(DLL, BPL)库文件提供
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

  /// <summary>
  ///   插件工厂注册, 由beanManager.dll提供
  /// </summary>
  IbeanFactoryRegister = interface(IInterface)
    ['{C06270CF-FF16-4AB0-89D7-3D8C3D8D9820}']

    /// <summary>
    ///   直接注册Bean工厂插件, 单EXE可以直接注册
    /// </summary>
    function registerBeanFactory(const pvFactory: IBeanFactory; const pvNameSapce:PAnsiChar):Integer;stdcall;
  end;

implementation

end.
