unit clock;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, setclock;

type

  { Tfrmclock }

  Tfrmclock = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    MnStay: TMenuItem;
    mnFixarClock: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnFixarClockClick(Sender: TObject);
    procedure MnStayClick(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Timer1Timer(Sender: TObject);
    procedure CarregaContexto();
  private
    setclock :  TSetclock;
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
    setclock.fixar := true;
    self.refresh;
  end
  else
  begin
    BorderStyle:=bsNone;
    mnFixarClock.Caption:='Mover Clock';
    setclock.fixar := false;
    //self.hide;
    //self.show;
    self.refresh;
  end;
  setclock.SalvaContexto();
end;

procedure Tfrmclock.MnStayClick(Sender: TObject);
begin
  if FormStyle = fsNormal then
  begin
    FormStyle:= fsStayOnTop;
    setclock.stay:=true;
  end
  else
  begin
    FormStyle:=fsNormal;
    setclock.stay:=false;
  end;
  refresh;

end;

procedure Tfrmclock.FormHide(Sender: TObject);
begin
    frmmenu.MnRelogio.Caption:='Mostrar Relógio';
end;

procedure Tfrmclock.CarregaContexto();
begin
  setclock.CarregaContexto(); (*Carrega o contexto do ambiente*)
  Left:= setclock.posx;
  top:= setclock.posy;
  if setclock.stay then
   begin
     FormStyle:= fsStayOnTop;
   end
   else
   begin
     FormStyle:= fsNormal;
   end;
   if setclock.fixar then
   begin
     BorderStyle:=bsSingle;
     mnFixarClock.Caption:='Fixar Clock';
   end
   else
   begin
     BorderStyle:=bsNone;
     mnFixarClock.Caption:='Mover Clock';
   end;

end;

procedure Tfrmclock.FormCreate(Sender: TObject);
begin
  setclock := TSetclock.create;
  CarregaContexto();


end;

procedure Tfrmclock.FormDestroy(Sender: TObject);
begin
  setclock.posx := Left;
  setclock.posy := top;
  setclock.SalvaContexto();
end;

procedure Tfrmclock.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

end;

end.

