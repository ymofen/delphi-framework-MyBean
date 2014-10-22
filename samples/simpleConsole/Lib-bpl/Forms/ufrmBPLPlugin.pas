unit ufrmBPLPlugin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mybean.core.beanFactory, uBasePluginForm, StdCtrls;

type
  TfrmBPLPlugin = class(TBasePluginForm)
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBPLPlugin: TfrmBPLPlugin;

implementation

{$R *.dfm}


initialization
  beanFactory.RegisterBean('bplFormDEMO', TfrmBPLPlugin);

finalization
  ;


end.
