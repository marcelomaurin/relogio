//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit settemp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'Settemp.cfg';


type
  { TfrmMenu }

  TSettemp = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        ckdevice : boolean;
        FPosX : integer;
        FPosY : integer;
        procedure SetDevice(const Value : Boolean);
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure Default();
  public
        procedure SalvaContexto();
        Procedure CarregaContexto();
        property device : boolean read ckdevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
  end;


implementation

procedure TsetTemp.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;


//Valores default do codigo
procedure TsetTemp.Default();
begin
    ckdevice := false;
end;

procedure TsetTemp.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TsetTemp.SetPOSY(value : integer);
begin
    FposY := value;
end;


Procedure TsetTemp.CarregaContexto();
var
  posicao: integer;
begin
    if  BuscaChave(arquivo,'DEVICE:',posicao) then
    begin
      ckdevice := (RetiraInfo(arquivo.Strings[posicao])='1');
    end;
    if  BuscaChave(arquivo,'POSX:',posicao) then
    begin
      FPOSX := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'POSY:',posicao) then
    begin
      FPOSY := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;

end;

//Metodo construtor
Constructor TsetTemp.create();
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


procedure TsetTemp.SalvaContexto();
begin
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(ckdevice,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));
  arquivo.Append('COMPORT:'+FCOMPORT);
  arquivo.Append('TYPE:'+inttostr(FTYPEC));

  arquivo.SaveToFile(filename);
end;

destructor TsetTemp.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.



