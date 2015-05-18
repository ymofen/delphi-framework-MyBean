#if _MSC_VER > 1000
#pragma once
#endif 

#include "mybeanInterfaceForCPlus.h"
#include "BeanFactory.h"

/// 全局的插件工厂变量
BeanFactory * __beanFactory;

/// 全局的ApplicationContext
IInterface * __applicationContext;

/// 获取ApplicationContext接口
TGetInterfaceFunctionForStdcall __ApplicationContextGetter;

/// 获取ApplicationKeyMap接口
TGetInterfaceFunctionForStdcall __ApplicationMapGetter;


IStrMapForCPlus * GetApplicationMap()
{
	if (__ApplicationMapGetter == NULL)
	{
		return NULL;
	}
	else
	{
		IInterface * map;
		__ApplicationMapGetter(&map);
		if (map == NULL){ 
			return NULL; 
		}
		else{			
			IStrMapForCPlus * ret= NULL;
			OutputDebugStringA("Map->QueryInterfaced(IStrMapForCPlus)\r\n");
			if (map->QueryInterface(__uuidof(IStrMapForCPlus), (void**)&ret) == S_OK)
			{
				map->Release();
				return ret;
			}
			else
			{
				map->Release();
				return NULL;
			}
		}
	}
}

IInterface * GetMapObject(PMyBeanChar objId)
{
	IStrMapForCPlus * map = GetApplicationMap();
	if (map != NULL)
	{	
		IInterface * ret;
		map->GetValue(objId, &ret);
		map->Release();
		return ret;
	}
	else
	{
		return NULL;
	}
}


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

