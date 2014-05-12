unit uJSonTools;

interface

uses
  uStringTools, DB, superobject, SysUtils, uDBTools, uDataSetTools, Classes,
  Variants, uEncryptTools, RegExUtils, ObjRecycle, SOWrapper, uIObjectList,
  uIIntfList, uDBIntf, uIParameter;

type
  TJSonTools = class(TObject)
  public

    //获取JSon数组中的某个字段的值
    //pvJsonData:
    //    [
    //        {"FName":"abcd","FCode":"001"},
    //        {"FName":"efg","FCode":"002"},
    //        {"FName":"xyz","FCode":"002"},
    //
    //    ]
    class function ExtractJSonValue(pvJsonData:ISuperObject; pvField:string;
        splitChar:String = ','): String;

    //判断JSon中是否含有某个字段
    //pvJsonData:
    //    [
    //        {"FName":"abcd","FCode":"001"},
    //        {"FName":"efg","FCode":"002"},
    //        {"FName":"xyz","FCode":"002"},
    //    ],
    //    也可以{"FName":"xyz","FCode":"002"},
    class function hasField(pvJsonData:ISuperObject; pvField:string): Boolean;

    /// <summary>
    /// 判断数组中是否存在某个值
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="pvJSonArray"> (ISuperObject) </param>
    /// <param name="pvValue"> (string) </param>
    class function JSonArrayHasValue(pvJSonArray: ISuperObject; pvValue: Variant):
        Boolean;

    /// <summary>关系赋值
    /// </summary>
    /// <param name="pvDest"> (TDataSet) </param>
    /// <param name="pvJSonData">[{"Fcode":"001", "FName":"abc"},{"Fcode":"002", "FName":"efg"}]</param>
    /// <param name="pvAssignJsnConfig">
    /// {
    ///   FKey:FSourceKey,
    ///   FKey:{value:"abc"},
    /// }
    /// </param>
    class procedure AssignFieldValueFromJsonAccordingJSonConfig(pvDest: TDataSet;
        pvJSonData, pvAssignJsnConfig: ISuperObject; pvIfSourceNoneThenEmpty:
        Boolean = false);


    /// <summary>
    ///   数组转换成Json
    /// </summary>
    /// <returns> ISuperObject
    /// {
    ///    "01":
    ///     {
    ///        "id":"01",
    ///        "caption":"xxx",
    ///     },
    ///    "02":
    ///     {
    ///        "id":"01",
    ///        "caption":"yyy",
    ///     },
    /// }
    /// </returns>
    /// <param name="pvArray">
    /// [
    ///    {
    ///        "id":"01",
    ///        "caption":"xxx",
    ///    },
    ///    {
    ///        "id":"01",
    ///        "caption":"yyy",
    ///    },
    /// ]
    /// 
    /// </param>
    /// <param name="pvKeyName"> (String) </param>
    class function JSonArray2JSonList(pvArray:ISuperObject; pvKeyName:String =
        'ID'): ISuperObject;


    /// <summary>
    ///   将字段的值放入到JSonData中,
    ///     赋值时产生的的json对象，有JSonData去创建(). 
    ///   推荐使用该方法
    /// </summary>
    /// <param name="pvField"> (TField) </param>
    /// <param name="pvJSonData"> (ISuperObject) </param>
    class procedure putFieldValue2JsonData(pvField: TField; const pvJSonData:
        ISuperObject);


    /// <summary>
    ///   将字段的值转换成JSon对象
    /// </summary>
    /// <returns> ISuperObject
    /// </returns>
    /// <param name="pvField"> (TField) </param>
    class function convertFieldValue2JSon(pvField:TField): ISuperObject;

    /// <summary>
    ///   关系赋值
    ///     2013年1月10日 09:14:58
    ///        加强 pvIfSourceNoneThenEmpty 参数的影响
    ///        加强 注释
    ///        加入 nilThenSkip 参数
    ///        去掉 nilThenEmpty 参数(默认进行)
    /// </summary>
    /// <param name="pvDest"> (TDataSet) </param>
    /// <param name="pvSourceValue"> 值 </param>
    /// <param name="pvAssignJsnConfig">
    /// {
    ///   FKey:FSourceKey,           //默认为Require = false
    ///   FKey:{value:"abc"},
    ///   FKey:{
    ///          field:"FSourceFieldName",
    ///          nilThenSkip:true,       //默认为false 源数据中找不到field时 跳过赋值(在require:false时使用)
    ///          require:true            //默认为false 必须进行赋值,检测FKey是否存在,和field是否在SourceValue中存在
    ///        },
    /// }
    /// </param>
    /// <param name="pvIfSourceNoneThenEmpty"> 如果为SourceValue中没有时赋值为空值 </param>
    class procedure CopyDataRecordFromJsonAccordingJSonConfig(pvDest: TDataSet;
        pvSourceValue, pvAssignJsnConfig: ISuperObject; pvIfSourceNoneThenEmpty:
        Boolean = false);



    /// <summary>
    ///    将Source中的一些字段copy到pvDest中<赋值由pvAssignJsnConfig配置>
    ///    2013年4月1日 11:10:12
    ///      根据CopyDataRecordFromJsonAccordingJSonConfig 而成
    ///
    ///     2013年1月10日 09:14:58
    ///        加强 pvIfSourceNoneThenEmpty 参数的影响
    ///        加强 注释
    ///        加入 nilThenSkip 参数
    ///        去掉 nilThenEmpty 参数(默认进行)
    /// </summary>
    /// <param name="pvDest"> (TDataSet) </param>
    /// <param name="pvSourceValue"> 值 </param>
    /// <param name="pvAssignJsnConfig">
    /// {
    ///   FKey:FSourceKey,           //默认为Require = false
    ///   FKey:{value:"abc"},
    ///   FKey:{
    ///          field:"FSourceFieldName",
    ///          nilThenSkip:true,       //默认为false 源数据中找不到field时 跳过赋值(在require:false时使用)
    ///          require:true            //默认为false 必须进行赋值,检测FKey是否存在,和field是否在SourceValue中存在
    ///        },
    /// }
    /// </param>
    /// <param name="pvIfSourceNoneThenEmpty"> 如果为SourceValue中没有时赋值为空值 </param>
    class procedure CopyJSonData(pvDest, pvSourceValue, pvAssignJsnConfig:
        ISuperObject; pvIfSourceNoneThenEmpty: Boolean = false);

    /// <summary>
    /// 获取数据字段信息
    /// </summary>
    /// <returns>

    /// </returns>
    /// <param name="pvDataSet"> (TDataSet) </param>
    /// <param name="vFieldsINfo"> 写入,覆盖
    /// {
    ///    "field":
    ///      {
    ///         "name":xx,
    ///         "caption":"pvPreName.xxx"
    ///      },
    /// }
    ///  </param>
    /// <param name="pvOverlay"> 写入时是否进行覆盖 </param>
    /// <param name="pvDictionaryINfo"> {"key":"caption"} </param>
    class function extractFieldsINfo(pvDataSet: TDataSet; vFieldsINfo:
        ISuperObject; pvOverlay: Boolean = true; pvDictionaryINfo: ISuperObject =
        nil; pvPreName: String = ''): ISuperObject;

    /// </returns>
    /// <param name="pvDataSet"> (TDataSet) </param>
    /// <param name="vData"> 写入,覆盖
    /// {
    ///    "field":
    ///      {
    ///         "name":xx,
    ///         "caption":"pvPreName.xxx",
    ///         "value":"xxxx"
    ///      },
    /// }
    ///  </param>
    /// <param name="pvOverlay"> 写入时是否进行覆盖 </param>
    /// <param name="pvDictionaryINfo"> {"key":"caption"} </param>
    class function extractRecordsData(pvDataSet: TDataSet; vData: ISuperObject;
        pvOverlay: Boolean = true; pvDictionaryINfo: ISuperObject = nil; pvPreName:
        String = ''): ISuperObject;

    /// <summary>TJSonTools.CopyDataRecordFromJsonData
    /// </summary>
    /// <param name="pvDestination"> (TDataSet) </param>
    /// <param name="pvSourceData">
    //   {
    //       fkey:"xxxx",
    //       fcode:"xxxx",
    //       fname:"xxxx",
    //       fskind:{value:1},
    //   }
    /// </param>
    /// <param name="pvCopyFields"> (string) </param>
    /// <param name="pvIgnoreFields"> (string) </param>
    class procedure CopyDataRecordFromJsonData(pvDestination: TDataSet;
        pvSourceData: ISuperObject; pvCopyFields: string = ''; pvIgnoreFields:
        string = '');


    /// <summary>关系赋值
    /// </summary>
    /// <param name="pvDest"> (TDataSet) </param>
    /// <param name="pvSource"> (TDataSet) </param>
    /// <param name="pvAssignJsnConfig">
    /// {
    ///   FKey:FSourceKey,
    ///   FKey:{value:"abc"},
    ///   FKey:{ref:"FSourceFieldName", nilThenEmpty:true}, //源数据中没有时置空
    ///   FKey:{field:"FSourceFieldName", require:true},
    /// }
    /// </param>
    class procedure CopyDataRecordAccordingJSonConfig(pvDest, pvSource: TDataSet;
        pvAssignJsnConfig: ISuperObject);

    class function CopyRecord2JSon(pvDataSet: TDataSet; vJSon: ISuperObject;
      pvIgnoreBinaryField: Boolean = false): ISuperObject;
    class function FixValidJSonKey(pvKeyValue: string): string;

    //DataSet打包成JSon
    //Blob和Bytes字段没有进行打包
    class function DataSetPack(pvDataSet: TDataSet): ISuperObject;


    /// <summary>TJSonTools.initializeItems
    /// </summary>
    /// <param name="pvData">
    /// [
    ///     {FKey:"",FCode:"",FName:""},
    ///     {FKey:"",FCode:"",FName:""},
    /// ]
    /// </param>
    /// <param name="pvItems"> (TStrings) </param>
    /// <param name="pvCaption"> (String) </param>
    class procedure initializeItems(pvData: ISuperObject; pvItems: TStrings;
        pvCaption: String; pvRecyleObject: TObjectRecycle = nil);

    //将数据还原到Dataset中
    class procedure DataSetUnPack(pvDataSet: TDataSet; pvPackData: ISuperObject;
      pvEmptyDataSet: Boolean = true);
    class function JsnParseFromFile(pvFile: string; pvEncrypKey: string = ''):
      ISuperObject;
    //存储文件使用该方式进行
    class function JsnSaveToFile(pvJsn: ISuperObject; pvFile: string; pvEncrypKey:
      string = ''): Boolean;
    class function JSonParseFromStream(const pvStream: TStream): ISuperObject;
    class function JSonSaveToStream(const pvJsn: ISuperObject; pvData: TStream = nil): TStream;


    /// <summary>
    ///   检测JSon中是否存在pvFields指定的字段
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="pvData"> (ISuperObject) </param>
    /// <param name="pvFields"> (string) </param>
    class function CheckJSonField(pvData:ISuperObject; pvFields:string): Boolean;

    //JSon的值转成Variant类型,如果nil返回null
    class function JSonValue2Variant(const pvJSon: ISuperObject): Variant;

    class function JSonArray2Strings(const pvJSon: ISuperObject): TStrings;

    // <summary>
    //   根据pvData值解析表达式
    // </summary>
    // <returns>
    //   解析好的值 When中的值或者是Else值
    // </returns>
    // <param name="pvExpression">
    // {
    //    "case":"FSKind",
    //    "when":
    //     {
    //       "1001":"1011",
    //       "1002":"1012",
    //       "1003":"FCode",     //先从pvData中查找
    //       "1004":{ref:"key"}  //从pvData中获取值
    //     },
    //    "else":"0",
    // },
    // </param>
    // <param name="pvData">
    //   {FSKind:1001,FCode:"abc"} ,也可以是[{}, {}]
    // </param>
    class function parseCaseWhen(const pvExpression, pvData: ISuperObject):
        ISuperObject;

    //判断是否CaseWhen表达式
    class function IsCaseWhenExpression(const pvExpression:ISuperObject): Boolean;

    //给字段赋值
    class procedure AssignFieldValueFormJSon(lvField: TField; pvValue:
        ISuperObject);
    class procedure emptyFieldValueAccordingJSonConfig(pvDataSet: TDataSet;
        pvAssignConfig: ISuperObject);


    /// <summary>
    /// 解析参数,来自MyDBUtils.ParserParams
    /// </summary>
    /// <returns>
    /// {
    ///    "@mm_Key":"XXXX-XXXX",
    /// }
    /// </returns>
    /// <param name="pvParamJsnConfig">
    /// {
    ///    "@mm_Key":"FMasterKey",
    ///    "@mm_Key":{"value":"xxxxx-xxx"},
    ///    "@mm_Key":{ref:"main","field":"FMasterKey"},
    /// }
    ///  </param>
    /// <param name="pvSource"> 取值的数据集 </param>
    /// <param name="pvSourceIdx"> 引用的数据集名称，可以为空(忽略ref) </param>
    class function JSonParamParse(pvParamJsnConfig: ISuperObject; pvSource:
        TDataSet; pvSourceIdx: string = ''): ISuperObject;
        
    /// <summary>
    /// 解析关联值
    /// </summary>
    /// <returns>
    /// {
    ///    "@mm_Key":"XXXX-XXXX",
    /// }
    /// </returns>
    /// <param name="pvParamJsnConfig">
    /// {
    ///    "@mm_Key":"FMasterKey",
    ///    "@mm_Key":{"value":"xxxxx-xxx"},
    ///    "@mm_Key":{ref:"main","field":"FMasterKey","emptyStringAsNull":true},
    ///    "@mm_Code":{
    ///      "field":FCode
    ///      "ref":
    ///       {
    ///          "ID":"SKind",   //refID
    ///          "locate":  //进行定位
    ///            {
    ///                "FCode":   //SKind中的字段
    ///                 {
    ///                        "field":"零件编号",  //source中的字段
    ///                        "ref":"source",
    ///                 },
    ///            },
    ///    },
    /// }
    ///  </param>
    /// <param name="pvSource"> 取值的数据集 </param>
    /// <param name="pvSourceIdx"> 引用的数据集名称，可以为空(忽略ref) </param>
    class function JSonParamParseFromRefIntfs(pvParamJsnConfig: ISuperObject;
        pvDefaultDataSet: TDataSet; const pvRefList: IIntfList): ISuperObject;



    /// <summary>
    ///   解析参数,数据从RefDatasetList中获取数据集
    /// </summary>
    /// <returns>
    /// {
    ///    "@mm_Key":"XXXX-XXXX",
    /// }
    /// </returns>
    /// <param name="vJSonParams">
    /// {
    ///    "@mm_Key":{ref:"main","field":"FMasterKey"}, //从引用中读取
    /// }
    ///  </param>
    /// <param name="pvRefDataSetList"> 引用的数据集列表 </param>
    class function JSonParamParseFromRefObjectList(var vJSonParams: ISuperObject;
        pvRefSourceDataSetList: IObjectList): ISuperObject;


    /// <summary>TJSonTools.assign2Param
    /// </summary>
    /// <param name="pvParamValues">
    ///      {
    ///         "@mm_Key":"xxxx",
    ///         "@mm_Key":{"value":"xxxx"},
    ///      }
    ///  </param>
    /// <param name="pvParam"> (IParameter) </param>
    class procedure assign2Param(const pvParamValues: ISuperObject; const pvParam:
        IParameter);

    /// <summary>
    ///   2013年4月1日 17:01:18
    /// </summary>
    /// <param name="pvDest"> (TDataSet) </param>
    /// <param name="pvJSonData">
    /// {
    ///   FKey:"{F36E540A-EE7F-42F0-B6E4-0B4F6A1971AF}",
    ///   FKey:{value:"abc"},
    ///   FKey:{
    ///            "require":true,    //必须有value值,没有弹出错误信息(nilExceptionMsg,没有时，弹出缺省的错误信息)
    ///            "err":"执行时，直接raise的错误信息",
    ///            "nilErrMsg":"value没有时raise的错误信息",
    ///            "emptyErrMsg":"value值为空时的错误信息",
    ///        }
    /// }
    /// </param>
    class procedure AssignFieldValueFromJsonData(pvDest: TDataSet; pvJSonData:
        ISuperObject);
    class procedure CopyRecord2JSonData(pvSourceDataSet: TDataSet; const
        pvJSonData: ISuperObject; pvCopyFields: string = ''; pvIgnoreFields: String
        = '');
    // <summary>
    //   打包数据集
    // </summary>
    // <returns>
    //   返回数据数组
    //   [
    //     {},{}
    //   ]
    // </returns>
    // <param name="pvDataSet"> (TDataSet) </param>
    // <param name="pvFields"> (String) </param>
    // <param name="pvDisableControl"> (Boolean) </param>
    class function DataSet2JSonData(pvDataSet: TDataSet; pvCopyFields: string = '';
        pvIgnoreFields: String = ''; pvDisableControl: Boolean = true):
        ISuperObject;



    /// <summary>TJSonTools.parseExpression
    /// </summary>
    /// <returns> String
    /// </returns>
    /// <param name="pvExpression">%key01%-%key02% </param>
    /// <param name="pvData"> (ISuperObject) </param>
    class function parseExpression(pvExpression: string; pvData: ISuperObject):
        String;
  end;

