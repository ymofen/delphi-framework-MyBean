(*
 *	 Unit owner: D10.天地弦
 *	   blog: http://www.cnblogs.com/dksoft
 *
 *   v0.1.1  (2014-09-03 23:46:16)
 *     添加 IApplicationContextEx01接口
 *      可以实现手动加载DLL和配置文件
 *
 *   v0.1.0(2014-08-29 13:00)
 *     修改加载方式(beanMananger.dll-改造)
 *
 *	 v0.0.1(2014-05-17)
 *     + first release
 *
 *

   核心框架接口文件
      IApplicationContext: 主控台必须要实现的接口
      IBeanFactory: 插件宿主必须要实现的接口
*)
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
    ///   初始化框架(线程不安全),
    ///     1.如果有配置文件<同名的.config.ini>则按照配置进行初始化
    ///     2.如果没有配置文件，
    ///       1>直接从(plug-ins\*.DLL, plug-ins\*.BPL, *.DLL)路径下 加载 DLL和BPL文件中的插件
    ///       2>加载ConfigPlugins下面的配置文件
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

  IApplicationContextEx01 = interface(IInterface)
    ['{10009F97-1949-476D-9CE1-1AF003B47DCB}']

    /// <summary>
    ///  加载库文件
    /// </summary>
    /// <returns>
    ///    加载成功返回true, 失败返回false, 可以用raiseLastOsError获取异常
    /// </returns>
    /// <param name="pvLibFile"> (PAnsiChar) </param>
    function checkLoadLibraryFile(pvLibFile:PAnsiChar): Boolean; stdcall;

    /// <summary>
    ///    加载配置文件
    /// </summary>
    /// <returns>
    ///   加载失败返回false<文件可能不存在>
    /// </returns>
    /// <param name="pvConfigFile"> (PAnsiChar) </param>
    function checkLoadBeanConfigFile(pvConfigFile:PAnsiChar): Boolean; stdcall;
  end;

  /// <summary>
  ///   主控台扩展接口
  ///    2014-09-22 12:27:56
  /// </summary>
  IApplicationContextEx2 = interface(IInterface)
    ['{401B2E73-3C6B-4738-9DE4-B628EE5E1D44}']

    /// <summary>
    ///   卸载掉指定的插件宿主文件(dll)
    ///     在卸载之前应该释放掉由所创建的对象实例，和分配的内存空间，
    ///     否则会在退出EXE的时候，出现内存访问违规错误
    ///     卸载如果出现问题, 返回false，请查看日志文件
    ///     *(谨慎使用)
    /// </summary>
    function unLoadLibraryFile(pvLibFile: PAnsiChar; pvRaiseException: Boolean =
        true): Boolean; stdcall;

    /// <summary>
    ///   判断BeanID是否存在
    /// </summary>
    function checkBeanExists(pvBeanID:PAnsiChar):Boolean; stdcall;
  end;


  /// <summary>
  ///   主控台扩展接口
  ///     2014-11-14 12:40:17
  /// </summary>
  IApplicationContextEx3 = interface(IInterface)
    ['{4D0387BC-0FF8-4D89-B064-C8C30AA432BE}']

    /// <summary>
    ///   获取所有Bean信息
    ///   result:     返回读取到的数据长度
    ///   pvLength:   尝试读取的长度，传入的pvBeanInfo必须分配有足够的内存
    ///   pvBeanInfo: 返回读取到的数据
    ///    utf8 AnsiString
    ///    [
    ///      {"id":"beanid", "lib":"libfile"}
    ///      ...
    ///    ]
    /// </summary>
    function GetBeanInfos(pvBeanInfo:PAnsiChar; pvLength:Integer): Integer; stdcall;
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
  ///   插件工厂注册
  /// </summary>
  IbeanFactoryRegister = interface(IInterface)
    ['{C06270CF-FF16-4AB0-89D7-3D8C3D8D9820}']

    /// <summary>
    ///   直接注册Bean工厂插件, 单EXE可以直接注册
    /// </summary>
    function registerBeanFactory(const pvFactory: IBeanFactory; const pvNameSapce:PAnsiChar):Integer;stdcall;
  end;


  IErrorInfo = interface(IInterface)
  ['{A15C511B-AD0A-43F9-AA3B-CAAE00DC372D}']
    /// <summary>
    ///   获取错误代码，没有错误返回 0
    /// </summary>
    function getErrorCode: Integer; stdcall;

    /// <summary>
    ///   获取错误信息数据，返回读取到的错误信息长度，
    ///     如果传入的pvErrorDesc为nil指针，返回错误信息的长度
    /// </summary>
    function getErrorDesc(pvErrorDesc: PAnsiChar; pvLength: Integer): Integer;  stdcall;
  end;

  IFreeObject = interface
    ['{863109BC-513B-440C-A455-2AD4F5EDF508}']
    procedure FreeObject; stdcall;
  end;

  IKeyMap = interface(IInterface)
    ['{3CF4907D-C1FF-4E93-9E32-06AAD82310B4}']

    /// <summary>
    ///   判断是否存在接口
    /// </summary>
    function existsObject(const pvKey:PAnsiChar):Boolean; stdcall;

    /// <summary>
    ///   根据key值获取接口
    /// </summary>
    function getObject(const pvKey:PAnsiChar):IInterface; stdcall;

    /// <summary>
    ///  赋值接口
    /// </summary>
    procedure setObject(const pvKey:PAnsiChar; const pvIntf: IInterface); stdcall;

    /// <summary>
    ///   移除接口
    /// </summary>
    procedure removeObject(const pvKey:PAnsiChar); stdcall;

    /// <summary>
    ///   清理对象
    /// </summary>
    procedure cleanupObjects; stdcall;

  end;

  IBeanConfigSetter = interface(IInterface)
    ['{C7DABCDB-9908-4C43-B353-647EDB7F3DCE}']


    /// <summary>
    ///   设置配置中的Config
    /// </summary>
    /// <param name="pvBeanConfig">
    ///   配置文件中JSon格式的字符串
    /// </param>
    procedure setBeanConfig(pvBeanConfig: PAnsiChar); stdcall;
  end;



var
  appPluginContext:IApplicationContext;
  applicationKeyMap:IKeyMap;

implementation



initialization
  appPluginContext := nil;
  applicationKeyMap := nil;

finalization
  appPluginContext := nil;
  applicationKeyMap := nil;

end.
