unit Unit_IHM_Zone;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface
uses
  Unit_Logic_Lieu,unit_ihm_outils,unit_logic_zone;

//Fonction principale d'affichage d'une zone
//numeroZone : numéro de la zone à afficher
function EcranZone(numeroZone : integer)  : TLieu;
  
//Affiche l'inventaire de la zone
//numeroZone : numéro de la zone
procedure AfficherInventaire(numeroZone : integer);

//Selection d'un emplacement au clavier
//laZone : la zone actuelle
//positionSelectionne : la position sélectionné (modifiée)
//Renvoie le dernier mouvement fait
function SelectionEmplacementClavier(laZone : TZone; var positionSelectionne : integer) : TMouvementMenu;

implementation
uses 
  SysUtils,unit_ihm_batiments,math,GestionEcran,unit_logic_batiment,unit_logic_ressources,unit_logic_outils,unit_logic_temps;

//Affiche l'inventaire de la zone
//numeroZone : numéro de la zone
procedure AfficherInventaire(numeroZone : integer);
var
  zone : TZone;
  res : TRessource;
  ligne : integer;
begin
  zone := GetZone(numeroZone);

  //Affichage du titre
  EcrireCentreSur(25,2,'INVENTAIRE DE LA ZONE');

  //Affichage des marzacoin
  CouleurTexte(Cyan);
  EcrireZoneGauche(0,0,'Marza''Coin');
  EcrireZoneGauche(29,0,': '+IntToStr(GetMarzacoin()));
  CouleurTexte(White);

  //Affichage des ressources
  if(not(ElectriciteActive())) then CouleurTexte(Red);
  EcrireZoneGauche(0,2,'Production d''électricité');
  EcrireZoneGauche(29,2,': '+IntToStr(GetProductionElectricite()));
  EcrireZoneGauche(0,3,'Consommation d''électricité');
  EcrireZoneGauche(29,3,': '+IntToStr(GetConsomationElectricite()));

  CouleurTexte(White);

  ligne := 5;
  for res := Low(TRessource) to High(TRessource) do
  begin
    if(res <> AUCUNRES) then
    begin
      EcrireZoneGauche(0,ligne,ToStringRessource(res));
      EcrireZoneGauche(29,ligne,': '+IntToStr(zone.inventaire[res]));
      ligne+=1;
    end;
  end;

end;

//Affiche un emplacement de la zone
//emplacement : l'emplacement à afficher
//position : sa position dans la zone
//estSelectionne : l'emplacement est séléectionné ?
procedure AfficherEmplacement(emplacement : TEmplacement; position : integer; estSelectionne : boolean);
var
  x : integer;  //colonne du coin haut gauche de la zone
  y : integer;  //ligne du coin haut gauche de la zone
  couleur : byte;
begin
  x := 52+(position div 5) *(126-52);
  y := 4+(position mod 5)*(11-4);

  //Si l'emplacement n'est pas connu on affiche juste INCONNU
  if(not(emplacement.estConnu)) then
  begin
    if estSelectionne then couleur := cyan else couleur := DarkGray;
    dessinerCadreXY(x,y,x+123-52,y+6,simple,couleur,Black);
    couleurTexte(couleur);
    EcrireCentreSur(x+(123-52) div 2+1,y+3,'EMPLACEMENT NON DECOUVERT');
  end
  //Si l'emplacement contient un batiment
  else if(emplacement.batiment.typeBatiment <> AUCUNBAT) then
  begin
    if estSelectionne then couleur := cyan else couleur := White;
    dessinerCadreXY(x,y,x+123-52,y+6,simple,couleur,Black);
    couleurTexte(couleur);
    deplacerCurseurXY(x+7,y+2); write('BATIMENT   : '+ToStringBatiment(emplacement.batiment.typeBatiment));
    if(emplacement.batiment.niveau>0) then 
    begin
      if(emplacement.batiment.typeBatiment = CENTRALE) then begin deplacerCurseurXY(x+7,y+4); write('PRODUCTION : Electricité'); end
      else begin deplacerCurseurXY(x+7,y+4); write('PRODUCTION : '+ToStringRessource(emplacement.batiment.production)); end;
      deplacerCurseurXY(x+7+(123-52) div 2,y+2); write('NIVEAU : '+IntToStr(emplacement.batiment.niveau));
    end;
  end
  //Si l'emplacement contient un gisement
  else if(emplacement.gisement.materiau <> AUCUNMAT) then
  begin
    if estSelectionne then couleur := cyan else couleur := Brown;
    dessinerCadreXY(x,y,x+123-52,y+6,simple,couleur,Black);
    couleurTexte(couleur);
    deplacerCurseurXY(x+7,y+2); write('GISEMENT NON EXPLOITE');
    deplacerCurseurXY(x+7,y+4); write('MINERAI : '+ToStringMateriau(emplacement.gisement.materiau));
    deplacerCurseurXY(x+7+(123-52) div 2,y+2); write('NIVEAU : '+IntToStr(emplacement.gisement.niveau));
  end
  //Si l'emplacement est juste vide
  else
  begin
    if estSelectionne then couleur := cyan else couleur := White;
    dessinerCadreXY(x,y,x+123-52,y+6,simple,couleur,Black);
    couleurTexte(couleur);
    EcrireCentreSur(x+(123-52) div 2+1,y+3,'EMPLACEMENT VIDE');
  end;

  //On se remet en blanc
  couleurTexte(White);
