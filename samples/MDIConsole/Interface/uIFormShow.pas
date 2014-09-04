unit uIFormShow;

interface

uses
  Vcl.Controls;

type
  /// <summary>
  ///   标准显示
  /// </summary>
  IShowAsNormal = interface(IInterface)
    ['{4A2274AB-3069-4A57-879F-BA3B3D15097D}']
    procedure showAsNormal; stdcall;
  end;

  /// <summary>
  ///   显示成Modal窗体
  /// </summary>
  IShowAsModal = interface(IInterface)
    ['{6A3A6723-8FE7-4698-94BC-5CEDFD4FC750}']
    function showAsModal: Integer; stdcall;
  end;

  /// <summary>
  ///   显示成MDI窗体
  /// </summary>
  IShowAsMDI = interface(IInterface)
    ['{F68D4D30-C70C-4BCC-9F83-F50D2D873629}']
    procedure showAsMDI; stdcall;
  end;

  IShowAsChild = interface(IInterface)
    ['{B0AF3A34-8A50-46F9-B723-DEE17F92633B}']
    procedure showAsChild(pvParent:TWinControl); stdcall;
  end;






implementation

end.
