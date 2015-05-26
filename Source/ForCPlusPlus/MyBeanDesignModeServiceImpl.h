#if _MSC_VER > 1000
#pragma once
#endif 

#include "MyBeanDesignMode.h"




/// 全局的插件工程变量修饰
/// <summary>
///   获取一个订阅者接口实例
/// </summary>
IPublisher * GetPublisher(PMyBeanChar publisherId)
{
	
	IInterface * intf = GetBean("MyBeanSubscribeCenter");
	ISubscribeCenter * subscribeCenter = NULL;
	IPublisher * publisher = NULL;
	if (intf != NULL)
	{
		if (intf->QueryInterface(__uuidof(ISubscribeCenter), (void**)&subscribeCenter) == S_OK)
		{
			intf->Release();	
			subscribeCenter->GetPublisher(publisherId, (IPublisher**)&publisher);
			subscribeCenter->Release();
			return publisher;
		}
		else
		{
			intf->Release();
			return NULL;
		}
	}
}

/// <summary>
///   向发布者添加一个订阅者
/// </summary>
bool AddSubscriber(PMyBeanChar publisherId, IInterface * subscriber)
{
	IPublisher * publisher = GetPublisher(publisherId);
	if (publisher != NULL)
	{
		publisher->AddSubscriber(subscriber);
		publisher->Release();
		return true;
	}
	else
	{
		return false;
	}
}