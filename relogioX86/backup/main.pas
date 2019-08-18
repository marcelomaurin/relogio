unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, PopupNotifier,
  ComCtrls, Menus, ExtCtrls, StdCtrls, splash, clock, setmain,SetupIoT,
  setsiot;


const Versao = '0.2B';


type
  { TfrmMenu }

  TfrmMenu = class(TForm)
    ckDevice: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MnRelogio: TMenuItem;
    mnMenu: TMenuItem;
    MenuItem3: TMenuItem;
    popTray: TPopupMenu;
    PopupNotifier1: TPopupNotifier;
    ToggleBox1: TToggleBox;
    ToggleBox2: TToggleBox;
    ToggleBox3: TToggleBox;
    ToggleBox4: TToggleBox;
    ToggleBox5: TToggleBox;
    TrayIcon1: TTrayIcon;
    procedure ComboBox5Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image6DblClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure mnMenuClick(Sender: TObject);
    procedure MnRelogioClick(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private
    setmain :TSetMain;
    Fsetsiot :TSetSIoT;
    procedure SalvaContexto();
    procedure CarregaContexto();
  public

  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.lfm}

{ TfrmMenu }

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
  setmain := TSetMain.create();
  fsetsiot := TSetSIoT.create();
  frmSplash := TfrmSplash.create(self);
  frmclock := Tfrmclock.create(self);
  frmSplash.show;
  Application.ProcessMessages;
  TrayIcon1.Visible := true;
  //frmclock.show;
  application.ProcessMessages;
  CarregaContexto();
  sleep(4000);
  frmSplash.close;
  Application.ProcessMessages;
end;

procedure TfrmMenu.FormDestroy(Sender: TObject);
begin
  setmain.posx := Left;
  setmain.posy := top;
  setmain.SalvaContexto();
  setmain.destroy();
  frmclock.Destroy();
end;

procedure TfrmMenu.ComboBox5Change(Sender: TObject);
begin

end;

procedure TfrmMenu.FormHide(Sender: TObject);
begin
   mnMenu.Caption := 'Mostrar Menu';
end;

procedure TfrmMenu.FormShow(Sender: TObject);
begin
     mnMenu.Caption := 'Esconder Menu';
end;

procedure TfrmMenu.Image6Click(Sender: TObject);
begin


end;

procedure TfrmMenu.CarregaContexto();
begin
  setmain.CarregaContexto();
  Fsetsiot.CarregaContexto();
  ckDevice.Checked := Fsetsiot.device;
  Left:= setmain.posx;
  top:= setmain.posy;

end;

procedure TfrmMenu.SalvaContexto();
begin
  setmain.device:= ckDevice.Checked;
  setmain.SalvaContexto();
end;

procedure TfrmMenu.Image6DblClick(Sender: TObject);
begin
  SalvaContexto();
  ShowMessage('Information save!')
end;

procedure TfrmMenu.MenuItem3Click(Sender: TObject);
begin
  close;
end;

procedure TfrmMenu.mnMenuClick(Sender: TObject);
begin
  if self.Visible then
  begin
    hide;
  end
  else
  begin
    Show;
  end;

end;

procedure TfrmMenu.MnRelogioClick(Sender: TObject);
begin
    if frmclock.Visible then
  begin
    frmclock.hide;
  end
  else
  begin
    frmclock.Show;
  end;
end;

procedure TfrmMenu.ToggleBox1Change(Sender: TObject);
begin
  Fsetsiot.destroy();

  frmSetupIoT := TFrmSetupIoT.Create(self);
  frmSetupIoT.Showmodal();
  frmSetupIoT.destroy();
  Fsetsiot := TSetSIoT .create();
  Fsetsiot.CarregaContexto();  (*Atualiza o contexto salvo*)
  ckDevice.Checked := Fsetsiot.device;
  ckDevice.Refresh;


end;

end.

