unit BeanConst;

interface

uses  Classes, SysUtils, windows;

const
  PageName='MyBean';
  Author='Seatune';

type
  TBeanType = (bNone, bForm, bLogic);

function LoadResResource(const AName: string): string;
implementation
function LoadResResource(const AName: string): string;
var
  AList: TStringList;
  AStream: TResourceStream;
begin
  AStream := TResourceStream.Create(HInstance, AName, RT_RCDATA);
  try
    AList := TStringList.Create;
    try
      AList.LoadFromStream(AStream);
      Result := AList.Text;
    finally
      AList.Free;
    end;
  finally
    AStream.Free;
  end;
end;

end.
