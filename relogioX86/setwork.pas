//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit setwork;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'Setwork.cfg';


type
  { TfrmMenu }

  TSetWork = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        ckdevice : boolean;
        FPosX : integer;
        FPosY : integer;
        FWDay : String;
        procedure SetDevice(const Value : Boolean);
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetWDay(value : String);
        procedure Default();
  public

        procedure SalvaContexto();
        Procedure CarregaContexto();
        property device : boolean read ckdevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
        property WDay : String read FWDay write SetWDay;
  end;


implementation

procedure TsetWork.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;

procedure TsetWork.SetWDay(value : String);
begin
  FWDay := Value;
end;

//Valores default do codigo
procedure TsetWork.Default();
begin
    ckdevice := false;
end;

procedure TsetWork.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TsetWork.SetPOSY(value : integer);
begin
    FposY := value;
end;


Procedure TsetWork.CarregaContexto();
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
Constructor TsetWork.create();
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


procedure TsetWork.SalvaContexto();
begin
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(ckdevice,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));

  arquivo.SaveToFile(filename);
end;

destructor TsetWork.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.



