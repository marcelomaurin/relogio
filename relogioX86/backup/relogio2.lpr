program relogio2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LazSerialPort, splash, clock, main, working, setmain, funcoes,
  setclock, SetupIoT, SetSIot, dmDados, temp, settemp, SetupWork, setwork,
  setworking, worktime, SetupDisplay, setdisplay, Display, unit1;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.Run;
end.

