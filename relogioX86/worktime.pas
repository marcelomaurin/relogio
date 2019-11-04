unit worktime;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  setworktime;

type

  { TfrmWorkTime }

  TfrmWorkTime = class(TForm)
    Label3: TLabel;
    lbWorkTime: TLabel;
    Label2: TLabel;
    lbWorkTime1: TLabel;
    mnFixarClock: TMenuItem;
    MnStay: TMenuItem;
    PopupMenu1: TPopupMenu;

    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CarregaContexto();
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnFixarClockClick(Sender: TObject);
    procedure MnStayClick(Sender: TObject);
  private

  public

  end;

var
  frmWorkTime: TfrmWorkTime;

implementation

{$R *.lfm}

{ TfrmWorkTime }

procedure TfrmWorkTime.FormCreate(Sender: TObject);
begin
  if (FSetWorktime = nil) then
  begin
       Fsetworktime := Tsetworktime.create();
  end;
  CarregaContexto();
  //Timer1.Enabled := true;
  //buffer := '';
end;

procedure TfrmWorkTime.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
    CloseAction:=caHide;
end;

procedure TfrmWorkTime.CarregaContexto();
begin
  FSetWorkTime.CarregaContexto();
  Left:= Fsetworktime.posx;
  top:= FSetWorkTime.posy;
  if FSetWorkTime.stay then
  begin
    FormStyle:= fsStayOnTop;
  end
  else
  begin
    FormStyle:= fsNormal;
  end;
  if FSetWorkTime.fixar then
  begin
    BorderStyle:=bsSingle;
    //mnFixarClock.Caption:='Fixar Clock';
  end
  else
  begin
    BorderStyle:=bsNone;
    //mnFixarClock.Caption:='Mover Clock';
  end;


end;

procedure TfrmWorkTime.FormDestroy(Sender: TObject);
begin
  Fsetworktime.posx := Left;
  Fsetworktime.posy := top;

  Fsetworktime.SalvaContexto();
  if Fsetworktime <> nil then
  begin
    Fsetworktime.Free();
    Fsetworktime := nil;
  end;
end;

procedure TfrmWorkTime.FormShow(Sender: TObject);
var
  a : integer;
begin
  (*Menu Aparece*)
  AlphaBlend:=true;
  AlphaBlendValue:=0;
  Refresh;
  for a:=0 to 255 do
  begin
    AlphaBlendValue:=a;
    Refresh;
    Sleep(10);
  end;
end;

procedure TfrmWorkTime.mnFixarClockClick(Sender: TObject);
begin
   if (BorderStyle = bsNone) then
   begin
     BorderStyle:=bsSingle;
     Fsetworktime.fixar := true;
     mnFixarClock.Caption:='Fixar Clock';
     self.refresh;
   end
   else
   begin
     BorderStyle:=bsNone;
     Fsetworktime.fixar := false;
     mnFixarClock.Caption:='Mover Clock';
     //self.hide;
     //self.show;
     self.refresh;
   end;
   Fsetworktime.SalvaContexto();

end;

procedure TfrmWorkTime.MnStayClick(Sender: TObject);
begin
  if FormStyle = fsNormal then
  begin
    FormStyle:= fsStayOnTop;
    Fsetworktime.stay := true;

  end
  else
  begin
    FormStyle:=fsNormal;
    Fsetworktime.stay := false;
  end;
  refresh;
  Fsetworktime.SalvaContexto();
end;

end.

