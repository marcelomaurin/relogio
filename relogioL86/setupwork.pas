unit SetupWork;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, setwork;

type

  { TfrmSetupWork }

  TfrmSetupWork = class(TForm)
    ckDevice: TCheckBox;

    edwday: TEdit;
    Image1: TImage;
    Label1: TLabel;
    mnFixarClock: TMenuItem;
    MnStay: TMenuItem;
    PopupMenu1: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnFixarClockClick(Sender: TObject);
  private
    procedure CarregaContexto();
  public

  end;

var
  frmSetupWork: TfrmSetupWork;

implementation

{$R *.lfm}

{ TfrmSetupWork }

procedure TfrmSetupWork.CarregaContexto();
begin
  FsetWork.CarregaContexto();
  Left:= FsetWork.posx;
  top:= FsetWork.posy;
  ckDevice.Checked := FsetWork.device;
  edwday.text := timetostr(Fsetwork.WDay);

  if FsetWork.stay then
   begin
     FormStyle:= fsStayOnTop;
   end
   else
   begin
     FormStyle:= fsNormal;
   end;
   if FsetWork.fixar then
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

procedure TfrmSetupWork.FormCreate(Sender: TObject);
begin
   if (FSetWork = nil) then (* Somente carrega se nao foi criado anteriormente *)
   begin
      FSetWork := TSetWork.create();
   end;
   CarregaContexto();
end;

procedure TfrmSetupWork.FormDestroy(Sender: TObject);
begin
  FSetWork.device:= ckDevice.Checked;
  FSetWork.posx := Left;
  FSetWork.posy := top;

  FSetWork.WDay := strtotime(edwday.text);
  //Fsettemp.TypeC := cbTypeC.ItemIndex;
  FSetWork.SalvaContexto();

  if (FSetWork <> nil) then
  begin
    FSetWork.Free();
    FSetWork := nil;
  end;

end;

procedure TfrmSetupWork.FormShow(Sender: TObject);
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


procedure TfrmSetupWork.mnFixarClockClick(Sender: TObject);
begin
  if (BorderStyle = bsNone) then
  begin
    BorderStyle:=bsSingle;
    Fsetwork.fixar := true;
    mnFixarClock.Caption:='Fixar Clock';
    self.refresh;
  end
  else
  begin
    BorderStyle:=bsNone;
    Fsetwork.fixar := false;
    mnFixarClock.Caption:='Mover Clock';
    //self.hide;
    //self.show;
    self.refresh;
  end;
  Fsetwork.SalvaContexto();
end;

end.

