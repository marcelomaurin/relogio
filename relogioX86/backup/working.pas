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
    mnWorking: TMenuItem;
    popworking: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    mnFixarClock.Caption:='Mover Clock';
  end;

end;

end.

