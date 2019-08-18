unit splash;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TfrmSplash }

  TfrmSplash = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.lfm}


{ TfrmSplash }
uses main;

procedure TfrmSplash.FormShow(Sender: TObject);
begin
  Label4.caption := versao;
end;

end.

