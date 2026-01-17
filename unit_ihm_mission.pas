unit unit_ihm_mission;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface
  uses unit_logic_lieu;

const
  MISSIONS_PAR_PAGE = 5;

//Ecran de gestion des missions
//numeroZone : numéro de la zone
function EcranMission(numeroZone : integer) : TLieu;

implementation
  uses
    GestionEcran,sysutils,unit_logic_zone,unit_logic_ressources,unit_logic_mission,unit_logic_outils,unit_ihm_zone,unit_ihm_outils;


procedure AfficherMissions(page: Integer);
var
  ligne, i, debut, fin: integer;
begin
  effacerEcran();
  EcrireCentreSur(124,2,'LISTE DES MISSIONS');

  // Calcul des indices de début et fin de page
  debut := page * MISSIONS_PAR_PAGE;
  fin := debut + MISSIONS_PAR_PAGE - 1;
  if fin >= GetNombreMissions() then fin := GetNombreMissions() - 1;

  ligne := 6;

  // Affichage des missions de la page
  for i := debut to fin do
  begin
    deplacerCurseurXY(55, ligne); write(IntToStr(i+1)+' - '+GetMission(i).nom);
    deplacerCurseurXY(55, ligne+1); write(GetMission(i).description);
    deplacerCurseurXY(55, ligne+2); write('Ressources à livrer : '+ToStringInventaire(GetMission(i).ressources));
    deplacerCurseurXY(55, ligne+3); write('Récompense : '+IntToStr(GetMission(i).recompense)+' Marza''coin');
    deplacerCurseurXY(55, ligne+4); write('Difficulté : '+IntToStr(GetMission(i).difficulte));
    ligne += 7;
  end;
end;


//Remplire la mission si possible
//numeroZone : numéro de la zone
//numéroMission : numéro de la mission
procedure RemplirMission(numeroZone : integer; numeroMission : integer);
begin
  if(ValiderMission(numeroZone,GetMission(numeroMission))) then 
  begin
    EffacerMenu();
    couleurTexte(Green);
    EcrireMenu(3,'   Félicitation, mission accomplie !');
    EcrireMenu(4,'         Ressources envoyées');
    readln;
  end
  else
  begin
    EffacerMenu();
    couleurTexte(Red);
    EcrireMenu(3,'  Impossible de réaliser cette mission');
    EcrireMenu(4,'     Il vous manque des ressources');
    readln;
  end;
end;

//Ecran de gestion des missions
//numeroZone : numéro de la zone
function EcranMission(numeroZone: integer): TLieu;
var
  pageCourante, nombrePages, totalMissions, debutPage, finPage: integer;
  choix: integer;
begin
  totalMissions := GetNombreMissions();
  pageCourante := 0;
  nombrePages := (totalMissions + MISSIONS_PAR_PAGE - 1) div MISSIONS_PAR_PAGE;

  repeat
    // Afficher la page courante
    AfficherMissions(pageCourante);
    AfficherInventaire(numeroZone);

    debutPage := pageCourante * MISSIONS_PAR_PAGE;
    finPage := debutPage + MISSIONS_PAR_PAGE - 1;
    if finPage >= totalMissions then finPage := totalMissions - 1;

    // Instructions
    EcrireMenu(0, 'Que souhaitez-vous faire ?');
    EcrireMenu(1, '0 = revenir à la zone');
    EcrireMenu(2, '-1 = page suivante');
    EcrireMenu(3, '-2 = page précédente');
    EcrireMenu(4, 'Choisissez le numéro de la mission');

    ZoneReponse();
    readln(choix);

    // Gestion des commandes spéciales
    if choix = 0 then
    begin
      EcranMission := ZONE;
      Exit;
    end
    else if choix = -1 then // page suivante
    begin
      if pageCourante < nombrePages - 1 then Inc(pageCourante);
    end
    else if choix = -2 then // page précédente
    begin
      if pageCourante > 0 then Dec(pageCourante);
    end
    else if (choix >= debutPage+1) and (choix <= finPage+1) then
    begin
      RemplirMission(numeroZone, choix-1); // -1 car tableau 0..n-1
      EcranMission := MISSION;
      Exit;
    end
    else
    begin
      EffacerMenu();
      couleurTexte(Red);
      EcrireMenu(5,'Numéro invalide');
      readln;
    end;
  until False;
end;


  
end.