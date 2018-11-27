unit config;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, main;

type

  { TfrmConfig }

  TfrmConfig = class(TForm)
    Button1: TButton;
    cbBaudrate: TComboBox;
    edURL: TEdit;
    edPort: TEdit;
    fileAlarme: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    lbPort: TLabel;
    lbPort1: TLabel;
    lbPort2: TLabel;
    lbversao: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure lbPortClick(Sender: TObject);
  private

  public

  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.lfm}

{ TfrmConfig }

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  lbversao.Caption:= frmmain.versao;
end;

procedure TfrmConfig.Label2Click(Sender: TObject);
begin

end;

procedure TfrmConfig.lbPortClick(Sender: TObject);
begin

end;

end.

