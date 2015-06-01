unit dllmain;

interface

type
  PInterface = ^IInterface;
  TGetInterfaceFunctionForStdcall = function(pvIntf:PInterface):HRESULT; stdcall;

/// <summary>
///   发生在DLL已经全部加载完成, 准备启动应用程序的时候, 需要在EXE中执行mybean.console单元中的StartLibraryService函数
/// </summary>
procedure StartLibraryService; stdcall;

implementation

procedure StartLibraryService; stdcall;
begin
   
end;

exports
  StartLibraryService;



end.