implementation

var
  __passString:String;

class procedure TJSonTools.AssignFieldValueFromJsonAccordingJSonConfig(pvDest:
    TDataSet; pvJSonData, pvAssignJsnConfig: ISuperObject;
    pvIfSourceNoneThenEmpty: Boolean = false);
var
  lvItem: TSuperObjectIter;
  lvField: TField;
  lvRet, lvSourceField:ISuperObject;
  lvStr: string;
  lvRequire: Boolean;

begin
  if pvAssignJsnConfig = nil then exit;
  try
    if ObjectFindFirst(pvAssignJsnConfig, lvItem) then
      repeat
        if not (pvDest.State in [dsInsert, dsEdit]) then pvDest.Edit;

        lvStr := Trim(LowerCase(lvItem.key));
        lvField := pvDest.FindField(lvStr);
        if lvItem.val.IsType(stObject) then
        begin
          lvRequire := not pvIfSourceNoneThenEmpty;
          if lvItem.val.O['require'] <> nil then
            lvRequire := lvItem.val.B['require'];
          if (lvField = nil) and lvRequire then
          begin
            raise Exception.Create(Format('%s字段不存在', [lvStr]));
          end;

          if lvField <> nil then
          begin
            if IsCaseWhenExpression(lvItem.val) then
            begin
              lvRet := parseCaseWhen(lvItem.val, pvJSonData);
              if lvRet<>nil then
              begin
                AssignFieldValueFormJSon(lvField, lvRet);
              end else
              begin
                lvField.Clear;
              end;
            end else if lvItem.val.O['value'] <> nil then
            begin
              AssignFieldValueFormJSon(lvField, lvItem.val.O['value']);
            end;
          end;
        end else
        begin
          lvRequire := not pvIfSourceNoneThenEmpty;
          if (lvField = nil) and lvRequire then
          begin
            raise Exception.Create(Format('%s字段不存在', [lvStr]));
          end;

          if lvField <> nil then
          begin
            lvStr := Trim(LowerCase(lvItem.val.AsString));
            lvField.AsString := ExtractJSonValue(pvJSonData, lvStr, ',');
          end;
        end;
      until not ObjectFindNext(lvItem);
  finally
    ObjectFindClose(lvItem);
  end;

