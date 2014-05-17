unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Menus, Actions, ActnList,
  Tabs;

type
  TfrmMain = class(TForm)
    mmMain: TMainMenu;
    TabSet1: TTabSet;
    actlstMain: TActionList;
    actAbout: TAction;
    actAbout1: TMenuItem;
    procedure actAboutExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  mBeanFrameVars, uIFormShow;

{$R *.dfm}

procedure TfrmMain.actAboutExecute(Sender: TObject);
var
  lvIntf:IInterface;
begin
  lvIntf := TmBeanFrameVars.getBean('aboutForm');
  try
    (lvIntf as IShowAsModal).showAsModal;
  finally
    TmBeanFrameVars.freeBeanInterface(lvIntf);
  end;
end;

end.
