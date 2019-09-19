unit SetupWork;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, setwork;

type

  { TfrmSetupWork }

  TfrmSetupWork = class(TForm)
    ckDevice: TCheckBox;

    edwday: TEdit;
    Image1: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    procedure CarregaContexto();
  public
    FSetWork : TSetWork;
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
  edwday.text := Fsetwork.WDay;


end;

procedure TfrmSetupWork.FormCreate(Sender: TObject);
begin
   FSetWork := TSetWDay.create();
   CarregaContexto();
end;

end.

