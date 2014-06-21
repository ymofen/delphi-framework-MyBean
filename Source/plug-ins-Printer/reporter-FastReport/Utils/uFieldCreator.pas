unit uFieldCreator;

interface

uses
  DB, Classes, SysUtils;

type
  TFieldCreator = class(TObject)
  public
    class function stringCanName(pvString:AnsiString): Boolean;
    class function CreateField(const pvDataSet: TDataSet; const pvFieldName:
        string; const pvFieldType: TFieldType; const pvSize: Integer = 0): TField;

  end;

implementation


class function TFieldCreator.CreateField(const pvDataSet: TDataSet; const
    pvFieldName: string; const pvFieldType: TFieldType; const pvSize: Integer =
    0): TField;
var
  lvOwner:TComponent;
begin
  lvOwner := pvDataSet;
  case pvFieldType of
    ftString:
      begin
        Result := TStringField.Create(lvOwner);
        Result.Size := pvSize;
        if Result.Size = 0 then
        begin
          Result.Size := 80;
        end;
      end;
    ftWideString:
      begin
        Result := TWideStringField.Create(lvOwner);
        Result.Size := pvSize;
        if Result.Size = 0 then
        begin
          Result.Size := 80;
        end;
      end;
    ftBCD:
      begin
        Result := TBCDField.Create(lvOwner);
        TBCDField(Result).Precision := 18;
        TBCDField(Result).Size := 4;
      end;
    ftGuid:
      begin
        Result := TGuidField.Create(lvOwner);
      end;
    ftBlob:
      begin
        Result := TBlobField.Create(lvOwner);
      end;
    ftMemo:
      begin
        Result := TMemoField.Create(lvOwner);
      end;
    ftBoolean:
      begin
        Result := TBooleanField.Create(lvOwner);
      end;
    ftDateTime:
      begin
        Result := TDateTimeField.Create(lvOwner);
      end;
    ftSmallint:
      begin
        Result := TSmallintField.Create(lvOwner);
      end;
    ftInteger:
      begin
        Result := TIntegerField.Create(lvOwner);
      end;
    ftWord:
      begin
        Result := TWordField.Create(lvOwner);
      end;
  end;
  if Result = nil then raise Exception.CreateFmt('×Ö¶Î(%s)´´½¨Ê§°Ü', [pvFieldName]);

  Result.FieldName := pvFieldName;
  Result.DataSet := pvDataSet;
  Result.FieldKind := fkData;
  if stringCanName(pvFieldName) then  
    Result.Name := pvDataSet.Name + pvFieldName;
end;

class function TFieldCreator.stringCanName(pvString:AnsiString): Boolean;
var
  i:Integer;
begin
  Result := False;
  if Length(pvString) = 0 then exit;

  Result := true;
  for i := 1 to Length(pvString) do
  begin
    if not (pvString[i] in ['0'..'9','a'..'z', 'A'..'Z', '_']) then
    begin
      Result := false;
      break;
    end;
    
  end;

end;

end.

