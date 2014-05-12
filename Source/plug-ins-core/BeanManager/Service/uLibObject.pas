unit uLibObject;

interface

uses
  Windows, SysUtils, Classes, uIBeanFactory, superobject;

type
  /// <summary>
  ///   DLL文件管理
  /// </summary>
  TLibObject = class(TObject)
  private
    FLibHandle:THandle;
    FLibFileName: String;
  private
    FbeanFactory: IBeanFactory;

    procedure DoCreatePluginFactory;

    procedure DoInitialize;
  public
    procedure DoFreeLibrary;

    function DoLoadLibrary: Boolean;

    property LibFileName: String read FLibFileName write FLibFileName;

    property beanFactory: IBeanFactory read FbeanFactory;

  end;

implementation

procedure TLibObject.DoCreatePluginFactory;
var
  lvFunc:function:IBeanFactory; stdcall;
begin
  @lvFunc := GetProcAddress(FLibHandle, PChar('getBeanFactory'));
  if (@lvFunc = nil) then
  begin
    raise Exception.CreateFmt('非法的Plugin模块文件(%s),找不到入口函数(getBeanFactory)', [self.FLibFileName]);
  end;
  FbeanFactory := lvFunc;
end;

procedure TLibObject.DoFreeLibrary;
begin
  FbeanFactory := nil;
  if FLibHandle <> 0 then FreeLibrary(FLibHandle);
end;

procedure TLibObject.DoInitialize;
begin
  DoCreatePluginFactory;
end;

function TLibObject.DoLoadLibrary: Boolean;
begin
  if FLibHandle <> 0 then
  begin
    Result := true;
    Exit;
  end;
  if not FileExists(FLibFileName) then
    raise Exception.Create('文件[' + FLibFileName + ']未找到!');
  FLibHandle := LoadLibrary(PChar(FLibFileName));
  Result := FLibHandle <> 0;
  if Result then DoInitialize;
end;

end.
