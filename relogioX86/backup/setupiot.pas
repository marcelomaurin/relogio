unit SetupIoT;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, EditBtn, dmDados, setsiot;

type

  { TfrmSetupIoT }

  TfrmSetupIoT = class(TForm)
    Button1: TButton;
    ckDevice: TCheckBox;
    cbTypeC: TComboBox;
    edPort: TEdit;
    edFileNextion: TFileNameEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;


    procedure Button1Click(Sender: TObject);
    procedure cbTypeCChange(Sender: TObject);
    procedure ckDeviceChange(Sender: TObject);
    procedure edPortChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

    procedure CarregaContexto();

  public
    Fsetsiot :TSetSIoT;

  end;

var
  frmSetupIoT: TfrmSetupIoT;

implementation

{$R *.lfm}

{ TfrmSetupIoT }

procedure TfrmSetupIoT.edPortChange(Sender: TObject);
begin
  Fsetsiot.COMPORT:= edPort.text;
end;

procedure TfrmSetupIoT.ckDeviceChange(Sender: TObject);
begin
  Fsetsiot.device:= ckDevice.Checked;
end;

procedure TfrmSetupIoT.cbTypeCChange(Sender: TObject);
begin
  Fsetsiot.TypeC:= cbTypeC.ItemIndex;
end;

procedure TfrmSetupIoT.Button1Click(Sender: TObject);
begin
  if (cbTypeC.ItemIndex = 1) then
  begin

  end
  else
  begin
    ShowMessage('Type not permitted');
  end;
end;

procedure TfrmSetupIoT.CarregaContexto();
begin
  Fsetsiot.CarregaContexto();
  Left:= Fsetsiot.posx;
  top:= Fsetsiot.posy;
  ckDevice.Checked := Fsetsiot.device;
  edPort.text := Fsetsiot.COMPORT;
  edFileNextion.text := Fsetsiot.FileNextion;
  cbTypeC.ItemIndex:= Fsetsiot.TypeC;

end;

procedure TfrmSetupIoT.FormCreate(Sender: TObject);
begin
   fsetsiot := TSetSIoT.create();
   CarregaContexto();
end;

procedure TfrmSetupIoT.FormDestroy(Sender: TObject);
begin
  Fsetsiot.device:= ckDevice.Checked;
  Fsetsiot.posx := Left;
  Fsetsiot.posy := top;
  Fsetsiot.comport := edPort.text;
  Fsetsiot.FileNextion := edFileNextion.Text;
  Fsetsiot.TypeC := cbTypeC.ItemIndex;
  Fsetsiot.SalvaContexto();
  if Fsetsiot <> nil then
    Fsetsiot.Free();

end;

end.

