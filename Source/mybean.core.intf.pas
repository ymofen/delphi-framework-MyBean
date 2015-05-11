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
  IBeanFactory = interface;
  /// <summary>
  ///   接口已经改变需要重新编译所有的DLL和主控台
  ///     2014年5月15日 20:55:28
  ///     D10.天地弦
  ///     添加了 CheckFinalize
  ///     修改了 CheckInitialize(pvLoadLib:Boolean);stdcall; 添加了参数
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
    procedure CheckInitialize; stdcall;


    /// <summary>
    ///   执行反初始化在程序准备退出的时候使用
    /// </summary>
    procedure CheckFinalize; stdcall;



    /// <summary>
    ///   获取一个bean接口(线程安全)
    ///     如果单实例内部开启互斥
    /// </summary>
    function GetBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   获取beanID对应的工厂接口
    /// </summary>
    function GetBeanFactory(pvBeanID:PAnsiChar): IInterface; stdcall;
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
    function CheckLoadLibraryFile(pvLibFile:PAnsiChar): Boolean; stdcall;

    /// <summary>
    ///   从配置文件中加载, 返回成功处理的Bean配置数量
    ///   可以调用多次
    /// </summary>
    /// <returns>
    ///   加载失败返回false<文件可能不存在>
    /// </returns>
    /// <param name="pvConfigFile">
    ///     pvConfigFiles,配置文件通配符"*.plug-ins, *.config"
    ///     可以是指定多个通配符文件
    ///     对应的文件必须是json文件，如果不是则忽略
    /// </param>
    function CheckLoadBeanConfigFile(pvConfigFile:PAnsiChar): Boolean; stdcall;
  end;

  /// <summary>
  ///   C++ 语言调用的接口
  /// </summary>
  IApplicationContextForCPlus = interface
    ['{9A7238C4-5A47-494B-9058-77500C1622DC}']

    /// <summary>
    ///   根据beanID获取对应的插件
    /// </summary>
    function GetBeanForCPlus(pvBeanID: PAnsiChar; out vInstance: IInterface): HRESULT; stdcall;

    /// <summary>
    ///   获取beanID对应的工厂接口
    /// </summary>
    function GetBeanFactoryForCPlus(pvBeanID:PAnsiChar; out vInstance: IInterface): HRESULT; stdcall;
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
    function UnLoadLibraryFile(pvLibFile: PAnsiChar; pvRaiseException: Boolean =
        true): Boolean; stdcall;

    /// <summary>
    ///   判断BeanID是否存在
    /// </summary>
    function CheckBeanExists(pvBeanID:PAnsiChar): Boolean; stdcall;
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

    /// <summary>
    ///    加载一个库文件, 获取其中插件，并进行注册
    ///    加载成功或者已经加载返回Lib文件中的BeanFactory接口
    ///    失败返回nil
    /// </summary>
    function CheckLoadALibFile(pvFile: PAnsiChar): IBeanFactory; stdcall;

//
//    /// <summary>
//    ///   添加一个插件实例, 可以用GetBean进行获取
//    /// </summary>
//    /// <param name="pvPluginID"> 插件的ID, 如果之前有添加，将会被替换成最后一次添加的 </param>
//    /// <param name="pvPlugin"> 插件实例 </param>
//    procedure AddPlugin(pvPluginID:PAnsiChar; pvPlugin:IInterface); stdcall;
//
//    /// <summary>
//    ///   移除掉一个插件实例.
//    /// </summary>
//    /// <param name="pvPluginID"> 添加时的插件ID </param>
//    procedure RemovePlugin(pvPluginID:PAnsiChar); stdcall;
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
    function GetBeanList(pvIDs:PAnsiChar; pvLength:Integer): Integer; stdcall;

    /// <summary>
    ///   根据beanID获取对应的插件
    /// </summary>
    function GetBean(pvBeanID: PAnsiChar): IInterface; stdcall;


    /// <summary>
    ///   初始化,加载DLL后执行
    /// </summary>
    procedure CheckInitalize; stdcall;

    /// <summary>
    ///   卸载DLL之前执行
    /// </summary>
    procedure CheckFinalize; stdcall;


    /// <summary>
    ///   配置所有bean的相关的配置,会覆盖之前的Bean配置
    ///    pvConfig是Json格式
    ///      beanID(mapKey)
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function ConfigBeans(pvConfig:PAnsiChar): Integer; stdcall;

    /// <summary>
    ///   配置bean的相关信息
    ///     pvConfig是Json格式的参数
    ///     会覆盖之前的bean配置
    ///      {
    ///          id:xxxx,
    ///          .....
    ///      }
    /// </summary>
    function ConfigBean(pvBeanID, pvConfig: PAnsiChar): Integer; stdcall;

    /// <summary>
    ///   配置bean配置
    ///     pluginID,内部的插件ID
    /// </summary>
    function ConfigBeanPluginID(pvBeanID, pvPluginID: PAnsiChar): Integer; stdcall;

    /// <summary>
    ///   配置bean配置
    ///     singleton,单实例,
    ///     配置单实例时，请注意要么对象有接口管理生命周期，要么实现IFreeObject接口
    ///     不要手动释放释放对象.
    /// </summary>
    function ConfigBeanSingleton(pvBeanID: PAnsiChar; pvSingleton:Boolean):
        Integer; stdcall;
  end;