end;

class procedure TJSonTools.CopyDataRecordFromJsonAccordingJSonConfig(pvDest:
    TDataSet; pvSourceValue, pvAssignJsnConfig: ISuperObject;
    pvIfSourceNoneThenEmpty: Boolean = false);
var
  lvItem: TSuperObjectIter;
  lvField: TField;
  lvSourceField:ISuperObject;
  lvStr: string;
  lvRequire: Boolean;


  procedure __DoLocalAssign(__Field:TField; __require:Boolean;
     __SourceField:ISuperObject;
     __sourceFieldName:String);
  begin
      if __SourceField <> nil then
        AssignFieldValueFormJSon(__Field, __SourceField)
      else if (pvIfSourceNoneThenEmpty) then
        __Field.Clear
      else if __require then    //必填
      begin
        if pvSourceValue = nil then
          raise Exception.Create(Format('源JSon值不存在不能查找字段(%s)', [__sourceFieldName]));
        if __SourceField = nil then
          raise Exception.Create(Format('源JSon值不存在不能查找字段(%s)'
            + sLineBreak + pvSourceValue.AsJSon(True), [__sourceFieldName]));
      end else if (lvItem.val.B['nilThenSkip']) then
      begin
        {nop}
      end else
        __Field.Clear;
  end;


begin
  if pvAssignJsnConfig = nil then exit;
  try
    if ObjectFindFirst(pvAssignJsnConfig, lvItem) then
      repeat
        if not (pvDest.State in [dsInsert, dsEdit]) then pvDest.Edit;

        lvStr := Trim(LowerCase(lvItem.key));
        lvField := pvDest.FindField(lvStr);
        if lvItem.val.IsType(stObject) then
        begin
          lvRequire := lvItem.val.B['require'];
          if (lvField = nil) and lvRequire then
          begin
            raise Exception.Create(Format('%s字段不存在', [lvStr]));
          end;

          if lvField <> nil then
          begin
            if lvItem.val.O['value'] <> nil then
            begin
              AssignFieldValueFormJSon(lvField, lvItem.val.O['value']);
            end else
            begin
              lvSourceField := nil;
              if lvItem.val.O['field'] <> nil then
              begin
                if pvSourceValue <> nil then
                  lvSourceField := pvSourceValue.O[lvItem.val.S['field']];
              end;

              __DoLocalAssign(lvField, lvRequire, lvSourceField, lvItem.val.S['field']);
            end;
          end;
        end else
        begin         //Item.val是直接的值,require为false
          lvRequire := false;
          if (lvField = nil) and lvRequire then
          begin
            raise Exception.Create(Format('%s字段不存在', [lvStr]));
          end;

          if lvField <> nil then
          begin
            lvStr := Trim(LowerCase(lvItem.val.AsString));

            lvSourceField := nil;

            if pvSourceValue <> nil then
              lvSourceField:=pvSourceValue.O[lvStr];

            __DoLocalAssign(lvField, lvRequire, lvSourceField, lvStr);
                            
          end;
        end;
      until not ObjectFindNext(lvItem);
  finally
    ObjectFindClose(lvItem);
  end;
end;

class procedure TJSonTools.CopyDataRecordAccordingJSonConfig(pvDest, pvSource:
    TDataSet; pvAssignJsnConfig: ISuperObject);
var
  lvItem: TSuperObjectIter;
  lvField, lvField2: TField;
  lvStr: string;
  lvRequire: Boolean;
