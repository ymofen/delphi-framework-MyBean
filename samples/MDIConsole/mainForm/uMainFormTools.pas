unit uMainFormTools;

interface

uses
  SysUtils, uIPluginForm;

type
  TMainFormTools = class(TObject)
  public
    class procedure closePlugin(const pvPlugin: IInterface);
    class procedure freePlugin(const pvPlugin: IInterface);

    class function getPluginCaption(const pvPlugin: IInterface): String;


    class function getInstanceID(const pvPlugin: IInterface): String;

    class procedure showAsMDI(const pvPlugin: IInterface);

    class procedure showAsNormal(const pvPlugin: IInterface);
  end;

implementation

uses
  Windows,
  Forms;

class procedure TMainFormTools.closePlugin(const pvPlugin: IInterface);
var
  lvForm:IPluginForm;
begin
  if pvPlugin.QueryInterface(IPluginForm, lvForm) = S_OK then
  begin
    lvForm.closeForm;
  end;
end;

class function TMainFormTools.getInstanceID(const pvPlugin: IInterface): String;
var
  lvForm:IPluginForm;
begin
  if pvPlugin.QueryInterface(IPluginForm, lvForm) = S_OK then
  begin
    Result := lvForm.getInstanceID;
  end;
end;

class procedure TMainFormTools.showAsMDI(const pvPlugin: IInterface);
var
  lvForm:IPluginForm;
begin
  if pvPlugin.QueryInterface(IPluginForm, lvForm) = S_OK then
  begin
    lvForm.showAsMDI;
  end;   
end;

class procedure TMainFormTools.showAsNormal(const pvPlugin: IInterface);
var
  lvForm:IPluginForm;
begin
  if pvPlugin.QueryInterface(IPluginForm, lvForm) = S_OK then
  begin
    lvForm.showAsNormal;
  end;
  
end;

class procedure TMainFormTools.freePlugin(const pvPlugin: IInterface);
var
  lvForm:IPluginForm;
begin
  if pvPlugin.QueryInterface(IPluginForm, lvForm) = S_OK then
  begin
    lvForm.freeObject;
  end;

end;

class function TMainFormTools.getPluginCaption(const pvPlugin: IInterface):
    String;
var
  lvForm:IPluginForm;
begin
  if pvPlugin.QueryInterface(IPluginForm, lvForm) = S_OK then
  begin
    Result := TForm(lvForm.getObject).Caption;
  end;

end;

end.
