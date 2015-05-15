#if _MSC_VER > 1000
#pragma once
#endif 

#include "MyBeanInterfaceForCPlus.h"
#include <map>
#include <string>

using namespace std;

/// 创建插件方法
typedef void(*CreateInstanceMethod)(IInterface ** instance);



class BeanInfo
{
private:
	IInterface * instance;
public:
	BeanInfo();
	~BeanInfo();
	string beanid;
	CreateInstanceMethod createMethod;
};

class BeanFactory :public IBeanFactory, IBeanFactory4CPlus
{
private:
	long m_ref;
	map<string, BeanInfo *> beanInfoList;
	void ClearBeanInfoList();
public:
	BeanFactory();
	~BeanFactory();
	HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppv);
	ULONG STDMETHODCALLTYPE AddRef();
	ULONG STDMETHODCALLTYPE Release();

	BeanInfo * RegisterBean(string beanid, CreateInstanceMethod method);
public:
	/// <summary>
	///   获取所有的插件ID
	///     返回获取ID的长度分隔符#10#13
	/// </summary>
	int __stdcall GetBeanList(PMyBeanChar IDs, int len);

	/// <summary>
	///   根据beanID获取对应的插件
	/// </summary>
	///  function GetBean(pvBeanID: PAnsiChar): IInterface; stdcall;
	HRESULT __stdcall GetBean(PMyBeanChar beanId);

	/// <summary>
	///   根据beanID获取对应的插件
	/// </summary>
	/// function GetBeanForCPlus(pvBeanID: PAnsiChar; out vInstance : IInterface) : HRESULT; stdcall;
	HRESULT __stdcall GetBeanForCPlus(PMyBeanChar beanId, IInterface **p);

	/// <summary>
	///   初始化,加载DLL后执行
	/// </summary>
	/// procedure CheckInitalize; stdcall;
	void __stdcall CheckInitalize();

	/// <summary>
	///   卸载DLL之前执行
	/// </summary>
	/// procedure CheckFinalize; stdcall;
	void __stdcall CheckFinalize();

	/// <summary>
	///   配置所有bean的相关的配置,会覆盖之前的Bean配置
	///    pvConfig是Json格式
	///      beanID(mapKey)
	///      {
	///          id:xxxx,
	///          .....
	///      }
	/// </summary>
	/// function ConfigBeans(pvConfig:PAnsiChar) : Integer; stdcall;
	int __stdcall ConfigBeans(PMyBeanChar config);

	/// <summary>
	///   配置bean的相关信息
	///     pvConfig是Json格式的参数
	///     会覆盖之前的bean配置
	///      {
	///          id:xxxx,
	///          .....
	///      }
	/// </summary>
	/// function ConfigBean(pvBeanID, pvConfig: PAnsiChar) : Integer; stdcall;
	int __stdcall ConfigBean(PMyBeanChar beanId, PMyBeanChar config);


	/// <summary>
	///   配置bean配置
	///     pluginID,内部的插件ID
	/// </summary>
	/// function ConfigBeanPluginID(pvBeanID, pvPluginID: PAnsiChar) : Integer; stdcall;
	int __stdcall ConfigBeanPluginID(PMyBeanChar beanId, PMyBeanChar pluginId);

	/// <summary>
	///   配置bean配置
	///     singleton,单实例,
	///     配置单实例时，请注意要么对象有接口管理生命周期，要么实现IFreeObject接口
	///     不要手动释放释放对象.
	/// </summary>
	/// function ConfigBeanSingleton(pvBeanID: PAnsiChar; pvSingleton:Boolean) : Integer; stdcall;
	int __stdcall ConfigBeanSingleton(PMyBeanChar beanId, bool pvSingleton);
};


