unit uLibObject;

interface

uses
  Windows, SysUtils, Classes, uIBeanFactory, superobject, uSOTools;

type
  /// <summary>
  ///   DLL文件管理
  /// </summary>
  TLibObject = class(TObject)
  private
    FLibHandle:THandle;
    FlibFileName: String;

    /// <summary>
    ///   bean的配置
    /// </summary>
    FConfig: ISuperObject;

  private
    FBeanFactory: IBeanFactory;

    procedure doCreatePluginFactory;

    procedure doInitialize;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    ///   beanID和配置信息
    /// </summary>
    procedure configBean(pvBeanID: string; pvBeanConfig: ISuperObject);

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
    property libFileName: String read FlibFileName write FlibFileName;

    /// <summary>
    ///   DLL中BeanFactory接口
    /// </summary>
    property beanFactory: IBeanFactory read FBeanFactory;
  end;

implementation

constructor TLibObject.Create;
begin
  inherited Create;
  FConfig := SO();
end;

destructor TLibObject.Destroy;
begin
  FConfig := nil;
  inherited Destroy;
end;

procedure TLibObject.doCreatePluginFactory;
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

procedure TLibObject.doFreeLibrary;
begin
  FBeanFactory := nil;
  if FLibHandle <> 0 then FreeLibrary(FLibHandle);
end;

procedure TLibObject.doInitialize;
begin
  doCreatePluginFactory;
end;

procedure TLibObject.configBean(pvBeanID: string; pvBeanConfig: ISuperObject);
var
  lvMapKey:String;
begin
  lvMapKey := TSOTools.makeMapKey(pvBeanID);
  FConfig.O[lvMapKey] := pvBeanConfig;
end;

function TLibObject.checkLoadLibrary: Boolean;
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

end.
