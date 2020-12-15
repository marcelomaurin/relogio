unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, PopupNotifier,
  ComCtrls, Menus, ExtCtrls, StdCtrls, splash, clock, dmDados, SetupIoT,
  setmain, temp, lazserial, SetupWork, working, dayworking, setwork;


const Versao = '2.3.5';


type
  { TfrmMenu }

  TfrmMenu = class(TForm)
    ckCasemod: TCheckBox;
    ckDevice: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ckWorking: TCheckBox;
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
    GroupBox6: TGroupBox;
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
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem4: TMenuItem;
    mnWorking: TMenuItem;
    N1: TMenuItem;
    MnRelogio: TMenuItem;
    mnMenu: TMenuItem;
    MenuItem3: TMenuItem;
    popTray: TPopupMenu;
    PopupNotifier1: TPopupNotifier;
    Timer1: TTimer;
    ToggleBox1: TToggleBox;
    ToggleBox2: TToggleBox;
    ToggleBox3: TToggleBox;
    ToggleBox4: TToggleBox;
    ToggleBox5: TToggleBox;
    ToggleBox6: TToggleBox;
    TrayIcon1: TTrayIcon;
    procedure ComboBox5Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image6DblClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure mnMenuClick(Sender: TObject);
    procedure MnRelogioClick(Sender: TObject);
    procedure mnWorkingClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure ToggleBox4Change(Sender: TObject);
    procedure ToggleBox6Change(Sender: TObject);
  private
    //Fsetmain :TSetMain;
    procedure SalvaContexto();
    procedure CarregaContexto();
    procedure FechaJanelas();
  public

  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.lfm}

{ TfrmMenu }

procedure TfrmMenu.FormCreate(Sender: TObject);
var
  a: integer;
begin
  if (Fsetmain = nil) then
  begin
    Fsetmain := TSetMain.create();
  end;
  frmSplash := TfrmSplash.create(self);
  frmSplash.AlphaBlend:=true;
  frmSplash.AlphaBlendValue:=0;
  frmSplash.show;
  for a:=0 to 255 do
  begin
    frmSplash.AlphaBlendValue:=a;
    Sleep(10);
    frmSplash.Refresh;
  end;
  Application.ProcessMessages;
  dmDados1 := TdmDados1.create(self);
  frmclock := Tfrmclock.create(self);
  frmSetupwork := TfrmSetupwork.create(self);
  frmSetupIoT := TFrmSetupIoT.Create(self);
  frmWorking := TFrmWorking.create(self);
  CarregaContexto();

  TrayIcon1.Visible := true;
  frmclock.show;
  application.ProcessMessages;

  sleep(4000);
  frmSplash.close;
  Application.ProcessMessages;
end;

procedure TfrmMenu.FormDestroy(Sender: TObject);
begin
  Fsetmain.posx := Left;
  Fsetmain.posy := top;
  Fsetmain.SalvaContexto();

  frmclock.Destroy();

  if (Fsetmain <> nil) then
  begin
    Fsetmain.free();
    FSetmain := nil;
  end;
end;

procedure TfrmMenu.ComboBox5Change(Sender: TObject);
begin

end;

procedure TfrmMenu.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:= caHide;
end;

procedure TfrmMenu.FormHide(Sender: TObject);
begin
   mnMenu.Caption := 'Mostrar Menu';
end;

procedure TfrmMenu.FormShow(Sender: TObject);
var
  a : integer;
begin
  mnMenu.Caption := 'Esconder Menu';
  (*Menu Aparece*)
  AlphaBlend:=true;
  AlphaBlendValue:=0;
  frmSplash.Refresh;
  for a:=0 to 255 do
  begin
    AlphaBlendValue:=a;
    Refresh;
    Sleep(10);
  end;
end;

procedure TfrmMenu.Image6Click(Sender: TObject);
begin
  FSetmain.SalvaContexto();
  hide;

end;

procedure TfrmMenu.CarregaContexto();
begin
  //Fsetmain.CarregaContexto();
  frmSetupIoT.Fsetsiot.CarregaContexto();
  ckDevice.Checked := frmSetupIoT.Fsetsiot.device;
  ckWorking.Checked := FSetWork.device;
  Left:= Fsetmain.posx;
  top:= Fsetmain.posy;
  if not Fsetmain.ckdevice then
  begin
     hide;
  end;

