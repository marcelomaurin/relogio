unit Display;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, LazSerial,
  setdisplay, temp, funcoes;

type

  { TfrmDisplay }

  TfrmDisplay = class(TForm)
    LazSerial1: TLazSerial;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  frmDisplay: TfrmDisplay;

implementation

{$R *.lfm}

{ TfrmDisplay }

procedure TfrmDisplay.FormCreate(Sender: TObject);
begin
  if (setdisplay.FSetDisplay <> nil) then
  begin
    if not LazSerial1.Active then
    begin

      LazSerial1 := TLazSerial.Create(self);
      LazSerial1.BaudRate:= br__9600;
      LazSerial1.Device:= FSetDisplay.DPort;
      try
          LazSerial1.Open;
          Timer1.Enabled:= true;
      except
          setdisplay.FSetDisplay.device:=false;
          setdisplay.FSetDisplay.SalvaContexto();
          LazSerial1.close;
      end;
    end;
  end;
end;

procedure TfrmDisplay.Timer1Timer(Sender: TObject);
begin
  if LazSerial1.Active then
  begin
     LazSerial1.WriteData('Data.txt="'+datetostr(now)+'"'+#255+#255+#255);
     LazSerial1.WriteData('Hora.txt="'+timetostr(now)+'"'+#255+#255+#255);
     if (temp.frmTemp<>nil) then
     begin
        LazSerial1.WriteData('Temp1.txt="'+temp.frmTemp.Temperatura+'"'+#255+#255+#255);
        LazSerial1.WriteData('Hum1.txt="'+temp.frmTemp.Humidade+'"'+#255+#255+#255);
        LazSerial1.WriteData('CPU01.val="'+inttostr(GetTotalCpuUsagePct())+'"'+#255+#255+#255);
     end;
  end;

end;

end.

