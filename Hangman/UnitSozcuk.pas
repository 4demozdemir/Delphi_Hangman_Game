unit UnitSozcuk;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Buttons, ComCtrls, StdCtrls;

type
  TFrmSozcuk = class(TForm)
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSozcuk: TFrmSozcuk;

implementation
Uses UnitMain;
{$R *.DFM}

procedure TFrmSozcuk.SpeedButton1Click(Sender: TObject);
begin
Close;
end;

procedure TFrmSozcuk.SpeedButton2Click(Sender: TObject);
var
  newWord: string;
begin
  newWord:= UpperCase( InputBox('Sözlüðe Ekle', 'Sözcük', '') );
  if newWord <> '' then
  with FrmMain do begin
   if not Table1.Locate('Sozcuk',newWord,[]) then
    begin
     Table1.Insert;
     Table1Sozcuk.AsString := newWord;
     Table1.Post;
    end
   else ShowMessage('Girilen sözcük Sözlükte mevcuttur!!!...');
  end;
end;
end.
