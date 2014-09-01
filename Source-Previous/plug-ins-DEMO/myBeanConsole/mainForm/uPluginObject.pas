unit uPluginObject;

interface

uses
  Classes, SysUtils, uICaption;

type
  TSetCaptionEvent = procedure(Sender: TObject; pvCaption:String) of object;

  TPluginObject = class(TInterfacedObject, ICaptionManager)
  private
    FPlugin: IInterface;
    FInstanceID: string;
    FcanClose: Boolean;
    FOnSetCaption: TSetCaptionEvent;
  public
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    constructor create();
    
    destructor Destroy; override;

    function getCaption: PAnsiChar; stdcall;
    
    procedure setCaption(pvCaption: PAnsiChar); stdcall;

    property InstanceID: string read FInstanceID write FInstanceID;

    //不能手动关闭
    property canClose: Boolean read FcanClose write FcanClose;


    property OnSetCaption: TSetCaptionEvent read FOnSetCaption write FOnSetCaption;

    property Plugin: IInterface read FPlugin write FPlugin;





  end;




implementation


constructor TPluginObject.create();
begin
  inherited Create;
  FcanClose:= true;
end;

destructor TPluginObject.Destroy;
begin
  FPlugin := nil;
  inherited Destroy;
end;

function TPluginObject.getCaption: PAnsiChar;
begin
  Result := '';
end;

procedure TPluginObject.setCaption(pvCaption: PAnsiChar);
begin
  if Assigned(FOnSetCaption) then
  begin
    FOnSetCaption(Self, String(AnsiString(pvCaption)));
  end;                             

end;

function TPluginObject._AddRef: Integer;
begin
  Result := -1;
end;

function TPluginObject._Release: Integer;
begin
  Result := -1;
end;

end.

