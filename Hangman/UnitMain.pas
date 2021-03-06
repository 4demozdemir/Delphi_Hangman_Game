unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Buttons, StdCtrls, ExtCtrls, Menus,//DBIProcs, DBITypes,
  ComCtrls;
type
  TFrmMain = class(TForm)
    Table1: TTable;
    DataSource1: TDataSource;
    Table1Kayitno: TAutoIncField;
    PanelPuan: TPanel;
    Puan: TLabel;
    Panel3: TPanel;
    SpeedButton31: TSpeedButton;
    SpeedButton32: TSpeedButton;
    SpeedButton33: TSpeedButton;
    Image1: TImage;
    Panel2: TPanel;
    Timer1: TTimer;
    procedure SpeedButton31Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton33Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AboutClick(Sender: TObject);
    procedure SpeedButton32Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    //External procedurler (A.Murat ACAR)
    procedure HarfClick(Sender: TObject);
    procedure ConstructButtons(Sender : TObject);
    procedure DestructButtons(Sender : TObject);
    procedure PaintPicture(Sender: TObject);
    procedure ConstructKeyLabels(Sender: TObject);
    procedure DestructKeyLabels(Sender: TObject);
    //procedure CreateAlias(AliasName, AliasPath: string);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

  //Global de?i?kenler
  alphButtons : array[0..31] of TButton; //Harf buttonlar?
  keyLabels   : array[0..31] of TLabel;  //?pucu kelime labelleri
  pictHang    : Integer;                 //Resim sira tutucu
  hangWord    : string;                  //Tutulan s?zc?k
  gameStart   : Boolean;                 //oyun ba?lang??, biti?
  count       : Integer;                 //ipucu kelime sayac?

implementation

uses UnitSozcuk;

{$R *.DFM}

procedure TFrmMain.SpeedButton31Click(Sender: TObject);
var i:Integer;
begin
Timer1.Enabled:=False;
// Oyun bitmeden yeni oyun isteniyor ise
if gameStart then DestructKeyLabels(Sender);

// Kelime tut
Table1.Locate('KayitNo',Random(Table1.RecordCount),[]);
hangWord := Table1Sozcuk.Value;

// Anahtar harfleri yazdir
ConstructKeyLabels(Sender);

//Degiskenleri initialize et
gameStart:=True;
pictHang:=0;
PanelPuan.Caption :='10000';
Panel3.Caption:='';
PaintPicture(Sender);
count :=0;
//Aktif olmayan butonlar? aktif et
for i:=0 to 31 do
 if not alphButtons[i].Enabled then alphButtons[i].Enabled:= True;

//Sozcukler secenigini deaktif et
SpeedButton33.Enabled:=False;
end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
var
   Yeri:Integer;
   Harf:string;
   Found: Boolean;
begin
//Eger oyun baslamamissa veya baslatildiktan sonra yeni oyun istenirse
if SpeedButton33.Enabled then exit;

Harf:=TButton(Sender).Caption;//Bas?lan Butonun g?sterdi?i harfin al?nmas?

TButton(Sender).Enabled:=False;//Bas?lan butonun Pasif hale getirilmesi

Found:=False;
for Yeri:=1 to Length(hangWord) do//Gelen harfin s?zc?k i?inde aranmas?
 begin
  if hangWord[Yeri]=Harf Then//e?er gelen harf s?zc?k i?inde varsa
   begin
    TLabel(FindComponent('H'+IntToStr(Yeri))).Caption:=Harf;
    Inc(count);
    if count = Length(hangWord) Then
     begin
      gameStart:=True;
      SpeedButton33.Enabled:=True;
      Timer1.Enabled:=True;
     end;
    Found:=True;//Harfin s?zc???n i?inde var oldu?unun belirlenmesi
   end;
 end;

if not Found Then //Harfin s?zc?k i?inde var olmamas? durumu
   begin
    Inc(pictHang);
    PaintPicture(Sender);
    if pictHang < 9 then PanelPuan.Caption := IntToStr(Round(StrToInt(PanelPuan.Caption)/2))
    else PanelPuan.Caption := '0';
   end;

