#if _MSC_VER > 1000
#pragma once
#endif 

#include <UNKNWN.h>

#define MyBeanChar char 
#define PMyBeanChar char *

typedef IUnknown IInterface;

/// TGetInterfaceFunctionForStdcall = function(out vIntf : IInterface) :HRESULT; stdcall;
typedef HRESULT(__stdcall *TGetInterfaceFunctionForStdcall) (IInterface ** instance);

/// <summary>
///   C++ 语言调用的接口, 主控台提供
/// </summary>
interface DECLSPEC_UUID("{9A7238C4-5A47-494B-9058-77500C1622DC}")
IApplicationContextForCPlus: public IInterface{
	/// <summary>
	///   根据beanID获取对应的插件
	/// </summary>
	/// function GetBeanForCPlus(pvBeanID: PAnsiChar; out vInstance : IInterface) : HRESULT; stdcall;
	virtual HRESULT __stdcall GetBeanForCPlus(PMyBeanChar beanId, IInterface **p) = 0;

	/// <summary>
	///   获取beanID对应的工厂接口
	/// </summary>
	/// function GetBeanFactoryForCPlus(pvBeanID:PAnsiChar; out vInstance : IInterface) : HRESULT; stdcall;
	virtual HRESULT __stdcall GetBeanFactoryForCPlus(PMyBeanChar beanId, IInterface **p) = 0;
};


/// <summary>
///   C++ 语言调用的接口, 主控台提供
/// </summary>
interface DECLSPEC_UUID("{66828066-38B7-4613-8F9B-627CB76D84F2}")
IStrMapForCPlus: public IInterface{
/// <summary>
///   根据key值获取接口
/// </summary>
/// function GetValue(pvKey:PAnsiChar; out vIntf : IInterface) : HRESULT; stdcall;
virtual HRESULT __stdcall GetValue(PMyBeanChar beanId, IInterface **p) = 0;


/// <summary>
///  赋值接口
/// </summary>
/// function SetValue(pvKey:PAnsiChar; pvIntf: IInterface) : HRESULT; stdcall;
virtual HRESULT __stdcall SetValue(PMyBeanChar beanId, IInterface * p) = 0;

/// <summary>
///   移除接口
/// </summary>
/// function Remove(pvKey:PAnsiChar) : HRESULT; stdcall;
virtual HRESULT __stdcall Remove(PMyBeanChar beanId) = 0;

/// <summary>
///   判断是否存在接口
/// </summary>
/// function Exists(pvKey:PAnsiChar) : HRESULT; stdcall;
virtual HRESULT __stdcall Exists(PMyBeanChar beanId) = 0;
};


/// <summary>
///   插件工厂接口,由插件宿主(DLL, BPL)库文件提供
/// </summary>
interface DECLSPEC_UUID("{480EC845-2FC0-4B45-932A-57711D518E70}")
IBeanFactory: public IInterface{
	/// <summary>
	///   获取所有的插件ID
	///     返回获取ID的长度分隔符#10#13
	/// </summary>
	virtual int __stdcall GetBeanList(PMyBeanChar IDs, int len) = 0;

	/// <summary>
	///   根据beanID获取对应的插件
	/// </summary>
	///  function GetBean(pvBeanID: PAnsiChar): IInterface; stdcall;
	virtual HRESULT __stdcall GetBean(PMyBeanChar beanId) = 0;


	/// <summary>
	///   初始化,加载DLL后执行
	/// </summary>
	/// procedure CheckInitalize; stdcall;
	virtual void __stdcall CheckInitalize() = 0;

	/// <summary>
	///   卸载DLL之前执行
	/// </summary>
	/// procedure CheckFinalize; stdcall;
	virtual void __stdcall CheckFinalize() = 0;

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
	virtual int __stdcall ConfigBeans(PMyBeanChar config) = 0;

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
	virtual int __stdcall ConfigBean(PMyBeanChar beanId, PMyBeanChar config) = 0;


	/// <summary>
	///   配置bean配置
	///     pluginID,内部的插件ID
	/// </summary>
	/// function ConfigBeanPluginID(pvBeanID, pvPluginID: PAnsiChar) : Integer; stdcall;
	virtual int __stdcall ConfigBeanPluginID(PMyBeanChar beanId, PMyBeanChar pluginId) = 0;

	/// <summary>
	///   配置bean配置
	///     singleton,单实例,
	///     配置单实例时，请注意要么对象有接口管理生命周期，要么实现IFreeObject接口
	///     不要手动释放释放对象.
	/// </summary>
	/// function ConfigBeanSingleton(pvBeanID: PAnsiChar; pvSingleton:Boolean) : Integer; stdcall;
	virtual int __stdcall ConfigBeanSingleton(PMyBeanChar beanId, bool pvSingleton) = 0;

	};


	/// <summary>
	///   C++ 的扩展实现插件工厂
	/// </summary>
	interface DECLSPEC_UUID("{D6F1B138-ECEA-44FC-A3E3-0B5169F1077A}")
	IBeanFactory4CPlus: public IInterface{
	/// <summary>
	///   根据beanID获取对应的插件
	/// </summary>
	/// function GetBeanForCPlus(pvBeanID: PAnsiChar; out vInstance : IInterface) : HRESULT; stdcall;
	virtual HRESULT __stdcall GetBeanForCPlus(PMyBeanChar beanId, IInterface **p) = 0;
	};
	
