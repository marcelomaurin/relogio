unit working;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Menus, setworking, worktime;

type

  { TfrmWorking }

  TfrmWorking = class(TForm)

    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    mnFixarClock: TMenuItem;
    MnStay: TMenuItem;
    PopupMenu1: TPopupMenu;
    Share: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageList1: TImageList;
    Label10: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbStart: TLabel;
    Label7: TLabel;
    lbStop: TLabel;
    Label9: TLabel;
    Timer1: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnFixarClockClick(Sender: TObject);
    procedure MnStayClick(Sender: TObject);
    procedure mnWorkingClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

    procedure CarregaContexto();

  public
    Fsetworking : TSetworking;
  end;

var
  frmWorking: TfrmWorking;

implementation

{$R *.lfm}

procedure TfrmWorking.FormCreate(Sender: TObject);
begin
  Fsetworking := Tsetworking.create();
  CarregaContexto();
  Timer1.Enabled := true;
  //buffer := '';
end;

procedure TfrmWorking.BitBtn1Click(Sender: TObject);
begin
  if (Fsetworking.TimeStart=0) then
  begin
    Fsetworking.TimeStart:= now;
    lbStart.caption := timetostr(Fsetworking.TimeStart) ;
  end
  else
  begin
    if (Fsetworking.TimeStop=0) then
    begin
        Fsetworking.TimeStop:= now;
        lbStop.caption := timetostr(Fsetworking.TimeStop) ;
    end
  end;
end;

procedure TfrmWorking.BitBtn2Click(Sender: TObject);
begin

end;

procedure TfrmWorking.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caHide;

end;

procedure TfrmWorking.FormDestroy(Sender: TObject);
begin
  Fsetworking.posx := Left;
  Fsetworking.posy := top;

  Fsetworking.SalvaContexto(true);
  if Fsetworking <> nil then
  begin
    Fsetworking.Free();
  end;
end;

procedure TfrmWorking.FormShow(Sender: TObject);
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

procedure TfrmWorking.mnFixarClockClick(Sender: TObject);
begin
   if (frmWorking.BorderStyle = bsNone) then
  begin
    BorderStyle:=bsSingle;
    mnFixarClock.Caption:='Fixar Clock';
    Fsetworking.fixar := true;
    self.refresh;
  end
  else
  begin
    BorderStyle:=bsNone;
    mnFixarClock.Caption:='Mover Clock';
    Fsetworking.fixar := false;
    //self.hide;
    //self.show;
    self.refresh;
  end;
  Fsetworking.SalvaContexto(true);
end;

procedure TfrmWorking.MnStayClick(Sender: TObject);
begin
  if FormStyle = fsNormal then
  begin
    FormStyle:= fsStayOnTop;
    Fsetworking.stay:=true;
  end
  else
  begin
    FormStyle:=fsNormal;
    Fsetworking.stay:=false;
  end;
  refresh;
end;

procedure TfrmWorking.mnWorkingClick(Sender: TObject);
begin

end;

procedure TfrmWorking.Timer1Timer(Sender: TObject);
var
  tempo : TTime;
  temporestante : ttime;
begin
  if (Fsetworking.TimeStart <>0) then
  begin
    tempo := now() - (Fsetworking.TimeStart+Fsetworking.TimeLap);
    temporestante := 8 - tempo;
    if (frmworktime = nil) then
    begin
      frmworktime := Tfrmworktime.create(self);
      frmworktime.show;
    end;
    frmworktime.lbWorkTime.caption := TimeToStr(tempo);
    frmworktime.lbworktime.refresh;
    frmworktime.lbWorkTime1.Caption:= timetostr(temporestante);
    frmworktime.lbworktime1.refresh;

  end;
end;

procedure TfrmWorking.CarregaContexto();
begin
  Fsetworking.CarregaContexto();
  Left:= Fsetworking.posx;
  top:= Fsetworking.posy;
  if Fsetworking.stay then
  begin
    FormStyle:= fsStayOnTop;
  end
  else
  begin
    FormStyle:= fsNormal;
  end;
  if Fsetworking.fixar then
  begin
    BorderStyle:=bsSingle;
    //mnFixarClock.Caption:='Fixar Clock';
  end
  else
  begin
    BorderStyle:=bsNone;
    //mnFixarClock.Caption:='Mover Clock';
  end;
  if (Fsetworking.TimeStart<>0) then
  begin
    lbStart.Caption := timetostr(Fsetworking.TimeStart);
  end;
  if (Fsetworking.TimeStop<>0) then
  begin
    lbStop.Caption := timetostr(Fsetworking.TimeStop);
  end;

end;

end.

