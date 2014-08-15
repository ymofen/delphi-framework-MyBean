unit ufrmPluginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, uBasePluginForm, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmPluginForm = class(TBasePluginForm)
    btnPutObject: TButton;
    btnGetObject: TButton;
    procedure btnGetObjectClick(Sender: TObject);
    procedure btnPutObjectClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

  TTesterObject = class(TObject)
  private
    FName:String;
  public

  end;

var
  frmPluginForm: TfrmPluginForm;

implementation

uses
  mBeanFrameVars, uIPluginForm, uMyBeanMapTools;

{$R *.dfm}

procedure TfrmPluginForm.btnGetObjectClick(Sender: TObject);
var
  lvObj:TTesterObject;
begin
  lvObj := TMyBeanMapTools.getObject('tester') as TTesterObject;
  if lvObj = nil then raise Exception.Create('对象仓库中没有找到对象的对象!');
  ShowMessage(lvObj.FName);
end;

procedure TfrmPluginForm.btnPutObjectClick(Sender: TObject);
var
  lvObj:TTesterObject;
begin
  lvObj := TTesterObject.Create;
  lvObj.FName := '全局对象测试';
  TMyBeanMapTools.setObject('tester', lvObj);
  ShowMessage('存放全局对象成功,你可以在其他插件中获取该对象');
end;

end.
