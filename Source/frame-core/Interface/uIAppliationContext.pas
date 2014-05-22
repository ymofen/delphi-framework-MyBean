unit uIAppliationContext;

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

implementation

end.
