//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit dayworking;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

//const filename = 'Setworking.cfg';


type
  { TfrmMenu }

  TDayWorking = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        ckdevice : boolean;

        FTimeStart : TTime;
        FTimeStop : TTime;
        FTimeLap : TTime;
        filename : String;
        procedure SetTimeStart(value : TTime);
        procedure SetTimeStop(value : TTime);
        procedure SetTimeLap(value : TTime);
        procedure Default();
  public
        procedure SalvaContexto();
        Procedure CarregaContexto();
        procedure IdentificaArquivo(flag : boolean);
        property TimeStart : TTime read FTimeStart write SetTimeStart;
        property TimeStop : TTime read FTimeStop write SetTimeStop;
        property TimeLap : TTime read FTimeLap write SetTimeLap;
  end;

var
   FDayWorking : TDayWorking;


implementation

procedure TDayWorking.SetTimeStart( Value : TTime);
begin
  FTimeStart := Value;
end;

procedure TDayWorking.SetTimeStop( Value : TTime);
begin
  FTimeStop := Value;
end;

procedure TDayWorking.SetTimeLap( Value : TTime);
begin
  FTimeLap := Value;
end;

//Valores default do codigo
procedure TDayWorking.Default();
begin
    FTimeLap:=0;
    FTimeStart:=0;
    FTimeStop:=0;

end;



Procedure TDayWorking.CarregaContexto();
var
  posicao: integer;
begin
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


procedure TDayWorking.IdentificaArquivo(flag : boolean);
begin
  filename := 'DWrk'+ FormatDateTime('ddmmyy',now())+'.dat';

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
    SalvaContexto();
  end;

end;

//Metodo construtor
Constructor TDayWorking.create();
begin
    if (arquivo = nil) then
    begin
         arquivo := TStringList.create();
    end;

    IdentificaArquivo(true);

end;


procedure TDayWorking.SalvaContexto();
begin
  if (arquivo=nil) then
  begin
       arquivo := TString.create;
       IdentificaArquivo(true);
  end;

  if (arquivo<>nil) then
  begin
       arquivo.Clear;
       arquivo.Append('TIMESTART:'+timetostr(FTimeStart));
       arquivo.Append('TIMESTOP:'+timetostr(FTimeStop));
       arquivo.Append('TIMELAP:'+timetostr(FTimeLap));
       arquivo.SaveToFile(filename);
  end;
end;

destructor TDayWorking.destroy();
begin
  SalvaContexto();
  if (Arquivo <> nil) then
  begin
       arquivo.free;
       arquivo := nil;
  end;
end;

end.



