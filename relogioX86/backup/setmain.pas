//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit setmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'main.cfg';


type
  { TfrmMenu }

  TSetMain = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        ckdevice : boolean;
        FPosX : integer;
        FPosY : integer;
        procedure SetDevice(const Value:);
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

procedure TSetMain.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;


//Valores default do codigo
procedure TSetMain.Default();
begin
    ckdevice := false;
end;

procedure TSetMain.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TSetMain.SetPOSY(value : integer);
begin
    FposY := value;
end;

Procedure TSetMain.CarregaContexto();
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

end;

//Metodo construtor
Constructor TSetMain.create();
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


procedure TSetMain.SalvaContexto();
begin
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(ckdevice,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));

  arquivo.SaveToFile(filename);
end;

destructor TSetMain.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.

