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
        FWDay : ttime;
        FFixar : boolean;
        FStay : boolean;
        FTime : ttime;
        procedure SetDevice(const Value : Boolean);
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetWDay(value : ttime);
        procedure SetFixar(value : boolean);
        procedure SetStay(value : boolean);
        procedure SetTime(const value : ttime);
        procedure Default();
  public
        procedure SalvaContexto();
        Procedure CarregaContexto();
        property device : boolean read ckdevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
        property WDay : Ttime read FWDay write SetWDay;
        property fixar : boolean read FFixar write SetFixar;
        property stay : boolean read FStay write SetStay;
        property time : Ttime read FTime write SetTime;
  end;

  var
    FSetWork : TSetWork;


implementation

procedure TsetWork.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;

procedure TsetWork.SetTime(const Value : Ttime);
begin
  FTime := Value;
end;


procedure TsetWork.SetWDay(value : Ttime);
begin
  FWDay := Value;
end;

//Valores default do codigo
procedure TsetWork.Default();
begin
    ckdevice := false;
end;

procedure TsetWork.SetFixar(value : boolean);
begin
    FFixar := value;
end;

procedure TsetWork.SetStay(value : boolean);
begin
    FStay := value;
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
    if  BuscaChave(arquivo,'FIXAR:',posicao) then
    begin
      FFixar := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'STAY:',posicao) then
    begin
      FStay := strtoBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'TIME:',posicao) then
    begin
      FTIME := strtotime(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'WDAY:',posicao) then
    begin
      FWDAY := strtotime(RetiraInfo(arquivo.Strings[posicao]));
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
  arquivo.Append('FIXAR:'+booltostr(FFixar));
  arquivo.Append('STAY:'+booltostr(FStay));
  arquivo.Append('TIME:'+timetostr(FTIME));
  arquivo.Append('WDAY:'+timetostr(FWDAY));

  arquivo.SaveToFile(filename);
end;

destructor TsetWork.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.



