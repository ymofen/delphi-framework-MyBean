unit DMQProtocol;

interface

const
  cmd_none     = 0;         //
  cmd_kickout  = 2;         // 通知踢掉连接
  cmd_send     = 3;         // 发送
  cmd_registerDispatch = 4; // 注册逻辑处理


const
  result_Decode_succ       = 1;
  result_Decode_none       = 2;  // 没有可以解码的数据
  result_Decode_error      = 3;  // 数据异常

type
  // 逻辑处理进程请求的数据结构
  // 处理进程 -> DMQ引擎 的数据结构
  PDMQDispatchRequestRecord = ^TDMQDispatchRequestRecord;
  TDMQDispatchRequestRecord = packed record
    flag        : Word;
    cmdIndex    : Word;
    remoteSocketHandle: THandle;     // 远程socket句柄
    remoteContextDNA  : Integer;     // ContextDNA
    datalen     : Integer;
  end;



  // DMQ引擎 -> 处理进程的数据结构
  TDMQDispatchRecord = packed record
    flag        : Word;
    remoteSocketHandle: THandle;     // 远程socket句柄
    remoteContextDNA  : Integer;     // ContextDNA
    datalen     : Integer;
  end;

  // 终端 -> DMQ引擎 的数据结构
  TDMQRequestRecord = packed record
    flag       : word;
    logicID    : word;     // 逻辑处理器ID
    datalen    : Integer;  // 数据长度
  end;

  // 终端 -> DMQ引擎 的数据结构
  TDMQResponseRecord = packed record
    flag       : word;
    datalen    : Integer;  // 数据长度
  end;

const
  TDMQRequestRecordSize = SizeOf(TDMQRequestRecord);
  TDMQDispatchRequestRecordSize = SizeOf(TDMQDispatchRequestRecord);

const
  Header_Flag = $D10;

implementation

end.
