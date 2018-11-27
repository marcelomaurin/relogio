unit alarme;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Buttons, ExtCtrls, acs_audio, acs_cdrom, acs_misc, acs_file,
  LedNumber, main, acs_classes;

type

  { TfrmAlarme }

  TfrmAlarme = class(TForm)
    diassemana: TCheckGroup;
    hora: TLEDNumber;
    minutos: TLEDNumber;
    lbHora: TLabel;
    lbHora1: TLabel;
    Shape1: TShape;
    btSalvar: TSpeedButton;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    procedure AcsAudioOut1Done(Sender: TComponent);
    procedure AcsAudioOut2Done(Sender: TComponent);
    procedure AcsFileOut1Done(Sender: TComponent);
    procedure AcsMemoryIn1BufferDone(Sender: TComponent);
    procedure btSalvarClick(Sender: TObject);
    procedure diassemanaClick(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
  private

  public

  end;

var
  frmAlarme: TfrmAlarme;

implementation

{$R *.lfm}

{ TfrmAlarme }
function iif(cond : boolean; verdade : variant; falso : variant): variant;
var
  resultado : variant;
begin
  resultado := falso;
  if cond then
  begin
       resultado := verdade;
  end
  else
  begin
       resultado := falso;
  end;
  result := resultado;
end;

procedure TfrmAlarme.btSalvarClick(Sender: TObject);
var
  localalarme : TTime;
  a : integer;
begin
  localalarme := StrToTime(hora.Caption+':'+ minutos.Caption);
  frmmain.horaalarme:= localalarme;
  for a := 0 to 6 do
  begin
    frmmain.diasemana[a] :=  iif(diassemana.Checked[a]=true,1,0);
  end;
  close;
end;

procedure TfrmAlarme.AcsFileOut1Done(Sender: TComponent);
begin

end;

procedure TfrmAlarme.AcsAudioOut1Done(Sender: TComponent);
begin

end;

procedure TfrmAlarme.AcsAudioOut2Done(Sender: TComponent);
begin

end;

procedure TfrmAlarme.AcsMemoryIn1BufferDone(Sender: TComponent);
begin

end;

procedure TfrmAlarme.diassemanaClick(Sender: TObject);
begin

end;

procedure TfrmAlarme.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var
  horaint: integer;
begin
  horaint := strtoint(hora.Caption);
  if (Button=btNext) then
  begin
     if (horaint<23) then
        horaint := horaint + 1
     else
        horaint := 0;

  end;
  if (Button=btPrev) then
  begin
     if (horaint>0) then
        horaint := horaint -1
     else
        horaint := 23;

  end;


  hora.Caption:= inttostr(horaint);
end;

procedure TfrmAlarme.UpDown2Click(Sender: TObject; Button: TUDBtnType);
var
  minutoint: integer;
begin
  minutoint := strtoint(minutos.Caption);
  if (Button=btNext) then
  begin
     if (minutoint<59) then
        minutoint := minutoint + 1
     else
        minutoint := 0;

  end;
  if (Button=btPrev) then
  begin
     if (minutoint>0) then
        minutoint := minutoint -1
     else
        minutoint := 59;

  end;


  minutos.Caption:= inttostr(minutoint);
end;

end.

