unit unit_logic_mission;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface
uses
  unit_logic_ressources;

type
  TMission = record
    nom : string;
    description : string;
    recompense : integer;
    ressources : TInventaire;
  end;
  
//Initialise les missions
procedure InitialiserMissions();

//Renvoie le nombre de missions disponibles
function GetNombreMissions() : integer;

//Renvoie une mission
//numeroMission : numéro de la mission
function GetMission(numeroMission : integer) : TMission;

implementation
const
  nombreMissions = 5;
var
  missions : array[1..nombreMissions] of TMission;


//Initialise les missions
procedure InitialiserMissions();
begin
  missions[1].nom := 'Rénovation des Fenêtres';
  missions[1].description := 'La pluie passe à travers les fenêtres... il est temps de les changer.';
  missions[1].recompense := 350;
  missions[1].ressources := CreerInventaireVide();
  missions[1].ressources[TUYAUFER] := 100;
  missions[1].ressources[ACIER] := 100;
  
  missions[2].nom := 'Rénovation du toit';
  missions[2].description := 'Il pleut dans l''IUT et on commence à manquer de sceaux pour les fuites.';
  missions[2].recompense := 750;
  missions[2].ressources := CreerInventaireVide();
  missions[2].ressources[POUTRE] := 100;
  missions[2].ressources[PLAQUER] := 100;

  missions[3].nom := 'Invasion de rats mutants';
  missions[3].description := 'Des rats mutants se sont infiltrés dans des salles informatiques et ont grignoté les cables.';
  missions[3].recompense := 400;
  missions[3].ressources := CreerInventaireVide();
  missions[3].ressources[CABLE] := 1000;

  missions[4].nom := 'L''ombre et la flamme';
  missions[4].description := 'Nous avons creusé trop profond et trop avidement dans les sous-sols de MMI...';
  missions[4].recompense := 300;
  missions[4].ressources := CreerInventaireVide();
  missions[4].ressources[FONDATION] := 100;

  missions[5].nom := 'Les pierres d''Esquie';
  missions[5].description := 'On a besoin de béton, de beaucoup de béton... ne posez pas de question !';
  missions[5].recompense := 800;
  missions[5].ressources := CreerInventaireVide();
  missions[5].ressources[BETON] := 1533;
end;

//Renvoie le nombre de missions disponibles
function GetNombreMissions() : integer;
begin
  GetNombreMissions := nombreMissions;
end;

//Renvoie une mission
//numeroMission : numéro de la mission
function GetMission(numeroMission : integer) : TMission;
begin
  GetMission := missions[numeroMission];
end;

end.