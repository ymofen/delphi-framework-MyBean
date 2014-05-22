unit PluginTabControl;

interface

uses
  Tabs, Classes, SysUtils, uICaption, uPluginObject;

type
  TPluginTabControl = class(TTabSet)
  private
    function checkGetPluginObject(pvIndex:Integer): TPluginObject;
  protected
    procedure OnTabChange(Sender: TObject; NewTab: Integer; var AllowChange:
        Boolean);
    procedure OnTabClose(Sender: TObject; var ACanClose: Boolean);

    procedure setCaptionMananger(const pvPlugin: IInterface; pvCaptionMananger:
        ICaptionManager);

    procedure onPluginSetCaption(Sender: TObject; pvCaption:String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function BindPlugin(const pvPlugin: IInterface; pvInstanceID: string): TPluginObject;

    function unBindPlugin(pvIndex: Integer; const pvPluginObject: TPluginObject):
        Boolean;

    function remove(pvInstanceID:string): Boolean;

    procedure showCurrentPlugin();

    function ShowTabPlugin(pvIndex: Integer): IInterface;
    
    function FindPlugin(const pvInstanceID: string): Integer;

    function CheckFind(const pvInstanceID: string; pvRaiseIfFalse: Boolean = true):
        Integer;

    function GetActivePlugin: IInterface;

    procedure closeAll;

    procedure freeAll;

    procedure RefreshCaption(const pvPlugin: IInterface);
  end;



implementation

uses
  Forms, uMainFormTools;

constructor TPluginTabControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  self.ShowCloseButton := true;
//  self.ShowCloseButtonOnActiveTab := true;
  self.OnChange := OnTabChange;
  //self.OnClose := OnTabClose;
end;

destructor TPluginTabControl.Destroy;
begin
  inherited Destroy;
end;

procedure TPluginTabControl.OnTabClose(Sender: TObject; var ACanClose: Boolean);
var
  lvPluginObject: TPluginObject;
begin
  //在Plugin释放的时候移除
  ACanClose := false;
  lvPluginObject := TPluginObject(Self.Tabs.Objects[self.TabIndex]);
  if not lvPluginObject.canClose then
  begin //不允许手工关闭, 主页
    {nop}
  end else
  begin
    TMainFormTools.closePlugin(lvPluginObject.Plugin);
  end;
end;

procedure TPluginTabControl.OnTabChange(Sender: TObject; NewTab: Integer; var
    AllowChange: Boolean);
var
  lvPluginObject: TPluginObject;
begin
  if self.TabIndex = -1 then exit;
  
  lvPluginObject := TPluginObject(Self.Tabs.Objects[self.TabIndex]);
  if lvPluginObject<> nil then
  begin
    TMainFormTools.showAsNormal(lvPluginObject.Plugin);
  end;
end;

function TPluginTabControl.BindPlugin(const pvPlugin: IInterface; pvInstanceID:
    string): TPluginObject;
var
  lvObj: TPluginObject;
  lvStr:String;
begin
  lvObj := TPluginObject.Create();
  lvObj.OnSetCaption := self.onPluginSetCaption;
  lvObj.InstanceID := pvInstanceID;
  lvObj.Plugin := pvPlugin;
  
  lvStr := TMainFormTools.getPluginCaption(lvObj.Plugin);
  self.setCaptionMananger(pvPlugin, lvObj);

  Self.OnChange := nil;
  try
    self.TabIndex := self.Tabs.AddObject(lvStr, lvObj);
  finally
    self.OnChange := OnTabChange;
  end;

//  with self.Tabs.Add do
//  begin
//    self.TabIndex := Index;
//    Data := lvObj;
//    ImageIndex := 0;
//    Caption := lvStr;
//  end;
  Result := lvObj;
end;

function TPluginTabControl.CheckFind(const pvInstanceID: string;
    pvRaiseIfFalse: Boolean = true): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Tabs.Count - 1 do
  begin
    if checkGetPluginObject(i).InstanceID = pvInstanceID then
    begin
      Result := i;
      Break;
    end;
  end;

  if (Result = -1) and pvRaiseIfFalse then
    raise Exception.CreateFmt('未找到(%)插件对应的页面', [pvInstanceID]);
end;

procedure TPluginTabControl.closeAll;
var
  i: Integer;
  lvPluginObject: TPluginObject;
begin
  for i := Self.Tabs.Count - 1 downto 0 do
  begin
    lvPluginObject := checkGetPluginObject(i);
    if not lvPluginObject.canClose then
    begin //不允许手工关闭, 主页
      {nop}
    end else
    begin
      TMainFormTools.closePlugin(lvPluginObject.Plugin);
    end;
  end;

end;

function TPluginTabControl.FindPlugin(const pvInstanceID: string): Integer;
var
  i: Integer;
  lvIsDetail:Boolean;
begin
  Result := -1;
  for i := 0 to Self.Tabs.Count - 1 do
  begin
    if checkGetPluginObject(i).InstanceID = pvInstanceID then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TPluginTabControl.freeAll;
var
  i: Integer;
  lvPluginObject: TPluginObject;
begin
  for i := Self.Tabs.Count - 1 downto 0 do
  begin
    lvPluginObject := checkGetPluginObject(i);
    try
      unBindPlugin(i, lvPluginObject);
      TMainFormTools.freePlugin(lvPluginObject.Plugin);
    finally
      lvPluginObject.Free;
    end;
  end;
end;

function TPluginTabControl.GetActivePlugin: IInterface;
var
  lvPluginObject: TPluginObject;
begin
  Result := nil;
  if Self.TabIndex = -1 then exit;
  Result := checkGetPluginObject(self.TabIndex).Plugin;
end;

function TPluginTabControl.checkGetPluginObject(pvIndex:Integer): TPluginObject;
begin
  Result := TPluginObject(Self.Tabs.Objects[pvIndex]);
  if Result = nil then
  begin
    raise Exception.Create('获取不到页面插件对象');
  end;
end;

procedure TPluginTabControl.onPluginSetCaption(Sender: TObject;
  pvCaption: String);
begin

end;

procedure TPluginTabControl.RefreshCaption(const pvPlugin: IInterface);
var
  lvIndex: Integer;
  lvInstanceID:String;
  s: string;
  s2: string;
begin
  lvInstanceID := TMainFormTools.getInstanceID(pvPlugin);
  lvIndex := CheckFind(lvInstanceID, False);
  if lvIndex <> -1 then
  begin
    self.Tabs[lvIndex] := TMainFormTools.getPluginCaption(pvPlugin);
  end;
end;

function TPluginTabControl.remove(pvInstanceID:string): Boolean;
var
  lvIndex: Integer;
  lvObj: TPluginObject;
begin
  Result := false;
  lvIndex := CheckFind(pvInstanceID, False);
  if lvIndex <> -1 then
  begin
    lvObj := checkGetPluginObject(lvIndex);
    try
      unBindPlugin(lvIndex, lvObj);
      Result := true;

    finally
      lvObj.Free;
    end;

  end;

end;

procedure TPluginTabControl.setCaptionMananger(const pvPlugin: IInterface;
    pvCaptionMananger: ICaptionManager);
var
  lvSetter:ICaptionManagerSetter;
begin
  if pvPlugin = nil then Exit;  
  try
    if pvPlugin.QueryInterface(ICaptionManagerSetter, lvSetter) = S_OK then
    begin
      lvSetter.setCaptionManager(pvCaptionMananger);
    end;
  except
  end;
end;

procedure TPluginTabControl.showCurrentPlugin;
begin
  ShowTabPlugin(self.TabIndex);
end;

function TPluginTabControl.ShowTabPlugin(pvIndex: Integer): IInterface;
var
  lvPluginObject: TPluginObject;
begin
  Self.TabIndex := pvIndex;
  if pvIndex = -1 then exit;
  
  lvPluginObject := checkGetPluginObject(pvIndex);
  TMainFormTools.showAsNormal(lvPluginObject.Plugin);
  Result := lvPluginObject.Plugin;
end;

function TPluginTabControl.unBindPlugin(pvIndex: Integer; const pvPluginObject:
    TPluginObject): Boolean;
var
  lvIndex: Integer;
  lvObj: TPluginObject;
begin
  self.OnChange := nil;
  try
    Result := false;
    setCaptionMananger(lvObj.Plugin, nil);
    //先删除
    //Self.Tabs[lvIndex] := nil;
    self.Tabs.Objects[pvIndex] := nil;

    Self.Tabs.Delete(pvIndex);
  finally
    self.OnChange := OnTabChange;
  end;

end;


end.