begin
  if pvAssignJsnConfig = nil then exit;
  try
    if ObjectFindFirst(pvAssignJsnConfig, lvItem) then
      repeat
        if not (pvDest.State in [dsInsert, dsEdit]) then pvDest.Edit;

        lvStr := Trim(LowerCase(lvItem.key));
        lvField := pvDest.FindField(lvStr);
        lvField2 := nil;
        if lvItem.val.IsType(stObject) then
        begin
          lvRequire := true;
          if lvItem.val.O['require'] <> nil then
            lvRequire := lvItem.val.B['require'];
          if (lvField = nil) and lvRequire then
          begin
            raise Exception.Create(Format('%s字段不存在', [lvStr]));
          end;

          if lvField <> nil then
          begin
            if lvItem.val.O['value'] <> nil then
            begin
              //lvField.AsString := lvItem.val.S['value'];
              AssignFieldValueFormJSon(lvField, lvItem.val.O['value']);
            end else
            begin
              lvStr := lvItem.val.S['field'];
              if lvItem.val.O['field'] <> nil then
              begin
                if pvSource <> nil then
                  lvField2 := pvSource.FindField(lvItem.val.S['field']);
              end;
              if (pvSource = nil) and lvRequire then
                raise Exception.Create(Format('源数据集不存在不能查找字段(%s)', [lvStr]));
              if (lvField2 = nil) and lvRequire then
                raise Exception.Create(Format('源数据集中的%s字段不存在', [lvStr]))
              else if (lvField2 = nil) and (lvItem.val.B['nilThenEmpty']) then
                lvField.Clear
              else if lvField2 <> nil then
                lvField.AsVariant := lvField2.AsVariant;
            end;
          end;  
        end else
        begin
          if lvField = nil then raise Exception.Create(Format('%s字段不存在', [lvStr]));
          lvStr := Trim(LowerCase(lvItem.val.AsString));
          if pvSource <> nil then
            lvField2 := pvSource.FindField(lvStr);
          if lvField2 = nil then raise Exception.Create(Format('源数据集中的%s字段不存在', [lvStr]));
          lvField.AsVariant := lvField2.AsVariant;
        end;
      until not ObjectFindNext(lvItem);
  finally
    ObjectFindClose(lvItem);
  end;
end;

class function TJSonTools.CopyRecord2JSon(pvDataSet: TDataSet; vJSon:
  ISuperObject; pvIgnoreBinaryField: Boolean = false): ISuperObject;
var
  i: Integer;
  lvField: TField;
begin
  Result := vJSon;
  if Result = nil then Result := SO();

  for i := 0 to pvDataSet.FieldCount - 1 do
  begin
    lvField := pvDataSet.Fields[i];
    if lvField.DataType in [ftDate, ftDateTime, ftString, ftGuid, ftWideString] then
    begin
      Result.S[LowerCase(lvField.FieldName)] := lvField.AsString;
    end else if (lvField.DataType in [ftBoolean]) then
    begin
      Result.B[LowerCase(lvField.FieldName)] := lvField.AsBoolean;
    end else if (lvField.DataType in [ftBlob]) then
    begin
      if not pvIgnoreBinaryField then
        Result.S[LowerCase(lvField.FieldName)] := TDBTools.BlobField2HexString(lvField);
    end else if (lvField.DataType in [ftBytes]) then
    begin
      if not pvIgnoreBinaryField then
        Result.S[LowerCase(lvField.FieldName)] := TDBTools.BinaryField2HexString(lvField);
    end else if not (lvField.DataType in [ftDataSet]) then
    begin
      Result.O[LowerCase(lvField.FieldName)] := SO(lvField.AsVariant);
    end;
  end;
end;

class procedure TJSonTools.DataSetUnPack(pvDataSet: TDataSet; pvPackData:
  ISuperObject; pvEmptyDataSet: Boolean = true);
var
  lvBookmark: TBookmark;
  i: Integer;
  lvValue: string;
  lvItemEntry: TSuperAvlEntry;
  lvItem, lvRecords: ISuperObject;
  lvField: TField;
begin
  if pvPackData = nil then raise Exception.Create('DataSetUnPack, JSonData is nil!');
  lvBookmark := TDataSetTools.DisableControlsAndGetBookMark(pvDataSet);
  try
    if pvEmptyDataSet then TDataSetTools.DeleteAllRecord(pvDataSet, False);


    if pvPackData.DataType = stArray then lvRecords:= pvPackData
    else if pvPackData.O['records'] <> nil then lvRecords := pvPackData.O['records']
    else if pvPackData.O['list'] <> nil then lvRecords := pvPackData.O['list'];
    
    if lvRecords = nil then Exit;

    for lvItem in lvRecords do
    begin
      pvDataSet.Append;
      for lvItemEntry in lvItem.AsObject do
      begin
        lvField := pvDataSet.FindField(lvItemEntry.Name);
        if lvField <> nil then
        begin
          if lvField.DataType in [ftBlob] then
          begin
            TDataSetTools.BlobFieldSetString(lvField, lvItemEntry.Value.AsString);
          end else if lvField.DataType in [ftBoolean] then
          begin
            if (lvItem.O[lvField.FieldName] = nil) or (lvItem.S[lvField.FieldName] = '') then
              lvField.Clear
            else
              lvField.AsBoolean := lvItem.B[lvField.FieldName];
          end else
          begin
            lvField.AsString := lvItemEntry.Value.AsString;
          end;
        end;


      end;
      pvDataSet.Post;
    end;
    pvDataSet.First;
  finally
    TDataSetTools.EnableControlsAndFreeBookMark(pvDataSet, lvBookmark);
  end;
end;

