unit working;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Menus, setworking;

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
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnFixarClockClick(Sender: TObject);
    procedure MnStayClick(Sender: TObject);
    procedure mnWorkingClick(Sender: TObject);
  private
    Fsetworking : TSetworking;
    procedure CarregaContexto();

  public

  end;

var
  frmWorking: TfrmWorking;

implementation

{$R *.lfm}

procedure TfrmWorking.FormCreate(Sender: TObject);
begin
  Fsetworking := Tsetworking.create();
  CarregaContexto();
  //buffer := '';
end;

procedure TfrmWorking.BitBtn1Click(Sender: TObject);
begin

end;

procedure TfrmWorking.BitBtn2Click(Sender: TObject);
begin

end;

procedure TfrmWorking.FormDestroy(Sender: TObject);
begin
  Fsetworking.posx := Left;
  Fsetworking.posy := top;

  Fsetworking.SalvaContexto();
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
  Fsetworking.SalvaContexto();
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
    setworking.stay:=false;
  end;
  refresh;
end;

procedure TfrmWorking.mnWorkingClick(Sender: TObject);
begin

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

end;

end.

