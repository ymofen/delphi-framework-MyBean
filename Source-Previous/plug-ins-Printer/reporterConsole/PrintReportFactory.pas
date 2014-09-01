unit PrintReportFactory;

interface

uses
  uIReporter, uIObjectList, ObjList, superobject,
  SysUtils;


type
  TPrintObject = class(TObject)
  private
    FID: String;
    FReporter: IReporter;
    FRemark: String;
  public
    destructor Destroy; override;
    property ID: String read FID write FID;
    property Reporter: IReporter read FReporter write FReporter;
    property Remark: String read FRemark write FRemark;
  end;

  TPrintReportFactory = class(TInterfacedObject, IReporterFactory)
  private
    FObjects: IObjectList;
    __pass:String;
    procedure checkLoadReporter;
  public
    constructor Create;
    destructor Destroy; override;
    procedure registerReporter(pvID, pvCaption: PAnsiChar; const pvReporter:
        IReporter);



    //获取一个报表接口
    function getReporter(pvID: PAnsiChar): IReporter;

    //ids:['FR','RM'], list:{fr:{id:"FR","Remark":"FR报表"},rm:{id...}
    function getReporterList: PAnsiChar; stdcall;

    class procedure checkInitialize;

    class function Instance: TPrintReportFactory;
    class procedure FreeInstance;

  end;

implementation

var
  __instance:TPrintReportFactory;
  __instanceIntf:IReporterFactory;

constructor TPrintReportFactory.Create;
begin
  inherited Create;
  FObjects := TObjList.Create(True);
end;

destructor TPrintReportFactory.Destroy;
begin
  FObjects.Clear;
  inherited Destroy;
end;

class procedure TPrintReportFactory.checkInitialize;
begin
  Instance.checkLoadReporter;
end;

procedure TPrintReportFactory.checkLoadReporter;
begin
end;

class procedure TPrintReportFactory.FreeInstance;
begin
  if __instance <> nil then
  begin
    __instanceIntf := nil;
    __instance := nil;
  end;
end;

class function TPrintReportFactory.Instance: TPrintReportFactory;
begin
  if __instance = nil then
  begin
    __instance := TPrintReportFactory.Create;
    __instanceIntf := __instance;
  end;
  Result := __instance;
end;

function TPrintReportFactory.getReporter(pvID: PAnsiChar): IReporter;
var
  lvID:String;
begin
  lvID := pvID;
  Result := TPrintObject(FObjects.CheckGet(pvID)).FReporter;
  lvID := '';
end;

function TPrintReportFactory.getReporterList: PAnsiChar;
var
  lvItem, lvJSon, lvIDs, lvList:ISuperObject;
  lvObj:TPrintObject;
  i:Integer;
begin
  lvJSon := SO();
  lvIDs := SO('[]');
  lvList := SO();
  lvJSon.O['ids'] := lvIDs;
  lvJSon.O['list'] := lvList;
  for i := 0 to FObjects.Count - 1 do
  begin
    lvObj := TPrintObject(FObjects.Values[i]);
    lvItem := SO();
    lvItem.S['id'] := lvObj.FID;
    lvItem.S['remark'] := lvObj.FRemark;
    lvList.O[lowercase(lvObj.FID)] := lvItem;
    lvIDs.AsArray.Add(SO(lvObj.ID));
  end;                        
  __pass := lvJSon.AsString;
  Result := PAnsiChar(__pass);
end;

procedure TPrintReportFactory.registerReporter(pvID, pvCaption: PAnsiChar;
    const pvReporter: IReporter);
var
  lvObj:TPrintObject;
begin
  lvObj := TPrintObject.Create;
  lvObj.FID := pvID;
  lvObj.FRemark := pvCaption;
  lvObj.FReporter := pvReporter;
  FObjects.CheckPut(pvID, lvObj, False);
end;

destructor TPrintObject.Destroy;
begin
  FReporter := nil;
  inherited Destroy;
end;

initialization

finalization
  TPrintReportFactory.FreeInstance;

end.
