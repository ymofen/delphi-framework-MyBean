unit uListViewTools;

interface

uses
  SysUtils, Classes, ShellAPI, uFileTools, ComCtrls, StdCtrls, ExtCtrls, Controls;

type
  TListViewTools = class(TObject)
  public
    class function getSystempIconIndex(pvFileName:string): Integer;

    class procedure initialListViewForUseSystemIcon(pvListView: TListView);
  end;

implementation

class function TListViewTools.getSystempIconIndex(pvFileName: string): Integer;
var
  lvFileName:String;
var
  FileInfo: TSHFileInfo;
  Flags: Integer;
begin
  lvFileName:= '~temp' +  ExtractFileExt(pvFileName);
  lvFileName := TFileTools.GetWinTempPath + lvFileName;
  if not FileExists(lvFileName) then
  begin
    //创建一个临时文件<用来获取图标>
    with TStringList.create do
    try
      saveToFile(lvFileName);
    finally
      Free;
    end;
  end;


  Flags := SHGFI_ICON or SHGFI_LARGEICON;

  SHGetFileInfo(PChar(lvFileName), 0, FileInfo, SizeOf(TSHFileInfo), Flags);
  Result := FileInfo.iIcon;
end;

class procedure TListViewTools.initialListViewForUseSystemIcon(pvListView:
    TListView);
var
  wwImageList:THandle;
  FileInfo : SHFILEINFO;
  lvImageList:TImageList;
begin
// 第一步,  绑定系统图标
  wwImageList:=SHGetFileInfo('c:\',0,FileInfo,sizeof(FileInfo),SHGFI_SYSICONINDEX or SHGFI_LARGEICON);
  if pvListView.LargeImages = nil then
  begin
    //和pvListView一起释放
    lvImageList := TImageList.Create(pvListView);
    pvListView.LargeImages := lvImageList;
  end;

  pvListView.LargeImages.Handle:=wwImageList;
  pvListView.LargeImages.ShareImages:=true;
end;

end.
