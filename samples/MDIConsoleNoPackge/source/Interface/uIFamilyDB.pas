unit uIFamilyDB;

interface

type

  { 为树形目录存储节点信息 . }
  TPersonData = record
    Name: string;
    Level: Integer;         //世代
    LevelWord: string;      //行字
    ListNum: Integer;        //排行
    FatherID: Int64;
    BranchID: Integer;     //支脉ID
    IconIdx: Integer;
  end;
  PPersonData = ^TPersonData;



  {支脉信息}
  TBranchData = record
    ID   :integer;
    Name :string;
    Addr :string;        //地址
    Level :integer;      //世代
    Note  :string;
    ParentID :integer;    //上代支脉
    Icon  :string;    //图标索引
  end;
  PBranchData = ^TBranchData;
  
  IFamilyDB = Interface
    ['{7A52B781-DAB2-48F2-9418-B27E0AD6521B}']
    function CreateDatabaseFile(const pvFilename: PAnsiChar): boolean; stdcall;
    function OpenDatabase(const pvFilename: PAnsiChar): boolean; stdcall;
    function CloseDatabase:boolean; stdcall;

    //人员数据
    function AddPersonData(const aPersonData :PPersonData):Int64;stdcall; //返回ID
    function GetPersonData(const AID:Int64):PPersonData;stdcall;

    //Branch数据
    function GetBranchData(const AID:Int64):PBranchData;stdcall;
    function AddBranchData(const aBranchData :PBranchData):Int64;stdcall; //返回ID
    function UpdateBranchData(const aBranchData :PBranchData):Int64;stdcall; //返回ID


     //为TreeView查询数据而设置
     //准备一个返回指定条件记录ID列的查询
     function PrepareQueryIDStatment(SQL:PAnsiChar):boolean;stdcall;  //准备查询语句
     function QueryIDStatmentStep():Int64;stdcall; //返回ID ,如没有记录则返回-1

  End;


  

implementation

end.
