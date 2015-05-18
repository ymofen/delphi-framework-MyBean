#if _MSC_VER > 1000
#pragma once
#endif 

/// 全局的插件工程变量修饰
extern BeanFactory * __beanFactory;
extern IInterface * __applicationContext;
extern IInterface * __stdcall GetBean(PMyBeanChar beanID);
extern IInterface * GetMapObject(PMyBeanChar objId);