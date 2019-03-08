unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Grids;

type
  pes = record
   meno,trieda,datum:string;
   skore:integer;
  end;
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    gridus: TStringGrid;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    Timer4: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Timer1Timer(Sender: TObject);
    procedure generujObjektJedna();
    procedure generujObjektDva();
    procedure generujObjektTri();
    procedure Timer4Timer(Sender: TObject);
    procedure vynulovanie();
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure halloffame(skore_p:integer);
    procedure griduss;
  private
    { private declarations }
  public
    { public declarations }
  end;
const PATH ='Z:\K A T K A\Imagine\data_imagine.txt';
var
  Form1: TForm1;
  x1,x2,x3,y1,y2,y3:integer;      //pozicie kociek(v 1,2,3 stlpci)
  score1,score2,score3,zaciatocneScore,celkoveScore,najvyssieScore:integer;
  i1,i2,i3:integer;  //premena na zistenie pozicie kocky
  hraBezi:boolean;
  poleY1:array[1..13] of integer;
  poleY2:array[1..13] of integer;
  poleY3:array[1..13] of integer;
  vyhercovia:array[1..20] of pes;
  vyhercovia_length:integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i,pocet:integer;
  pom_s:string;
  subor:textfile;
begin
randomize;
Button1.caption:='Zacni hru';
x1:=100;
x2:=400;
x3:=700;
                          // zaciatocne pozicie
y1:=50;
y2:=50;
y3:=50;

i1:=0;
i2:=0;
i3:=0;

score1:=20;
score2:=25;                         //defaultne skore
score3:=30;
zaciatocneScore:=score1+score2+score3;
CelkoveScore:=0;




Timer1.Interval:=1000-score1;
Timer2.Interval:=1000-score2;               // rychlost timeru je zavisla od skore
Timer3.Interval:=1000-score3;                // cim vacsie skore tym rychlejsi timer
hraBezi:=false;

  FOR i:=1 to 13 DO
  begin
  poleY1[i]:=(i*50)-50;
  poleY2[i]:=(i*50)-50;
  poleY3[i]:=(i*50)-50;
  end;

Image1.canvas.Brush.color:=clYellow;
Image1.canvas.fillrect(clientRect);        // spodna kocka
Image1.canvas.Brush.color:=clBlack;
Image1.canvas.Rectangle(0,550,900,600);


//Nacitanie vyhercov
AssignFile(subor,PATH);
Reset(subor);
ReadLn(subor,pom_s);
pocet:=strtoint(pom_s);
for i:=1 to pocet do begin
ReadLn(subor,pom_s);
vyhercovia[i].meno:=      Copy(pom_s,1,Pos(';',pom_s)-1);
                          Delete(pom_s,1,Pos(';',pom_s));
vyhercovia[i].trieda:=    Copy(pom_s,1,Pos(';',pom_s)-1);
                          Delete(pom_s,1,Pos(';',pom_s));
vyhercovia[i].skore:=      StrToInt(Copy(pom_s,1,Pos(';',pom_s)-1));
                          Delete(pom_s,1,Pos(';',pom_s));
vyhercovia[i].datum:=     Copy(pom_s,1,Length(pom_s));




end;
CloseFile(subor);
vyhercovia_length:=10;

griduss;
najvyssieScore:=vyhercovia[1].skore;
Label6.caption:='Najvyssie score je '+IntToStr(najvyssieScore);
end;

procedure TForm1.Button1Click(Sender: TObject);     //RESET button
begin
Button1.caption:='Nova hra';
score1:=20;
score2:=25;
score3:=30;
celkoveScore:=0;
Label1.Caption:='Tvoje skore je: '+IntToStr(celkoveScore);

Timer1.Interval:=1000-score1;
Timer2.Interval:=1000-score2;
Timer3.Interval:=1000-score3;

hraBezi:=true;
Timer4.enabled:=true;

Timer1.enabled:=true;
i1:=0;
Timer2.enabled:=true;
i2:=0;
Timer3.enabled:=true;
i3:=0;

end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin                                        // detekuje ci je mys v pozicii kocky 1

IF (X<=x1+100) AND (X>=x1) AND (Y<=poleY1[i1]+100)
               AND (Y>=poleY1[i1]) AND (hraBezi=true) AND (Y>100) THEN
  begin
  Image1.canvas.Brush.color:=clBlack;
   Image1.canvas.Pen.color:=clWhite;                      // vymaze miesto kde bola kocka
   Image1.Canvas.Rectangle(x1,poleY1[i1],x1+100,poleY1[i1]+100);
   score1:=score1+20;
   i1:=0;
  end;

