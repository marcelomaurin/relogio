//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit setclock;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'clock.cfg';


type
  { TfrmMenu }

  TSetclock = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        ckdevice : boolean;
        FPosX : integer;
        FPosY : integer;
        FFixar : boolean;
        FStay : boolean;

        procedure Default();
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetDevice(const Value : Boolean);
        procedure SetFixar(value : boolean);
        procedure SetStay(value : boolean);

  public
        procedure SalvaContexto();
        Procedure CarregaContexto();
        property device : boolean read ckdevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
        property fixar : boolean read FFixar write SetFixar;
        property stay : boolean read FStay write SetStay;
  end;

implementation

procedure TSetclock.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TSetclock.SetPOSY(value : integer);
begin
    FposY := value;
end;


procedure TSetclock.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;

procedure TSetclock.SetFixar(value : boolean);
begin
    FFixar := value;
end;

procedure TSetclock.SetStay(value : boolean);
begin
    FStay := value;
end;


//Valores default do codigo
procedure TSetclock.Default();
begin
    ckdevice := false;
end;

Procedure TSetclock.CarregaContexto();
var
  posicao: integer;
begin
    if  BuscaChave(arquivo,'DEVICE:',posicao) then
    begin
      device := (RetiraInfo(arquivo.Strings[posicao])='1');
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

end;

//Metodo construtor
Constructor TSetclock.create();
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


procedure TSetclock.SalvaContexto();
begin
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(ckdevice,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));


  arquivo.SaveToFile(filename);
end;

destructor TSetclock.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.

