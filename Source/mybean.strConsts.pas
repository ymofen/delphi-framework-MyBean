unit mybean.strConsts;

interface

resourcestring
  sDebug_LoadFromConfigFile        = '从配置文件中加载bean配置';
  sDebug_NoneConfigFile            = '没有加载任何配置文件';
  sDebug_DirectlyLoadLibFile       = '直接加载DLL文件';
  sDebug_applicationContextUnload  = 'applicationContext存在[%d]未释放的情况';
  sDebug_applicationKeyMapUnload   = 'applicationKeyMap存在[%d]未释放的情况';

  sLoadTrace_BeanID_Repeat         = '在注册插件[%s]时发现重复,已经在[%s]进行了注册';
  sLoadTrace_Lib_Inialize          = '准备初始化插件文件[%s]';
  sLoadTrace_Lib_Invalidate        = '文件[%s]不是有效的插件宿主文件';
  sLoadTrace_Lib_Error             = '加载插件文件[%s]出现异常:%s';

implementation

end.
