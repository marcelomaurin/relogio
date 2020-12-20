//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:15/12/2020

unit setdisplay;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'Setdisplay.cfg';


type
  { TfrmMenu }

  TSetDisplay = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        FDEVICE : boolean;
        FPosX : integer;
        FPosY : integer;
        FFixar : boolean;
        FStay : boolean;
        FDPort : String;
        procedure SetDevice(const Value : Boolean);
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetDPort(value : string);
        procedure SetFixar(value : boolean);
        procedure SetStay(value : boolean);
        procedure Default();
  public
        procedure SalvaContexto();
        Procedure CarregaContexto();
        property device : boolean read FDevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
        property DPort : String read FDPort write SetDPort;
        property fixar : boolean read FFixar write SetFixar;
        property stay : boolean read FStay write SetStay;
  end;

  var
       FSetDisplay : TSetDisplay;

implementation

procedure TsetDisplay.SetDevice(const Value : Boolean);
begin
     FDevice := Value;
end;

procedure TsetDisplay.SetDPort(value : string);
begin
  FDPort := Value;
end;



//Valores default do codigo
procedure TsetDisplay.Default();
begin
    FDevice := false;
    FDPort := 'COM1';
end;

procedure TsetDisplay.SetFixar(value : boolean);
begin
    FFixar := value;
end;

procedure TsetDisplay.SetStay(value : boolean);
begin
    FStay := value;
end;

procedure TsetDisplay.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TsetDisplay.SetPOSY(value : integer);
begin
    FposY := value;
end;


Procedure TsetDisplay.CarregaContexto();
var
  posicao: integer;
begin
    if  BuscaChave(arquivo,'DEVICE:',posicao) then
    begin
      FDevice := (RetiraInfo(arquivo.Strings[posicao])='1');
    end;
    if  BuscaChave(arquivo,'POSX:',posicao) then
    begin
      FPOSX := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'POSY:',posicao) then
    begin
      FPOSY := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'FIXAR:',posicao) then
    begin
      FFixar := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'STAY:',posicao) then
    begin
      FStay := strtoBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'DPORT:',posicao) then
    begin
      FDPort := RetiraInfo(arquivo.Strings[posicao]);
    end;
end;

//Metodo construtor
Constructor TsetDisplay.create();
begin
  arquivo := TStringList.create();
  if (FileExists(filename)) then
  begin
    arquivo.LoadFromFile(filename);
    CarregaContexto();
  end
  else
  begin
    default();
  end;
end;


procedure TsetDisplay.SalvaContexto();
begin
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(FDEVICE,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));
  arquivo.Append('FIXAR:'+booltostr(FFixar));
  arquivo.Append('STAY:'+booltostr(FStay));
  arquivo.Append('DPORT:'+FDPort);
  arquivo.SaveToFile(filename);
end;

destructor TsetDisplay.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.