class function TJSonTools.FixValidJSonKey(pvKeyValue: string): string;
begin
  //   /\:*?<>"[]|
  Result := TStringTools.DeleteChars(pvKeyValue, ['-', ',', '.',
    '{', '}', '(', ')', '\', '/', '"', '[', ']', '|', '?', '<', '>', ' ']);
end;

class function TJSonTools.DataSetPack(pvDataSet: TDataSet): ISuperObject;
var
  lvBookmark: TBookmark;
  i: Integer;
  lvValue: string;
  lvItem: ISuperObject;
  lvField: TField;
begin
  Result := SO();
  lvBookmark := TDataSetTools.DisableControlsAndGetBookMark(pvDataSet);
  try
    pvDataSet.First;
    while not pvDataSet.Eof do
    begin
      lvItem := SO();
      for i := 0 to pvDataSet.FieldCount - 1 do
      begin
        lvField := pvDataSet.Fields[i];
        if lvField.DataType in [ftBlob] then
        begin
          lvItem.S[lvField.FieldName] := TDataSetTools.BlobAsString(lvField);
        end else if lvField.DataType in [ftBoolean] then
        begin
          if not lvField.IsNull then
          begin
            lvItem.B[lvField.FieldName] := lvField.AsBoolean;
          end;
        end else
        begin
          lvItem.S[lvField.FieldName] := lvField.AsString;
        end;
      end;
      Result['records[]'] := lvItem;
      pvDataSet.Next;
    end;
  finally
    TDataSetTools.EnableControlsAndFreeBookMark(pvDataSet, lvBookmark);
  end;
end;

class function TJSonTools.JsnParseFromFile(pvFile: string; pvEncrypKey: string
  = ''): ISuperObject;
var
  lvStream: TMemoryStream;
  lvStr: AnsiString;
begin
  if FileExists(pvFile) then
  begin
    lvStream := TMemoryStream.Create;
    try
      lvStream.LoadFromFile(pvFile);
      lvStream.Position := 0;
      SetLength(lvStr, lvStream.Size);
      lvStream.ReadBuffer(lvStr[1], lvStream.Size);

      if pvEncrypKey <> '' then
      begin
        lvStr := Trim(TEncryptTools.DESDecryptStr(lvStr, pvEncrypKey));
        if (Length(lvStr) > 2) and (lvStr[1] = '{') then
          Result := SO(lvStr);
      end else if Length(trim(lvStr)) > 2 then //没有加密
        Result := SO(lvStr);
    finally
      lvStream.Free;
    end;
  end;
  if (Result = nil) or (not Result.IsType(stObject)) then Result := SO();
end;

class function TJSonTools.JsnSaveToFile(pvJsn: ISuperObject; pvFile: string;
  pvEncrypKey: string = ''): Boolean;
var
  lvStrings: TStrings;
  lvStream: TMemoryStream;

  lvStr: AnsiString;
begin
  Result := false;
  if pvJsn = nil then exit;
  lvStream := TMemoryStream.Create;
  //lvStrings := TStringList.Create;
  try
    if pvEncrypKey <> '' then
    begin //加密
      lvStr := pvJsn.AsJSon(False, False);
      lvStr := TEncryptTools.DESEncryptStr(lvStr, pvEncrypKey);

      //lvStrings.Add(lvStr);
    end else
    begin
      lvStr := pvJsn.AsJSon(True, False);
      //lvStrings.Add(pvJsn.AsJSon(True, false));
    end;
    if lvStr <> '' then
      lvStream.WriteBuffer(lvStr[1], Length(lvStr));
    lvStream.SaveToFile(pvFile);
    //lvStrings.SaveToFile(pvFile);
    Result := true;
  finally
    //lvStrings.Free;
    lvStream.Free;
  end;
end;

class function TJSonTools.JSonArray2Strings(const pvJSon: ISuperObject):
  TStrings;
var
  i: Integer;
begin
  Result := nil;
  if pvJSon = nil then exit;
  if not pvJSon.IsType(stArray) then raise Exception.Create('不是JSon数组类型，不能进行转换');
  Result := TStringList.Create;
  for i := 0 to pvJSon.AsArray.Length - 1 do
  begin
    Result.Add(pvJSon.AsArray[i].AsString);
  end;
end;

class function TJSonTools.JSonParseFromStream(const pvStream: TStream):
  ISuperObject;
var
  lvDataString: string;
begin
  pvStream.Position := 0;
  SetLength(lvDataString, pvStream.Size);
  pvStream.ReadBuffer(lvDataString[1], pvStream.Size);
  Result := SO(lvDataString);
end;

class function TJSonTools.JSonSaveToStream(const pvJsn: ISuperObject; pvData:
  TStream = nil): TStream;
var
  lvJsnString: string;
begin
  lvJsnString := pvJsn.AsJSon();
  if pvData <> nil then
  begin
    pvData.WriteBuffer(lvJsnString[1], Length(lvJsnString));
    Result := pvData;
  end else
  begin
    Result := TMemoryStream.Create;
    Result.WriteBuffer(lvJsnString[1], Length(lvJsnString));
    Result.Position := 0;
  end;
end;

class function TJSonTools.JSonValue2Variant(const pvJSon: ISuperObject): Variant;
begin
  if pvJSon = nil then
  begin
    Result := null;
  end else
  begin
    case pvJSon.DataType of
      stInt: Result := pvJSon.AsInteger;
      stDouble: Result := pvJSon.AsDouble;
      stBoolean: Result := pvJSon.AsBoolean;
      stNull: Result := null;
      stCurrency: Result := pvJSon.AsCurrency;
      stObject: Result := pvJSon.AsJSon(False);
    else
      Result := pvJSon.AsString;
    end;
  end;
end;

class procedure TJSonTools.AssignFieldValueFormJSon(lvField: TField; pvValue:
    ISuperObject);
begin
  if pvValue = nil then exit;

  if pvValue.IsType(stBoolean) then
    lvField.AsBoolean := pvValue.AsBoolean
  else if pvValue.IsType(stDouble) then
    lvField.AsFloat := pvValue.AsDouble
  else if pvValue.IsType(stInt) then
    lvField.AsInteger := pvValue.AsInteger
  else if pvValue.IsType(stNull) then
    lvField.Clear
  else
    lvField.AsString := pvValue.AsString;

end;

class function TJSonTools.CheckJSonField(pvData:ISuperObject; pvFields:string):
    Boolean;
var
  lvKeyName: string;
  lvLocateKeyValues: Variant;
  lvKeyFieldLst: TStrings;
  j: Integer;
begin
  Result := False;
  if pvFields <> '' then
  begin
    lvKeyFieldLst := TStringList.Create;
    try
      lvKeyFieldLst.Text := gblRegExUtil.Replace(pvFields, '[;|,]+[ ]*', sLineBreak, true);
      Result := lvKeyFieldLst.Count > 0;
      for j := 0 to lvKeyFieldLst.Count - 1 do
      begin
        lvKeyName := Trim(lvKeyFieldLst[j]);
        if lvKeyName <> '' then
        begin
          if pvData.O[lvKeyName] = nil then
          begin
            Result := False;
            Break;
          end;
        end;
      end;
    finally
      lvKeyFieldLst.Free;
    end;
  end;
end;

class function TJSonTools.convertFieldValue2JSon(pvField:TField): ISuperObject;
begin
  Result := nil;
  if pvField.DataType in [ftBlob] then
  begin
    Result := TSuperObject.Create(TDataSetTools.BlobAsString(pvField));
  end else if pvField.DataType in [ftBoolean] then
  begin
    Result := TSuperObject.Create(pvField.AsBoolean);
  end else if pvField.DataType in [ftCurrency, ftFloat, ftFMTBcd, ftBCD] then
  begin
    Result := TSuperObject.Create(pvField.AsFloat);
  end else if pvField.DataType in [ftInteger, ftSmallint, ftWord, ftLargeint] then
  begin
    Result := TSuperObject.Create(pvField.AsInteger);
  end else
  begin
    Result := TSuperObject.Create(pvField.AsString);
  end;
end;

class procedure TJSonTools.CopyDataRecordFromJsonData(pvDestination: TDataSet;
    pvSourceData: ISuperObject; pvCopyFields: string = ''; pvIgnoreFields:
    string = '');
var
  lvDField: TField;
  lvField:TSuperAvlEntry;
  lvValue:ISuperObject;
  i: Integer;
  lvIgnoreFields, lvCopyFields: TStrings;
begin
  if pvSourceData = nil then exit;
  
  lvIgnoreFields := TStringList.Create;
  lvCopyFields := TStringList.Create;
  try
    if pvIgnoreFields <> '' then
      lvIgnoreFields.Text := gblRegExUtil.Replace(pvIgnoreFields, '[;|,]+[ ]*', sLineBreak, true);

    if pvCopyFields <> '' then
      lvCopyFields.Text := gblRegExUtil.Replace(pvCopyFields, '[;|,]+[ ]*', sLineBreak, true);

    TDataSetTools.DataSetEdit(pvDestination);
    if lvCopyFields.Count = 0 then
    begin
      for lvField in pvSourceData.AsObject do
      begin
        lvDField := pvDestination.FindField(lvField.Name);
        if (lvDField <> nil)
           and
           (lvIgnoreFields.IndexOf(lvDField.FieldName) = -1) then
        begin
          if (lvField.Value <> nil) and (lvField.Value.DataType = stObject) and (lvField.Value.O['value'] <> nil) then
          begin
            TJSonTools.AssignFieldValueFormJSon(lvDField, lvField.Value.O['value']);
          end else
          begin
            TJSonTools.AssignFieldValueFormJSon(lvDField, lvField.Value);
          end;
        end;
      end;
    end else
    begin
      for i := 0 to lvCopyFields.Count - 1 do
      begin
        lvValue := pvSourceData.O[lvCopyFields[i]];
        lvDField := pvDestination.FindField(lvCopyFields[i]);
        if (lvValue <> nil)
           and (lvDField <> nil)
           and (lvIgnoreFields.IndexOf(lvDField.FieldName) = -1) then
        begin
          if (lvValue <> nil) and (lvValue.DataType = stObject) and (lvValue.O['value'] <> nil) then
          begin
            TJSonTools.AssignFieldValueFormJSon(lvDField, lvValue.O['value']);
          end else
          begin
            TJSonTools.AssignFieldValueFormJSon(lvDField, lvValue);
          end;
        end;
      end;
    end;
  finally
    lvCopyFields.Free;
    lvIgnoreFields.Free;
  end;
  
end;

class procedure TJSonTools.emptyFieldValueAccordingJSonConfig(pvDataSet:
    TDataSet; pvAssignConfig: ISuperObject);
var
  lvItem: TSuperObjectIter;
  lvField: TField;
  lvStr: string;
begin
  if (pvAssignConfig = nil) then
    raise Exception.Create('没有选取任何值');
  if ObjectFindFirst(pvAssignConfig, lvItem) then
  try
    repeat
      lvStr := LowerCase(lvItem.key);
      lvField := pvDataSet.FindField(lvStr);
      if lvField = nil then raise Exception.Create(Format('%s字段不存在', [lvStr]));
      lvField.Clear;
    until not ObjectFindNext(lvItem);
  finally
    ObjectFindClose(lvItem);
  end;
end;

class function TJSonTools.ExtractJSonValue(pvJsonData:ISuperObject;
    pvField:string; splitChar:String = ','): String;
var
  lvJSon:ISuperObject;
  lvStr:String;
begin
  Result := '';
  if pvJsonData = nil then exit;

  if pvJsonData.IsType(stArray) then  //数组
  begin
    for lvJSon in pvJsonData do
    begin
      lvStr := lvJSon.S[pvField];
      if lvStr <> '' then
      begin
        Result := Result + lvStr + ',';
      end;
    end;
    if Length(Result) <> 0 then SetLength(Result, Length(Result) -1);
  end else
  begin
    Result := pvJsonData.S[pvField];
  end;

end;

class function TJSonTools.hasField(pvJsonData:ISuperObject; pvField:string):
    Boolean;
var
  lvItem:ISuperObject;
begin
  Result := false;
  if pvJsonData = nil then exit;

  if pvJsonData.IsType(stArray) then
  begin
    if pvJsonData.AsArray.Length = 0 then Exit;
    for lvItem in pvJsonData do
    begin
      if lvItem.O[pvField] <> nil then
      begin
        Result := true;
        Break;
      end;
    end;
  end else if
      pvJsonData.IsType(stObject)
      and (pvJsonData.O[pvField] <> nil) then
  begin
    Result := true;
  end; 

end;

class procedure TJSonTools.initializeItems(pvData: ISuperObject; pvItems:
    TStrings; pvCaption: String; pvRecyleObject: TObjectRecycle = nil);
var
  lvItem:ISuperObject;
  lvSOWrapper:TSOWrapper;
begin
  if pvData = nil then Exit;
  for lvItem in pvData do
  begin
    lvSOWrapper := TSOWrapper.Create(lvItem);
    if pvRecyleObject <> nil then pvRecyleObject.Add(lvSOWrapper);
    pvItems.AddObject(lvItem.S[pvCaption], lvSOWrapper);
  end;
end;

class function TJSonTools.IsCaseWhenExpression(const
    pvExpression:ISuperObject): Boolean;
begin
  Result := (pvExpression<> nil)
            and pvExpression.IsType(stObject)
            and (pvExpression.O['case'] <> nil)
            and (pvExpression.O['when'] <> nil)
            ;
end;


class function TJSonTools.JSonParamParse(pvParamJsnConfig: ISuperObject;
    pvSource: TDataSet; pvSourceIdx: string = ''): ISuperObject;
var
  item: TSuperObjectIter;
begin
  Result := SO();
  if pvParamJsnConfig = nil then exit;
  if pvSource = nil then
  begin
    Result := pvParamJsnConfig;
    exit;
  end;

  if ObjectFindFirst(pvParamJsnConfig, item) then
    repeat
      if ObjectIsType(item.val, stObject) then
      begin
        if (item.val.S['value'] = '') and (item.val.S['field'] <> '') then
        begin
          if item.val.S['ref'] <> '' then
          begin
            if pvSourceIdx = item.val.S['ref'] then //相等于才解析
              item.val.S['value'] := pvSource.FieldByName(item.val.S['field']).AsString;
          end else
          begin
            item.val.S['value'] := pvSource.FieldByName(item.val.S['field']).AsString;
          end;
        end;

        if (item.val.S['value'] <> '') then
        begin
          Result.S[item.key] := item.val.S['value'];
        end;
      end else
      begin
        if pvSource.FindField(item.val.AsString) <> nil then
        begin
          Result.S[item.key] := pvSource.FieldByName(item.val.AsString).AsString;
        end else
        begin
          Result.O[item.key] := item.val;
        end;
      end;
    until not ObjectFindNext(item);
  ObjectFindClose(item);
end;

class function TJSonTools.JSonParamParseFromRefIntfs(pvParamJsnConfig:
    ISuperObject; pvDefaultDataSet: TDataSet; const pvRefList: IIntfList):
    ISuperObject;
var
  item: TSuperObjectIter;
  lvRefItem, lvLocate:ISuperObject;
  lvIntf:IInterface;
  lvDataSetGetter:IDataSetGetter;
  lvDataSet:TDataSet;
  lvField:TField;
  lvDelete:Boolean;
  lvTempConfig:ISuperObject;
  procedure __checkRefList();
  begin
    if pvRefList = nil then
    begin
      raise Exception.Create('没有传入RefList,不能进行关联取值' + sLineBreak + pvParamJsnConfig.AsJSon(True));
    end;
  end;

  function getRefDataSet(const pvRefID: String): TDataSet;
  begin
      lvIntf := pvRefList.CheckGet(PAnsiChar(__passString));
      if lvIntf = nil then
      begin
        raise Exception.Create('无法从RefList中获取' + __passString + '接口!');
      end;

      lvDataSetGetter := nil;
      lvIntf.QueryInterface(IDataSetGetter, lvDataSetGetter);
      if lvDataSetGetter = nil then
      begin
        raise Exception.Create(__passString + '接口,不支持IDataSetGetter接口,无法获取数据集');
      end;
      Result := lvDataSetGetter.getDataSet;
      if Result = nil then
      begin
        raise Exception.Create(__passString + '接口中不能获取数据集,数据集为空');
      end;
  end;

  procedure __checkDefaultDataSet();
  begin
  
  end;
begin
  Result := SO();
  if pvParamJsnConfig = nil then exit;


  //不改变原有的参数
  lvTempConfig := pvParamJsnConfig.Clone;

  if ObjectFindFirst(lvTempConfig, item) then
    repeat
      if ObjectIsType(item.val, stObject) then
      begin
        lvDelete := false;
        if (item.val.O['value'] = nil) and (item.val.S['field'] <> '') then
        begin
          lvRefItem :=item.val.O['ref'];
          if (lvRefItem <> nil) then
          begin
            __checkRefList;
            if lvRefItem.DataType = stObject then
            begin
              __passString :=lvRefItem.S['ID'];
              lvDataSet := getRefDataSet(__passString);
              lvLocate := lvRefItem.O['locate'];
              if lvLocate <> nil then
              begin
                lvLocate := JSonParamParseFromRefIntfs(lvLocate, pvDefaultDataSet, pvRefList);
                if not TDataSetTools.ExecuteLocate(lvDataSet,lvLocate) then
                begin
                  if item.val.B['require'] then
                  begin
                    raise Exception.Create('不能定位对应的值' + sLineBreak + lvRefItem.O['locate'].AsJSon(True));
                  end;
                  lvDataSet := nil;
                end;
              end;
            end else if lvRefItem.AsString <> '' then
            begin
              __passString := item.val.S['ref'];
              lvDataSet := getRefDataSet(__passString);
            end;
            
            if lvDataSet <> nil then
            begin
              lvField := lvDataSet.FindField(item.val.S['field']);
              if lvField = nil then
              begin
                raise Exception.Create('找不到对应的字段[' + item.val.S['field'] + ']');
              end;
              item.val.S['value'] := lvField.AsString;
            end;
          end else
          begin
            item.val.S['value'] := pvDefaultDataSet.FieldByName(item.val.AsString).AsString;
          end;
        end;

        if (item.val.S['value'] <> '') then  //空值处理
        begin
          Result.S[item.key] := item.val.S['value'];
        end else
        begin
          if item.val.B['require'] then
          begin
            raise Exception.Create('不能读取关联对象的值' + sLineBreak + item.val.AsJSon(True));
          end;
        end;
      end else
      begin
        if (pvDefaultDataSet <> nil) and (pvDefaultDataSet.FindField(item.val.AsString) <> nil) then
        begin
          Result.S[item.key] := pvDefaultDataSet.FieldByName(item.val.AsString).AsString;
        end else
        begin
          Result.O[item.key] := item.val;
        end;
      end;
    until not ObjectFindNext(item);
  ObjectFindClose(item);
end;

class function TJSonTools.JSonParamParseFromRefObjectList(var vJSonParams:
    ISuperObject; pvRefSourceDataSetList: IObjectList): ISuperObject;
var
  item: TSuperObjectIter;
  lvSource:TDataSet;
  lvValue:String;
begin
  if vJSonParams = nil then exit;
  if pvRefSourceDataSetList = nil then exit;

  if ObjectFindFirst(vJSonParams, item) then
  repeat
    if ObjectIsType(item.val, stObject) then
    begin
      if (item.val.S['value'] = '') and (item.val.S['field'] <> '') then
      begin
        if item.val.S['ref'] <> '' then
        begin
          lvSource := pvRefSourceDataSetList.CheckGet(item.val.S['ref'], False) as TDataSet;
          if lvSource <> nil then
          begin
            lvValue := lvSource.FieldByName(item.val.S['field']).AsString;
            vJSonParams.S[item.key] := lvValue;
          end;
        end;
      end;
    end;
  until not ObjectFindNext(item);
  ObjectFindClose(item);
end;

class function TJSonTools.parseCaseWhen(const pvExpression, pvData:
    ISuperObject): ISuperObject;
var
  lvCaseVal, lvStr:String;
  lvWhen, lvResultExpression:ISuperObject;
  function extractResultFromData(pvField:String):ISuperObject;
  begin
    if hasField(pvData, pvField) then
    begin
      Result := SO(ExtractJSonValue(pvData, pvField, ','));
    end else
    begin
      Result := nil;
    end;
  end;
begin
  //从pvData获取pvData的值
  lvCaseVal:=pvData.S[pvExpression.S['case']];
  if lvCaseVal ='' then
  begin
    lvResultExpression := pvExpression.O['else'];
  end else
  begin
    lvResultExpression := pvExpression.O['when.' + lvCaseVal];
    if lvResultExpression = nil then
    begin
      lvResultExpression := pvExpression.O['else'];
    end;
  end;

  if lvResultExpression = nil then exit;

  if lvResultExpression.IsType(stObject) then
  begin
    if lvResultExpression.O['value'] <> nil then
    begin
      Result := lvResultExpression.O['value'];
    end else if (lvResultExpression.O['ref'] <> nil) then
    begin
      Result := extractResultFromData(lvResultExpression.S['ref']);
    end else
    begin
      raise Exception.Create('未知的表达式' + sLineBreak + lvResultExpression.AsJSon(True));
    end;
  end else if lvResultExpression.isType(stString) then
  begin
    lvStr := lvResultExpression.AsString;
    if hasField(pvData, lvStr) then
    begin
      Result := extractResultFromData(lvStr);
    end else
    begin
      Result := lvResultExpression;
    end;
  end else
  begin
    Result := lvResultExpression;
  end;

           
end;

class procedure TJSonTools.assign2Param(const pvParamValues: ISuperObject;
    const pvParam: IParameter);
var
  item: TSuperObjectIter;
begin
  if pvParamValues = nil then exit;

  if ObjectFindFirst(pvParamValues, item) then
    repeat
      if ObjectIsType(item.val, stObject) then
      begin
        pvParam[item.key] := item.val.S['value']
      end else
        pvParam[item.key] := item.val.AsString;
    until not ObjectFindNext(item);
  ObjectFindClose(item);
end;

class procedure TJSonTools.AssignFieldValueFromJsonData(pvDest: TDataSet;
    pvJSonData: ISuperObject);
var
  lvItem: TSuperObjectIter;
  lvField: TField;
  lvRet, lvSourceField:ISuperObject;
  lvStr, lvFieldID, lvMsg: string;
  lvRequire: Boolean;
begin
  if pvJSonData = nil then exit;
  try
    if ObjectFindFirst(pvJSonData, lvItem) then
      repeat
        if not (pvDest.State in [dsInsert, dsEdit]) then pvDest.Edit;

        lvFieldID := Trim(LowerCase(lvItem.key));
        lvField := pvDest.FindField(lvFieldID);
        if lvItem.val.IsType(stObject) then
        begin
          lvMsg:= lvItem.val.S['err'];
          if lvMsg <> '' then
          begin
            raise Exception.Create(lvMsg);
          end;
            
          lvRequire := lvItem.val.B['require'];

          if lvItem.val.O['value'] <> nil then
          begin
            lvMsg:= lvItem.val.S['emptyErrMsg'];
            if lvMsg <> '' then
            begin
              if lvItem.val.S['value'] = '' then
              begin
                raise Exception.Create(lvMsg);
              end;                                         
            end;
            AssignFieldValueFormJSon(lvField, lvItem.val.O['value']);
          end else      //value值为nil
          begin
            if lvItem.val.S['nilErrMsg'] <> '' then
            begin
              raise Exception.Create(lvItem.val.S['nilErrMsg']);
            end else
            begin
              raise Exception.Create('缺少[' + lvFieldID + ']值!');              
            end;
          end;
        end else
        begin
          if lvField <> nil then
          begin
            AssignFieldValueFormJSon(lvField, lvItem.val);
          end;
        end;
      until not ObjectFindNext(lvItem);
  finally
    ObjectFindClose(lvItem);
  end;

end;

class procedure TJSonTools.CopyJSonData(pvDest, pvSourceValue,
    pvAssignJsnConfig: ISuperObject; pvIfSourceNoneThenEmpty: Boolean = false);
var
  lvItem: TSuperObjectIter;
  lvSourceField:ISuperObject;
  lvFieldID, lvStr, lvSourceFieldID: string;
  lvRequire: Boolean;


  procedure __DoLocalAssign(__FieldID: string; __require: Boolean; __SourceField:
      ISuperObject; __sourceFieldName: String);
  begin
      if __SourceField <> nil then
        pvDest.O[__FieldID] := __SourceField
      else if (pvIfSourceNoneThenEmpty) then
        pvDest.Delete(__FieldID)
      else if __require then    //必填
      begin
        if pvSourceValue = nil then
          raise Exception.Create(Format('源JSon值不存在不能查找字段(%s)', [__sourceFieldName]));
        if __SourceField = nil then
          raise Exception.Create(Format('源JSon值不存在不能查找字段(%s)'
            + sLineBreak + pvSourceValue.AsJSon(True), [__sourceFieldName]));
      end else if (lvItem.val.B['nilThenSkip']) then
      begin
        {nop}
      end else
        pvDest.Delete(__FieldID);
  end; 

begin
  if pvAssignJsnConfig = nil then exit;
  try
    if ObjectFindFirst(pvAssignJsnConfig, lvItem) then
      repeat
        lvFieldID := Trim(LowerCase(lvItem.key));
        if lvItem.val.IsType(stObject) then
        begin
          lvRequire := lvItem.val.B['require'];

          if lvItem.val.O['value'] <> nil then
          begin
            pvDest.O[lvFieldID] := lvItem.val.O['value'];
          end else
          begin
            lvSourceField := nil;
            if lvItem.val.O['field'] <> nil then
            begin
              if pvSourceValue <> nil then
                lvSourceField := pvSourceValue.O[lvItem.val.S['field']];
            end;

            __DoLocalAssign(lvFieldID, lvRequire, lvSourceField, lvItem.val.S['field']);
          end;

        end else
        begin         //Item.val是直接的值,require为false
          lvRequire := false;

          lvSourceFieldID := Trim(LowerCase(lvItem.val.AsString));

          lvSourceField := nil;

          if pvSourceValue <> nil then
            lvSourceField:=pvSourceValue.O[lvSourceFieldID];

          __DoLocalAssign(lvFieldID, lvRequire, lvSourceField, lvSourceFieldID);
        end;
      until not ObjectFindNext(lvItem);
  finally
    ObjectFindClose(lvItem);
  end;
end;

class procedure TJSonTools.CopyRecord2JSonData(pvSourceDataSet: TDataSet; const
    pvJSonData: ISuperObject; pvCopyFields: string = ''; pvIgnoreFields: String
    = '');
var
  lvField: TField;
  i: Integer;
  lvIgnoreFields, lvCopyFields: TStrings;
begin
  lvIgnoreFields := TStringList.Create;
  lvCopyFields := TStringList.Create;
  try
    if pvIgnoreFields <> '' then
      lvIgnoreFields.Text := gblRegExUtil.Replace(pvIgnoreFields, '[;|,]+[ ]*', sLineBreak, true);

    if pvCopyFields <> '' then
      lvCopyFields.Text := gblRegExUtil.Replace(pvCopyFields, '[;|,]+[ ]*', sLineBreak, true);

    if lvCopyFields.Count = 0 then
    begin
      for i := 0 to pvSourceDataSet.FieldCount - 1 do
      begin
        lvField := pvSourceDataSet.Fields[i];
        if (lvIgnoreFields.IndexOf(lvField.FieldName) = -1) then
        begin
          putFieldValue2JsonData(lvField, pvJSonData);
        end;
      end;
    end else
    begin
      for i := 0 to lvCopyFields.Count - 1 do
      begin
        lvField := pvSourceDataSet.FindField(lvCopyFields[i]);
        if (lvField <> nil)
          and (lvIgnoreFields.IndexOf(lvField.FieldName) = -1) then
        begin
          putFieldValue2JsonData(lvField, pvJSonData);
        end;
      end;
    end;
  finally
    lvCopyFields.Free;
    lvIgnoreFields.Free;
  end;
end;

class function TJSonTools.DataSet2JSonData(pvDataSet: TDataSet; pvCopyFields:
    string = ''; pvIgnoreFields: String = ''; pvDisableControl: Boolean =
    true): ISuperObject;
var
  lvBookmark: TBookmark;
  i: Integer;
  lvValue: string;
  lvItem: ISuperObject;
  lvField: TField;
  lvFieldList:TStrings;
begin 
  Result := SO('[]');
  if pvDisableControl then lvBookmark := TDataSetTools.DisableControlsAndGetBookMark(pvDataSet);
  try
    pvDataSet.First;
    while not pvDataSet.Eof do
    begin
      lvItem := SO();
      CopyRecord2JSonData(pvDataSet, lvItem, pvCopyFields, pvIgnoreFields);
      Result.AsArray.Add(lvItem);
      pvDataSet.Next;
    end;
  finally
    if pvDisableControl then TDataSetTools.EnableControlsAndFreeBookMark(pvDataSet, lvBookmark);
  end;
end;

class function TJSonTools.extractFieldsINfo(pvDataSet: TDataSet; vFieldsINfo:
    ISuperObject; pvOverlay: Boolean = true; pvDictionaryINfo: ISuperObject =
    nil; pvPreName: String = ''): ISuperObject;
var
  i:Integer;
  lvItem:ISuperObject;
  lvField:TField;
  lvCaption:String;
begin
  if vFieldsINfo = nil then exit;

  for I := 0 to pvDataSet.FieldCount - 1 do
  begin
    lvField := pvDataSet.Fields[i];
    lvItem := SO();
    lvItem.S['name'] := lvField.FieldName;

    lvItem.S['caption'] := lvField.DisplayLabel;
    if pvDictionaryINfo <> nil then
    begin
      lvCaption :=pvDictionaryINfo.S[LowerCase(lvField.FieldName)];
      if lvCaption <> '' then
      begin
        lvItem.S['caption'] := lvCaption;
      end;
    end;

    if pvPreName <> '' then
    begin
      lvItem.S['caption'] := pvPreName + '.' + lvItem.S['caption'];
    end;

    if pvOverlay then
    begin
      vFieldsINfo.O[LowerCase(lvField.FieldName)] := lvItem;
    end else
    begin
      if vFieldsINfo.O[LowerCase(lvField.FieldName)] = nil then
        vFieldsINfo.O[LowerCase(lvField.FieldName)] := lvItem;
    end;
  end;
end;

class function TJSonTools.extractRecordsData(pvDataSet: TDataSet; vData:
    ISuperObject; pvOverlay: Boolean = true; pvDictionaryINfo: ISuperObject =
    nil; pvPreName: String = ''): ISuperObject;
var
  i:Integer;
  lvItem:ISuperObject;
  lvField:TField;
  lvCaption:String;
begin
  if vData = nil then exit;

  for I := 0 to pvDataSet.FieldCount - 1 do
  begin
    lvField := pvDataSet.Fields[i];
    lvItem := SO();
    lvItem.S['name'] := lvField.FieldName;
    lvItem.S['caption'] := lvField.DisplayLabel;
    lvItem.S['value'] := lvField.AsString;
    if pvDictionaryINfo <> nil then
    begin
      lvCaption :=pvDictionaryINfo.S[LowerCase(lvField.FieldName)];
      if lvCaption <> '' then
      begin
        lvItem.S['caption'] := lvCaption;
      end;
    end;
    if pvPreName <> '' then
    begin
      lvItem.S['caption'] := pvPreName + '.' + lvItem.S['caption'];
    end;
    if pvOverlay then
    begin
      vData.O[LowerCase(lvField.FieldName)] := lvItem;
    end else
    begin
      if vData.O[LowerCase(lvField.FieldName)] = nil then
        vData.O[LowerCase(lvField.FieldName)] := lvItem;
    end;
  end;
end;

class function TJSonTools.JSonArray2JSonList(pvArray:ISuperObject;
    pvKeyName:String = 'ID'): ISuperObject;
var
  lvItem:ISuperObject;
begin
  if pvArray = nil then exit;
  if pvArray.DataType <> stArray then Exit;
  Result := SO;
  for lvItem in pvArray do
  begin
    if lvItem.O[pvKeyName] =nil then
      raise Exception.Create('数组中不存在[' + pvKeyName +']值');
    Result.O[lvItem.S[pvKeyName]] := lvItem;
  end;
end;

class function TJSonTools.JSonArrayHasValue(pvJSonArray: ISuperObject; pvValue:
    Variant): Boolean;
var
  lvItem:ISuperObject;
  lvItemVar:Variant;
begin
  Result := false;
  if pvJSonArray = nil then exit;
  if not pvJSonArray.IsType(stArray) then Exit;
  if pvJSonArray.AsArray.Length = 0 then exit;
  if pvJSonArray.AsArray.O[0].DataType in [stObject, stArray] then exit;

  for lvItem in pvJSonArray do
  begin
    lvItemVar := JSonValue2Variant(lvItem);
    if pvValue = lvItemVar then
    begin
      Result := true;
      Break;
    end;    
  end;


end;

class function TJSonTools.parseExpression(pvExpression: string; pvData:
    ISuperObject): String;
var
  lvKey, lvValue:String;
begin
  Result := pvExpression;
  while True do
  begin
    lvKey := gblRegExUtil.GetArea(Result, '%', '%');
    if lvKey = '' then Break;
    lvValue := pvData.S[LowerCase(lvKey)];
    Result := StringReplace(Result, '%' + lvKey + '%', lvValue, [rfReplaceAll, rfIgnoreCase]);    
  end;
end;

class procedure TJSonTools.putFieldValue2JsonData(pvField: TField; const
    pvJSonData: ISuperObject);
var
  lvKey:String;
begin
  lvKey := LowerCase(pvField.FieldName);
  if pvField.DataType in [ftBlob] then
  begin
    pvJSonData.S[lvKey] := TDataSetTools.BlobAsString(pvField);
  end else if pvField.DataType in [ftBoolean] then
  begin
    pvJSonData.B[lvKey] := pvField.AsBoolean;
  end else if pvField.DataType in [ftCurrency, ftFloat, ftFMTBcd, ftBCD] then
  begin
    pvJSonData.D[lvKey] := pvField.AsFloat;
  end else if pvField.DataType in [ftInteger, ftSmallint, ftWord, ftLargeint] then
  begin
    pvJSonData.I[lvKey] := pvField.AsInteger;
  end else if pvField.DataType in [ftDate, ftDateTime] then
  begin
    if pvField.AsDateTime > 0 then
    begin
      pvJSonData.S[lvKey] := FormatDateTime('yyyy-MM-dd hh:nn:ss', pvField.AsDateTime);
    end;
  end else if not (pvField.DataType in [ftDataSet]) then
  begin
    pvJSonData.S[lvKey] := pvField.AsString;
  end;  
end;

end.

