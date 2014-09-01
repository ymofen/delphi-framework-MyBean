unit StdInterface;
{
    标准的接口,
    可以不用带包运行的接口
}

interface


type
  //JSonString获取
  IJSonConfigStringGetter = interface(IInterface)
    ['{0CF8F1E1-7E28-4812-9BD9-BDD128867BCE}']
    function getJSonConfigString: PAnsiChar; stdcall;
  end;

  //JSonStringSetter
  IJSonConfigStringSetter = interface(IInterface)
    ['{C5B50640-E35C-47C2-BC37-CBC7B567248B}']
    procedure setJSonConfigString(const pvValue: PAnsiChar); stdcall;
  end;

  //执行准备动作
  IPrepare = interface(IInterface)
    ['{D04E4227-D948-4678-83F1-3A82DFB852A6}']
    procedure Prepare; stdcall;
  end;

  //调试器
  IDebugger = interface(IInterface)
    ['{A9927B16-3599-45EC-97B8-E6F799D75A48}']
    procedure debugInfo(msg: PAnsiChar; level: Integer); stdcall;
  end;




  //进度条
  IProgConsole = interface(IInterface)
    ['{63CBE456-9534-42F6-8934-16702E92BBCB}']
    //1 设置当前值
    procedure SetPosition(pvPosition: Integer);
    
    //1 //设置最大值
    procedure SetMax(pvValue: Integer);

    //是否已经终止
    function IsBreaked():Boolean;

    //递增进度
    procedure IncPosition();

    //
    procedure ShowProgressConsole();

    // 隐藏关闭
    procedure HideConsole();

    // 释放
    procedure FreeConsole();

    //设置显示文字
    procedure SetHintText(pvHint:PAnsiChar);
  end;

implementation

end.
