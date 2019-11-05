//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit setsiot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'SetupIoT.cfg';


type
  { TfrmMenu }

  TSetSIoT = class(TObject)
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
        procedure SetDevice(const Value : Boolean);
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetTypeC(value : integer);
        procedure SetCOMPORT(value : String);
        procedure SetFileNextion(value : String);
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
  end;


implementation

procedure TSetSIoT.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;


//Valores default do codigo
procedure TSetSIoT.Default();
begin
    ckdevice := false;
end;

procedure TSetSIoT.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TSetSIoT.SetPOSY(value : integer);
begin
    FposY := value;
end;

procedure TSetSIoT.SetTypeC(value : integer);
begin
    FTypeC := value;
end;

procedure TSetSIoT.SetCOMPORT(value : string);
begin
    FCOMPORT := value;
end;

procedure TSetSIoT.SetFileNextion(value : string);
begin
    FFileNextion := value;
end;

Procedure TSetSIoT.CarregaContexto();
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
Constructor TSetSIoT.create();
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


procedure TSetSIoT.SalvaContexto();
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

destructor TSetSIoT.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.


