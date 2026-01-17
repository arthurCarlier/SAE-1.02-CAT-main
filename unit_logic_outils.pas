//Unité contenant des outils utils pour les autres unités
unit Unit_Logic_Outils;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface
//Demande à l'utilisateur de saisir une valeur
//renvoie cette valeur si elle est entre min et max inclus
//renvoie -1 sinon
function NormalisationChoix(min,max : integer) : integer;

implementation
uses
    SysUtils;

//Demande à l'utilisateur de saisir une valeur
//renvoie cette valeur si elle est entre min et max inclus
//renvoie -1 sinon
function NormalisationChoix(min,max : integer) : integer;
var
  saisie : string;
  valeur : integer;
begin
  readln(saisie);
  if TryStrToInt(saisie, valeur) then
  begin
     if(valeur < min) OR (valeur > max) then valeur := -1;
  end
  else valeur := -1;
  NormalisationChoix := valeur;
end;

end.

