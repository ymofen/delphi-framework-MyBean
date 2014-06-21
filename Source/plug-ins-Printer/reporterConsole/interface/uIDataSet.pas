unit uIDataSet;

interface

uses
  DB;

type
  IDataSetGetter = interface(IInterface)
    ['{710743CE-3817-455B-A29C-39B3EA98DE5F}']
    function getDataSet: TDataSet; stdcall;
  end;

implementation

end.
