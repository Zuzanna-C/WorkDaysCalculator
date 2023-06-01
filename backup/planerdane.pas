unit PlanerDane;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset, ZSequence;

type

  { TPlanerDaneF }

  TPlanerDaneF = class(TDataModule)
    ZConn: TZConnection;
    ZQUrlopy: TZQuery;
    ZQUrlopyetat: TLongintField;
    ZQUrlopyid: TLongintField;
    ZQUrlopyilosc_dni: TLongintField;
    ZQUrlopykoniec: TDateField;
    ZQUrlopypoczatek: TDateField;
    ZQUrlopyuzytkownik: TStringField;
    ZSUrlopyId: TZSequence;
  private

  public

  end;

var
  PlanerDaneF: TPlanerDaneF;

implementation

{$R *.lfm}

end.

