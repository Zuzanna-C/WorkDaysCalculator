unit PlanerM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  DBCtrls, DateTimePicker, DateUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    BDniRobocze: TButton;
    BClose: TButton;
    DT1: TDateTimePicker;
    DT2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    procedure BDniRoboczeClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);

    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  p, k: TDate;

implementation

{$R *.lfm}

{ TForm1 }

function CzyToRokPrzestepny(Data: TDate): boolean;
var
  YT, DT: word;
  wynik: integer;
begin
  Result := False;
  DecodeDateDay(Data, YT, DT);
  wynik := YT mod 4;
  if wynik = 0 then
    Result := True;
end;

function CzyToTenSamRok(pocz, kon: TDate): boolean;
var
  PY, PW, PD, KY, KW, KD: word;
begin
  DecodeDateWeek(pocz, PY, PW, PD);
  DecodeDateWeek(kon, KY, KW, KD);
  if PY = KY then
    Result := True
  else
    Result := False;
end;

function CzyToWeekend(Data: TDate): boolean;
begin
  if (DayOfTheWeek(Data) = 6) or (DayOfTheWeek(Data) = 7) then
    Result := True
  else
    Result := False;
end;

function CzyToSwieto(WybrData: TDate): boolean;
var
  swieta: array [1..13] of TDate;
  YT, MT, DT: word;
  i, RP: integer;


  procedure RuchomeSwieta(rok: TDate; var Wielkanoc1: TDate;
  var Wielkanoc2: TDate; var ZielSw: TDate; var BozeCialo: TDate);
  var
    Y1, W1, D1: word;
    a, b, c, d, e, RP: integer;
    Wielkanoc: integer;
  begin
    DecodeDateWeek(rok, Y1, W1, D1);
    RP := 0;

    if CzyToRokPrzestepny(rok) then
      RP := 1;

    a := Y1 mod 19;
    b := Y1 mod 4;
    c := Y1 mod 7;
    d := (a * 19 + 24) mod 30;
    e := (2 * b + 4 * c + 6 * d + 5) mod 7;

    Wielkanoc := 81 + d + e;
    Wielkanoc1 := EncodeDateDay(Y1, Wielkanoc + RP);
    Wielkanoc2 := EncodeDateDay(Y1, Wielkanoc + 1 + RP);
    ZielSw := EncodeDateDay(Y1, Wielkanoc + 48 + RP);
    BozeCialo := EncodeDateDay(Y1, Wielkanoc + 59 + RP);
  end;

begin
  Result := False;
  DecodeDate(WybrData, YT, MT, DT);
  RP := 0;

  if CzyToRokPrzestepny(WybrData) then
    RP := 1;

  // Stałe święta
  swieta[1] := EncodeDateDay(YT, 1);
  swieta[2] := EncodeDateDay(YT, 6);
  swieta[3] := EncodeDateDay(YT, 121 + RP);
  swieta[4] := EncodeDateDay(YT, 123 + RP);
  swieta[5] := EncodeDateDay(YT, 227 + RP);
  swieta[6] := EncodeDateDay(YT, 305 + RP);
  swieta[7] := EncodeDateDay(YT, 315 + RP);
  swieta[8] := EncodeDateDay(YT, 359 + RP);
  swieta[9] := EncodeDateDay(YT, 360 + RP);
  //  Ruchome święta
  RuchomeSwieta(WybrData, swieta[10], swieta[11], swieta[12], swieta[13]);

  for i := 1 to 13 do
    if WybrData = swieta[i] then Result := True;

end;

//Obliczanie dni roboczych
function ObliczDniRobocze(pocz, kon: TDate): integer;

var
  py, pm, pd, ky, km, kd, ly: word;
  DniPracy: integer;

  function DniRoboczeRok(pocz, kon: TDate): integer;
  var
    DniPracy: integer;
    ld: TDate;
  begin
    Result := 0;
    DniPracy := 0;
    if kon < pocz then Exit;
    ld := pocz;
    repeat
      if not ((CzyToSwieto(ld)) or CzyToWeekend(ld)) then
        Inc(DniPracy);
      ld := IncDay(ld);
    until ld > kon;
    Result := DniPracy;
  end;

begin
  DniPracy := 0;
  DecodeDate(pocz, py, pm, pd);
  DecodeDate(kon, ky, km, kd);
  ly := py;
  if ky <= py then
  begin
    DniPracy := DniRoboczeRok(pocz, kon);
  end
  else
  begin
    DniPracy := DniRoboczeRok(pocz, EncodeDate(ly, 12, 31));
    Inc(ly);
    while ly < ky do
    begin
      DniPracy := DniPracy + DniRoboczeRok(EncodeDate(ly, 1, 1), EncodeDate(ly, 12, 31));
      Inc(ly);
    end;
    DniPracy := DniPracy + DniRoboczeRok(EncodeDate(ly, 1, 1), kon);
  end;
  Result := DniPracy;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  DT1.Date := Date;
  DT2.Date := Date;
end;

procedure TForm1.BDniRoboczeClick(Sender: TObject);
var
  dr: integer;
begin
  dr := ObliczDniRobocze(DT1.Date, DT2.Date);
  if dr = 0 then
  begin
    ShowMessage('Brak dni roboczych w zaznaczonym okresie. Sprawdz czy poprawnie wybrales daty.');
  end
  else
    ShowMessage('Dni robocze to: ' + IntToStr(dr));
end;

procedure TForm1.BCloseClick(Sender: TObject);
begin
  Form1.Close;
end;

end.
