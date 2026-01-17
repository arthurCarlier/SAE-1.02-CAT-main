//Unit en charge des zones
unit Unit_Logic_Zone;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface
  uses Unit_logic_ressources,Unit_Logic_Batiment,unit_logic_mission;

type 
  //Gisement de ressource
  TGisement = record  
    materiau : TMateriau;  //Type de materiau
    niveau : integer;       //Niveau du gisement
  end;

  //Emplacement de constructiion
  TEmplacement = record
    gisement : TGisement;   //Gisement éventuel
    batiment : TBatiment;   //Batiment éventuel
    estConnu : boolean;     //L'emplacement est-il connu
  end;

  TEmplacementsZone = array[0..9] of TEmplacement;  //Ensemble de 10 emplacements qui forme une zone

  //Zone
  TZone = record 
    nom : string;                       //Nom de la zone
    emplacements : TEmplacementsZone;   //Emplacements composant la zone
    inventaire : TInventaire;           //Inventaire de la zone
  end;
  

//Initialise les différentes zones du jeu
procedure InitialiserZones();

//L'ascenseur est-il déjà construit dans la zone ?
//numeroZone : numero de la zone
function IsAscenseurConstruit(numeroZone : integer) : boolean;

//Renvoie le nombre de marzacoin possédé
function GetMarzacoin() : integer;

//Renvoie la zone demandée
//numero : numero de la zone
function GetZone(numero : integer) : TZone;

//Essaye d'ajouter le batiment à l'emplacement donné
//batiment : le batiment à mettre
//numeroZone : numéro de la zone pour la construction
//numeroEmplacement : numéro de l'emplacement pour la construction
function AjouterBatiment(batiment : TBatiment; numeroZone : integer; numeroEmplacement : integer) : boolean;

//Essaye d'améliorer un batiment (si suffisament de ressources)
//numeroZone : Numéro de la zone
//numeroEmplacement : Numéro de l'emplacement
function AmeliorerBatiment(numeroZone : integer; numeroEmplacement : integer) : boolean;

//Passage à la journée suivante
procedure PasserJournee();

//Explore la zone puis passe le tour
procedure ExplorerLaZone(numeroZone : integer) ;

//Fixe la production d'un constructeur
//numeroZone : numero de la zone
//numeroEmplacement : numero de l'emplacement dans la zone
//ressource : ressource produite
procedure SetProduction(numeroZone : integer;numeroEmplacement : integer; ressource : TRessource);

//Renvoie le nombre de zones
function NombreDeZones() : integer;

//Transfère une ressource d'une zone à l'autre
//numeroZoneOrigine :  numéro de la zone d'origine
//numeroZoneDestination : numéro de la zone d'arrivée
//ressource : ressource transférée
//quantité : quantitée transférée
procedure TransfererRessource(numeroZoneOrigine : integer; numeroZoneDestination : integer; ressource : TRessource; quantite : Integer);

//Renvoie la production d'électricité
function GetProductionElectricite() : integer;

//Renvoie la consommation d'électricité
function GetConsomationElectricite() : integer;

//Y'a-t-il du courant ?
function ElectriciteActive() : boolean;

//Essaye de valider la mission
//numeroZone : numéro de la zone
//mission : mission à valider
function ValiderMission(numeroZone : integer; mission : TMission) : boolean;

implementation
uses
  unit_logic_temps;
const
  NBZONES = 3;
var
  zones : array[0..NBZONES-1] of TZone;       //Zone du jeu
  ascenseurConstruit : boolean;
  marzacoin : integer;

//L'ascenseur est-il déjà construit dans la zone ?
//numeroZone : numero de la zone
function IsAscenseurConstruit(numeroZone : integer) : boolean;
var
  i:integer;
begin
  IsAscenseurConstruit := false;
  for i:=0 to 9 do
    if(zones[numeroZone].emplacements[i].batiment.typeBatiment = ASCENSEUR) then IsAscenseurConstruit:=true;
end;

//Renvoie le nombre de marzacoin possédé
function GetMarzacoin() : integer;
begin
  GetMarzacoin:=marzacoin;
end;

//Création d'un gisement
function CreerGisement(materiau : TMateriau; niveau : integer) : TGisement;
begin
  CreerGisement.materiau := materiau;
  CreerGisement.niveau := niveau;
end;

//Création d'un emplacement vide
function CreerEmplacement(materiau : TMateriau; niveauGisement : integer; estConnu : boolean) : TEmplacement;
begin
  CreerEmplacement.gisement := CreerGisement(materiau, niveauGisement);
  CreerEmplacement.batiment := CreerBatiment(AUCUNBAT,AUCUNRES,0);
  CreerEmplacement.estConnu := estConnu;
end;

//Initialise les différentes zones du jeu
procedure InitialiserZones();
var
  i : integer;
  nbEmplacementVisible : integer;
  nbTentiativeGisement : integer;
