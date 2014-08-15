unit uMyBeanMapTools;

interface

uses
  uIMapObject, mBeanFrameVars;

type
  TMyBeanMapTools = class(TObject)
  public
    class function getObject(pvKey:string): TObject;
    class procedure removeAndFreeObject(pvKey:string);
    class procedure setObject(pvKey:String; pvObject:TObject);
  end;


implementation

class function TMyBeanMapTools.getObject(pvKey:string): TObject;
begin
  Result := (TmBeanFrameVars.getBean('objMap') as IMapObject).getObject(pvKey);
end;

class procedure TMyBeanMapTools.removeAndFreeObject(pvKey: string);
var
  lvObj:TObject;
begin
  lvObj := getObject(pvKey);
  if (lvObj <> nil) then
  begin
    (TmBeanFrameVars.getBean('objMap') as IMapObject).removeObject(pvKey);
    try
      lvObj.Free;
    except
    end;
  end;
end;

class procedure TMyBeanMapTools.setObject(pvKey: String; pvObject: TObject);
var
  lvObj:TObject;
begin
  lvObj := getObject(pvKey);
  if lvObj <> nil then
  begin   //释放之前的对象
    try
      lvObj.Free;
    except
    end;
  end;
  (TmBeanFrameVars.getBean('objMap') as IMapObject).setObject(pvKey, pvObject);
end;

end.
