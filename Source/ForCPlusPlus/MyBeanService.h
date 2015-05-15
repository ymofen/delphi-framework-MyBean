#if _MSC_VER > 1000
#pragma once
#endif 

#include "mybeanInterfaceForCPlus.h"
#include "BeanFactory.h"

/// 全局的插件工厂变量
BeanFactory * __beanFactory;

/// 全局的ApplicationContext
IInterface * __applicationContext;


IInterface * __stdcall GetBean(PMyBeanChar beanID){
	IApplicationContextForCPlus * applicationContext;
	IInterface * ret;
	const GUID intfIID = __uuidof(IApplicationContextForCPlus);
	if (__applicationContext->QueryInterface(intfIID, (void**)&applicationContext) == S_OK)
	{
		applicationContext->GetBeanForCPlus(beanID, (IInterface**)&ret);			
		applicationContext->Release();  // QueryInterface在Delphi中进行了累加, 处理完成后 进行减少引用
		return ret;
	}
	else
	{
		return NULL;
	}
}