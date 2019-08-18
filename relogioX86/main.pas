unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, PopupNotifier,
  ComCtrls, Menus, ExtCtrls, StdCtrls, splash, clock;


const Versao = '0.1B';


type
  { TfrmMenu }

  TfrmMenu = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    ComboBox1: TComboBox;
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
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
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
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure mnMenuClick(Sender: TObject);
    procedure MnRelogioClick(Sender: TObject);
  private

  public

  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.lfm}

{ TfrmMenu }

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
  frmSplash := TfrmSplash.create(self);
  frmclock := Tfrmclock.create(self);
  frmSplash.show;
  Application.ProcessMessages;
  sleep(4000);
  frmSplash.close;
  TrayIcon1.Visible := true;
  frmclock.show;
  application.ProcessMessages;
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

end.

