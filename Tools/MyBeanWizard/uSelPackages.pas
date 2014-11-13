unit uSelPackages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst;

type
  TItemInfo=Class
    PackageFullName:String;
  end;
  TfrmSelPackages = class(TForm)
    btn_OK: TBitBtn;
    btn_Cancel: TBitBtn;
    lis_Units: TCheckListBox;
    lis_Packages: TListBox;
    Label2: TLabel;
    btn_ExtractUnit: TSpeedButton;
    OpenDialog1: TOpenDialog;
    btn_SelPackages: TSpeedButton;
    btn_Clear: TSpeedButton;
    chb_SelAll: TCheckBox;
    btn_Del: TSpeedButton;
    procedure btn_SelPackagesClick(Sender: TObject);
    procedure btn_ClearClick(Sender: TObject);
    procedure btn_ExtractUnitClick(Sender: TObject);
    procedure chb_SelAllClick(Sender: TObject);
    procedure btn_DelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure DoGetPackageInfo(const PackageFile:String);
    procedure CheckAll(v:Boolean);
    procedure ClearList(aList:TStrings);
  public
    procedure PutUnitToList(const UnitName:string);
    procedure GetUnitList(aList:TStrings);
  end;

var
  frmSelPackages: TfrmSelPackages;

implementation

{$R *.dfm}
procedure PckageInfo(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);
begin
  if NameType=ntContainsUnit then
  begin
    if Flags<>3 then
      frmSelPackages.PutUnitToList(Name);
  end;
end;

procedure TfrmSelPackages.btn_SelPackagesClick(Sender: TObject);
var i,idx:Integer;
    ItemInfo:TItemInfo;
    s:String;
begin
  //self.OpenDialog1.InitialDir:=ExtractFilePath(paramStr(0));
  if self.OpenDialog1.Execute then
  begin
    for i:=0 to self.OpenDialog1.Files.Count-1 do
    begin
      s:=ExtractFileName(self.OpenDialog1.Files[i]);
      idx:=lis_Packages.Items.IndexOf(s);
      if idx=-1 then
      begin
        ItemInfo:=TItemInfo.Create;
        ItemInfo.PackageFullName:=self.OpenDialog1.Files[i];
        lis_Packages.Items.AddObject(s,ItemInfo);
      end;
    end;
  end;
end;

procedure TfrmSelPackages.btn_ClearClick(Sender: TObject);
begin
  ClearList(self.lis_Packages.Items);
end;

procedure TfrmSelPackages.btn_ExtractUnitClick(Sender: TObject);
var i:integer;
    ItemInfo:TItemInfo;
begin
  self.lis_Units.Clear;
  for i:=0 to self.lis_Packages.Items.Count-1 do
  begin
    ItemInfo:=TItemInfo(self.lis_Packages.Items.Objects[i]);
    self.DoGetPackageInfo(ItemInfo.PackageFullName);
  end;
end;

procedure TfrmSelPackages.DoGetPackageInfo(const PackageFile: String);
var h:HMODULE;
    f:Integer;
begin
  h:=SafeLoadLibrary(PackageFile);//LoadPackage
  try
    f:=0;
    SysUtils.GetPackageInfo(h,nil,f,@PckageInfo);
  finally
    FreeLibrary(h);//UnLoadPackage
  end;
end;

procedure TfrmSelPackages.PutUnitToList(const UnitName: string);
var idx:Integer;
begin
  idx:=self.lis_Units.Items.IndexOf(UnitName);
  if idx=-1 then
  begin
    idx:=self.lis_Units.Items.Add(UnitName);
    self.lis_Units.Checked[idx]:=True;
  end;
end;

procedure TfrmSelPackages.chb_SelAllClick(Sender: TObject);
begin
  CheckAll(self.chb_SelAll.Checked);
end;

procedure TfrmSelPackages.CheckAll(v: Boolean);
var i:Integer;
begin
  for i:=0 to self.lis_Units.Count-1 do
    self.lis_Units.Checked[i]:=v;
end;

procedure TfrmSelPackages.GetUnitList(aList: TStrings);
var i:Integer;
begin
  for i:=0 to self.lis_Units.Count-1 do
  begin
    if self.lis_Units.Checked[i] then
      aList.Add(self.lis_Units.Items[i]);
  end;
end;


procedure TfrmSelPackages.ClearList(aList: TStrings);
var i:integer;
begin
  for i:=0 to aList.Count-1 do
    aList.Objects[i].Free;

  aList.Clear;
end;

procedure TfrmSelPackages.btn_DelClick(Sender: TObject);
var idx:Integer;
begin
  idx:=lis_Packages.ItemIndex;
  if idx<>-1 then
  begin
    lis_Packages.Items.Objects[idx].Free;
    lis_Packages.DeleteSelected;
  end;
end;

procedure TfrmSelPackages.FormDestroy(Sender: TObject);
begin
  ClearList(self.lis_Packages.Items);
end;

end.
