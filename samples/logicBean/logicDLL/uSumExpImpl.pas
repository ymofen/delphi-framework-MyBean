unit uSumExpImpl;

interface

uses
  mybean.core.objects, uILogic, mybean.tools.beanFactory;



type
  TSumExpImpl = class(TMyBeanInterfacedObject, ISumExp)
  protected
    function sum(i:Integer; j:Integer):Integer; stdcall;
  end;

implementation

{ TSumExpImpl }

function TSumExpImpl.sum(i, j: Integer): Integer;
begin
  Result := i + j;

  (TMyBeanFactoryTools.getBean('mybeanLogger') as IMyBeanLogger).LogMessage('dll插件调用mybeanLogger插件，输出一些信息');
end;

end.
