unit working;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Menus;

type

  { TfrmWorking }

  TfrmWorking = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Share: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageList1: TImageList;
    Label10: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    mnWorking: TMenuItem;
    popworking: TPopupMenu;
  private

  public

  end;

var
  frmWorking: TfrmWorking;

implementation

{$R *.lfm}

end.

