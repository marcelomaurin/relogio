//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit setworking;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

//const filename = 'Setworking.cfg';


type
  { TfrmMenu }

  TSetworking = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        ckdevice : boolean;
        FPosX : integer;
        FPosY : integer;
        FFixar : boolean;
        FStay : boolean;
        FTimeStart : TTime;
        FTimeStop : TTime;
        FTimeLap : TTime;
        filename : String;
        procedure SetDevice(const Value : Boolean);
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetFixar(value : boolean);
        procedure SetStay(value : boolean);
        procedure SetTimeStart(value : TTime);
        procedure SetTimeStop(value : TTime);
        procedure SetTimeLap(value : TTime);
        procedure Default();
  public
        procedure SalvaContexto(flag : boolean);
        Procedure CarregaContexto();
        procedure IdentificaArquivo(flag : boolean);
        property device : boolean read ckdevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
        property fixar : boolean read FFixar write SetFixar;
        property stay : boolean read FStay write SetStay;
        property TimeStart : TTime read FTimeStart write SetTimeStart;
        property TimeStop : TTime read FTimeStop write SetTimeStop;
        property TimeLap : TTime read FTimeLap write SetTimeLap;
  end;


implementation

procedure TSetworking.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;

procedure TSetworking.SetTimeStart( Value : TTime);
begin
  FTimeStart := Value;
end;

procedure TSetworking.SetTimeStop( Value : TTime);
begin
  FTimeStop := Value;
end;

procedure TSetworking.SetTimeLap( Value : TTime);
begin
  FTimeLap := Value;
end;

//Valores default do codigo
procedure TSetworking.Default();
begin
    ckdevice := false;
    FTimeLap:=0;
    FTimeStart:=0;
    FTimeStop:=0;
    fixar:=false;
end;

procedure TSetworking.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TSetworking.SetPOSY(value : integer);
begin
    FposY := value;
end;

procedure TSetworking.SetFixar(value : boolean);
begin
    FFixar := value;
end;

procedure TSetworking.SetStay(value : boolean);
begin
    FStay := value;
end;

Procedure TSetworking.CarregaContexto();
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
    if  BuscaChave(arquivo,'TIMESTART:',posicao) then
    begin
      FTIMESTART := strtoTime(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'TIMESTOP:',posicao) then
    begin
      FTIMESTOP := strtoTime(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'TIMELAP:',posicao) then
    begin
      FTIMELAP := strtoTime(RetiraInfo(arquivo.Strings[posicao]));
    end;
end;


procedure TSetworking.IdentificaArquivo(flag : boolean);
begin
  filename := 'Work'+ FormatDateTime('ddmmyy',now())+'.cfg';

  if (FileExists(filename)) then
  begin
    if flag then
    begin
         arquivo.LoadFromFile(filename);
         CarregaContexto();
    end;
  end
  else
  begin
    default();
    SalvaContexto(false);
  end;

end;

//Metodo construtor
Constructor TSetworking.create();
begin
    arquivo := TStringList.create();
    IdentificaArquivo(true);
    Timer1.ac
end;


procedure TSetworking.SalvaContexto(flag : boolean);
begin
  if (flag) then
  begin
    IdentificaArquivo(false);
  end;
  filename := 'Work'+ FormatDateTime('ddmmyy',now())+'.cfg';
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(ckdevice,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));
  arquivo.Append('FIXAR:'+booltostr(FFixar));
  arquivo.Append('STAY:'+booltostr(FStay));
  arquivo.Append('TIMESTART:'+timetostr(FTimeStart));
  arquivo.Append('TIMESTOP:'+timetostr(FTimeStop));
  arquivo.Append('TIMELAP:'+timetostr(FTimeLap));

  arquivo.SaveToFile(filename);
end;

destructor TSetworking.destroy();
begin
  SalvaContexto(true);
  arquivo.free;
end;

end.



