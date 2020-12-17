unit SetupDisplay;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, setdisplay, LazSerial,funcoes;

type

  { TfrmSetupDisplay }

  TfrmSetupDisplay = class(TForm)
    ckDevice: TCheckBox;
    edDPort: TEdit;
    Image1: TImage;
    Label1: TLabel;
    mnFixarClock: TMenuItem;
    MnStay: TMenuItem;
    PopupMenu1: TPopupMenu;
    //FLazSerial : TLazSerial;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnFixarClockClick(Sender: TObject);
    procedure MnStayClick(Sender: TObject);
  private
     procedure CarregaContexto();
  public

  end;

var
  frmSetupDisplay: TfrmSetupDisplay;

implementation

{$R *.lfm}

{ TfrmSetupDisplay }

procedure TfrmSetupDisplay.CarregaContexto();
begin
  FsetDisplay.CarregaContexto();
  Left:= FsetDisplay.posx;
  top:= FsetDisplay.posy;
  ckDevice.Checked := FsetDisplay.device;
  edDPort.text := FsetDisplay.DPort;

  if FsetDisplay.stay then
   begin
     FormStyle:= fsStayOnTop;
   end
   else
   begin
     FormStyle:= fsNormal;
   end;
   if FsetDisplay.fixar then
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


procedure TfrmSetupDisplay.FormCreate(Sender: TObject);
begin
   if (FSetDisplay = nil) then (* Somente carrega se nao foi criado anteriormente *)
   begin
      FSetDisplay := TSetDisplay.create();

   end;
   CarregaContexto();
   (*
   //FLazSerial := TLazSerial.Create(self);
   //FLazSerial.BaudRate:= br__9600;
   //FLazSerial.Device:= FSetDisplay.DPort;
   if FLazSerial.Active then
   begin
      try
         FLazSerial.Open;
      except
         FLazSerial.Active:=false;
      end;
   end;
   *)
end;

procedure TfrmSetupDisplay.FormDestroy(Sender: TObject);
begin
  FSetDisplay.device:= iif(ckDevice.Checked,1,0);
  FSetDisplay.posx := Left;
  FSetDisplay.posy := top;
  FSetDisplay.DPort := edDPort.text;
  //Fsettemp.TypeC := cbTypeC.ItemIndex;
  FSetDisplay.SalvaContexto();
  (*
  if FLazSerial.Active then
  begin
       FLazSerial.Close;
  end;
  *)
  if (FSetDisplay <> nil) then
  begin
    FSetDisplay.Free();
    FSetDisplay := nil;
  end;
end;

procedure TfrmSetupDisplay.FormShow(Sender: TObject);
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

procedure TfrmSetupDisplay.mnFixarClockClick(Sender: TObject);
begin
  if (BorderStyle = bsNone) then
  begin
    BorderStyle:=bsSingle;
    FsetDisplay.fixar := true;
    mnFixarClock.Caption:='Fixar Clock';
    self.refresh;
  end
  else
  begin
    BorderStyle:=bsNone;
    FsetDisplay.fixar := false;
    mnFixarClock.Caption:='Mover Clock';
    //self.hide;
    //self.show;
    self.refresh;
  end;
  FsetDisplay.SalvaContexto();
end;

procedure TfrmSetupDisplay.MnStayClick(Sender: TObject);
begin
  if FormStyle = fsNormal then
  begin
    FormStyle:= fsStayOnTop;
    FsetDisplay.stay := true;

  end
  else
  begin
    FormStyle:=fsNormal;
    FsetDisplay.stay := false;
  end;
  refresh;
  FsetDisplay.SalvaContexto();

end;

end.

