unit SOWrapper;

interface

uses
  superobject;

type
  TSOWrapper = class(TObject)
  private
    FJsnObject: ISuperObject;
    procedure SetJsnObject(const Value: ISuperObject);
  public
    constructor Create(pvJsonObject: ISuperObject);
    destructor Destroy; override;
    property JsnObject: ISuperObject read FJsnObject write SetJsnObject;
  end;

implementation

constructor TSOWrapper.Create(pvJsonObject: ISuperObject);
begin
  inherited Create;
  FJsnObject := pvJsonObject;
end;

destructor TSOWrapper.Destroy;
begin
  FJsnObject := nil;
  inherited Destroy;
end;

procedure TSOWrapper.SetJsnObject(const Value: ISuperObject);
begin
  FJsnObject := nil;
  FJsnObject := Value;
end;

end.

