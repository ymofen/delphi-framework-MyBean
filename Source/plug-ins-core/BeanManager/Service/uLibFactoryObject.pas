unit uLibFactoryObject;

interface

uses
  Windows, SysUtils, Classes, uIBeanFactory, superobject, uSOTools,
  uBaseFactoryObject;

type
  /// <summary>
  ///   DLL文件管理
  /// </summary>
  TLibFactoryObject = class(TBaseFactoryObject)
  private
    FLibHandle:THandle;
    FlibFileName: String;

  private

    procedure doCreatePluginFactory;

    procedure doInitialize;
    procedure SetlibFileName(const Value: String);
  public
    procedure checkInitialize; override;

    procedure cleanup;override;

    /// <summary>
    ///   根据beanID获取插件
    /// </summary>
    function getBean(pvBeanID:string): IInterface; override;

    /// <summary>
    ///   释放Dll句柄
    /// </summary>
    procedure doFreeLibrary;

    /// <summary>
    ///   加载dll文件
    /// </summary>
    function checkLoadLibrary: Boolean;

    /// <summary>
    ///   DLL文件
    /// </summary>
    property libFileName: String read FlibFileName write SetlibFileName;

  end;

implementation

procedure TLibFactoryObject.doCreatePluginFactory;
var
  lvFunc:function:IBeanFactory; stdcall;
begin
  @lvFunc := GetProcAddress(FLibHandle, PChar('getBeanFactory'));
  if (@lvFunc = nil) then
  begin
    raise Exception.CreateFmt('非法的Plugin模块文件(%s),找不到入口函数(getBeanFactory)', [self.FlibFileName]);
  end;
  FBeanFactory := lvFunc;
end;

procedure TLibFactoryObject.doFreeLibrary;
begin
  FBeanFactory := nil;
  if FLibHandle <> 0 then FreeLibrary(FLibHandle);
end;

procedure TLibFactoryObject.doInitialize;
begin
  doCreatePluginFactory;
end;

procedure TLibFactoryObject.checkInitialize;
begin
  if FbeanFactory <> nil then
  begin
    checkLoadLibrary;
  end;
end;

function TLibFactoryObject.checkLoadLibrary: Boolean;
begin
  if FLibHandle <> 0 then
  begin
    Result := true;
    Exit;
  end;
  if not FileExists(FlibFileName) then
    raise Exception.Create('文件[' + FlibFileName + ']未找到!');
  FLibHandle := LoadLibrary(PChar(FlibFileName));
  Result := FLibHandle <> 0;
  if Result then doInitialize;
end;

procedure TLibFactoryObject.cleanup;
begin
  doFreeLibrary;
end;

function TLibFactoryObject.getBean(pvBeanID:string): IInterface;
begin
  ;
end;

procedure TLibFactoryObject.SetlibFileName(const Value: String);
begin
  FlibFileName := Value;
  Fnamespace := FlibFileName;
end;

end.