begin
  ascenseurConstruit := false;
  marzacoin := 0;

  //Zone de départ
  zones[0].inventaire := CreerInventaireVide();
  zones[0].nom := 'Zone de départ';
  zones[0].emplacements[0] := CreerEmplacement(AUCUNMAT,0,true);
  zones[0].emplacements[0].batiment := CreerBatiment(ASCENSEUR,AUCUNRES,0);
  zones[0].emplacements[1] := CreerEmplacement(FERMAT,random(3)+1,true);
  zones[0].emplacements[2] := CreerEmplacement(CUIVREMAT,random(3)+1,true);
  zones[0].emplacements[3] := CreerEmplacement(FERMAT,random(3)+1,false);
  zones[0].inventaire[PLAQUEFER] := 100;
  zones[0].inventaire[CABLE] := 100;
  zones[0].inventaire[BETON] := 20;
  for i:= 4 to 9 do zones[0].emplacements[i] := CreerEmplacement(AUCUNMAT,0,false);
  
  //Désert (Fer+Charbon sûr)
  zones[1].inventaire := CreerInventaireVide();
  zones[1].nom := 'Zone du désert rocheux';
  for i:= 0 to 9 do zones[1].emplacements[i] := CreerEmplacement(AUCUNMAT,0,false);
  nbTentiativeGisement := random(2);
  for i:= 1 to nbTentiativeGisement do zones[1].emplacements[random(10)] := CreerEmplacement(CUIVREMAT,random(3)+1,false);
    //Gisement de fer
  nbTentiativeGisement := random(2)+1;
  for i:= 1 to nbTentiativeGisement do zones[1].emplacements[random(10)] := CreerEmplacement(FERMAT,random(3)+1,false);
    //Gisement de charbon
  nbTentiativeGisement := random(2)+1;
  for i:= 1 to nbTentiativeGisement do zones[1].emplacements[random(10)] := CreerEmplacement(CHARBONMAT,random(3)+1,false);
  
  nbEmplacementVisible := random(3)+2;
  for i:=0 to nbEmplacementVisible-1 do zones[1].emplacements[i].estConnu := true;


  //Forêt
  zones[2].inventaire := CreerInventaireVide();
  zones[2].nom := 'Zone de la forêt nordique';
  for i:= 0 to 9 do zones[2].emplacements[i] := CreerEmplacement(AUCUNMAT,0,false);
    //Gisement de fer
  nbTentiativeGisement := random(2);
  for i:= 1 to nbTentiativeGisement do zones[2].emplacements[random(10)] := CreerEmplacement(FERMAT,random(3)+1,false);
    //Gisement de cuivre
  nbTentiativeGisement := random(2);
  for i:= 1 to nbTentiativeGisement do zones[2].emplacements[random(10)] := CreerEmplacement(CUIVREMAT,random(3)+1,false);
    //Gisement de calcaire
  nbTentiativeGisement := random(2)+1;
  for i:= 1 to nbTentiativeGisement do zones[2].emplacements[random(10)] := CreerEmplacement(CALCAIREMAT,random(3)+1,false);
  
  nbEmplacementVisible := random(3)+2;
  for i:=0 to nbEmplacementVisible-1 do zones[2].emplacements[i].estConnu := true;
end;

//Renvoie la zone demandée
//numero : numero de la zone
function GetZone(numero : integer) : TZone;
begin
  GetZone := zones[numero];
end;
  
//Essaye d'ajouter le batiment à l'emplacement donné
//batiment : le batiment à mettre
//numeroZone : numéro de la zone pour la construction
//numeroEmplacement : numéro de l'emplacement pour la construction
function AjouterBatiment(batiment : TBatiment; numeroZone : integer; numeroEmplacement : integer) : boolean;
var
  emplacement : TEmplacement;
begin
  emplacement := zones[numeroZone].emplacements[numeroEmplacement];
  AjouterBatiment := true;

  //Cas particulier
  case batiment.typeBatiment of
    //Une mine doit être sur un gisement
    MINE : 
    begin
      //Adapte la mine
      case emplacement.gisement.materiau of
        FERMAT : batiment.production := FER;
        CUIVREMAT : batiment.production := CUIVRE;
        CHARBONMAT : batiment.production := CHARBON;
        CALCAIREMAT : batiment.production := CALCAIRE;
        else AjouterBatiment := false;
      end;
    end;
    //Il ne peut y avoir qu'un seul ascenseur
    ASCENSEUR : AjouterBatiment := not(ascenseurConstruit);
  end;

  //Construction du batiment si possible
  if(AjouterBatiment) then
  begin
    zones[numeroZone].emplacements[numeroEmplacement].batiment := batiment;
    if(batiment.typeBatiment = ASCENSEUR) then ascenseurConstruit := true;

    //On retire les ressources de la zone
    RetirerInventaire(zones[numeroZone].inventaire,CoutConstruction(batiment));
  end;

end;

//Essaye d'améliorer un batiment (si suffisament de ressources)
//numeroZone : Numéro de la zone
//numeroEmplacement : Numéro de l'emplacement
function AmeliorerBatiment(numeroZone : integer; numeroEmplacement : integer) : boolean;
var
  cout : TInventaire;
