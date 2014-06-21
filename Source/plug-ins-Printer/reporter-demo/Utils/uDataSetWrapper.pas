unit uDataSetWrapper;

interface

uses
  uIDataSet, DB;

type
  TDataSetWrapper = class(TInterfacedObject
    , IDataSetGetter)
  private
    FDataSet: TDataSet;
  public
    constructor Create(ADataSet: TDataSet);
    function getDataSet: TDataSet; stdcall;
  end;

implementation

constructor TDataSetWrapper.Create(ADataSet: TDataSet);
begin
  inherited Create;
  FDataSet := ADataSet;
end;

function TDataSetWrapper.getDataSet: TDataSet;
begin
  Result := FDataSet;
end;

end.
