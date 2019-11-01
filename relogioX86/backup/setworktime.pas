//Objetivo construir os parametros de setup do clock
//Criado por Marcelo Maurin Martins
//Data:01/11/2019

unit setworktime;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'Setworktime.cfg';


type
  { TfrmMenu }

  TSetWorkTime = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        ckdevice : boolean;
        FPosX : integer;
        FPosY : integer;
        FTypeC : integer;
        FCOMPORT : String;
        FFileNextion : String;
        FFixar : boolean;
        FStay : boolean;
        procedure SetDevice(const Value : Boolean);
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetTypeC(value : integer);
        procedure SetCOMPORT(value : String);
        procedure SetFileNextion(value : String);
        procedure SetFixar(value : boolean);
        procedure SetStay(value : boolean);
        procedure Default();
  public
        procedure SalvaContexto();
        Procedure CarregaContexto();
        property device : boolean read ckdevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
        property TypeC : integer read FTypeC write SetTypeC;
        property COMPORT : String read FCOMPORT write SetCOMPORT;
        property FileNextion : String read FFileNextion write SetFileNextion;
        property fixar : boolean read FFixar write SetFixar;
        property stay : boolean read FStay write SetStay;
  end;



implementation

procedure TSetWorkTime.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;

procedure TSetWorkTime.SetFixar(value : boolean);
begin
    FFixar := value;
end;

procedure TSetWorkTime.SetStay(value : boolean);
begin
    FStay := value;
end;

//Valores default do codigo
procedure TSetWorkTime.Default();
begin
    ckdevice := false;
end;

procedure TSetWorkTime.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TSetWorkTime.SetPOSY(value : integer);
begin
    FposY := value;
end;

procedure TSetWorkTime.SetTypeC(value : integer);
begin
    FTypeC := value;
end;

procedure TSetWorkTime.SetCOMPORT(value : string);
begin
    FCOMPORT := value;
end;

procedure TSetWorkTime.SetFileNextion(value : string);
begin
    FFileNextion := value;
end;

Procedure TSetWorkTime.CarregaContexto();
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
    if  BuscaChave(arquivo,'COMPORT:',posicao) then
    begin
      FCOMPORT := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'FILENEXTION:',posicao) then
    begin
      FFILENEXTION := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'TYPE:',posicao) then
    begin
      FTypeC := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
end;

//Metodo construtor
Constructor TSetWorkTime.create();
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


procedure TSetWorkTime.SalvaContexto();
begin
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(ckdevice,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));
  arquivo.Append('COMPORT:'+FCOMPORT);
  arquivo.Append('FILENEXTION:'+FFILENEXTION);
  arquivo.Append('TYPE:'+inttostr(FTYPEC));

  arquivo.SaveToFile(filename);
end;

destructor TSetWorkTime.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.


