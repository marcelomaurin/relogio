unit dmDados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, setsiot, setmain;

type

  { TdmDados1 }

  TdmDados1 = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private

  public
    //Fsetsiot :TSetSIoT;
    //Fsetmain :TSetMain;

  end;

var
  dmDados1: TdmDados1;

implementation

{$R *.lfm}

{ TdmDados1 }

procedure TdmDados1.DataModuleCreate(Sender: TObject);
begin
  //Fsetmain := TSetMain.create();
  //fsetsiot := TSetSIoT.create();

end;

procedure TdmDados1.DataModuleDestroy(Sender: TObject);
begin


end;

end.