if pictHang = 9 then //Oyunun Bitmesi
   begin
    ShowMessage('Oyun Bitti...');
    DestructKeyLabels(Sender);
    SpeedButton33.Enabled:=True;
    Panel3.Caption:='Aranan S?zc?k : ' + hangWord;
    gameStart := False;
   end;
end;

procedure TFrmMain.PaintPicture(Sender: TObject);
begin
 Image1.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Resim\Resim'+IntToStr(pictHang)+'.bmp');
end;

procedure TFrmMain.SpeedButton33Click(Sender: TObject);
begin
FrmSozcuk:=TFrmSozcuk.Create(Application);
FrmSozcuk.ShowModal;
FrmSozcuk.Free;

end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
//Random initialize
Randomize;

//S?zc?klerin yerald??? tablonun a??lmas?
//CreateAlias('Adam','PATH:'+ ExtractFilePath(ParamStr(0)) + 'VERI');
//table1.DatabaseName := 'Adam';
Table1.TableName := ExtractFilePath(ParamStr(0)) + 'VERI\AdamAs.db';

DataSource1.DataSet:=Table1;
Table1.Active:=True;

//Harf butonlar?n?n yap?land?r?lmas?
ConstructButtons(Sender);

//Game Intialization
gameStart:=False;
hangWord:='';
pictHang:=0;
PaintPicture(Sender);

end;


{procedure TFrmMain.CreateAlias(AliasName, AliasPath: string);
begin
 Check(DbiInit(Nil));
 DbiAddAlias( Nil, PChar(AliasName),
 nil, PChar(AliasPath), True);
 Check(DbiExit);
end;
}

procedure TFrmMain.ConstructButtons(Sender : TObject);
var i : Integer;
    alphabet : array[0..31] of char;
begin
alphabet := 'ABC?DEFG?HI?JKLMNO?PQRS?TU?VWXYZ';
for i:=0 to 31 do
 begin
  alphButtons[i] := TButton.Create(FrmMain);
  alphButtons[i].Parent := Panel2;
  alphButtons[i].Height := 25;
  alphButtons[i].Width  := 25;
  alphButtons[i].Left   := 4 + 26*(i mod 8);
  alphButtons[i].Top    := 4 + 26*(i div 8);
  alphButtons[i].Caption := alphabet[i];
  //Turkce alfabe kullanilmayacaksa 65-90 arasi
  // dongu ile asagidaki gibi yapilir.
  // alphButtons[i].Caption := Chr(i);
  alphButtons[i].Font.Style := [fsBold];
  alphButtons[i].OnClick := SpeedButton1Click;
 end;
end;

procedure TFrmMain.DestructButtons(Sender : TObject);
var i : Integer;
begin
 for i:=0 to 31 do alphButtons[i].Free;
end;

procedure TFrmMain.HarfClick(Sender: TObject);
begin
 TButton(Sender).Enabled:=False;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
DestructButtons(Sender);
if gameStart then DestructKeyLabels(Sender);
Table1.Active:=False;
end;

procedure TFrmMain.ConstructKeyLabels(Sender : TObject);
var i, lftOrg : Integer;
begin
lftOrg := 108 - Round(21*Length(hangWord)/2);
for i:=0 to Length(hangWord) -1 do
 begin
  keyLabels[i]        := TLabel.Create(FrmMain);
  keyLabels[i].Name   := 'H' + IntToStr(i+1);
  keyLabels[i].Parent := Panel3;
  keyLabels[i].Height := 24;
  keyLabels[i].Width  := 12;
  keyLabels[i].Left   := 7+lftOrg + 21*i;
  keyLabels[i].Top    := 13;
  keyLabels[i].Caption := '_';
  keyLabels[i].Alignment := taCenter;
  keyLabels[i].Font.Style := [fsBold];
 end;
end;

procedure TFrmMain.DestructKeyLabels(Sender : TObject);
var i : Integer;
begin
 for i:=0 to Length(hangWord) -1 do keyLabels[i].Free;
end;

procedure TFrmMain.AboutClick(Sender: TObject);
begin
 ShowMessage('Adam Asmaca - Delphi');
end;

procedure TFrmMain.SpeedButton32Click(Sender: TObject);
begin
Close;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var i:Integer;
begin
 for i:=0 to Length(hangWord) -1 do
  keyLabels[i].Visible:=not keyLabels[i].Visible;
end;

end.

