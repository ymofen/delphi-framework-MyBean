unit uIBeanFactoryRegister;

interface

uses
  uIBeanFactory;

type
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