IF (X<=x2+100) AND (X>=x2) AND (Y<=poleY2[i2]+100)    // detekuje ci je mys v pozicii kocky 2
               AND (Y>=poleY2[i2]) AND (hraBezi=true) AND (Y>100) THEN
  begin
  Image1.canvas.Brush.color:=clBlack;
  Image1.canvas.Pen.color:=clWhite;
  Image1.Canvas.Rectangle(x2,poleY2[i2],x2+100,poleY2[i2]+100);
  score2:=score2+25;
  i2:=0;
  end;
                                                        // detekuje ci je mys v pozicii kocky 3
IF (X<=x3+100) AND (X>=x3) AND (Y<=poleY3[i3]+100)
               AND (Y>=poleY3[i3]) AND (hraBezi=true) AND (Y>100) THEN
  begin
  Image1.canvas.Brush.color:=clBlack;
  Image1.canvas.Pen.color:=clWhite;
  Image1.Canvas.Rectangle(x3,poleY3[i3],x3+100,poleY3[i3]+100);
  score3:=score3+30;
  i3:=0;
  end;


end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin

IF 1000-score1<100 THEN Timer1.Interval:=200           // ak to je uz prilis rychle tak
ELSE Timer1.Interval:=1000-score1;                     // mame jednu staticku rychlost
Image1.canvas.Brush.color:=random(256*256*256);
Image1.canvas.Pen.color:=clWhite;
Image1.canvas.Rectangle(0,0,300,600-50);

y1:=y1+50;                   //posun samotny
i1:=i1+1;
generujObjektJedna();

IF(poleY1[i1]+50>600) THEN vynulovanie();



end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
IF 1000-score2<100 THEN Timer2.Interval:=150
ELSE Timer2.Interval:=1000-score2;
Image1.canvas.Brush.color:=random(256*256*256);
Image1.canvas.Pen.color:=clWhite;
Image1.canvas.Rectangle(300,0,600,600-50);

y2:=y2+50;
i2:=i2+1;
generujObjektDva();


IF(poleY2[i2]+50>600) THEN vynulovanie();

end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
IF 1000-score3<100 THEN Timer3.Interval:=100
ELSE Timer3.Interval:=1000-score3;
Image1.canvas.Brush.color:=random(256*256*256);
Image1.canvas.Pen.color:=clWhite;
Image1.canvas.Rectangle(600,0,900,600-50);

y3:=y3+50;
i3:=i3+1;
generujObjektTri();


IF(poleY3[i3]+50>600) THEN vynulovanie();

end;

procedure TForm1.generujObjektJedna();
begin
Image1.canvas.Brush.color:=clRed;
Image1.canvas.Rectangle(x1,poleY1[i1],x1+100,poleY1[i1]+100);
end;

procedure TForm1.generujObjektDva();
begin
Image1.canvas.Brush.color:=clGreen;
Image1.canvas.Rectangle(x2,poleY2[i2],x2+100,poleY2[i2]+100);
end;

procedure TForm1.generujObjektTri();
begin
Image1.canvas.Brush.color:=clBlue;
Image1.canvas.Rectangle(x3,poleY3[i3],x3+100,poleY3[i3]+100);
end;



procedure TForm1.Timer4Timer(Sender: TObject);
begin
celkoveScore:=score1+score2+score3-zaciatocneScore;
Label1.Caption:='Tvoje skore je: '+IntToStr(celkoveScore);
Image1.canvas.Brush.color:=clBlack;
Image1.canvas.Rectangle(0,550,900,600);
end;

procedure TForm1.vynulovanie();         // koniec hry
var subor:textfile;
    i,pocet:integer;
    pom_s:string;
begin
 //Kontrola vyhercu naraz vyhrateho
AssignFile(subor,PATH);
Reset(subor);
ReadLn(subor,pom_s);
pocet:=StrToInt(pom_s);
for i:=1 to pocet do begin
ReadLn(subor,pom_s);
vyhercovia[i].meno:=      Copy(pom_s,1,Pos(';',pom_s)-1);
                          Delete(pom_s,1,Pos(';',pom_s));
vyhercovia[i].trieda:=    Copy(pom_s,1,Pos(';',pom_s)-1);
                          Delete(pom_s,1,Pos(';',pom_s));
vyhercovia[i].skore:=      StrToInt(Copy(pom_s,1,Pos(';',pom_s)-1));
                          Delete(pom_s,1,Pos(';',pom_s));
vyhercovia[i].datum:=     Copy(pom_s,1,Length(pom_s));




end;
CloseFile(subor);
najvyssieScore:=vyhercovia[1].skore;
Label6.caption:='Najvyssie score je '+IntToStr(najvyssieScore);
griduss;
//Koniec kontorly
{
 IF celkoveScore>najvyssieScore THEN
   begin

   end;
}

  Image1.canvas.Brush.color:=clYellow;
  Image1.canvas.fillrect(clientRect);
  Timer1.enabled:=false;
  Timer2.enabled:=false;
  Timer3.enabled:=false;
  Timer4.enabled:=false;

  hraBezi:=false;
