unit uMyBeanLoggerImpl;

interface

uses
  mybean.core.objects, uILogic,
  mybean.core.beanFactory;

type
  TMyBeanLoggerImpl = class(TMyBeanInterfacedObject, IMyBeanLogger)
  protected
    procedure LogMessage(s: PAnsiChar); stdcall;
  end;

implementation

{ TMyBeanLoggerImpl }

procedure TMyBeanLoggerImpl.LogMessage(s: PAnsiChar);
begin
  WriteLn(s);
end;


initialization
  ///×¢²áÈÕÖ¾²å¼þ
  beanFactory.RegisterBean('mybeanLogger', TMyBeanLoggerImpl);

end.
