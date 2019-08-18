unit SetupIoT;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, setsiot;

type

  { TfrmSetupIoT }

  TfrmSetupIoT = class(TForm)
    ckDevice: TCheckBox;
    cbTypeC: TComboBox;
    edPort: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;

    procedure ckDeviceChange(Sender: TObject);
    procedure edPortChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Fsetsiot :TSetSIoT;
    procedure CarregaContexto();

  public

  end;

var
  frmSetupIoT: TfrmSetupIoT;

implementation

{$R *.lfm}

{ TfrmSetupIoT }

procedure TfrmSetupIoT.edPortChange(Sender: TObject);
begin

end;

procedure TfrmSetupIoT.ckDeviceChange(Sender: TObject);
begin

end;

procedure TfrmSetupIoT.CarregaContexto();
begin
  Fsetsiot.CarregaContexto();
  Left:= Fsetsiot.posx;
  top:= Fsetsiot.posy;
  ckDevice.Checked := Fsetsiot.device;
  edPort.text := Fsetsiot.COMPORT;
  cbTypeC.ItemIndex:= Fsetsiot.TypeC;

end;

procedure TfrmSetupIoT.FormCreate(Sender: TObject);
begin
   Fsetsiot := TSetSIoT.create();

   CarregaContexto();
end;

procedure TfrmSetupIoT.FormDestroy(Sender: TObject);
begin
  Fsetsiot.device:= ckDevice.Checked;
  Fsetsiot.posx := Left;
  Fsetsiot.posy := top;
  Fsetsiot.comport := edPort.text;
  Fsetsiot.TypeC := cbTypeC.ItemIndex:=
  Fsetsiot.SalvaContexto();
  Fsetsiot.destroy();
end;

end.

