unit uIBarTenderData;

interface

type
  
  /// <summary>
  ///   直接获取BarTender打印数据
  ///   如果实现了该接口则会从中选择数据进行打印
  /// </summary>
  IBarTenderDataGetter = interface(IInterface)
    ['{E101710A-1502-4809-911A-B968FBAE07C9}']

    /// <summary>
    ///   获取BarTender直接需要打印的数据
    /// </summary>
    /// <returns>
    /// {
    ///    "list":
    ///     [
    ///
    //          {   //一条记录
    //              fieldname:
    //              {
    //                 "name":fieldname,
    //                 "value":xxx,
    //                 "caption":"设计时标题",
    //              },
    //              fieldname2:
    //              {
    //                 "name":fieldname2,
    //                 "value":xxx,
    //                 "caption":"设计时标题",
    //              },
    //          },
    ///         {}
    ///     ]
    /// }
    /// </returns>
    function getBarTenderPrintData: PAnsiChar; stdcall;
  end;

implementation

end.
