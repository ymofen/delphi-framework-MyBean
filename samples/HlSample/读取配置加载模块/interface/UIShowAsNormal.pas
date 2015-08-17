unit UIShowAsNormal;

interface

type
  IShowForm = interface
  ['{DC71A10B-7EC2-45D8-B2D7-17D78D193C90}']
  procedure ShowAsNoraml;stdcall;
  procedure ShowAsMdi;stdcall;
  end;

  IMainPlugCom =interface
    ['{CE4DF363-A5A3-4013-A27C-2A3C4F15E3EB}']
  procedure Receive(msg:PChar);stdcall;
  procedure Send(msg:PChar);stdcall;
  end;



implementation

end.
