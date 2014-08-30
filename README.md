#delphi-framework-MyBean

开源地址:
https://git.oschina.net/ymofen/delphi-framework-MyBean

MyBean轻量级配置框架，插件交流群: 205486036


说明文档
http://www.cnblogs.com/DKSoft/category/608549.html

BLOG
http://www.cnblogs.com/DKSoft/category/540328.html


[MyBean特性]

1.轻量级配置插件框架，一个开源的DLL，完成对插件的管理。

2.可以通过配置选择预加载配置文件，不直接加载DLL插件文件

3.可以通过配置选择是否使用DLL缓存目录，这样可以在运行时就可以覆盖更新插件DLL。

4.单个EXE可以通过注册插件工厂，使用插件功能。

5.方便的单实例模式。可以由框架接管插件的生命周期。

6.只要实现了IInterface都可以称为插件，可以注册到框架插件，整合简单。

7.可以读取多个插件配置文件，在主配置中进行如下配置即可
;加载bean配置文件目录(相对路径(EXE目录的相对路径)，绝对路径(c:\config\*.*)
;没有配置时,直接加载DLL,从DLL中获取PluginID
;<none>时不加载任何DLL插件
beanConfigFiles=*.plug-ins,plug-ins\*.plug-ins,beanConfig\*.plug-ins

8.使用json进行bean的配置,配置简单
{
   "id":"aboutForm",
   "pluginID":"aboutForm", //如果与id一致可以进行忽略
   "lib":"plug-ins\\mCore.dll", //文件名
   "singleton":true, //是否单件模式
   /// 配置单实例时，请注意要么对象有接口引用管理生命周期，要么实现IFreeObject接口
   /// 不要手动释放释放对象.
}

9.框架绿色而且全部开源(支持D7 - XE6)