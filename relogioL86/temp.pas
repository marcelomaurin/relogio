unit temp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ExtCtrls, LazSerial, settemp;

type

  { TfrmTemp }

  TfrmTemp = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LazSerial1: TLazSerial;
    mnFixarClock: TMenuItem;
    MnStay: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LazSerial1RxData(Sender: TObject);
    procedure mnFixarClockClick(Sender: TObject);
    procedure MnStayClick(Sender: TObject);
  private
    buffer : string;
  public
    Fsettemp : TSettemp;
    procedure CarregaContexto();
  end;

var
  frmTemp: TfrmTemp;

implementation

{$R *.lfm}

{ TfrmTemp }

procedure TfrmTemp.CarregaContexto();
begin
  Fsettemp.CarregaContexto();
  Left:= Fsettemp.posx;
  top:= Fsettemp.posy;
  if Fsettemp.stay then
  begin
    FormStyle:= fsStayOnTop;
  end
  else
  begin
    FormStyle:= fsNormal;
  end;
  if Fsettemp.fixar then
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

procedure TfrmTemp.FormCreate(Sender: TObject);
begin
  Fsettemp := Tsettemp.create();
  CarregaContexto();
  Brush.Style:=bsClear;
  buffer := '';
end;

procedure TfrmTemp.FormDestroy(Sender: TObject);
begin
  LazSerial1.Close;
  //Fsettemp.device:= ckDevice.Checked;
  Fsettemp.posx := Left;
  Fsettemp.posy := top;

  //Fsettemp.comport := edPort.text;
  //Fsettemp.TypeC := cbTypeC.ItemIndex;
  Fsettemp.SalvaContexto();
  if Fsettemp <> nil then
  begin
    Fsettemp.Free();
  end;

end;

procedure TfrmTemp.FormShow(Sender: TObject);
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

procedure TfrmTemp.LazSerial1RxData(Sender: TObject);
var
  posicao : integer;
  aux : string;
begin
  buffer := buffer + LazSerial1.ReadData;
  posicao  :=  pos('Humidade:',buffer);
  if (posicao > 0 ) then
  begin
    aux := copy(buffer,posicao+9,pos(#13,buffer)-(posicao+9));
    label4.Caption := aux;
    buffer := copy(buffer,pos(#13,buffer)+2, Length(buffer));
  end;
  posicao  :=  pos('Temperatura:',buffer);
  if (posicao > 0 ) then
  begin
    aux:=  copy(buffer,posicao+12,pos(#13,buffer)-13);
    Label2.Caption := aux;
    buffer := copy(buffer,pos(#13,buffer)+2, Length(buffer));
  end;

end;

procedure TfrmTemp.mnFixarClockClick(Sender: TObject);
begin
  if (BorderStyle = bsNone) then
  begin
    BorderStyle:=bsSingle;
    Fsettemp.fixar := true;
    mnFixarClock.Caption:='Fixar Clock';
    self.refresh;
  end
  else
  begin
    BorderStyle:=bsNone;
    Fsettemp.fixar := false;
    mnFixarClock.Caption:='Mover Clock';
    //self.hide;
    //self.show;
    self.refresh;
  end;
  Fsettemp.SalvaContexto();
end;

procedure TfrmTemp.MnStayClick(Sender: TObject);
begin
  if FormStyle = fsNormal then
  begin
    FormStyle:= fsStayOnTop;
    Fsettemp.stay := true;

  end
  else
  begin
    FormStyle:=fsNormal;
    Fsettemp.stay := false;
  end;
  refresh;
  Fsettemp.SalvaContexto();
end;

end.

