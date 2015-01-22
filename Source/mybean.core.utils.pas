(*
 *	 Unit owner: D10.天地弦
 *	   blog: http://www.cnblogs.com/dksoft
 *
 *   v0.1.0(2014-08-29 13:00)
 *     修改加载方式(beanMananger.dll-改造)
 *
 *	 v0.0.1(2014-05-17)
 *     + first release
 *
 *
 *)

unit mybean.core.utils;

interface

uses  
  mybean.core.safeLogger;


var
  __beanLogger:TSafeLogger;

implementation



initialization
  __beanLogger := TSafeLogger.Create;
  __beanLogger.setAppender(TLogFileAppender.Create(False));

finalization  
  __beanLogger.Free;
  __beanLogger := nil;



end.
