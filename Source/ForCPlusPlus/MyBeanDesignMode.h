#if _MSC_VER > 1000
#pragma once
#endif 

#include "mybeanInterfaceForCPlus.h"

/// <summary>
///   订阅侦听者
/// </summary>
/// ISubscribeListener = interface
/// ['{ECC2BDC4-737E-4493-BFF1-DCC7B5CE0BD8}']
interface DECLSPEC_UUID("{ECC2BDC4-737E-4493-BFF1-DCC7B5CE0BD8}")
ISubscribeListener: public IInterface{

/// <summary>
///   添加了一个订阅者
/// </summary>
/// <param name="pvSubscriberID"> 订阅者ID </param>
/// <param name="pvSubscriber"> 订阅者 </param>
/// procedure OnAddSubscriber(pvSubscriberID: Integer; const pvSubscriber : IInterface); stdcall;
virtual void __stdcall OnAddSubscriber(int index, const IInterface * subscriber) = 0;


/// <summary>
///   移除了一个订阅者
/// </summary>
/// <param name="pvSubscriberID"> 订阅者ID </param>
/// procedure OnRemoveSubscriber(pvSubscriberID: Integer); stdcall;
virtual void __stdcall OnRemoveSubscriber(int subscriberId) = 0;
};


/// <summary>
///   发布者接口
/// </summary>
///IPublisher = interface
///['{AF590D7D-2E86-4729-8282-0423781EBB4C}']
interface DECLSPEC_UUID("{AF590D7D-2E86-4729-8282-0423781EBB4C}")
IPublisher: public IInterface{

/// <summary>
///   注册一个侦听者到发布者实例中
/// </summary>
/// <returns>
///   返回一个ID,移除时通过该ID进行移除, 注册失败返回-1
/// </returns>
/// <param name="pvSubscriber"> (IInterface) </param>
/// function AddSubscriber(const pvSubscriber : IInterface) : Integer; stdcall;
virtual int __stdcall AddSubscriber(const IInterface *p) = 0;

/// <summary>
///   从发布者中移除掉一个侦听者
/// </summary>
/// <returns>
///   成功返回True, 失败返回:False
/// </returns>
/// <param name="pvSubscriberID"> 订阅者ID(添加时返回的ID) </param>
/// function RemoveSubscriber(pvSubscriberID: Integer) : HRESULT; stdcall;
virtual HRESULT __stdcall RemoveSubscriber(int subscriberId) = 0;


/// <summary>
///   获取订阅者数量
/// </summary>
/// <returns>
///   个数
/// </returns>
/// function GetSubscriberCount : Integer; stdcall;
virtual int __stdcall GetSubscriberCount() = 0;


/// <summary>
///   获取其中的一个订阅者
/// </summary>
/// <returns>
///   S_OK,获取成功
/// </returns>
/// <param name="pvIndex">  序号 </param>
/// <param name="vSubscribeInstance"> 返回的订阅者 </param>
/// function GetSubscriber(pvIndex: Integer; out vSubscribeInstance : IInterface) :HRESULT; stdcall;
virtual HRESULT __stdcall GetSubscriber(int index, IInterface ** vSubscribeInstance) = 0;


/// <summary>
///   添加了一个订阅侦听者
///   添加或者移除订阅者时进行通知
/// </summary>
/// <returns>
///   S_OK: 成功
/// </returns>
/// <param name="pvInstance"> 订阅侦听者 </param>
/// function AddSubscribeListener(const pvInstance : ISubscribeListener) : HRESULT; stdcall;
virtual HRESULT __stdcall AddSubscribeListener(const ISubscribeListener * p) = 0;

/// <summary>
///   移除一个订阅侦听者
/// </summary>
/// <returns> S_OK: 成功
/// </returns>
/// <param name="pvInstance"> (ISubscribeListener) </param>
/// function RemoveSubscribeListener(const pvInstance : ISubscribeListener) : HRESULT; stdcall;
virtual HRESULT __stdcall RemoveSubscribeListener(const ISubscribeListener * p) = 0;
};

/// <summary>
///   MyBean 订阅模式中心
/// </summary>
/// ISubscribeCenter = interface
//  ['{805F8214-6766-4A51-9CD8-09BE67B8D383}']
interface DECLSPEC_UUID("{805F8214-6766-4A51-9CD8-09BE67B8D383}")
ISubscribeCenter: public IInterface{

/// <summary>
///   通过发布者ID获取一个发布者接口实例, 如果该实例不存在则进行创建。否则直接返回
///   线程安全版本(
/// </summary>
/// <returns>
///   S_OK：获取成功
///   S_FALSE: 获取失败
/// </returns>
/// <param name="pvPublisherID"> 同一个pvPublisherID获取的发布者实例是相同的 </param>
/// <param name="vPubInstance"> 返回的接口实例 </param>
///  function GetPublisher(pvPublisherID:PMyBeanChar; out vPubInstance : IPublisher) : HRESULT;  stdcall;
virtual HRESULT __stdcall GetPublisher(PMyBeanChar publisherId, IPublisher **p) = 0;
};


/// <summary>
///   获取一个订阅者接口实例
/// </summary>
extern IPublisher * GetPublisher(PMyBeanChar publisherId);

/// <summary>
///   向发布者添加一个订阅者
/// </summary>
extern void AddSubscriber(PMyBeanChar publisherId, IInterface * subscriber);