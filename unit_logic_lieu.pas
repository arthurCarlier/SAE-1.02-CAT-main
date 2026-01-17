//Unité en charge de la gestion des lieux et des déplacements entre les lieux
unit Unit_Logic_Lieu;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface

type
  TLieu = (TITRE,MENU,HISTOIRE,INIT,WIKI,ZONE,MISSION,QUITTER);     //Liste des lieux possibles

//Procédure de Hub redirigant vers le lieu en cours
procedure Hub();

//Change la zone actuelle
procedure ChangerZone(numero : integer);



//------------------------------------------------------------------------------//


implementation
uses
    Unit_IHM_Titre,unit_ihm_zone,unit_logic_zone,unit_logic_temps,unit_ihm_wiki,unit_ihm_mission,unit_logic_mission;

var
  numeroZone : integer;         //Numéro de la zone actuelle    

//Change la zone actuelle
procedure ChangerZone(numero : integer);
begin
  numeroZone := numero;
end;

//Initialisation d'une nouvelle partie
function InitialisationPartie() : TLieu;
begin
  //Initialisation de la date
  InitialisationDate();

  //Initialisation des missions
  InitialiserMissions();
  
  //Initialisation des zones
  InitialiserZones();
  numeroZone := 0;

  //On se rend dans la première zone
  InitialisationPartie := ZONE;
end;

//Procédure de Hub redirigant vers le lieu en cours
procedure Hub();
var
  lieuEnCours : TLieu;        //Lieu actuel
begin
  //On commence à l'écran titre
  lieuEnCours := TITRE;

  while(lieuEnCours <> QUITTER) do
  begin
       case lieuEnCours of
          TITRE : lieuEnCours := EcranTitre();
          INIT : lieuEnCours := InitialisationPartie();
          HISTOIRE : lieuEnCours := EcranHistoire();
          ZONE : lieuEnCours := EcranZone(numeroZone);
          MENU : lieuEnCours := EcranMenu();
          WIKI : lieuEnCours := EcranWiki();
          MISSION : lieuEnCours := EcranMission(numeroZone);
       end;
  end;
end;

end.

