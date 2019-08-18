unit clock;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus;

type

  { Tfrmclock }

  Tfrmclock = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    mnFixarClock: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    Timer1: TTimer;
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnFixarClockClick(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  frmclock: Tfrmclock;

implementation

{$R *.lfm}

{ Tfrmclock }
uses main;


procedure Tfrmclock.Timer1Timer(Sender: TObject);
begin
  Label1.Caption:= DateToStr(now());
  label2.Caption:=TimeToStr(now());
  Application.ProcessMessages;
end;

procedure Tfrmclock.FormShow(Sender: TObject);
begin
  Timer1.Enabled:= true;
  frmmenu.MnRelogio.Caption:='Esconder Relógio';
end;

procedure Tfrmclock.mnFixarClockClick(Sender: TObject);
begin
  if (frmclock.BorderStyle = bsNone) then
  begin
    BorderStyle:=bsSingle;
    mnFixarClock.Caption:='Fixar Clock';
    self.refresh;
  end
  else
  begin
    BorderStyle:=bsNone;
    mnFixarClock.Caption:='Mover Clock';
    //self.hide;
    //self.show;
    self.refresh;
  end;
end;

procedure Tfrmclock.FormHide(Sender: TObject);
begin
    frmmenu.MnRelogio.Caption:='Mostrar Relógio';
end;

procedure Tfrmclock.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

end;

end.

