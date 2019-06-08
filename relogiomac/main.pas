unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, LedNumber, indGnouMeter, Sensors;

type

  { TfrmRelogio }

  TfrmRelogio = class(TForm)
    AnalogSensor1: TAnalogSensor;
    indGnouMeter1: TindGnouMeter;
    lbData: TLabel;
    lbHora: TLabel;
    lbHora1: TLabel;
    LEDNumber1: TLEDNumber;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Timer1: TTimer;
    TrayIcon1: TTrayIcon;
    procedure lbHoraClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  frmRelogio: TfrmRelogio;

implementation

{$R *.lfm}

{ TfrmRelogio }

procedure TfrmRelogio.lbHoraClick(Sender: TObject);
begin

end;

procedure TfrmRelogio.Timer1Timer(Sender: TObject);
begin
  lbHora.Caption:= timetostr(now);
  lbdata.Caption:= DateToStr(now);
end;

end.