/// <summary>
  ///   VC 接口
  /// </summary>
  IBeanFactoryForCPlus = interface
    ['{D6F1B138-ECEA-44FC-A3E3-0B5169F1077A}']
    /// <summary>
    ///   根据beanID获取对应的插件
    /// </summary>
    function GetBeanForCPlus(pvBeanID: PAnsiChar; out vInstance: IInterface): HRESULT; stdcall;
  end;

  /// <summary>
  ///   插件工厂注册
  /// </summary>
  IBeanFactoryRegister = interface(IInterface)
  ['{C06270CF-FF16-4AB0-89D7-3D8C3D8D9820}']

    /// <summary>
    ///   直接注册Bean工厂插件, 单EXE可以直接注册
    /// </summary>
    function RegisterBeanFactory(const pvFactory: IBeanFactory; const
        pvNameSapce:PAnsiChar): Integer; stdcall;
  end;


  IErrorInfo = interface(IInterface)
  ['{A15C511B-AD0A-43F9-AA3B-CAAE00DC372D}']
    /// <summary>
    ///   获取错误代码，没有错误返回 0
    /// </summary>
    function GetErrorCode: Integer; stdcall;

    /// <summary>
    ///   获取错误信息数据，返回读取到的错误信息长度，
    ///     如果传入的pvErrorDesc为nil指针，返回错误信息的长度
    /// </summary>
    function GetErrorDesc(pvErrorDesc: PAnsiChar; pvLength: Integer): Integer;
        stdcall;
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
    function ExistsObject(const pvKey:PAnsiChar): Boolean; stdcall;

    /// <summary>
    ///   根据key值获取接口
    /// </summary>
    function GetObject(const pvKey:PAnsiChar): IInterface; stdcall;

    /// <summary>
    ///  赋值接口
    /// </summary>
    procedure SetObject(const pvKey:PAnsiChar; const pvIntf: IInterface); stdcall;

    /// <summary>
    ///   移除接口
    /// </summary>
    procedure RemoveObject(const pvKey:PAnsiChar); stdcall;

    /// <summary>
    ///   清理对象
    /// </summary>
    procedure CleanupObjects; stdcall;

  end;

  IBeanConfigSetter = interface(IInterface)
    ['{C7DABCDB-9908-4C43-B353-647EDB7F3DCE}']


    /// <summary>
    ///   设置配置中的Config
    /// </summary>
    /// <param name="pvBeanConfig">
    ///   配置文件中JSon格式的字符串
    /// </param>
    procedure SetBeanConfig(pvBeanConfig: PAnsiChar); stdcall;
  end;



var

  appPluginContext:IApplicationContext;
  applicationKeyMap:IKeyMap;

  /// <summary>
  ///   提供一个获取appPluginContext对象的函数指针，TMyBeanFactoryTools中如果该指针存在，直接调用该函数
  /// </summary>
  GetApplicationContextFunc: function:IApplicationContext; stdcall;

  /// <summary>
  ///   提供一个获取applicationKeyMap对象的函数指针，TMyBeanFactoryTools中如果该指针存在，直接调用该函数
  /// </summary>
  GetApplicationKeyMapFunc: function:IKeyMap; stdcall;
  

implementation



initialization
  appPluginContext := nil;
  applicationKeyMap := nil;

finalization
  appPluginContext := nil;
  applicationKeyMap := nil;

end.
