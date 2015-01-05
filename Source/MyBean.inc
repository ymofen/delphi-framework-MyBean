{$DEFINE MYBEAN}

{$IFDEF DEBUG}
  {$DEFINE LOG_ON}
{$ENDIF}

{$IF defined(FPC) or defined(VER170) or defined(VER180) or defined(VER190) or defined(VER200) or defined(VER210)}
  {$DEFINE HAVE_INLINE}
{$IFEND}