begin
  //Calcul du cout d'amélioration
  cout := CoutAmelioration(zones[numeroZone].emplacements[numeroEmplacement].batiment);
  //Si suffisament de ressource
  if ContientInventaire(zones[numeroZone].inventaire,cout) then
  begin
    //Améliorer le niveau du batiment
    AmeliorerBatiment := true;
    zones[numeroZone].emplacements[numeroEmplacement].batiment.niveau := zones[numeroZone].emplacements[numeroEmplacement].batiment.niveau+1;
    //Retirer les ressources
    RetirerInventaire(zones[numeroZone].inventaire,cout);
  end
  else AmeliorerBatiment:=false;
end;

//Passage à la journée suivante pour la zone
//numeroZone : numéro de la zone
//renvoie si toutes les machines ont pu fonctionner
function PasserJourneeZone(numeroZone : integer) : boolean;
var
  numeroEmplacement : integer;
  productionDuBatiment : TInventaire;
  consomationBatiment : TInventaire;
  nouveauStock : TInventaire;
begin
  PasserJourneeZone := true;
  CopierInventaire(nouveauStock,zones[numeroZone].inventaire);
  //Pour chaque emplacement
  for numeroEmplacement := 0 to 9 do
  begin
    //Calcul de la consomation nécessaire
    consomationBatiment := CoutProductionBatiment(zones[numeroZone].emplacements[numeroEmplacement].batiment);

    //Si la consomation est possible
    if ContientInventaire(zones[numeroZone].inventaire,consomationBatiment) then
    begin
      //Calcul de la production possible
      productionDuBatiment := ProductionBatiment(zones[numeroZone].emplacements[numeroEmplacement].batiment,zones[numeroZone].emplacements[numeroEmplacement].gisement.niveau);
      
      //Suppression de la consommation de l'inventaire de la zone
      RetirerInventaire(nouveauStock,consomationBatiment);
      //Ajout de la production à l'inventaire de la zone
      AjouterInventaire(nouveauStock,productionDuBatiment);
    end
    else PasserJourneeZone := false;
  end;
  
  CopierInventaire(zones[numeroZone].inventaire,nouveauStock);
end;


//Passage à la journée suivante
procedure PasserJournee();
var
  i:integer;
begin
  if(ElectriciteActive()) then
    for i:=Low(zones) to High(zones) do PasserJourneeZone(i);
  PasserJourDate();
end;

//Explore la zone puis passe le tour
procedure ExplorerLaZone(numeroZone : integer) ;
var
 alea : integer;
begin
  alea := Random(10);
  if not(zones[numeroZone].emplacements[alea].estConnu) then
  begin
    zones[numeroZone].emplacements[alea].estConnu := true;
  end;
  PasserJournee();
end;

//Fixe la production d'un constructeur
//numeroZone : numero de la zone
//numeroEmplacement : numero de l'emplacement dans la zone
//ressource : ressource produite
procedure SetProduction(numeroZone : integer;numeroEmplacement : integer; ressource : TRessource);
begin
  zones[numeroZone].emplacements[numeroEmplacement].batiment.production := ressource;
end;

//Renvoie le nombre de zones
function NombreDeZones() : integer;
begin
  NombreDeZones := NBZONES;
end;

//Transfère une ressource d'une zone à l'autre
//numeroZoneOrigine :  numéro de la zone d'origine
//numeroZoneDestination : numéro de la zone d'arrivée
//ressource : ressource transférée
//quantité : quantitée transférée
procedure TransfererRessource(numeroZoneOrigine : integer; numeroZoneDestination : integer; ressource : TRessource; quantite : Integer);
begin
  zones[numeroZoneOrigine].inventaire[ressource] -= quantite;
  zones[numeroZoneDestination].inventaire[ressource] += quantite;
end;


//Renvoie la production d'électricité
function GetProductionElectricite() : integer;
var
  nbZone : integer;
  nbEmplacement : integer;
begin
  GetProductionElectricite := 0;
  for nbZone := low(zones) to High(zones) do
    for nbEmplacement := 0 to 9 do
    begin
      if(zones[nbZone].emplacements[nbEmplacement].batiment.typeBatiment = Centrale) then GetProductionElectricite += 1200;
    end;
end;

//Renvoie la consommation d'électricité
function GetConsomationElectricite() : integer;
var
  nbZone : integer;
  nbEmplacement : integer;
begin
  GetConsomationElectricite := 0;
  for nbZone := low(zones) to High(zones) do
    for nbEmplacement := 0 to 9 do
    begin
      GetConsomationElectricite += ConsommationElectriciteBatiment(Zones[nbZone].emplacements[nbEmplacement].batiment);
    end;
end;

//Y'a-t-il du courant ?
function ElectriciteActive() : boolean;
begin
  ElectriciteActive := (GetProductionElectricite()>=GetConsomationElectricite());
end;

//Essaye de valider la mission
//numeroZone : numéro de la zone
//mission : mission à valider
function ValiderMission(numeroZone : integer; mission : TMission) : boolean;
begin
  ValiderMission:=false;
  if(ContientInventaire(zones[numeroZone].inventaire,mission.ressources)) then
  begin
    RetirerInventaire(zones[numeroZone].inventaire,mission.ressources);
    marzacoin += mission.recompense;
    ValiderMission := true;
  end;
end;
end.