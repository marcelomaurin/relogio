unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, LazSerial, LazSynaSer;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    LazSerial1: TLazSerial;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure LazSerial1RxData(Sender: TObject);
    procedure LazSerial1Status(Sender: TObject; Reason: THookSerialReason;
      const Value: string);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  LazSerial1.Open;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  LazSerial1.close;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  LazSerial1.WriteData('page 1'+#255+#255+#255);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
    LazSerial1.WriteData('page 2'+#255+#255+#255);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  a : integer;
begin
  for a:= 0 to 100 do
  begin
       LazSerial1.WriteData('val02.val='+inttostr(a)+#255+#255+#255);
       LazSerial1.WriteData('prog02.val='+inttostr(a)+#255+#255+#255);
       sleep(100);
  end;
end;

procedure TForm1.LazSerial1RxData(Sender: TObject);
begin

end;

procedure TForm1.LazSerial1Status(Sender: TObject; Reason: THookSerialReason;
  const Value: string);
begin
  //MessageBoxFunction(pchar(Value),'retorno',0);
end;

end.

