unit uIBeanConfigSetter;

interface



type
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

implementation

end.
