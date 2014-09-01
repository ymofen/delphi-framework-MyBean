unit uIPluginForm;

interface 

type 
  /// <summary>
  ///   基本窗体插件
  /// </summary>
  IPluginForm = interface(IInterface)
    ['{27DDB6A4-7D2F-4026-AA95-EBB995E573AC}']

    /// <summary>
    ///   MDI方式显示窗体
    /// </summary>
    procedure showAsMDI; stdcall;

    /// <summary>
    ///   showModal方式显示窗体
    /// </summary>
    function showAsModal: Integer; stdcall;

    /// <summary>
    ///   显示窗体
    /// </summary>
    procedure showAsNormal(); stdcall;

    /// <summary>
    ///   关闭窗体
    /// </summary>
    procedure closeForm; stdcall;

    /// <summary>
    ///   释放窗体
    /// </summary>
    procedure freeObject; stdcall;

    /// <summary>
    ///   获取窗体对象
    /// </summary>
    function getObject:TObject; stdcall;

    /// <summary>
    ///   获取对象唯一ID, 由窗体创建时随机产生
    /// </summary>
    function getInstanceID: string; stdcall;

  end;

implementation

end.