end; 

procedure AfficherEmpacementsZone(zone:TZone; numeroSelectionne : integer);
var
  i:integer;
begin
  //Affichage des emplacements
  for i:=0 to 9 do AfficherEmplacement(zone.emplacements[low(zone.emplacements)+i],i,i=numeroSelectionne);
end;

//Selection d'un emplacement au clavier
//laZone : la zone actuelle
//positionSelectionne : la position sélectionné (modifiée)
//Renvoie le dernier mouvement fait
function SelectionEmplacementClavier(laZone : TZone; var positionSelectionne : integer) : TMouvementMenu;
var
  mouvement : TMouvementMenu;
begin
  AfficherEmpacementsZone(laZone,positionSelectionne);
  mouvement := LectureClavier();

  while(mouvement <> VALIDER) AND (mouvement <> FIN) do
  begin
    case mouvement of
      HAUT : if(positionSelectionne mod 5 <> 0) then positionSelectionne := positionSelectionne-1;
      BAS : if(positionSelectionne mod 5 <> 4) then positionSelectionne := positionSelectionne+1;
      DROIT : if(positionSelectionne div 5 <> 1) then positionSelectionne := positionSelectionne+5;
      GAUCHE : if(positionSelectionne div 5 <> 0) then positionSelectionne := positionSelectionne-5;
    end;
    AfficherEmpacementsZone(laZone,positionSelectionne);
    mouvement := LectureClavier();
  end;
  SelectionEmplacementClavier:=mouvement;
end;

//Changer de zone
function ChangerDeZone() : TLieu;
var
  i:integer;
  choix : integer;
begin
  EffacerMenu();
  EcrireMenu(0,'Dans quelle zone voulez-vous aller ?');
  for i:=0 to NombreDeZones()-1 do
    EcrireMenu(i+1,'  '+IntToStr(i+1)+'/ '+GetZone(i).Nom);
  
  choix := -1;
  while(choix = -1) do 
    begin
      ZoneReponse();
      choix := NormalisationChoix(1,NombreDeZones());
    end;
  ChangerZone(choix-1);
  ChangerDeZone := Zone;
end;


//Changer de zone
function Transferer(numeroZoneOrigine : integer) : TLieu;
const
  NOMBREAFFICHEPARPAGE = 5;
var
  i:integer;
  choix : integer;
  numeroZoneArrivee : integer;
  numeroPage : integer;
  nombrePage : integer;
  indiceMin : integer;
  indiceMax : integer;
  ressourceChoisie : TRessource;
  quantite : integer;