IF celkoveScore>najvyssieScore THEN
  begin
  halloffame(celkoveScore); //zapise vyhercu
  najvyssieScore:=celkoveScore;
  Label6.caption:='Najvyssie score je '+IntToStr(najvyssieScore);
  end;

  score1:=20;
  score2:=25;
  score3:=30;
  CelkoveScore:=0;
  Timer1.Interval:=1000-score1;
  Timer2.Interval:=1000-score2;
  Timer3.Interval:=1000-score3;
  Image1.canvas.Brush.color:=clBlack;
  Image1.canvas.Rectangle(0,550,900,600);

end;
procedure TForm1.halloffame(skore_p:integer);
var
  UserString,pom_s,meno_p,trieda_p: string;
  i,pocet:integer;
  subor:textfile;
begin
  InputQuery('VYHERCA', 'Prekonali ste posledného najlepšieho hráča a zalúžite si umiestenenie v Hall of Fame. Prosím povedzte nám svoje meno:', UserString);
  if Length(userstring)>10 then InputQuery('VYHERCA', 'Meno iba max 10 znakov a bez diakritiky', UserString);
  if Length(userstring)>10 then InputQuery('VYHERCA', 'Neštvi ma, ešte raz a stratíš svoj progres', UserString);
  if Length(userstring)>10 then InputQuery('VYHERCA', 'Posledne varovanie(max 10, bez diaktiritky)', UserString);
  if Length(userstring)>10 then begin ShowMessage('Ty si to chcel'); halt; end;
  meno_p:=userstring;
  InputQuery('VYHERCA', 'A trieda?', UserString);
  if Length(userstring)>3 then InputQuery('VYHERCA', 'Prosím vo formáte číslo a trieda(napr. 1.B, okt)', UserString);
  if Length(userstring)>3 then InputQuery('VYHERCA', 'Neštvi ma, ešte raz a stratíš svoj progres', UserString);
  if Length(userstring)>3 then InputQuery('VYHERCA', 'Posledne varovanie', UserString);
  if Length(userstring)>3 then begin ShowMessage('Ty si to chcel'); halt; end;
  trieda_p:=userstring;

  for i:=10 downto 1 do begin
     vyhercovia[i+1].meno:=vyhercovia[i].meno;
     vyhercovia[i+1].trieda:=vyhercovia[i].trieda;
     vyhercovia[i+1].skore:=vyhercovia[i].skore;
     vyhercovia[i+1].datum:=vyhercovia[i].datum;
  end;
  vyhercovia[1].meno:=meno_p;
  vyhercovia[1].trieda:=trieda_p;
  vyhercovia[1].skore:=skore_p;
  vyhercovia[1].datum:=DateTimeToStr(date);

  //Zapis vyhercu
AssignFile(subor,PATH);
Rewrite(subor);
WriteLn(subor,'10');
for i:=1 to 10 do begin
  pom_s:=vyhercovia[i].meno+';'+vyhercovia[i].trieda+';'+IntToStr(vyhercovia[i].skore)+';'+vyhercovia[i].datum;
  WriteLn(subor,pom_s);
end;
CloseFile(subor);

//Znovanacitanie
AssignFile(subor,PATH);
Reset(subor);
ReadLn(subor,pom_s);
pocet:=StrToInt(pom_s);
for i:=1 to pocet do begin
ReadLn(subor,pom_s);
vyhercovia[i].meno:=      Copy(pom_s,1,Pos(';',pom_s)-1);
                          Delete(pom_s,1,Pos(';',pom_s));
vyhercovia[i].trieda:=    Copy(pom_s,1,Pos(';',pom_s)-1);
                          Delete(pom_s,1,Pos(';',pom_s));
vyhercovia[i].skore:=      StrToInt(Copy(pom_s,1,Pos(';',pom_s)-1));
                          Delete(pom_s,1,Pos(';',pom_s));
vyhercovia[i].datum:=     Copy(pom_s,1,Length(pom_s));




end;
CloseFile(subor);
vyhercovia_length:=10;




griduss;


end;

procedure TForm1.griduss;
var i:integer;
begin
  for i:=1 to 10 do begin
gridus.cells[1,i]:=vyhercovia[i].meno;
gridus.cells[2,i]:=vyhercovia[i].trieda;
gridus.cells[3,i]:=IntToStr(vyhercovia[i].skore);
gridus.cells[4,i]:=vyhercovia[i].datum;
end;
end;
end.

