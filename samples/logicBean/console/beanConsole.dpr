program beanConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  mybean.console,
  mybean.tools.beanFactory,
  SysUtils,
  uILogic in '..\common\uILogic.pas';

var
  s:string;
  i, j:Integer;
begin
  try
    //初始化mybean框架
    applicationContextInitialize;

    writeLn('input i:');
    Readln(i);
    writeLn('input j:');
    Readln(j);
    WriteLn('sum result:' +
      IntToStr(
        (TMyBeanFactoryTools.getBean('sumExp') as ISumExp).sum(i, j)    //调用插件执行逻辑
      )
    );

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Writeln('按任意键退出程序');

  Readln(s);


end.
