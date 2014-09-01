unit uFastReporter;

interface

uses
  ufrmFastReport, uIReporter, uIIntfList, superobject, SysUtils, uCRCTools,
  uFileTools, uIUIReporter, uPreviewObjectWrapper, Windows;

type
  TFastReporter = class(TInterfacedObject
     , IReporter
     , IUIReporter
     , IReportConsoleSetter)
  private
    FReportForm: TfrmFastReport;
    FReportFile:String;
    FDataIntf: IInterface;
    FReportConsole:IReportConsole;

  public
    function createPreviewFrame: IInterface; stdcall;

    procedure setReportConsole(const pvConsole: IReportConsole); stdcall;
  public
    procedure AfterConstruction; override;

    destructor Destroy; override;
    function Design: Boolean; stdcall;
    procedure Preview; stdcall;
    procedure Print; stdcall;
    //设置设计好的报表文件模板
    procedure setDesignFile(pvFile: PAnsiChar); stdcall;
    //设置名字
    procedure setName(pvName:PAnsiChar);stdcall;

    //数据对象的接口列表
    procedure setDataList(pvIntf: IInterface); stdcall;

    //清理数据
    procedure Clear; stdcall;

  end;

function createRepoter: IReporter; stdcall;

implementation


var
  __count:Integer;
  

function createRepoter: IReporter; stdcall;
begin
  Result := TFastReporter.Create;
end;

destructor TFastReporter.Destroy;
begin
  FReportConsole := nil;
  FDataIntf := nil;
  InterlockedDecrement(__count);
  inherited Destroy;
end;

procedure TFastReporter.AfterConstruction;
begin
  inherited;
  InterlockedIncrement(__count);  
end;

procedure TFastReporter.Clear;
begin
  FDataIntf := nil;
end;

function TFastReporter.createPreviewFrame: IInterface;
var
  lvObj:TPreviewObjectWrapper;
  lvFile:String;
begin
  lvObj := TPreviewObjectWrapper.Create;
  try
    FReportForm := TfrmFastReport.Create(nil);
    FReportForm.CreateDataObject(FDataIntf);
    lvObj.LayOutControl := FReportForm.CreatePreViewFM;
    FReportForm.rtpReport.LoadFromFile(FReportFile);
    FReportForm.rtpReport.ShowReport();

    //删除报表文件
    SysUtils.DeleteFile(FReportFile);
    lvObj.FreeObject := FReportForm;
  except
    lvObj.Free;
    raise;
  end;
  Result := lvObj;
end;

{ TFastReporter }

function TFastReporter.Design: Boolean;
var
  lvCRC:Cardinal;

begin
  if FReportFile = '' then
    raise Exception.Create('请指定一个文件名,用来加载和存储设计的模板文件(该文件可以不存在,但是该文件目录要可以写入)!');
  FReportForm := TfrmFastReport.Create(nil);
  try
    FReportForm.CreateDataObject(FDataIntf);
    lvCRC := 0;
    if FileExists(FReportFile) then
    begin
      FReportForm.rtpReport.LoadFromFile(FReportFile);
      lvCRC := TCRCTools.crc32File(FReportFile);
    end else
    begin
      ///保存一个空的报表
      FReportForm.rtpReport.PrepareReport();
      FReportForm.rtpReport.SaveToFile(FReportFile);
      FReportForm.rtpReport.LoadFromFile(FReportFile);
    end;
    FReportForm.rtpReport.DesignReport();
    if lvCRC <> TCRCTools.crc32File(FReportForm.rtpReport.FileName) then
    begin
      TFileTools.FileCopy(FReportForm.rtpReport.FileName, FReportFile);
      Result := true;
    end;
  finally
    FReportForm.Free;
  end;
end;

procedure TFastReporter.Preview;
begin
  FReportForm := TfrmFastReport.Create(nil);
  try
    FReportForm.CreateDataObject(FDataIntf);
    FReportForm.rtpReport.LoadFromFile(FReportFile);
    FReportForm.rtpReport.ShowReport();
  finally
    FReportForm.Free;
  end;
end;

procedure TFastReporter.Print;
begin
  FReportForm := TfrmFastReport.Create(nil);
  try
    FReportForm.CreateDataObject(FDataIntf);
    FReportForm.rtpReport.LoadFromFile(FReportFile);
    FReportForm.rtpReport.Print;
  finally
    FReportForm.Free;
  end;
end;

procedure TFastReporter.setDataList(pvIntf: IInterface);
begin
  FDataIntf := pvIntf;
end;

procedure TFastReporter.setDesignFile(pvFile: PAnsiChar);
begin
  FReportFile := pvFile;  
end;


procedure TFastReporter.setName(pvName: PAnsiChar);
begin
  
end;

procedure TFastReporter.setReportConsole(const pvConsole: IReportConsole);
begin
  FReportConsole := pvConsole;
end;

initialization
  __count := 0;

finalization
   Assert(__count = 0, 'fast reporter Memory leak');

end.
