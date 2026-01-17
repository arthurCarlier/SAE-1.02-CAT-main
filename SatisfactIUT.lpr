program SatisfactIUT;
{$mode objfpc}{$H+}
uses
  Unit_Logic_Lieu,unit_tests_unitaires,GestionEcran;

begin
  test();
  couleurTexte(White);
  Randomize;
  Unit_Logic_Lieu.Hub();
end.