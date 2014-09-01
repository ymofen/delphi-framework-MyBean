unit uMsgTools;
{
  对话框单元
}

interface

uses
     SysUtils, windows, forms, Dialogs;
     
type
  TMsgTools = class(TObject)
  public
    //显示信息框
    class procedure ShowINfo(pvMsg: string);

    class procedure showNumeric(pvFloat:Double; pvPreText:string= '');

    //询问确认信息框
    class function QueryMsg(pvMsg:String): Boolean;
    class procedure ShowError(Msg: string; pvTitle: String = '');

    class procedure showException(E:Exception;pvAbort:Boolean = true);

    class procedure showErrorMessage(msg:string;pvAbort:Boolean = true);

    //6: IDYES, 7: no, 2:cancel     //Windows
    class function ShowYesNoCancel(Msg: string; DefaultButton: Word = 1; TopMost:
        Boolean = false): Word;

  end;



implementation

{显示信息框}
class procedure TMsgTools.ShowINfo(pvMsg: string);
begin
  Application.MessageBox(PChar(pvMsg),'消息...',MB_ICONINFORMATION+MB_OK);
end;

{问确认信息框}
class function TMsgTools.QueryMsg(pvMsg:String): Boolean;
begin
  if Application.MessageBox(PChar(pvMsg),'询问...',MB_ICONINFORMATION+MB_YESNO)=7 then
    Result:=False
  else
    Result:=true;
end;

class procedure TMsgTools.ShowError(Msg: string; pvTitle: String = '');
begin
  if pvTitle = '' then pvTitle :=Application.Title;
  Application.MessageBox(PChar(Msg),
    PChar(pvTitle), MB_ICONERROR or MB_OK or MB_DEFBUTTON1);
end;

class procedure TMsgTools.showErrorMessage(msg:string;pvAbort:Boolean = true);
begin
   MessageDlgPos(msg, mtError, [mbOK], 0, -1, -1);
   if pvAbort then
   begin
     Abort;
   end;
end;

class procedure TMsgTools.showException(E:Exception;pvAbort:Boolean = true);
begin
   MessageDlgPos(E.Message, mtError, [mbOK], 0, -1, -1);
   if pvAbort then
   begin
     Abort;
   end;
end;

class procedure TMsgTools.showNumeric(pvFloat:Double; pvPreText:string= '');
var
  lvMsg:String;
begin
  lvMsg := pvPreText + FloatToStr(pvFloat);
  ShowINfo(lvMsg);
end;

class function TMsgTools.ShowYesNoCancel(Msg: string; DefaultButton: Word = 1;
    TopMost: Boolean = false): Word;
const
  TDEFBUTTON: array[1..4] of Word = (MB_DEFBUTTON1, MB_DEFBUTTON2, MB_DEFBUTTON3, MB_DEFBUTTON4);
var
  ltype: Cardinal;
begin
  if DefaultButton < 1 then DefaultButton := 1;
  if DefaultButton > 4 then DefaultButton := 4;
  ltype := MB_ICONQUESTION or MB_YESNOCANCEL or TDEFBUTTON[DefaultButton];
  if TopMost then ltype := ltype or MB_TOPMOST;
  result := Application.MessageBox(PChar(string(Msg)),
    PChar(Application.Title), ltype);
end;

end.