end;

procedure TfrmMenu.SalvaContexto();
begin
  Fsetmain.device:= Showing;
  Fsetmain.SalvaContexto();
end;

procedure TfrmMenu.Image6DblClick(Sender: TObject);
begin
  SalvaContexto();
  ShowMessage('Information save!')
end;

procedure TfrmMenu.FechaJanelas();
begin
  if FDayWorking <> nil then
  begin
     //FDayWorking.close;
     FDayWorking.destroy;
  end;

end;

procedure TfrmMenu.MenuItem3Click(Sender: TObject);
begin
     FechaJanelas();
     Application.Terminate;
end;

procedure TfrmMenu.mnMenuClick(Sender: TObject);
begin
  if self.Visible then
  begin
    hide;
    Fsetmain.ckdevice := false;
    SalvaContexto();
  end
  else
  begin
    Show;
    Fsetmain.ckdevice := true;
    SalvaContexto();
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

procedure TfrmMenu.mnWorkingClick(Sender: TObject);
begin
  frmWorking.show;
end;

procedure TfrmMenu.Timer1Timer(Sender: TObject);
begin
  //Device leitor de temperatura
  if ckDevice.Checked then
  begin
    if (frmSetupIoT.Fsetsiot.TypeC = 1) then (*Device Sensor de temperatura*)
    begin
        if frmtemp= nil then
        begin
          frmtemp := Tfrmtemp.create(self);
          frmtemp.LazSerial1.Device := frmSetupIoT.Fsetsiot.COMPORT;
          frmTemp.LazSerial1.BaudRate:= br115200;
          frmtemp.Show;
          frmTemp.LazSerial1.Open;
        end;
    end;
    if (frmSetupIoT.Fsetsiot.TypeC = 2) then (*Device Relogio*)
    begin

    end;
  end
  else
  begin
    if frmtemp <> nil then
    begin
      frmtemp.Free;
      frmtemp := nil;
    end;
  end;
  if ckWorking.Checked then
  begin
      if (frmWorking=nil) then
      begin
        frmWorking := Tfrmworking.create(self);
        frmworking.Show;
        mnWorking.Visible:=false;
      end
      else
      begin
        //if frmWorking
        //frmworking.show;
        if mnWorking.Visible=false then
        begin
             mnWorking.Visible:=true;
        end;
      end;


  end
  else
  begin
    if frmWorking <> nil then
    begin
      frmWorking.close;
      frmworking.Free ;
      frmWorking := nil;
      mnWorking.Visible:=false;
    end;
  end;

end;

procedure TfrmMenu.ToggleBox1Change(Sender: TObject);
begin
  if frmSetupIoT = Nil then
    frmSetupIoT := TfrmSetupIoT.create(self);
  //frmSetupIoT.Fsetsiot := Fsetsiot;
  frmSetupIoT.Showmodal();
  //frmSetupIoT.Fsetsiot.CarregaContexto();  (*Atualiza o contexto salvo*)
  frmSetupIoT.Fsetsiot.SalvaContexto();
  ckDevice.Checked := frmSetupIoT.Fsetsiot.device;
  ckDevice.Refresh;


end;

procedure TfrmMenu.ToggleBox4Change(Sender: TObject);
begin
  if frmSetupWork = Nil then
    frmSetupWork := TfrmSetupWork.create(self);
  //frmSetupWork.Fsetsiot := Fsetsiot;
  frmSetupWork.Showmodal();
  //frmSetupWork.Fsetsiot.CarregaContexto();  (*Atualiza o contexto salvo*)
  FSetWork.SalvaContexto();
  ckWorking.Checked := FSetWork.device;
  ckWorking.Refresh;
end;

procedure TfrmMenu.ToggleBox6Change(Sender: TObject);
begin
  (*
  if frmSetupCasemod = Nil then
    frmSetupCasemod := TfrmSetupCasemod.create(self);
  //frmSetupIoT.Fsetsiot := Fsetsiot;
  frmSetupCasemod.Showmodal();
  //frmSetupIoT.Fsetsiot.CarregaContexto();  (*Atualiza o contexto salvo*)
  frmSetupCasemod.Fsetsiot.SalvaContexto();
  ckCasemod.Checked := frmSetupCasemod.Fsetsiot.device;
  ckcasemod.Refresh;
  *)
end;

end.

