unit PlanerDane;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset, ZSequence;

type

  { TPlanerDaneF }

  TPlanerDaneF = class(TDataModule)
    ZQUrlopyetat: TLongintField;
    ZQUrlopyid: TLongintField;
    ZQUrlopyilosc_dni: TLongintField;
    ZQUrlopykoniec: TDateField;
    ZQUrlopypoczatek: TDateField;
    ZQUrlopyuzytkownik: TStringField;
  private

  public

  end;

var
  PlanerDaneF: TPlanerDaneF;

implementation

{$R *.lfm}

end.

