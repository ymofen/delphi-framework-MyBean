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

unit mybean.tools.beanFactory;

interface

uses
  mybean.core.intf, SysUtils;

type
  TMyBeanFactoryTools = class(TObject)
  public
    /// <summary>
    ///   获取applicationContext接口
    /// </summary>
    class function applicationContext: IApplicationContext;

    
    class procedure checkRaiseErrorINfo(const pvIntf: IInterface);

    /// <summary>
    ///   根据beanID获取对应的插件接口,
    ///      如果beanID对应的配置为单实例模式，相应的对象只会创建一次
    /// </summary>
    class function getBean(pvBeanID: string; pvRaiseIfNil: Boolean = true): IInterface;

    /// <summary>
    ///   释放插件
    /// </summary>
    class procedure freeBeanInterface(const pvInterface:IInterface);

    /// <summary>
    ///   存放全局的对象
    /// </summary>
    class procedure setObject(const pvID: AnsiString; const pvObject: IInterface);

    /// <summary>
    ///   设置得到全局的接口对象
    /// </summary>
    class function getObject(const pvID:AnsiString):IInterface;


    /// <summary>
    ///   判断插件是否存在
    /// </summary>
    class function existsObject(pvID:String): Boolean;

    /// <summary>
    ///   移除全局的接口对象
    /// </summary>
    class procedure removeObject(pvID:AnsiString);
  end;

implementation



class function TMyBeanFactoryTools.applicationContext: IApplicationContext;
begin
  Result := appPluginContext;
end;

class procedure TMyBeanFactoryTools.checkRaiseErrorINfo(const pvIntf: IInterface);
var
  lvErr:IErrorINfo;
  lvErrCode:Integer;
  lvErrDesc:AnsiString;
  j:Integer;
begin
  if pvIntf = nil then exit;
  if pvIntf.QueryInterface(IErrorINfo, lvErr) = S_OK then
  begin
    lvErrCode := lvErr.getErrorCode;
    if lvErrCode <> 0  then
    begin
      j:=lvErr.getErrorDesc(nil, 0);

      if j = 0 then
      begin
        lvErrDesc := '未知的错误信息';
      end else
      begin
        if j > 2048 then j := 2048;
        SetLength(lvErrDesc, j + 1);
        j := lvErr.getErrorDesc(PAnsiChar(lvErrDesc), j);
        lvErrDesc[j+1] := #0;
      end;

      if lvErrCode = -1 then
      begin
        raise Exception.Create(string(lvErrDesc));
      end else
      begin
        raise Exception.CreateFmt('错误信息:%s' + sLineBreak + '错误代码:%d', [lvErrDesc, lvErrCode]);
      end;
    end;
  end;


end;

class function TMyBeanFactoryTools.existsObject(pvID: String): Boolean;
begin
  Result := applicationKeyMap.existsObject(PAnsiChar(AnsiString(pvID)));
end;

class procedure TMyBeanFactoryTools.freeBeanInterface(
  const pvInterface: IInterface);
var
  lvFree:IFreeObject;
begin
  if pvInterface.QueryInterface(IFreeObject, lvFree) = S_OK then
  begin
    lvFree.FreeObject;
    lvFree := nil;
  end;
end;

class function TMyBeanFactoryTools.getBean(pvBeanID: string; pvRaiseIfNil: Boolean
    = true): IInterface;
var
  lvFactory:IBeanFactory;
begin
  lvFactory := applicationContext.getBeanFactory(PAnsiChar(AnsiString(pvBeanID))) as IBeanFactory;
  if lvFactory = nil then
  begin
    if pvRaiseIfNil then
      raise Exception.CreateFmt('找不到插件[%s]对应的工厂', [pvBeanID]);
  end else
  begin
    result := lvFactory.getBean(PAnsiChar(AnsiString(pvBeanID)));
    if (Result = nil) and (pvRaiseIfNil) then
    begin
      checkRaiseErrorINfo(lvFactory);
    end;
  end;
end;

class function TMyBeanFactoryTools.getObject(const pvID: AnsiString): IInterface;
begin
  Result := applicationKeyMap.getObject(PAnsiChar(pvID));
end;

class procedure TMyBeanFactoryTools.removeObject(pvID: AnsiString);
begin
  if applicationKeyMap <> nil then
    applicationKeyMap.removeObject(PAnsiChar(pvID));
end;


class procedure TMyBeanFactoryTools.setObject(const pvID: AnsiString; const
    pvObject: IInterface);
begin
  applicationKeyMap.setObject(PAnsiChar(pvID), pvObject);
end;

end.