begin
  //Choix de la zone d'arrivee
  EffacerMenu();
  EcrireMenu(0,'Vers quelle zone ?');
  for i:=0 to NombreDeZones()-1 do
    EcrireMenu(i+1,'  '+IntToStr(i+1)+'/ '+GetZone(i).Nom);
  
  choix := -1;
  while(choix = -1) do 
    begin
      ZoneReponse();
      choix := NormalisationChoix(1,NombreDeZones());
    end;
  numeroZoneArrivee := choix-1;

  //Choix de la ressource
  numeroPage := 0;
  ressourceChoisie := AUCUNRES;
  nombrePage := (Ord(High(TRessource))-Ord(Low(TRessource))) div NOMBREAFFICHEPARPAGE;
  if((Ord(High(TRessource))-Ord(Low(TRessource))) mod NOMBREAFFICHEPARPAGE > 0) then nombrePage:=nombrePage+1;

  while (ressourceChoisie = AUCUNRES) do
  begin
    EffacerMenu();
    EcrireMenu(0,'Quelle ressource transférer ?');

    indiceMin := Ord(Low(TRessource))+1 + NOMBREAFFICHEPARPAGE*numeroPage;
    indiceMax := min(Ord(High(TRessource)),indiceMin+NOMBREAFFICHEPARPAGE-1);

    for i:= 1 to indiceMax-indiceMin+1 do 
      EcrireMenu(i,'  '+IntToStr(i)+'/ '+ToStringRessource(TRessource(indiceMin+i-1)));
    EcrireMenu(i+1,'  '+IntToStr(i+1)+'/ Autres');

    choix := -1;
    while(choix = -1) do
    begin
      ZoneReponse();
      choix := NormalisationChoix(1,i+1);
    end; 

    case choix=(i+1) of
      //Passage à la page suivante
      true : numeroPage := (numeroPage+1) mod nombrePage;
      //Choix d'une ressource
      else ressourceChoisie := TRessource(TRessource(indiceMin+choix-1));
    end;
  end;

  EffacerMenu();
  EcrireMenu(0,'Quelle quantité (max='+IntToStr(GetZone(numeroZoneOrigine).inventaire[ressourceChoisie])+') ?');
  choix := -1;
    while(choix = -1) do
    begin
      ZoneReponse();
      choix := NormalisationChoix(0,GetZone(numeroZoneOrigine).inventaire[ressourceChoisie]);
    end; 
  quantite := choix;

  TransfererRessource(numeroZoneOrigine,numeroZoneArrivee,ressourceChoisie,quantite);

  EffacerMenu();
  couleurTexte(Green);
  EcrireMenu(3,'         Transfère réussi !');
  readln;

  Transferer := Zone;
end;


//Fonction principale d'affichage d'une zone
//numeroZone : numéro de la zone à afficher
function EcranZone(numeroZone : integer)  : TLieu;
var 
  laZone : TZone;
  choix : integer;
begin
  effacerEcran();
  DessinerCadresPrincipaux();

  //On récupère la zone
  laZone := GetZone(numeroZone);

  //Affichage de l'inventaire
  AfficherInventaire(numeroZone);

  //Affichage du nom
  EcrireCentreSur(87,2,'ZONE : '+laZone.nom);
  EcrireCentreSur(162,2,AffichageDate());

  //Affichage des emplacements
  AfficherEmpacementsZone(laZone,-1);

  EcrireMenu(0,'Que voulez-vous faire ?');
  EcrireMenu(1,'  1/ Construire un bâtiment');
  EcrireMenu(2,'  2/ Changer la production');
  EcrireMenu(3,'  3/ Améliorer un bâtiment');
  EcrireMenu(4,'  4/ Explorer la zone');
  EcrireMenu(5,'  5/ Changer de zone');
  EcrireMenu(6,'  6/ Transferer des ressources');
  EcrireMenu(7,'  7/ Passer la journée');
  EcrireMenu(8,'  8/ Missions');
  EcrireMenu(9,'  9/ Wiki');
  EcrireMenu(10,'  0/ Quitter la partie');

  choix := -1;
  while(choix = -1) do 
    begin
      ZoneReponse();
      choix := NormalisationChoix(0,9);
    end;

  case choix of
    1 : EcranZone := Construction(numeroZone);
    2 : EcranZone := ChangerProduction(numeroZone);
    3 : EcranZone := AmeliorerBatimentZone(numeroZone);
    4 : 
    begin 
      ExplorerLaZone(numeroZone);
      EcranZone := ZONE;
    end;
    5 : EcranZone := ChangerDeZone();
    6 : EcranZone := Transferer(numeroZone);
    7 : 
    begin 
      PasserJournee();
      EcranZone := ZONE;
    end;
    8 :
    begin
      if(IsAscenseurConstruit(numeroZone)) then 
        EcranZone := MISSION
      else 
      begin
        EffacerMenu();
        couleurTexte(Red);
        EcrireMenu(3,'   Impossible d''accéder aux missions');
        EcrireMenu(4,' Aucun ascenseur orbital dans la zone !');
        readln;
        EcranZone := ZONE;
      end;
    end;
    9 : EcranZone := WIKI;
    0 : EcranZone := TITRE;
  end;
end;

  
end.