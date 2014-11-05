unit uEWHelpers;

{$I eDefines.inc}

interface

{$IFDEF DELPHI5}
uses
  FileCtrl;

type
  THandle = Integer;
{$ENDIF}

function SelectDirectory(const AppHandle: THandle; const Caption: string;
  const Root: WideString; var Directory: string): Boolean;

implementation

{$IFDEF FPC}
uses Dialogs;
{$ELSE}
uses {$IFDEF MSWINDOWS}Windows, ActiveX, ShlObj, {$ENDIF} SysUtils, Forms;
{$ENDIF}

{$IFDEF FPC}
function SelectDirectory(const AppHandle: THandle; const Caption: string;
  const Root: WideString; var Directory: string): Boolean;
var
  str: Ansistring;
begin
  // now only Ansi version
  str := Directory;
  Result := Dialogs.SelectDirectory(Caption, Root, str);
  if Result then Directory := str;
end;
{$ELSE}
function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpdata);
  result := 0;
end;

function SelectDirectory(const AppHandle: THandle; const Caption: string;
  const Root: WideString; var Directory: string): Boolean;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  OldErrorMode: Cardinal;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := False;
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(AppHandle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do
      begin
        hwndOwner := AppHandle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS or
          {$IFDEF DELPHI7UP} BIF_NEWDIALOGSTYLE {$ELSE} $0040 {$ENDIF};
        if Directory <> '' then
        begin
          lpfn := SelectDirCB;
          lParam := Integer(PChar(Directory));
        end;
      end;
      WindowList := DisableTaskWindows(0);
      OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        SetErrorMode(OldErrorMode);
        EnableTaskWindows(WindowList);
      end;
      Result :=  ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;
{$ENDIF}

end.
