(*
 * MyBean扩展单元
 *   常用设计模式调用单元
 *   该单元，需要依赖MyBeanSubscribeCenter插件(订阅中心插件)
 *
 * 1.0
 *   订阅者插件
*)
unit mybean.ex.designmode.utils;

interface

uses
  mybean.ex.designmode.intf, mybean.tools.beanFactory, mybean.core.intf;


/// <summary>
///   通过发布者ID获取一个发布者接口实例, 如果该实例不存在则进行创建。否则直接返回
///   线程安全版本
/// </summary>
/// <returns>
///  返回获取到发布者接口实例
/// </returns>
/// <param name="pvPublisherID"> 同一个pvPublisherID获取的发布者实例是相同的 </param>
function GetPublisher(const pvPublisherID: string): IPublisher; stdcall;

implementation

function GetPublisher(const pvPublisherID: string): IPublisher;
var
  lvCenter: ISubscribeCenter;
  lvIntf:IInterface;
begin
  Result := nil;
  lvIntf := TMyBeanFactoryTools.GetBean('MyBeanSubscribeCenter');
  if lvIntf.QueryInterface(ISubscribeCenter, lvCenter) = S_OK then
  begin
    lvCenter.GetPublisher(PMyBeanChar(MyBeanString(pvPublisherID)), Result);
  end;                                                                    
end;

end.
