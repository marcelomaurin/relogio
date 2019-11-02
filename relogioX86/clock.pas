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
    Fsetclock.fixar := true;
    self.refresh;
  end
  else
  begin
    BorderStyle:=bsNone;
    mnFixarClock.Caption:='Mover Clock';
    Fsetclock.fixar := false;
    //self.hide;
    //self.show;
    self.refresh;
  end;
  Fsetclock.SalvaContexto();
end;

procedure Tfrmclock.MnStayClick(Sender: TObject);
begin
  if FormStyle = fsNormal then
  begin
    FormStyle:= fsStayOnTop;
    Fsetclock.stay:=true;
  end
  else
  begin
    FormStyle:=fsNormal;
    Fsetclock.stay:=false;
  end;
  refresh;

end;

procedure Tfrmclock.FormHide(Sender: TObject);
begin
    frmmenu.MnRelogio.Caption:='Mostrar Relógio';
end;

procedure Tfrmclock.CarregaContexto();
begin
  Fsetclock.CarregaContexto(); (*Carrega o contexto do ambiente*)
  Left:= Fsetclock.posx;
  top:= Fsetclock.posy;
  if Fsetclock.stay then
   begin
     FormStyle:= fsStayOnTop;
   end
   else
   begin
     FormStyle:= fsNormal;
   end;
   if Fsetclock.fixar then
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
  Fsetclock := TSetclock.create;
  CarregaContexto();


end;

procedure Tfrmclock.FormDestroy(Sender: TObject);
begin
  Fsetclock.posx := Left;
  Fsetclock.posy := top;
  Fsetclock.SalvaContexto();
end;

procedure Tfrmclock.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

end;

end.

